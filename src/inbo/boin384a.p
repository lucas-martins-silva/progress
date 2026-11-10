/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN384A 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BOIN384A MUT}
&ENDIF

/*************************************************************************************
**  BOIN384a.P  - Especifica p/ programa cp0514.w (browser filho).
**
**  req-sum - Requisicoes Sumarizadas - 
**
**  Ultima altera‡Æo : 03/08/99 - GeraBO
***************************************************************************************/

{inbo/boin384a.i RowObject}
{inbo/boin384a.i tt-requisicao}

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY tt-requisicao
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-requisicao

{include/boini.i}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

define  var  v-it-codigo       like item.it-codigo    no-undo.
define  var  l-finalizadas     as logical             no-undo.
define  var  l-terminadas      as logical             no-undo.

procedure setConstraint1:
    /* Faz a pesquisa p/ carregar a temp-table do browser 
    *  Parƒmetros:
    *  ipar1 : p-it-codigo     : Codigo do usuario.
    *  ipar2 : p-l-finalizadas : Parametro p/ listar ordens finalizadas.
    *  ipar3 : p-l-terminadas  : Parametro p/ listar ordens terminadas.
    */

     define input  parameter p-it-codigo     like item.it-codigo    no-undo.
     define input  parameter p-l-finalizadas as logical             no-undo.
     define input  parameter p-l-terminadas  as logical             no-undo.

     assign v-it-codigo   = p-it-codigo
            l-finalizadas = p-l-finalizadas
            l-terminadas  = p-l-terminadas.
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
/*{include/bosersen.i}*/
{include/boprebro.i}
{include/boexecre.i}
{include/boexeupt.i}
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}
 

procedure serverSendRows :
    /*
    **  Disponivel no smart data object da V9, e foi reimplementado dentro
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query
    **  e facilitara a migracao destes programas para os Smart Data Objects.
    */
    define input  parameter piStartRow     as  integer   no-undo.
    define input  parameter pcRowIdent     as  character no-undo.
    define input  parameter plNext         as  logical   no-undo.
    define input  parameter piRowsToReturn as  integer   no-undo.
    define output parameter piRowsReturned as  integer   no-undo.
    define output parameter table          for RowObject.

    define variable hQuery        as handle    no-undo.
    define variable hBuffer       as handle    no-undo.
    define variable hRowObject    as handle    no-undo.
    define variable hDataQuery    as handle    no-undo.
    define variable cRowIdent     as character no-undo.
    define variable rRowIDs       as rowid     extent 10 no-undo.
    define variable lOK           as logical   no-undo.
    define variable iRow          as integer   no-undo.

    for each rowObject:
        delete rowObject.
    end.    
    IF true THEN DO:
        IF pcRowIdent NE ? AND pcRowIdent NE "":U THEN DO:
            rRowIDs = ?.
            reposition {&query-name} to rowid to-rowid(pcRowIdent).
            get next {&query-name}.
        END.
        ELSE IF piStartRow NE ? AND piStartRow NE 0 THEN DO:
            REPOSITION  {&query-name} TO ROW piStartRow.
            GET next {&query-name}.
        END.
        IF plNext THEN
            GET next {&query-name}.
        DO WHILE available({&first-table-in-query}) :
            if piRowsToReturn <> 0 and piRowsReturned >= piRowsToReturn then do:
               leave.
            end.
            create rowObject.
            buffer-copy {&table-name} to rowObject.
            assign rowobject.r-rowid = rowid({&table-name}).
            GET NEXT {&query-name}.
            piRowsReturned = piRowsReturned + 1.   
        END.
        IF piRowsReturned > 0 THEN DO:
            RUN openQuery(i-bo-query).
            IF piStartRow = ? OR piStartRow = 0 THEN DO:
                get first {&query-name}.
                get prev {&query-name}.
            END.
            ELSE
                REPOSITION  {&query-name} TO ROW (piStartRow).
        END.
    END.
    RETURN.
end procedure.

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade"). 
    run endMethod   ("initializeValidade").
end procedure.
 
