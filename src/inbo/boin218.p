/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN218 2.00.00.042} /*** "010042" 17/06/2025 16:40:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin218 MUT}
&ENDIF

/*
**  BOIN218.P
**
**  movto-estoq - Movimento de Estoque
**
**  Ultima altera‡Æo : 01/12/99 - GeraBO
*/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY movto-estoq
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME movto-estoq

{include/boini.i}

{inbo/boin218.i RowObject}

{adbo/boad107.i tt-estabelec}
{inbo/boin281.i tt-param-cp}
{include/i_dbtype.i}
 
{cdp/cdcfgman.i} /* Preprocessadores EMS 2.02 e EMS 2.03 */
{cdp/cdcfgdis.i} /* Defini‡Æo dos pr‚-processadores que diferenciam releases*/
{cdp/cdcfgren.i} /* Identifica se o programa est  sendo executado na Grendene */
{utp/ut-glob.i}

&IF "{&mguni_version}" >= "2.071" &THEN
DEF VAR c-cod-estabel-usuar AS CHAR format "x(05)".
&ELSE
DEF VAR c-cod-estabel-usuar AS CHAR FORMAT "x(03)".
&ENDIF
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

 /*=================== SETCONSTRAINT2========================*/
    def var d-data-ini        as date    no-undo.
    def var d-data-fim        as date    no-undo.
    def var c-estabel-ini     as char    no-undo.
    def var c-estabel-fim     as char    no-undo.
    def var c-localiz-ini     as char    no-undo.
    def var c-localiz-fim     as char    no-undo.         
    def var c-item-ini        as char    no-undo.
    def var c-item-fim        as char    no-undo.
    def var c-referencia-ini  as char    no-undo.
    def var c-referencia-fim  as char    no-undo.
    def var c-lote-ini        as char    no-undo.
    def var c-lote-fim        as char    no-undo.           
    def var i-tipo-trans      as integer no-undo.
/* ======================= ==========================*/    
    def var codigo            as char    no-undo.
    def var c-cod-depos       as char    no-undo.
    def var c-it-codigo       as char    no-undo.
    def var c-depos-ini       as char    no-undo.
    def var c-depos-fim       as char    no-undo.
    def var c-estabelec       as char    no-undo.
    def var i-espe-ini        as integer no-undo.
    def var i-espe-fim        as integer no-undo. 
    def var c-seri-ini        as char    no-undo.
    def var c-seri-fim        as char    no-undo.
    def var c-nume-ini        as char    no-undo.
    def var c-nume-fim        as char    no-undo.    
    def var i-medio           as integer no-undo.
    def var i-var-09          as integer no-undo.
    define variable c-nr-ord-produ-aux as character no-undo.

    def var i-seq    like oper-ord.sequencia no-undo.

    /*=================== defini‡Æo de vari veis para a SETCONSTRAINT7========================*/
    def var c-serie          as char    no-undo. 
    def var c-nat-oper       as char    no-undo. 
    def var c-cod-estab      as char    no-undo. 
    def var c-nro-docto      as char    no-undo. 
    def var i-cod-emit       as int     no-undo. 



/*   defini‡äes utilizadas pela api para valida‡Æo de chave estrangeira (ceapi001.p)  */

{cep/ceapi001.i}    /* Definicao de temp-table do movto-estoq */

{cdp/cd0666.i}      /* Definicao da temp-table de erros */

/* **   fim defini‡Æo api ** */


procedure setConstraint1:

end procedure.

procedure setConstraint2:

  /*Suleyka Sterzo Cavalcanti   -  29/12/1999  */

    def input parameter r-chave             as rowid      no-undo.
    def input parameter p-c-data-ini        as char       no-undo.
    def input parameter p-c-data-fim        as char       no-undo.
    def input parameter p-c-estabel-ini     as char       no-undo.
    def input parameter p-c-estabel-fim     as char       no-undo.
    def input parameter p-c-localiz-ini     as char       no-undo.
    def input parameter p-c-localiz-fim     as char       no-undo.
    def input parameter p-c-item-ini        as char       no-undo.
    def input parameter p-c-item-fim        as char       no-undo.
    def input parameter p-c-referencia-ini  as char       no-undo.
    def input parameter p-c-referencia-fim  as char       no-undo.
    def input parameter p-c-lote-ini        as char       no-undo.
    def input parameter p-c-lote-fim        as char       no-undo.
    def input parameter p-c-tp-movtos       as char       no-undo. 

    assign d-data-ini       =  date(p-c-data-ini) 
           d-data-fim       =  date(p-c-data-fim)
           c-estabel-ini    =  p-c-estabel-ini 
           c-estabel-fim    =  p-c-estabel-fim
           c-localiz-ini    =  p-c-localiz-ini
           c-localiz-fim    =  p-c-localiz-fim
           c-item-ini       =  p-c-item-ini
           c-item-fim       =  p-c-item-fim  
           c-referencia-ini =  p-c-referencia-ini
           c-referencia-fim =  p-c-referencia-fim
           c-lote-ini       =  p-c-lote-ini 
           c-lote-fim       =  p-c-lote-fim   
           i-tipo-trans     =  integer(p-c-tp-movtos).  

 find first deposito where rowid(deposito) = r-chave no-lock no-error.
 if avail deposito then assign c-cod-depos = deposito.cod-depos. 
end procedure.

procedure setConstraint3:
 def input parameter r-chave as rowid no-undo.
 find first estabelec where rowid(estabelec) = r-chave no-lock no-error.
end procedure.

procedure setConstraint4:
    def input parameter p-c-it-codigo       as char       no-undo.
    def input parameter p-c-data-ini        as char       no-undo.
    def input parameter p-c-data-fim        as char       no-undo.
    def input parameter p-c-depos-ini       as char       no-undo.
    def input parameter p-c-depos-fim       as char       no-undo.    
    def input parameter p-c-localiz-ini     as char       no-undo.
    def input parameter p-c-localiz-fim     as char       no-undo. 
    def input parameter p-c-estabelec       as char       no-undo.
    def input parameter p-c-espe-ini        as char       no-undo.
    def input parameter p-c-espe-fim        as char       no-undo.
    def input parameter p-c-seri-ini        as char       no-undo.
    def input parameter p-c-seri-fim        as char       no-undo.    
    def input parameter p-c-nume-ini        as char       no-undo.
    def input parameter p-c-nume-fim        as char       no-undo.    
    def input parameter p-c-referencia-ini  as char       no-undo.
    def input parameter p-c-referencia-fim  as char       no-undo.
    def input parameter p-c-lote-ini        as char       no-undo.
    def input parameter p-c-lote-fim        as char       no-undo.           

    assign c-it-codigo      =  p-c-it-codigo
           d-data-ini       =  date(p-c-data-ini) 
           d-data-fim       =  date(p-c-data-fim)
           c-depos-ini      =  p-c-depos-ini 
           c-depos-fim      =  p-c-depos-fim
           c-localiz-ini    =  p-c-localiz-ini
           c-localiz-fim    =  p-c-localiz-fim
           c-estabelec      =  p-c-estabelec
           i-espe-ini       =  integer(p-c-espe-ini)
           i-espe-fim       =  integer(p-c-espe-fim)            
           c-seri-ini       =  p-c-seri-ini
           c-seri-fim       =  p-c-seri-fim  
           c-nume-ini       =  p-c-nume-ini
           c-nume-fim       =  p-c-nume-fim           
           c-referencia-ini =  p-c-referencia-ini
           c-referencia-fim =  p-c-referencia-fim
           c-lote-ini       =  p-c-lote-ini 
           c-lote-fim       =  p-c-lote-fim.
end procedure.

procedure setConstraint5 :
    define input parameter c-nr-ord-produ as character  no-undo.
    assign c-nr-ord-produ-aux = c-nr-ord-produ.
end procedure.

procedure setConstraint6:

    def input parameter p-depos-ini    as char       no-undo.
    def input parameter p-depos-fim    as char       no-undo.
    def input parameter p-data-ini     as char       no-undo.
    def input parameter p-data-fim     as char       no-undo.
    def input parameter p-estabel-ini  as char       no-undo.
    def input parameter p-estabel-fim  as char       no-undo.
    def input parameter p-item-ini     as char       no-undo.
    def input parameter p-item-fim     as char       no-undo.

    assign c-depos-ini   =  p-depos-ini 
           c-depos-fim   =  p-depos-fim
           d-data-ini    =  date(p-data-ini) 
           d-data-fim    =  date(p-data-fim)
           c-estabel-ini =  p-estabel-ini
           c-estabel-fim =  p-estabel-fim
           c-item-ini    =  p-item-ini
           c-item-fim    =  p-item-fim.  

