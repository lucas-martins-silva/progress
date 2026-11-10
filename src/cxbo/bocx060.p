/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX060 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX060 MUT}
&ENDIF

/*
**  BOCX060.P
**
**  traduc-item - Cadastro de Tradu‡äes de Itens
**
**  Ultima altera‡Æo : 05/05/99 - GeraBO - Brv9587
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY traduc-item
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME traduc-item
 
&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */ 
 
{include/boini.i}
 
{cxbo/bocx060.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var c-idioma as char no-undo.
def var c-item   as char no-undo. 
def var c-idioma-ini as char no-undo.
def var c-idioma-fim as char no-undo.
def var c-item-ini as char no-undo.
def var c-item-fim as char no-undo.
def var i-emitente-ini as int no-undo.
def var i-emitente-fim as int no-undo.

procedure setConstraint1:


end procedure.
 
procedure setConstraint2:
def input parameter p-item   as char no-undo.
def input parameter p-idioma as char no-undo.

assign c-idioma = p-idioma
       c-item   = p-item.
end procedure.
 
procedure setConstraint3:
def input parameter p-item-ini as char no-undo.
def input parameter p-item-fim as char no-undo.

assign c-item-ini = p-item-ini
       c-item-fim = p-item-fim.
end procedure.
 
procedure setConstraint4:
def input parameter p-idioma-ini as char no-undo.
def input parameter p-idioma-fim as char no-undo.

assign c-idioma-ini = p-idioma-ini
       c-idioma-fim = p-idioma-fim.

end procedure.

procedure setConstraint5:
def input parameter p-item-ini as char no-undo.
def input parameter p-item-fim as char no-undo.
def input parameter p-idioma-ini as char no-undo.
def input parameter p-idioma-fim as char no-undo.
&if "{&bf_mat_versao_ems}" >= "2.062" &then
def input parameter p-emit-ini as char no-undo.
def input parameter p-emit-fim as char no-undo.
&endif

assign c-idioma-ini = p-idioma-ini
       c-idioma-fim = p-idioma-fim
       c-item-ini   = p-item-ini
       c-item-fim   = p-item-fim
    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
       i-emitente-ini  = int(p-emit-ini)
       i-emitente-fim  = int(p-emit-fim)
    &endif .
end procedure.

procedure setConstraint6:
def input parameter p-emitente-ini as int no-undo.
def input parameter p-emitente-fim as int no-undo.

assign i-emitente-ini = p-emitente-ini
       i-emitente-fim = p-emitente-fim.

end procedure.
 

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where traduc-item.it-codigo >= c-item and 
                                                                  traduc-item.cod-idioma >= c-idioma
                                                                  no-lock use-index pk-tr-item
                                                                  {&v9indrep}. 
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where traduc-item.it-codigo >= c-item-ini and 
                                                                  traduc-item.it-codigo <= c-item-fim no-lock 
                                                                  by traduc-item.it-codigo
                                                                  {&v9indrep}.
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where traduc-item.cod-idioma >= c-idioma-ini and 
                                                                  traduc-item.cod-idioma <= c-idioma-fim no-lock 
                                                                  by traduc-item.cod-idioma
                                                                  {&v9indrep}.
        when 5 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where traduc-item.it-codigo >= c-item-ini and
                                                                  traduc-item.it-codigo <= c-item-fim and
                                                                  traduc-item.cod-idioma >= c-idioma-ini and 
                                                                  traduc-item.cod-idioma <= c-idioma-fim
                                                                &if "{&bf_mat_versao_ems}":U >= "2.062":U &then 
                                                                  and traduc-item.cod-emitente >= i-emitente-ini
                                                                  and traduc-item.cod-emitente <= i-emitente-fim
                                                                &endif
                                                                 no-lock 
                                                                  use-index pk-tr-item
                                                                  {&v9indrep}.  
       &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
       when 6 then
           open query {&QUERY-NAME} for each {&TABLE-NAME} where traduc-item.cod-emitente >= i-emitente-ini and 
                                                                 traduc-item.cod-emitente <= i-emitente-fim no-lock 
                                                                  by traduc-item.cod-emitente
                                                                  {&v9indrep}.
       &endif
       
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
{include/bovaldel.i}

procedure executeUpdate:
    /*
    **  Executa Update
    */
    
    buffer-copy RowObject except r-rowid it-codigo cod-idioma
                          &if "{&bf_mat_versao_ems}":U >= "2.062":U &then cod-emitente &endif
                          to {&TABLE-NAME}.
end procedure.

 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

procedure findCh_tr_item:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-cod-idioma as char no-undo.
    def input parameter c-it-codigo  as char no-undo.
    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then   
        def input parameter i-cod-emitente as integer no-undo.
    &endif
    
    def output parameter table for RowObject.
 
    find traduc-item where
         traduc-item.cod-idioma = c-cod-idioma
     and traduc-item.it-codigo = c-it-codigo
        &if  "{&bf_mat_versao_ems}":U >= "2.062":U &then   
            and traduc-item.cod-emitente = i-cod-emitente
        &endif
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
 
procedure findPk_tr_item:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-it-codigo as char no-undo.
    def input parameter c-cod-idioma as char no-undo.

    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then  
        def input parameter i-cod-emitente as integer no-undo. 
    &endif

    def output parameter c-return as char no-undo.
 
    find traduc-item where
        traduc-item.it-codigo = c-it-codigo
        and traduc-item.cod-idioma = c-cod-idioma
        &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
            and traduc-item.cod-emitente = i-cod-emitente
        &endif
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
           if not can-find(idioma where
                  idioma.id-codigo = rowObject.cod-idioma) then do:
              assign i-seq-erro = i-seq-erro + 1.
              run utp/ut-msgs.p (input "msg",
                                 input 4774,
                                 input " ").
              create tt-bo-erro.
              assign tt-bo-erro.i-sequen  = i-seq-erro
                     tt-bo-erro.cd-erro   = 4774
                     tt-bo-erro.mensagem  = return-value.
           end.
       &else
           if not can-find(idioma where
                  idioma.cod_idioma = rowObject.cod-idioma) then do:
              assign i-seq-erro = i-seq-erro + 1.
              run utp/ut-msgs.p (input "msg",
                                 input 4774,
                                 input " ").
              create tt-bo-erro.
              assign tt-bo-erro.i-sequen  = i-seq-erro
                     tt-bo-erro.cd-erro   = 4774
                     tt-bo-erro.mensagem  = return-value.
           end.
       &endif
    end.
 
    if rowObject.it-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} it-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else do:
       if not can-find(item where
              item.it-codigo = rowObject.it-codigo) then do:
          assign i-seq-erro = i-seq-erro + 1.
          {utp/ut-field.i mgind item it-codigo 1}
          run utp/ut-msgs.p (input "msg",
                             input 166,
                             input return-value).
          create tt-bo-erro.
          assign tt-bo-erro.i-sequen  = i-seq-erro
                 tt-bo-erro.cd-erro   = 166
                 tt-bo-erro.mensagem  = return-value.
       end.
    end.
 

    if rowObject.tr-it-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} tr-it-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.tr-desc-item = ? or rowObject.tr-desc-item = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} tr-desc-item 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
     if rowObject.tr-narrativa = ?  then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} tr-narrativa 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
         if RowObject.cod-emitente <> 0 and
             not can-find(first emitente where                                           
                                emitente.cod-emitente = RowObject.cod-emitente) then do:
    
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-table.i mgadm emitente cod-emitente 1}
               run utp/ut-msgs.p (input "msg",
                                  input 2804,
                                  input return-value).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 2804
                      tt-bo-erro.mensagem     = return-value.
            end.
    &endif
    
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
   /** Verifica duplicidade dos registros **/
    if can-find(first traduc-item where
                      traduc-item.cod-idioma = rowObject.cod-idioma
                  and traduc-item.it-codigo  = rowObject.it-codigo
                  &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
                      and traduc-item.cod-emitente = rowObject.cod-emitente
                  &endif)   then do:

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
        when "cod-idioma" then c-value = RowObject.cod-idioma.
        when "it-codigo" then c-value = RowObject.it-codigo.
        when "tr-desc-item" then c-value = RowObject.tr-desc-item.
        when "tr-it-codigo" then c-value = RowObject.tr-it-codigo.
        when "tr-narrativa" then c-value = RowObject.tr-narrativa.
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

        &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
            when "cod-emitente" then c-value = RowObject.cod-emitente.
        &endif
        
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
 