procedure findCodigo:
    /*  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-nr-req-sum as inte no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter c-return as char no-undo.
 
    find req-sum where req-sum.nr-req-sum = i-nr-req-sum
                   and req-sum.it-codigo = c-it-codigo  no-lock no-error.
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
    /*  Valida Fields
    */
    find first rowObject no-lock no-error.
 
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
 
    if rowObject.dep-destino = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} dep-destino 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.emite-requis = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} emite-requis 1}
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
 
    if rowObject.nr-req-sum = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} nr-req-sum 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qt-atendida = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qt-atendida 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qt-requis = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qt-requis 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qt-solicit = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qt-solicit 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.quant-aloc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} quant-aloc 1}
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
 
    run endMethod ("validateFields").
 
end procedure.
 
procedure validateCreate:
    /*  Valida cria‡Æo da tabela/duplicidade de registro.
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
 
    find first tt-bo-erro no-lock no-error.
    if not available tt-bo-erro then do:
        find req-sum where req-sum.nr-req-sum = rowObject.nr-req-sum
                       and req-sum.it-codigo = rowObject.it-codigo    no-lock no-error.
        if avail req-sum then do:
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
        when "cod-depos" then c-value = RowObject.cod-depos.
        when "cod-localiz" then c-value = RowObject.cod-localiz.
        when "dep-destino" then c-value = RowObject.dep-destino.
        when "it-codigo" then c-value = RowObject.it-codigo.
        when "loc-dest" then c-value = RowObject.loc-dest.
        when "lote-ser-dest" then c-value = RowObject.lote-ser-dest.
        when "lote-serie" then c-value = RowObject.lote-serie.
        when "un" then c-value = RowObject.un.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "qt-atendida" then c-value = RowObject.qt-atendida.
        when "qt-requis" then c-value = RowObject.qt-requis.
        when "qt-solicit" then c-value = RowObject.qt-solicit.
        when "quant-aloc" then c-value = RowObject.quant-aloc.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "nr-req-sum" then c-value = RowObject.nr-req-sum.
        when "op-codigo" then c-value = RowObject.op-codigo.
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
        when "emite-requis" then c-value = RowObject.emite-requis.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        otherwise return error.
    end case.
end procedure.

procedure carregaTemptableFilho:
      /* Gera a query p/ a tt-requisicao que ser  mostrada pelo browser
       * Parƒmetro:
       * opar1 : p-nro-linhas : Numero de registros gerados pela query.
      */

      def output parameter p-nro-linhas as integer no-undo.

      assign p-nro-linhas = 0.
 
for each tt-requisicao:
     delete tt-requisicao.
end.

for each req-sum where req-sum.it-codigo = v-it-codigo                     and  
                        (req-sum.qt-solicit - req-sum.qt-atendida) > 0     no-lock,
    first ord-prod where ord-prod.nr-req-sum = req-sum.nr-req-sum          and
                       ((ord-prod.estado = 5) or (ord-prod.estado = 6)     or
                        (ord-prod.estado = 7  and l-finalizadas)           or
                        (ord-prod.estado = 8  and l-terminadas))           no-lock:
    create tt-requisicao.
    assign tt-requisicao.nr-ordem    = 0
           tt-requisicao.nr-req      = req-sum.nr-req-sum
           tt-requisicao.quant-orig  = req-sum.qt-solicit
           tt-requisicao.quant-atend = req-sum.qt-atendida
           tt-requisicao.saldo       = (req-sum.qt-solicit - req-sum.qt-atendida).           
    assign p-nro-linhas = p-nro-linhas + 1.       
end.

for each reservas where reservas.it-codigo = v-it-codigo            and
                        reservas.quant-orig > 0                     and
                        reservas.quant-atend < reservas.quant-orig  and
                        reservas.estado = 1 no-lock,
    first ord-prod  where ord-prod.nr-ord-produ = reservas.nr-ord-produ   and
                          ord-prod.nr-req-sum = 0                         and
                        ((ord-prod.estado = 6) or (ord-prod.estado = 5)   or
                         (ord-prod.estado = 7  and l-finalizadas)         or
                         (ord-prod.estado = 8  and l-terminadas))         no-lock,
    first lin-prod where lin-prod.nr-linha = ord-prod.nr-linha no-lock:

    create tt-requisicao.
    assign tt-requisicao.nr-ordem    = reservas.nr-ord-produ
           tt-requisicao.nr-req      = 0
           tt-requisicao.quant-orig  = reservas.quant-orig
           tt-requisicao.quant-atend = reservas.quant-atend
           tt-requisicao.saldo       = (reservas.quant-orig - reservas.quant-atend).
    assign p-nro-linhas = p-nro-linhas + 1.           
end.

end procedure.    






 