end procedure.
/*                             and (({&TABLE-NAME}.tipo-trans = 1 and i-tipo-trans = 1) or ({&TABLE-NAME}.tipo-trans = 2 and i-tipo-trans = 2)) no-lock.*/

procedure setConstraint7:

    def input parameter p-c-serie       as char       no-undo.
    def input parameter p-c-nat-oper    as char       no-undo.
    def input parameter p-c-cod-estab   as char       no-undo.
    def input parameter p-c-nro-docto   as char       no-undo.
    def input parameter p-i-cod-emit    as int        no-undo.


    assign c-serie      =  p-c-serie 
           c-nat-oper   =  p-c-nat-oper
           c-cod-estab  =  p-c-cod-estab 
           c-nro-docto  =  p-c-nro-docto
           i-cod-emit   =  p-i-cod-emit.

end procedure.

PROCEDURE setConstraint9:

    DEFINE INPUT  PARAMETER pTpTrans AS INTEGER    NO-UNDO.

    ASSIGN i-tipo-trans = pTpTrans.

END PROCEDURE.

PROCEDURE openQuery:

    DEFINE INPUT  PARAMETER i-abertura AS INTEGER    NO-UNDO.

    CASE i-abertura:
        when 1 then
             open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                &if "{&ems_dbtype}" <> "progress" &THEN
                    BY movto-estoq.nr-trans  INDEXED-REPOSITION.
                &else
                    BY movto-estoq.it-codigo INDEXED-REPOSITION.
                &endif
        when 2 then do :
            if i-tipo-trans <> 3 then     
                 open query {&QUERY-NAME} for each {&TABLE-NAME} 
                               &IF DEFINED(CUSTOM_GRENDENE) &THEN 
                                   use-index dep-estab
                               &ENDIF 
                               where {&TABLE-NAME}.cod-depos    = c-cod-depos
                                 and {&TABLE-NAME}.dt-trans    >= d-data-ini 
                                 and {&TABLE-NAME}.dt-trans    <= d-data-fim 
                                 and {&TABLE-NAME}.cod-estabel >= c-estabel-ini
                                 and {&TABLE-NAME}.cod-estabel <= c-estabel-fim
                                 and {&TABLE-NAME}.cod-localiz >= c-localiz-ini
                                 and {&TABLE-NAME}.cod-localiz <= c-localiz-fim
                                 and {&table-name}.it-codigo   >= c-item-ini
                                 and {&table-name}.it-codigo   <= c-item-fim
                                 and {&TABLE-NAME}.cod-refer   >= c-referencia-ini
                                 and {&TABLE-NAME}.cod-refer   <= c-referencia-fim
                                 and {&TABLE-NAME}.lote        >= c-lote-ini 
                                 and {&TABLE-NAME}.lote        <= c-lote-fim 
                                 and {&TABLE-NAME}.tipo-trans = i-tipo-trans no-lock
                                  by {&TABLE-NAME}.cod-depos
                                  by {&TABLE-NAME}.cod-estabel
                                  by {&TABLE-NAME}.dt-trans descending
                                  by {&table-name}.it-codigo
                                  by {&TABLE-NAME}.lote
                                  by {&TABLE-NAME}.cod-refer INDEXED-REPOSITION.
            else 
                 open query {&QUERY-NAME} for each {&TABLE-NAME} 
                               &IF DEFINED(CUSTOM_GRENDENE) &THEN 
                                   use-index dep-estab
                               &ENDIF 
                               where {&TABLE-NAME}.cod-depos    = c-cod-depos
                                 and {&TABLE-NAME}.dt-trans    >= d-data-ini 
                                 and {&TABLE-NAME}.dt-trans    <= d-data-fim 
                                 and {&TABLE-NAME}.cod-estabel >= c-estabel-ini
                                 and {&TABLE-NAME}.cod-estabel <= c-estabel-fim
                                 and {&TABLE-NAME}.cod-localiz >= c-localiz-ini
                                 and {&TABLE-NAME}.cod-localiz <= c-localiz-fim
                                 and {&table-name}.it-codigo   >= c-item-ini
                                 and {&table-name}.it-codigo   <= c-item-fim
                                 and {&TABLE-NAME}.cod-refer   >= c-referencia-ini
                                 and {&TABLE-NAME}.cod-refer   <= c-referencia-fim
                                 and {&TABLE-NAME}.lote        >= c-lote-ini 
                                 and {&TABLE-NAME}.lote        <= c-lote-fim no-lock
                                  by {&TABLE-NAME}.cod-depos
                                  by {&TABLE-NAME}.cod-estabel
                                  by {&TABLE-NAME}.dt-trans descending 
                                  by {&table-name}.it-codigo 
                                  by {&TABLE-NAME}.lote
                                  by {&TABLE-NAME}.cod-refer INDEXED-REPOSITION.
       end.
       when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} of estabelec
                                         &if '{&ems_dbtype}' = 'Progress' &then
                                              no-lock indexed-reposition.
                                         &else
                                              no-lock by {&TABLE-NAME}.dt-trans descending.
                                         &endif

       when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} 
                          where {&table-name}.it-codigo    = c-it-codigo
                            AND {&TABLE-NAME}.dt-trans    >= d-data-ini 
                            AND {&TABLE-NAME}.dt-trans    <= d-data-fim 
                            AND {&TABLE-NAME}.cod-depos   >= c-depos-ini 
                            AND {&TABLE-NAME}.cod-depos   <= c-depos-fim 
                            AND {&TABLE-NAME}.cod-localiz >= c-localiz-ini 
                            AND {&TABLE-NAME}.cod-localiz <= c-localiz-fim 
                            AND {&TABLE-NAME}.cod-estabel  = c-estabelec 
                            AND {&TABLE-NAME}.esp-docto   >= i-espe-ini
                            AND {&TABLE-NAME}.esp-docto   <= i-espe-fim 
                            AND {&TABLE-NAME}.serie-docto >= c-seri-ini 
                            AND {&TABLE-NAME}.serie-docto <= c-seri-fim 
                            AND {&TABLE-NAME}.nro-docto   >= c-nume-ini 
                            AND {&TABLE-NAME}.nro-docto   <= c-nume-fim 
                            AND {&TABLE-NAME}.cod-refer   >= c-referencia-ini 
                            AND {&TABLE-NAME}.cod-refer   <= c-referencia-fim 
                            AND {&TABLE-NAME}.lote        >= c-lote-ini 
                            AND {&TABLE-NAME}.lote        <= c-lote-fim  NO-LOCK
                            INDEXED-REPOSITION.
         when 5 then
              open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                            where {&TABLE-NAME}.nr-ord-produ = integer (c-nr-ord-produ-aux) INDEXED-REPOSITION.

         when 6 then
              open query {&QUERY-NAME} for each {&TABLE-NAME} 
                          where {&TABLE-NAME}.dt-trans    >= d-data-ini 
                            and {&TABLE-NAME}.dt-trans    <= d-data-fim 
                            and {&TABLE-NAME}.cod-estabel >= c-estabel-ini
                            and {&TABLE-NAME}.cod-estabel <= c-estabel-fim
                            and {&table-name}.it-codigo   >= c-item-ini
                            and {&table-name}.it-codigo   <= c-item-fim
                            and {&TABLE-NAME}.cod-depos   >= c-depos-ini
                            and {&TABLE-NAME}.cod-depos   <= c-depos-fim no-lock INDEXED-REPOSITION.
         when 7 then
              open query {&QUERY-NAME} FOR EACH {&TABLE-NAME}
                                                WHERE {&TABLE-NAME}.esp-docto = 28 NO-LOCK INDEXED-REPOSITION.

         when 8 then
              open query {&QUERY-NAME} FOR EACH {&TABLE-NAME}
                                          where   {&TABLE-NAME}.cod-estabel    = c-cod-estab
                                            and   {&TABLE-NAME}.serie-docto    = c-serie
                                            and   {&TABLE-NAME}.nro-docto      = c-nro-docto
                                            and   {&TABLE-NAME}.cod-emitente   = i-cod-emit 
                                            and   {&TABLE-NAME}.nat-operacao = c-nat-oper or c-nat-oper = "" 
                                            NO-LOCK INDEXED-REPOSITION. 
         WHEN 9 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} WHERE 
                       {&table-name}.it-codigo    = c-it-codigo AND
                       {&TABLE-NAME}.dt-trans    >= d-data-ini  AND 
                       {&TABLE-NAME}.dt-trans    <= d-data-fim  AND
                       {&TABLE-NAME}.cod-depos   >= c-depos-ini AND 
                       {&TABLE-NAME}.cod-depos   <= c-depos-fim AND 
                       {&TABLE-NAME}.cod-localiz >= c-localiz-ini AND 
                       {&TABLE-NAME}.cod-localiz <= c-localiz-fim AND 
                       {&TABLE-NAME}.cod-estabel  = c-estabelec   AND 
                       {&TABLE-NAME}.esp-docto   >= i-espe-ini    AND 
                       {&TABLE-NAME}.esp-docto   <= i-espe-fim    AND 
                       {&TABLE-NAME}.serie-docto >= c-seri-ini    AND 
                       {&TABLE-NAME}.serie-docto <= c-seri-fim    AND 
                       {&TABLE-NAME}.nro-docto   >= c-nume-ini    AND 
                       {&TABLE-NAME}.nro-docto   <= c-nume-fim    AND 
                       {&TABLE-NAME}.cod-refer   >= c-referencia-ini AND 
                       {&TABLE-NAME}.cod-refer   <= c-referencia-fim AND 
                       {&TABLE-NAME}.lote        >= c-lote-ini       AND 
                       {&TABLE-NAME}.lote        <= c-lote-fim       AND 
                       (IF i-tipo-trans = 3 THEN YES else
                          {&TABLE-NAME}.tipo-trans = i-tipo-trans)    NO-LOCK
                       INDEXED-REPOSITION.         
    END CASE.
    assign l-query    = true
           i-bo-query = i-abertura.
END PROCEDURE.

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

procedure findNr_trans:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input  parameter i-nr-trans as inte no-undo.
    def output parameter c-return   as char no-undo.

    find movto-estoq where
        movto-estoq.nr-trans = i-nr-trans
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

procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.

    run startMethod ("validateFields").
    if rowObject.cod-depos = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-depos 1}
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
        {utp/ut-field.i movind {&TABLE-NAME} cod-estabel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.cod-estabel-des = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-estabel-des 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.cod-refer = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-refer 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.ct-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} ct-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.dt-trans = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} dt-trans 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.esp-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} esp-docto 1}
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
        {utp/ut-field.i movind {&TABLE-NAME} it-codigo 1}
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
        {utp/ut-field.i movind {&TABLE-NAME} nat-operacao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.nr-trans = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} nr-trans 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.nro-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} nro-docto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.num-ord-des = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} num-ord-des 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.num-sequen = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} num-sequen 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.op-seq = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} op-seq 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.quantidade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} quantidade 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.sc-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} sc-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.sequen-nf = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} sequen-nf 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.serie-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} serie-docto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.tipo-preco[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tipo-preco 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.tipo-preco[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tipo-preco 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.tipo-preco[03] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tipo-preco 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.tipo-trans = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tipo-trans 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.tipo-valor = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tipo-valor 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.un = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} un 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.valor-icm = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor-icm 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.valor-ipi = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor-ipi 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.valor-iss = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor-iss 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.valor-nota = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor-nota 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-icm-fasb[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} vl-icm-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-icm-fasb[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} vl-icm-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-ipi-fasb[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} vl-ipi-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-ipi-fasb[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} vl-ipi-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-iss-fasb[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} vl-iss-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-iss-fasb[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} vl-iss-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-nota-fasb[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} vl-nota-fasb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.vl-nota-fasb[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} vl-nota-fasb 1}
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
    def input  param p-reduzida     as   int  no-undo.
    def input  param p-dt-vali-lote as   date no-undo.
    def input  param p-perg01       as   char no-undo.
    def input  param p-perg02       as   char no-undo.
    def input  param p-perg03       as   char no-undo.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.

    def var iEmpresa like param-global.empresa-prin no-undo.    

    run initializeValidate.
    run startMethod ("validateCreate").

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.


    run validateFields.

 /*---------------------------------------*/

    find first RowObject no-error.
    find first param-global no-lock no-error.

    assign iEmpresa = param-global.empresa-prin.
    &if defined (bf_dis_consiste_conta) &then
        find estabelec where
             estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.
        if avail estabelec then do:
           run cdp/cd9970.p (input  rowid(estabelec),
                              output iEmpresa).
        end.
    &endif

    find first param-estoq  no-lock no-error.
    if RowObject.dt-trans <= param-estoq.ult-fech-dia then do:
        run utp/ut-msgs.p (input "msg",
                           input 7186, 
                           input "").
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 7186
               tt-bo-erro.mensagem     = return-value. 
    end.
    if RowObject.dt-trans > today then do:
        run utp/ut-msgs.p (input "msg",
                           input 1929,
                           input "").
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 1929
               tt-bo-erro.mensagem     = return-value.        
    end.

    if RowObject.nr-ord-produ = 0 then do:
        assign RowObject.nr-ord-produ = 0
               RowObject.item-pai     = ''
               RowObject.cod-roteiro  = ''
               RowObject.op-codigo    = 0.
        if RowObject.conta-contabil = "" then do:
            find first empresa where empresa.ep-codigo = iEmpresa no-lock no-error.
            if avail empresa and empresa.usa-reduzida = yes then do:
                find conta-contab use-index reduzida
                    where conta-contab.ep-codigo = iEmpresa 
                      and conta-contab.reduzida  = p-reduzida no-lock no-error.
                if avail conta-contab then do:
                    RowObject.conta-contabil = conta-contab.conta-contabil.
                end.
                else do:
                    {utp/ut-table.i mgadm conta-contab 1}
                    run utp/ut-msgs.p (input "msg",
                                       input 2,
                                       input return-value).
                    assign i-seq-erro = i-seq-erro + 1.
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 2
                           tt-bo-erro.mensagem     = return-value.        

                end.
            end.
        end.
    end.
    else do:
            find ord-prod where ord-prod.nr-ord-produ = RowObject.nr-ord-produ no-lock no-error.
            if avail ord-prod then do:
                 assign RowObject.conta-contabil = ord-prod.conta-ordem. 
                 find conta-contab where 
                      conta-contab.ep-codigo    = iEmpresa and
                      conta-contab.conta-contabil = ord-prod.conta-ordem no-lock no-error.
                 if avail conta-contab then
                     assign RowObject.conta-contabil = conta-contab.conta-contabil. 
            end.    
    end.
    find item where item.it-codigo = RowObject.it-codigo no-lock no-error.
    if avail item then do:
        find ord-prod where ord-prod.nr-ord-produ = RowObject.nr-ord-produ no-lock no-error.
        if item.tipo-con-est <> 4 then do:
           assign RowObject.cod-refer = "".
        end.         
        if item.loc-unica then do:
           assign RowObject.cod-localiz = "".
        end.

        if item.tipo-con-est = 1 then do:
           assign RowObject.cod-refer = "".
        end.
        if RowObject.quantidade = 2 then do:
            assign RowObject.quantidade = 1.
        end.
        if item.tipo-con-est <> 4 then do:
           assign RowObject.cod-refer = " ".
        end.        
        if item.cod-obsoleto = 3 then do:
            run utp/ut-msgs.p (input "msg",
                               input 1885,
                               input "").
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 1885
                   tt-bo-erro.mensagem     = return-value.                           
        end.
        if item.it-codigo = "" or item.tipo-contr = 4 then do:
            run utp/ut-msgs.p (input "msg",
                               input 1886,
                               input "").
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 1886
                   tt-bo-erro.mensagem     = return-value.                           
        end.
        if item.loc-unica then 
            assign RowObject.cod-localiz = item.cod-localiz.
        if item.tipo-con-est = 1 then
            assign RowObject.lote      = ''
                   RowObject.cod-refer = ''.
        if item.tipo-con-est = 2 or item.tipo-con-est = 3 then
            assign RowObject.cod-refer = ''.

        if item.tipo-con-est > 1 and RowObject.lote = "" then do:
           run utp/ut-msgs.p (input "msg",
                              input 2158,
                              input "").
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2158
                   tt-bo-erro.mensagem     = return-value.                           
        end.

        find deposito where deposito.cod-depos = RowObject.cod-depos no-lock no-error.
        if avail deposito then do:
           if deposito.ind-dep-cq = yes and item.contr-qualid then do:
                run utp/ut-msgs.p (input "msg",
                                   input 1887,
                                   input "").
                assign i-seq-erro = i-seq-erro + 1.
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 1887
                       tt-bo-erro.mensagem     = return-value.                           
           end.

           if deposito.ind-dep-rej = yes and item.contr-qualid then do:
              run utp/ut-msgs.p (input "msg",
                                 input 1888,
                                 input "").
                assign i-seq-erro = i-seq-erro + 1.
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 1888
                       tt-bo-erro.mensagem     = return-value. 
           end.
        end.
        if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
           find first saldo-estoq use-index lote where saldo-estoq.lote      = RowObject.lote and
                                                       saldo-estoq.it-codigo = item.it-codigo no-lock no-error.
           if avail saldo-estoq then do:
              assign p-dt-vali-lote = saldo-estoq.dt-vali-lote
                     RowObject.cod-refer    = saldo-estoq.cod-refer.
              if saldo-estoq.dt-vali-lote < RowObject.dt-trans and
                 p-perg02 = "no" then do:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-de-validade AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "de_Validade" *}
                 ASSIGN c-lbl-liter-de-validade = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-de-transacao AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "de_Transa‡Æo" *}
                 ASSIGN c-lbl-liter-de-transacao = TRIM(RETURN-VALUE).
                 run utp/ut-msgs.p (input "msg",
                                    input 89,
                                    input c-lbl-liter-de-validade + "~~" + c-lbl-liter-de-transacao).
                 assign i-seq-erro = i-seq-erro + 1.
                 create tt-bo-erro.
                 assign tt-bo-erro.i-sequen     = i-seq-erro
                        tt-bo-erro.cd-erro      = 89
                        tt-bo-erro.mensagem     = return-value. 
              end.
           end.
           else do:
              if p-dt-vali-lote = ? then do:
                 run utp/ut-msgs.p (input "msg",
                                    input 2205,
                                    input return-value).
                    assign i-seq-erro = i-seq-erro + 1.
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 2205
                           tt-bo-erro.mensagem     = return-value.                                    
              end.                             
              if p-dt-vali-lote < RowObject.dt-trans and
                 p-perg02 = "no" then do:
                   /* Inicio -- Projeto Internacional */
                   DEFINE VARIABLE c-lbl-liter-de-validade-2 AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "de_Validade" *}
                   ASSIGN c-lbl-liter-de-validade-2 = TRIM(RETURN-VALUE).
                   DEFINE VARIABLE c-lbl-liter-de-transacao-2 AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "de_Transa‡Æo" *}
                   ASSIGN c-lbl-liter-de-transacao-2 = TRIM(RETURN-VALUE).
                   run utp/ut-msgs.p (input "msg",  /* Data de Validade e menor que data da transacao.Deseja proseguir? */
                                      input 89,
                                      input c-lbl-liter-de-validade-2 + "~~" + c-lbl-liter-de-transacao-2).
                  assign i-seq-erro = i-seq-erro + 1.
                  create tt-bo-erro.
                  assign tt-bo-erro.i-sequen     = i-seq-erro
                         tt-bo-erro.cd-erro      = 89
                         tt-bo-erro.mensagem     = return-value.
              end. 
              if item.tipo-con-est = 4 then do:
                 find referencia where referencia.cod-refer = RowObject.cod-refer no-lock no-error.
                 if not avail referencia then do:
                        {utp/ut-table.i mgind referencia 1}
                        run utp/ut-msgs.p (input "msg", input 2, input return-value).
                        assign i-seq-erro = i-seq-erro + 1.
                        create tt-bo-erro.
                        assign tt-bo-erro.i-sequen     = i-seq-erro
                               tt-bo-erro.cd-erro      = 2
                               tt-bo-erro.mensagem     = return-value.
                 end.
              end.
           end. 
        end.
        if RowObject.un <> item.un then do:
                run utp/ut-msgs.p (input "msg",input 1571,input "").
                assign i-seq-erro = i-seq-erro + 1.
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 1571
                       tt-bo-erro.mensagem     = return-value.               
        end.
        if not item.fraciona and 
           RowObject.quantidade <> 
           integer(RowObject.quantidade) then do:
           run utp/ut-msgs.p (input "msg", input 1892,input "").
                assign i-seq-erro = i-seq-erro + 1.
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 1892
                       tt-bo-erro.mensagem     = return-value.               
        end.  
        if avail ord-prod then do:
            find first reservas where reservas.nr-ord-produ = ord-prod.nr-ord-produ and
                                      reservas.it-codigo   = item.it-codigo no-lock no-error.
            if  (ord-prod.rep-prod > 1 and ord-prod.rep-prod < 4) or avail reservas then do:
                if  avail ord-prod and param-global.modulo-cp then do:
                    &IF DEFINED (bf_man_linha_estab) &THEN
                    find lin-prod 
                         where lin-prod.cod-estabel = ord-prod.cod-estabel
                           and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.                  
                    &ELSE
                    find lin-prod where lin-prod.nr-linha = ord-prod.nr-linha no-lock no-error.
                    &ENDIF
                    if not avail lin-prod or
                                 lin-prod.sum-requis <> 2 or
                                 item.tipo-requis    <> 1 then do:
                        assign RowObject.nr-ord-produ = 0
                               RowObject.item-pai     = ''
                               RowObject.cod-roteiro  = ''
                               RowObject.op-codigo    = 0.
                    end.  
                end.   
            end.
            if (ord-prod.rep-prod = 1 or ord-prod.rep-prod = 4) and avail reservas then do:
                find next reservas where reservas.nr-ord-produ = ord-prod.nr-ord-produ and
                                         reservas.it-codigo    = item.it-codigo no-lock no-error.
                if  avail reservas then do:
                    if avail ord-prod and param-global.modulo-cp then do:
                        &IF DEFINED (bf_man_linha_estab) &THEN
                            find lin-prod 
                           where lin-prod.cod-estabel = ord-prod.cod-estabel
                             and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.                  
                        &ELSE
                            find lin-prod where lin-prod.nr-linha = ord-prod.nr-linha no-lock no-error.
                        &ENDIF
                        if not avail lin-prod or
                                     lin-prod.sum-requis <> 2 or
                                     item.tipo-requis    <> 1 then do:
                            assign RowObject.nr-ord-produ = 0
                                   RowObject.item-pai     = ''
                                   RowObject.cod-roteiro  = ''
                                   RowObject.op-codigo    = 0.
                        end.  
                    end.   
                end.
            end.
        end.
    end.
    if RowObject.nr-ord-produ <> 0 then do:
        find ord-prod where ord-prod.nr-ord-produ = RowObject.nr-ord-produ no-lock no-error.
        if avail ord-prod then do:
            find first reservas where reservas.nr-ord-produ = ord-prod.nr-ord-produ and
                                      reservas.it-codigo    = RowObject.it-codigo no-lock no-error.
            if not avail reservas then do:
               run utp/ut-msgs.p (input "msg", 
                                  input 18542, 
                                  input "").
               if p-perg01 = "no" then do:
                  assign i-seq-erro = i-seq-erro + 1.
                  create tt-bo-erro.
                  assign tt-bo-erro.i-sequen     = i-seq-erro
                         tt-bo-erro.cd-erro      = 18542
                         tt-bo-erro.mensagem     = return-value. 
               end.
            end.
            else do:
               if avail item then do:
                   if  item.tipo-requis = 2 then do:
                       run utp/ut-msgs.p (input "msg",
                                          input 5675,
                                          input "").
                       assign i-seq-erro = i-seq-erro + 1.
                       create tt-bo-erro.
                       assign tt-bo-erro.i-sequen     = i-seq-erro
                              tt-bo-erro.cd-erro      = 5675
                              tt-bo-erro.mensagem     = return-value. 
                   end.
               end.
            end.
        end.
    end.
    if param-global.modulo-cp or 
       param-global.modulo-mi then do: 
       if RowObject.nr-ord-produ <> 0 then do:
          if  not avail ord-prod then do:
               run utp/ut-msgs.p (input "msg",
                                  input 1879, 
                                  input "").
               assign i-seq-erro = i-seq-erro + 1.
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 1879
                      tt-bo-erro.mensagem     = return-value.                               
          end.
          else do:
             if ord-prod.estado = 8  then do:
                   run utp/ut-msgs.p (input "msg", 
                                      input 1881, 
                                      input "").
                   assign i-seq-erro = i-seq-erro + 1.
                   create tt-bo-erro.
                   assign tt-bo-erro.i-sequen     = i-seq-erro
                          tt-bo-erro.cd-erro      = 1881
                          tt-bo-erro.mensagem     = return-value. 
             end.
             if ord-prod.estado = 7  then do:
                   run utp/ut-msgs.p (input "msg",
                                      input 1882,
                                      input "").
                   assign i-seq-erro = i-seq-erro + 1.
                   create tt-bo-erro.
                   assign tt-bo-erro.i-sequen     = i-seq-erro
                          tt-bo-erro.cd-erro      = 1882
                          tt-bo-erro.mensagem     = return-value. 
             end.
             if avail item then do:
                if  item.it-codigo = ord-prod.it-codigo and 
                    ord-prod.tipo <> 5 and 
                    ord-prod.tipo <> 9 then do:
                       run utp/ut-msgs.p (input "msg",
                                          input 2008,
                                          input "").
                       assign i-seq-erro = i-seq-erro + 1.
                       create tt-bo-erro.
                       assign tt-bo-erro.i-sequen     = i-seq-erro
                              tt-bo-erro.cd-erro      = 2008
                              tt-bo-erro.mensagem     = return-value. 
                end.                     
             end.
             if (ord-prod.rep-prod > 1 and ord-prod.rep-prod < 4) or avail reservas then do:
                /*       INCLUDE COM "SHOW", AGUARDANDO MODIFICA€åES       */
                /*         {cep/ce0205.i1}       */
             end.
          end.
       end.
       else do:      
          find first conta-contab where conta-contab.ep-codigo      = iEmpresa and
                                        conta-contab.conta-contabil = RowObject.conta-contabil no-lock no-error.
          if  not available conta-contab then do:
                   run utp/ut-msgs.p (input "msg", 
                                      input 1883,
                                      input "").
                   assign i-seq-erro = i-seq-erro + 1.
                   create tt-bo-erro.
                   assign tt-bo-erro.i-sequen     = i-seq-erro
                          tt-bo-erro.cd-erro      = 1883
                          tt-bo-erro.mensagem     = return-value.
          end.
          else do:            
            if  conta-contab.estado <> 3 then do:
                     run utp/ut-msgs.p (input "msg",
                                        input 443,
                                        input "").
                     assign i-seq-erro = i-seq-erro + 1.
                     create tt-bo-erro.
                     assign tt-bo-erro.i-sequen     = i-seq-erro
                            tt-bo-erro.cd-erro      = 443
                            tt-bo-erro.mensagem     = return-value. 
            end.              
            if conta-contab.estoque = 4 or conta-contab.estoque = 7 or 
               conta-contab.estoque = 8 or conta-contab.estoque = 9 or 
               conta-contab.estoque = 10                  then do:
                     run utp/ut-msgs.p (input "msg",
                                        input 1884,
                                        input "").
                     assign i-seq-erro = i-seq-erro + 1.
                     create tt-bo-erro.
                     assign tt-bo-erro.i-sequen     = i-seq-erro
                            tt-bo-erro.cd-erro      = 1884
                            tt-bo-erro.mensagem     = return-value. 
            end.
            if  conta-contab.estoque = 5 then do:
                     run utp/ut-msgs.p (input "msg",
                                        input 8629,
                                        input "").
                     assign i-seq-erro = i-seq-erro + 1.
                     create tt-bo-erro.
                     assign tt-bo-erro.i-sequen     = i-seq-erro
                            tt-bo-erro.cd-erro      = 8629
                            tt-bo-erro.mensagem     = return-value. 
            end.      
          end.
       end.
    end.
/*====================       Aguardando por Procedure     ===============================

        &IF DEFINED (bf_man_linha_estab) &THEN
        find lin-prod 
             where lin-prod.cod-estabel = ord-prod.cod-estabel
               and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.                  
        &ELSE
        find lin-prod where lin-prod.nr-linha = ord-prod.nr-linha no-lock no-error.
        &ENDIF
        if avail item then do:
            if avail lin-prod and 
               lin-prod.sum-requis = 2 and 
               item.tipo-requis    = 1 then do:
                find first reservas where 
                     reservas.nr-ord-produ = ord-prod.nr-ord-produ and
                     reservas.item-pai     = RowObject.item-pai    and
                     reservas.cod-roteiro  = RowObject.cod-roteiro and
                     reservas.op-codigo    = RowObject.op-codigo   and
                     reservas.it-codigo    = item.it-codigo no-lock no-error.
                if avail reservas then do:
                    find first aloca-reserva where 
                         aloca-reserva.nr-ord-produ = ord-prod.nr-ord-produ and
                         aloca-reserva.it-codigo    = item.it-codigo and
                         aloca-reserva.cod-estabel  = RowObject.cod-estabel and
                         aloca-reserva.cod-depos    = RowObject.cod-depos   and
                         aloca-reserva.item-pai     = RowObject.item-pai    and
                         aloca-reserva.cod-roteiro  = RowObject.cod-roteiro and
                         aloca-reserva.op-codigo    = RowObject.op-codigo
                         no-lock no-error.
                    if avail aloca-reserva then do:
                        if RowObject.quantidade > aloca-reserva.quant-aloc then do:
                            run utp/ut-msgs.p (input "msg",
                                               input 1893,
                                               input string(RowObject.quantidade) + "~~"
                                                                   + string(aloca-reserva.quant-aloc)).
                            if return-value = "no" then do:
                                assign i-seq-erro = i-seq-erro + 1.
                                create tt-bo-erro.
                                assign tt-bo-erro.i-sequen     = i-seq-erro
                                       tt-bo-erro.cd-erro      = 1893
                                       tt-bo-erro.mensagem     = return-value. 
                            end.
                        end.

                    end.
                end.
            end.
        end.
    end.

======================================================================================*/

    if RowObject.quantidade <= 0 then do:
        run utp/ut-msgs.p (input "msg",input 1368,input "").
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 1368
               tt-bo-erro.mensagem     = return-value.               
    end.
    if avail item then do:
            find saldo-estoq use-index estabel-dep where saldo-estoq.cod-estabel = RowObject.cod-estabel and
                                                         saldo-estoq.cod-depos   = RowObject.cod-depos   and
                                                         saldo-estoq.cod-localiz = RowObject.cod-localiz and
                                                         saldo-estoq.lote        = RowObject.lote        and
                                                         saldo-estoq.cod-refer   = RowObject.cod-refer   and
                                                         saldo-estoq.it-codigo   = item.it-codigo no-wait no-error .                    
            if not avail saldo-estoq then do:                                   
                if locked saldo-estoq then do:
                    {utp/ut-table.i movind saldo-estoq 1}
                    run utp/ut-msgs.p (input "msg",input 3012,input return-value).
                    assign i-seq-erro = i-seq-erro + 1.
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 3012
                           tt-bo-erro.mensagem     = return-value.
                end.
            end.
            else do:
                 find saldo-estoq use-index estabel-dep where saldo-estoq.cod-estabel = RowObject.cod-estabel and
                                                              saldo-estoq.cod-depos   = RowObject.cod-depos   and
                                                              saldo-estoq.cod-localiz = RowObject.cod-localiz and
                                                              saldo-estoq.lote        = RowObject.lote        and
                                                              saldo-estoq.cod-refer   = RowObject.cod-refer   and
                                                              saldo-estoq.it-codigo   = item.it-codigo exclusive-lock no-error.
            end.               
        /*       INCLUDE COM "SHOW", AGUARDANDO MODIFICA€åES       */
        /*   {cep/ce0205.i2}  */   /* Valida‡Æo de Saldo-Estoq/Quantidade */
    end.
    if avail ord-prod and param-global.modulo-cs then do:
        find last movto-mat use-index num-seq where
              movto-mat.nr-ord-produ = ord-prod.nr-ord-produ no-lock no-error.
        if  avail movto-mat then do:
            assign RowObject.num-sequen = movto-mat.num-sequen + 1.
        end.
        else do:
            assign RowObject.num-sequen = 1.
        end.
    end.
    if avail ord-prod and RowObject.nr-ord-produ <> 0 then do:
       assign RowObject.conta-contabil =  ord-prod.conta-ordem.
       find first conta-contab where conta-contab.ep-codigo      =  iEmpresa and
                                     conta-contab.conta-contabil = RowObject.conta-contabil no-lock no-error.
          if avail conta-contab then do:
             assign RowObject.ct-codigo = conta-contab.ct-codigo
                    RowObject.sc-codigo = conta-contab.sc-codigo.
          end.
    end.
    create tt-movto.  
    assign tt-movto.cod-versao-integracao = 1
           tt-movto.dt-trans         = RowObject.dt-trans
           tt-movto.nr-ord-produ     = RowObject.nr-ord-produ
           tt-movto.nro-docto        = RowObject.nro-docto
           tt-movto.serie-docto      = RowObject.serie-docto
           tt-movto.conta-contabil   = RowObject.conta-contabil
           tt-movto.it-codigo        = RowObject.it-codigo
           tt-movto.cod-estabel      = RowObject.cod-estabel
           tt-movto.cod-depos        = RowObject.cod-depos
           tt-movto.cod-localiz      = RowObject.cod-localiz
           tt-movto.cod-refer        = RowObject.cod-refer
           tt-movto.lote             = RowObject.lote
           tt-movto.quantidade       = RowObject.quantidade
           tt-movto.un               = RowObject.un
           tt-movto.tipo-trans       = 2
           tt-movto.esp-docto        = 28 /* requisicao */
           tt-movto.dt-vali-lote     = p-dt-vali-lote
           tt-movto.op-seq           = i-seq
           /*tt-movto.usuario          = c-seg-usuario*/. 

    run cep/ceapi001.p (input-output table tt-movto,
                        input-output table tt-erro,
                        input yes).  
    for each tt-erro:
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = tt-erro.cd-erro
               tt-bo-erro.mensagem     = tt-erro.mensagem.        
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
        when "cod-estabel-des" then c-value = RowObject.cod-estabel-des.
        when "cod-localiz" then c-value = RowObject.cod-localiz.
        when "cod-orig-trans" then c-value = RowObject.cod-orig-trans.
        when "cod-prog-orig" then c-value = RowObject.cod-prog-orig.
        when "cod-refer" then c-value = RowObject.cod-refer.
        when "cod-roteiro" then c-value = RowObject.cod-roteiro.
        when "cod-usu-ult-alter" then c-value = RowObject.cod-usu-ult-alter.
        when "conta-contabil" then c-value = RowObject.conta-contabil.
        when "conta-saldo" then c-value = RowObject.conta-saldo.
        when "ct-codigo" then c-value = RowObject.ct-codigo.
        when "ct-saldo" then c-value = RowObject.ct-saldo.
        when "descricao-db" then c-value = RowObject.descricao-db.
        when "hr-contab" then c-value = RowObject.hr-contab.
        when "hr-trans" then c-value = RowObject.hr-trans.
        when "it-codigo" then c-value = RowObject.it-codigo.
        when "item-pai" then c-value = RowObject.item-pai.
        when "lote" then c-value = RowObject.lote.
        when "nat-operacao" then c-value = RowObject.nat-operacao.
        when "nro-docto" then c-value = RowObject.nro-docto.
        when "origem-valor" then c-value = RowObject.origem-valor.
        when "refer-contab" then c-value = RowObject.refer-contab.
        when "referencia" then c-value = RowObject.referencia.
        when "sc-codigo" then c-value = RowObject.sc-codigo.
        when "sc-saldo" then c-value = RowObject.sc-saldo.
        when "serie-docto" then c-value = RowObject.serie-docto.
        when "un" then c-value = RowObject.un.
        when "usuario" then c-value = RowObject.usuario.
        otherwise return error.
    end case.
end procedure.

procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.

    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "peso-liquido" then c-value = RowObject.peso-liquido.
        when "quantidade" then c-value = RowObject.quantidade.
        when "valor-ggf-m[1]" then c-value = RowObject.valor-ggf-m[1].
        when "valor-ggf-m[2]" then c-value = RowObject.valor-ggf-m[2].
        when "valor-ggf-m[3]" then c-value = RowObject.valor-ggf-m[3].
        when "valor-ggf-o[1]" then c-value = RowObject.valor-ggf-o[1].
        when "valor-ggf-o[2]" then c-value = RowObject.valor-ggf-o[2].
        when "valor-ggf-o[3]" then c-value = RowObject.valor-ggf-o[3].
        when "valor-ggf-p[1]" then c-value = RowObject.valor-ggf-p[1].
        when "valor-ggf-p[2]" then c-value = RowObject.valor-ggf-p[2].
        when "valor-ggf-p[3]" then c-value = RowObject.valor-ggf-p[3].
        when "valor-icm" then c-value = RowObject.valor-icm.
        when "valor-ipi" then c-value = RowObject.valor-ipi.
        when "valor-iss" then c-value = RowObject.valor-iss.
        when "valor-mat-m[1]" then c-value = RowObject.valor-mat-m[1].
        when "valor-mat-m[2]" then c-value = RowObject.valor-mat-m[2].
        when "valor-mat-m[3]" then c-value = RowObject.valor-mat-m[3].
        when "valor-mat-o[1]" then c-value = RowObject.valor-mat-o[1].
        when "valor-mat-o[2]" then c-value = RowObject.valor-mat-o[2].
        when "valor-mat-o[3]" then c-value = RowObject.valor-mat-o[3].
        when "valor-mat-p[1]" then c-value = RowObject.valor-mat-p[1].
        when "valor-mat-p[2]" then c-value = RowObject.valor-mat-p[2].
        when "valor-mat-p[3]" then c-value = RowObject.valor-mat-p[3].
        when "valor-mob-m[1]" then c-value = RowObject.valor-mob-m[1].
        when "valor-mob-m[2]" then c-value = RowObject.valor-mob-m[2].
        when "valor-mob-m[3]" then c-value = RowObject.valor-mob-m[3].
        when "valor-mob-o[1]" then c-value = RowObject.valor-mob-o[1].
        when "valor-mob-o[2]" then c-value = RowObject.valor-mob-o[2].
        when "valor-mob-o[3]" then c-value = RowObject.valor-mob-o[3].
        when "valor-mob-p[1]" then c-value = RowObject.valor-mob-p[1].
        when "valor-mob-p[2]" then c-value = RowObject.valor-mob-p[2].
        when "valor-mob-p[3]" then c-value = RowObject.valor-mob-p[3].
        when "valor-nota" then c-value = RowObject.valor-nota.
        when "vl-icm-fasb[1]" then c-value = RowObject.vl-icm-fasb[1].
        when "vl-icm-fasb[2]" then c-value = RowObject.vl-icm-fasb[2].
        when "vl-ipi-fasb[1]" then c-value = RowObject.vl-ipi-fasb[1].
        when "vl-ipi-fasb[2]" then c-value = RowObject.vl-ipi-fasb[2].
        when "vl-iss-fasb[1]" then c-value = RowObject.vl-iss-fasb[1].
        when "vl-iss-fasb[2]" then c-value = RowObject.vl-iss-fasb[2].
        when "vl-nota-fasb[1]" then c-value = RowObject.vl-nota-fasb[1].
        when "vl-nota-fasb[2]" then c-value = RowObject.vl-nota-fasb[2].
        when "vl-taxa" then c-value = RowObject.vl-taxa.
        otherwise return error.
    end case.
end procedure.

procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.

    case c-field:
        when "cod-emitente" then c-value = RowObject.cod-emitente.
        when "esp-docto" then c-value = RowObject.esp-docto.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "nr-ord-produ" then c-value = RowObject.nr-ord-produ.
        when "nr-ord-refer" then c-value = RowObject.nr-ord-refer.
        when "nr-reporte" then c-value = RowObject.nr-reporte.
        when "nr-req-sum" then c-value = RowObject.nr-req-sum.
        when "nr-trans" then c-value = RowObject.nr-trans.
        when "nr-trans-deb" then c-value = RowObject.nr-trans-deb.
        when "num-ord-des" then c-value = RowObject.num-ord-des.
        when "num-ord-inv" then c-value = RowObject.num-ord-inv.
        when "num-seq-des" then c-value = RowObject.num-seq-des.
        when "num-sequen" then c-value = RowObject.num-sequen.
        when "numero-ordem" then c-value = RowObject.numero-ordem.
        when "op-codigo" then c-value = RowObject.op-codigo.
        when "op-seq" then c-value = RowObject.op-seq.
        when "sequen-nf" then c-value = RowObject.sequen-nf.
        when "tipo-preco[1]" then c-value = RowObject.tipo-preco[1].
        when "tipo-preco[2]" then c-value = RowObject.tipo-preco[2].
        when "tipo-preco[3]" then c-value = RowObject.tipo-preco[3].
        when "tipo-trans" then c-value = RowObject.tipo-trans.
        when "tipo-valor" then c-value = RowObject.tipo-valor.
        otherwise return error.
    end case.
end procedure.

procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.

    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "dt-contab" then c-value = RowObject.dt-contab.
        when "dt-nf-saida" then c-value = RowObject.dt-nf-saida.
        when "dt-trans" then c-value = RowObject.dt-trans.
        otherwise return error.
    end case.
end procedure.

procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.

    case c-field:
        when "contabilizado" then c-value = RowObject.contabilizado.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        otherwise return error.
    end case.
end procedure.

procedure retornaValorMaterialGgfMaoObra:
    /*
          Retorna o valor unitÿrio do Material, o valor unitÿrio da MÆo de Obra e o Valor Unitÿrio de GGF,
          trazendo cada valor desses em 3 tipos de moedas, a corrente, e outras cujos c¢digos estÆo 
          cadastrados na param-estoq (moeda1 e moeda2).

          Parƒmetros:
	   ipar1  : r-chave              : Rowid do Movimento corrente da interface
	   ipar2  : p-medio              : Valor escolhido na tela de parƒmetros
	   opar3  : e-de-valor1          : Valor unit rio do Material na moeda corrente
	   opar4  : e-de-valor2          : Valor unit rio do Material na moeda 1
	   opar5  : e-de-valor3          : Valor unit rio do Material na moeda 2
	   opar6  : e-de-valor4          : Valor unit rio da MÊo Obra na moeda corrente
	   opar7  : e-de-valor5          : Valor unit rio da MÊo Obra na moeda 1
	   opar8  : e-de-valor6          : Valor unit rio da MÊo Obra na moeda 2
	   opar9  : e-de-valor7          : Valor unit rio de GGF      na moeda corrente
	   opar10 : e-de-valor8          : Valor unit rio de GGF      na moeda 1
	   opar11 : e-de-valor9          : Valor unit rio de GGF      na moeda 2
          opar12 : tt-bo-erro           : temp-table com erros que venham a acontecer.
    */

    def input  parameter r-chave as rowid no-undo.
    def input  parameter p-medio     as integer no-undo.
    def output parameter e-de-valor1 as decimal no-undo.
    def output parameter e-de-valor2 as decimal no-undo.
    def output parameter e-de-valor3 as decimal no-undo.
    def output parameter e-de-valor4 as decimal no-undo.
    def output parameter e-de-valor5 as decimal no-undo.
    def output parameter e-de-valor6 as decimal no-undo.
    def output parameter e-de-valor7 as decimal no-undo.
    def output parameter e-de-valor8 as decimal no-undo.
    def output parameter e-de-valor9 as decimal no-undo.
    def output parameter table for tt-bo-erro.

    assign i-medio=p-medio.
    find first movto-estoq where rowid(movto-estoq) = r-chave no-lock no-error.

    if not avail {&TABLE-NAME} then do:
        assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i movind {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
    end.

    else do:

      find first param-estoq no-lock no-error.    
      if i-medio = ? or i-medio = 0 then do:
          find estabelec where estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.
          if avail estabelec then
              assign i-medio = estabelec.custo-contab.
      end.

      if i-medio = 1 then do:
          assign  e-de-valor1 = movto-estoq.valor-mat-m[1]
                  e-de-valor4 = movto-estoq.valor-mob-m[1]  
                  e-de-valor7 = movto-estoq.valor-ggf-m[1].

          if param-estoq.tem-moeda1 = yes then
              assign e-de-valor2 = movto-estoq.valor-mat-m[2]
                     e-de-valor5 = movto-estoq.valor-mob-m[2]
                     e-de-valor8 = movto-estoq.valor-ggf-m[2].


          if param-estoq.tem-moeda2 = yes then
              assign e-de-valor3 = movto-estoq.valor-mat-m[3]
                     e-de-valor6 = movto-estoq.valor-mob-m[3]
                     e-de-valor9 = movto-estoq.valor-ggf-m[3].
      end.

      else if i-medio = 2 then do:
          assign  e-de-valor1 = movto-estoq.valor-mat-o[1]
                  e-de-valor4 = movto-estoq.valor-mob-o[1]  
                  e-de-valor7 = movto-estoq.valor-ggf-o[1].

          if param-estoq.tem-moeda1 = yes then
              assign e-de-valor2 = movto-estoq.valor-mat-o[2]
                     e-de-valor5 = movto-estoq.valor-mob-o[2]
                     e-de-valor8 = movto-estoq.valor-ggf-o[2].


          if param-estoq.tem-moeda2 = yes then
              assign e-de-valor3 = movto-estoq.valor-mat-o[3]
                     e-de-valor6 = movto-estoq.valor-mob-o[3]
                     e-de-valor9 = movto-estoq.valor-ggf-o[3].
      end.

      else if i-medio = 3 then do:
          assign  e-de-valor1 = movto-estoq.valor-mat-p[1]
                  e-de-valor4 = movto-estoq.valor-mob-p[1]  
                  e-de-valor7 = movto-estoq.valor-ggf-p[1].

          if param-estoq.tem-moeda1 = yes then
              assign e-de-valor2 = movto-estoq.valor-mat-p[2]
                     e-de-valor5 = movto-estoq.valor-mob-p[2]
                     e-de-valor8 = movto-estoq.valor-ggf-p[2].


          if param-estoq.tem-moeda2 = yes then
              assign e-de-valor3 = movto-estoq.valor-mat-p[3]
                     e-de-valor6 = movto-estoq.valor-mob-p[3]
                     e-de-valor9 = movto-estoq.valor-ggf-p[3].
      end.
    end. 
end procedure.


procedure HabilitAddMovtoEstoq:

    /*
    Descri‡Æo:
    Verifica se existe Param-Global e Param-Estoq gravado na tabela, retornando temp-table 
    de erro e parƒmetros para habilitar e desabilitar campos de tela.

    Parƒmetros:
    opar1 : p-nr-ord-prod   : retorna sim/nao. Habilita ou nÆo a variavel de tela(Ordem Produ‡Æo). 
                              (Sim - Habilita, Nao - Desabilita).
    opar2 : p-reduzida      : retorna sim/nao. Habilita ou nÆo a variavel de tela(Conta Reduzida). 
                              (Sim - Habilita, Nao - Desabilita).
    opar3 : p-estabel       : retorna estabelecimento param-estoq.
    opar4 : tt-bo-erro      : retorna temp-table de erro.
    */

    def output param p-nr-ord-produ   as char no-undo.
    def output param p-hab-estab      as char no-undo.
    def output param p-reduzida       as char no-undo.
    def output param p-estabel        as char no-undo.
    def output param table            for tt-bo-erro.

    def var iEmpresa like param-global.empresa-prin no-undo.    

    assign p-nr-ord-produ     = 'sim' /* habilita */
           p-hab-estab        = 'sim' /* habilita */
           p-reduzida         = 'sim' /* habilita */.

    find first param-global  no-lock no-error.

    assign iEmpresa = param-global.empresa-prin.
    &if defined (bf_dis_consiste_conta) &then
        find estabelec where
             estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.
        if avail estabelec then do:
           run cdp/cd9970.p (input  rowid(estabelec),
                              output iEmpresa).
        end.
    &endif

    if not avail param-global then do:
        run utp/ut-msgs.p (input "msg",
                           input 16,
                           input "").
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16
               tt-bo-erro.mensagem     = return-value.    
    end.
    else do:
        if param-global.modulo-cp or param-global.modulo-mi then do:
           assign p-nr-ord-produ = 'sim' /* habilita */.
        end.
        else do:
           assign p-nr-ord-produ     = 'nao' /* nÆo habilita */.
        end.  
        find first empresa where empresa.ep-codigo = iEmpresa no-lock no-error.
        if avail empresa and empresa.usa-reduzida = no then do:        
            assign p-reduzida = 'nao'.
        end.
    end.
    find first param-estoq no-lock no-error.
    if not avail param-estoq then do:
        run utp/ut-msgs.p (input "msg",
                           input 1059,
                           input "").
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 1059
               tt-bo-erro.mensagem     = return-value.   
    end.
    else do:
       ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.
       /* Funcao Super/Minas */
       &IF DEFINED(Bf_dis_usuario_estab) &THEN
            IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                                 AND funcao.ativo     = YES) THEN DO:
               RUN cdp/cd8702.p (INPUT c-seg-usuario,
                                      INPUT-OUTPUT c-cod-estabel-usuar).
            END.
       &ENDIF
       assign p-estabel = c-cod-estabel-usuar.
       if param-estoq.estab-uni then 
          assign p-hab-estab = 'nao'.
    end.
end procedure.

procedure retornaCustoContab:

    /**************

     Retorna o tipo de custo que o usuÿrio estÿ utilizando na sua empresa.

     Par³metros:
     opar1 : p-custo - custo contÿbil   

    ***************/

    define output parameter p-custo as int no-undo.

    find first tt-param-cp no-error.
    if not avail tt-param-cp then do:
        find first param-cp no-lock no-error.
        if avail param-cp then do:
            create tt-param-cp.
            buffer-copy param-cp to tt-param-cp.
        end.
    end.

    if avail tt-param-cp then do:
       find first tt-estabelec 
            where tt-estabelec.cod-estabel = tt-param-cp.cod-estabel no-error.
       if not avail tt-estabelec then do:
           find first estabelec where estabelec.cod-estabel = tt-param-cp.cod-estabel no-lock no-error.
           if avail estabelec then do:
                create tt-estabelec.
                buffer-copy estabelec to tt-estabelec.
           end.
       end.

       if avail tt-estabelec 
            then assign p-custo = tt-estabelec.custo-contab.
    end.

end procedure.


Procedure verificaDoctoDuplicMovtoEstoq:

    /*
        Verifica se o documento j  est  cadastrado. Se estiver, retorna um AVISO.
        Parƒmetros:
        ipar1:  p-serie-docto  : s‚rie do documento informada pelo usuÿrio.
        ipar2:  p-nro-docto    : n£mero documento informado.
        opar3:  tt-bo-erro     : temp-table com Aviso.
    */

    def input  param p-serie-docto  as char no-undo.
    def input  param p-nro-docto    as char no-undo.
    def output param table for tt-bo-erro.

    find first movto-estoq where (movto-estoq.esp-docto = 28 or movto-estoq.esp-docto = 5) and
                                  movto-estoq.serie-docto = p-serie-docto                  and
                                  movto-estoq.nro-docto   = p-nro-docto no-lock no-error.
    if avail movto-estoq then do:
        run utp/ut-msgs.p (input "msg", 
                           input 3175, 
                           input "").
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 3175
               tt-bo-erro.mensagem     = return-value.                           
    end.


end procedure.

PROCEDURE retornaValorMAterial:
    /*Descri‡Æo: 
     *Valida valor do Material Mensal a ser retornado.
     *
     *Parƒmetros:
     *ipar1 : p-rowid     : Rowid do Movto-estoq.
     *ipar2 : p-medio     : Medio do Movto-estoq.
     *ipar3 : p-moeda     : Moeda do Movto-estoq.
     *opar4 : p-valor-mat : Valor do Material Mensal.*/

    def input  param p-rowid      as rowid   no-undo.
    def input  param p-medio      as char    no-undo.
    def input  param p-moeda      as char    no-undo.
    def output param p-valor-mat  as decimal no-undo.

    find first movto-estoq where rowid(movto-estoq) = p-rowid no-lock no-error.

    case int(p-medio):
       when 1 then assign p-valor-mat = movto-estoq.valor-mat-m[integer(p-moeda)].
       when 2 then assign p-valor-mat = movto-estoq.valor-mat-o[integer(p-moeda)].
       when 3 then assign p-valor-mat = movto-estoq.valor-mat-p[integer(p-moeda)].
    end case.

END.

PROCEDURE retornaValorMaoObra:
    /*Descri‡Æo: 
     *Valida valor da MÆo de Obra Mensal a ser retornado.
     *
     *Parƒmetros:
     *ipar1 : p-rowid     : Rowid do Movto-estoq.
     *ipar2 : p-medio     : Medio do Movto-estoq.
     *ipar3 : p-moeda     : Moeda do Movto-estoq.
     *opar4 : p-valor-mob : Valor da MÆo de Obra Mensal.*/

    def input  param p-rowid      as rowid   no-undo.
    def input  param p-medio      as char    no-undo.
    def input  param p-moeda      as char    no-undo.
    def output param p-valor-mob  as decimal no-undo.

    find first movto-estoq where rowid(movto-estoq) = p-rowid no-lock no-error.

    case int(p-medio):
       when 1 then assign p-valor-mob = movto-estoq.valor-mob-m[integer(p-moeda)].
       when 2 then assign p-valor-mob = movto-estoq.valor-mob-o[integer(p-moeda)].
       when 3 then assign p-valor-mob = movto-estoq.valor-mob-p[integer(p-moeda)].
    end case.

END.

PROCEDURE retornaValorGGF:
    /*Descri‡Æo: 
     *Valida valor do GGF Mensal a ser retornado.
     *
     *Parƒmetros:
     *ipar1 : p-rowid     : Rowid do Movto-estoq.
     *ipar2 : p-medio     : Medio do Movto-estoq.
     *ipar3 : p-moeda     : Moeda do Movto-estoq.
     *opar4 : p-valor-ggf : Valor do GGF Mensal.*/

    def input  param p-rowid      as rowid   no-undo.
    def input  param p-medio      as char    no-undo.
    def input  param p-moeda      as char    no-undo.
    def output param p-valor-ggf  as decimal no-undo.

    find first movto-estoq where rowid(movto-estoq) = p-rowid no-lock no-error.

    case int(p-medio):
       when 1 then assign p-valor-ggf = movto-estoq.valor-ggf-m[integer(p-moeda)].
       when 2 then assign p-valor-ggf = movto-estoq.valor-ggf-o[integer(p-moeda)].
       when 3 then assign p-valor-ggf = movto-estoq.valor-ggf-p[integer(p-moeda)].
    end case.

END.

Procedure AchaCodDepos:

/*
** Acha na tabela movto-estoq o codigo do deposito
** correspondente ao passado como parametro.
*/

run startMethod ("find").

def input parameter c-depos as char.
def output parameter c-return as char.

find first movto-estoq where movto-estoq.cod-depos = c-depos NO-LOCK no-error.
if not avail movto-estoq then do:
   c-return = "1".
end.
else do:
   c-return = "".
   run setCurrent.
end.

run endMethod ("find").

end procedure.


Procedure validaDataTransacao:
    /*
        Verifica se a data da transa‡Æo ‚ maior do que a data do dia. 
        Parƒmetros:
        ipar1:  p-data-trans : Data transa‡Æo informada pelo usu rio
        opar2:  tt-bo-erro   : temp-table com Aviso
    */

   define input  parameter p-data-trans as date no-undo.
   define output parameter table for tt-bo-erro.  

   define variable d-data-trans as date no-undo.

   assign d-data-trans = p-data-trans.

   if d-data-trans > today then do:
        {utp/ut-field.i movind {&TABLE-NAME} dt-trans 1}  
        run utp/ut-msgs.p (input "msg", 
                           input 255, 
                           input return-value).
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-data-transacao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Data_Transa‡Æo" *}
        ASSIGN c-lbl-liter-data-transacao = TRIM(RETURN-VALUE).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 255
               tt-bo-erro.mensagem     = c-lbl-liter
               tt-bo-erro.parametros    = c-lbl-liter-data-transacao.                           
   end.

end procedure.


