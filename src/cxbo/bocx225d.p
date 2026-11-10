/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX225D 2.00.00.013 } /*** "010013" 28/07/2025 10:44:29 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX225D MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX225d.P
**
**  ordens-embarque - Ordens Embarque para consulta acompanhamento embarques
**                    botäes ordens/itens - wim0555.p
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY tt-ordens
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-ordens

{include/boini.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

DEFINE TEMP-TABLE rowObject no-undo like ordens-embarque
    field r-rowid      as rowid
    field valor        as decimal
    field it-codigo    as char
    field data-entrega as date
    field num-pedido   like processo-imp.num-pedido
    field rownum       as int
    field desc-item    as char.

DEFINE TEMP-TABLE tt-ordens no-undo like ordens-embarque
    field r-rowid      as rowid
    field valor        as decimal
    field it-codigo    as char
    field data-entrega as date
    field num-pedido   like processo-imp.num-pedido
    field rownum       as int
    field desc-item    as char.
    
DEFINE TEMP-TABLE tt-itens no-undo
    field it-codigo  like item.it-codigo
    field quantidade like ordens-embarque.quantidade
    FIELD qt-do-forn LIKE ordens-embarque.qt-do-forn
    field valor      like cotacao-item.preco-unit
    index codigo is unique primary
        it-codigo.    
    
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.    

def var c-embarque     as char    no-undo. 
def var c-cod-estabel  as char    no-undo.
def var c-idioma       as char    no-undo.
def var i-cod-emitente as integer no-undo.
def var c-par          as char    no-undo.
def var da-emis        as date    no-undo.
def var de-quant       as decimal no-undo.
def var de-valor       as decimal no-undo.
def var i-var          as integer no-undo.
def var de-item        as integer no-undo.

{cdp/cdcfgmat.i}

procedure setConstraint1:

end procedure. 
 
procedure setConstraint2:
def input parameter p-emb   as char    no-undo.
def input parameter p-est   as char    no-undo.
def input parameter p-param as integer no-undo.
def var c-desc-item         as char    no-undo. 

assign c-embarque       = p-emb
       c-cod-estabel    = p-est
       i-var            = p-param.       
       
    for each tt-itens:
        delete tt-itens.
    end.
    
    find embarque-imp 
        where embarque-imp.cod-estabel = c-cod-estabel 
          and embarque-imp.embarque    = c-embarque no-lock no-error.
    if avail embarque-imp then do:
        for each ordens-embarque no-lock 
            where ordens-embarque.cod-estabel = embarque-imp.cod-estabel 
              and ordens-embarque.embarque    = embarque-imp.embarque 
              break by ordens-embarque.numero-ordem:
    
            find ordem-compra
               where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock no-error.
            if avail ordem-compra then do:            
            
                find cotacao-item 
                    where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                      and cotacao-item.cod-emitente = ordem-compra.cod-emitente
                      and cotacao-item.it-codigo    = ordem-compra.it-codigo 
                      and cotacao-item.cot-aprovada = yes 
                      no-lock no-error.     

                assign de-valor = (cotacao-item.pre-unit-for * 100 ) / 
                                  ( 100 + cotacao-item.aliquota-ipi ) . 

                find prazo-compra 
                    where prazo-compra.numero-ordem = ordens-embarque.numero-ordem 
                      and prazo-compra.parcela      = ordens-embarque.parcela no-lock no-error.
                      
                find tt-itens where tt-itens.it-codigo = ordem-compra.it-codigo no-error.
                if not avail tt-itens then do:
                    create tt-itens.
                    assign tt-itens.it-codigo = ordem-compra.it-codigo.
                end.                      
                assign tt-itens.quantidade = tt-itens.quantidade + ordens-embarque.quantidade
                       tt-itens.qt-do-forn = tt-itens.qt-do-forn + ordens-embarque.qt-do-forn
                       tt-itens.valor      = tt-itens.valor + 
                                             (de-valor * ordens-embarque.qt-do-forn).                                     
                  
                &IF DEFINED(bf-mat-comex) &THEN
                    FOR FIRST ITEM fields(descricao-1 descricao-2) WHERE
                              ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK:
                    END.
                    IF AVAIL ITEM THEN
                        ASSIGN c-desc-item = ITEM.descricao-1 + ITEM.descricao-2.
                &else
                    FOR FIRST ITEM fields(desc-item) WHERE
                              ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK:
                    END.
                    IF AVAIL ITEM THEN
                        ASSIGN c-desc-item = ITEM.desc-item.
                &ENDIF
                if i-var = 1 then do:     
                    create tt-ordens.
                    buffer-copy ordens-embarque to tt-ordens.
                    assign tt-ordens.valor        = de-valor * ordens-embarque.qt-do-forn
                           tt-ordens.r-rowid      = rowid(ordens-embarque)
                           tt-ordens.it-codigo    = ordem-compra.it-codigo
                           
                           tt-ordens.desc-item    = c-desc-item
                              
                           tt-ordens.num-pedido   = ordem-compra.num-pedido.
                    if avail prazo-compra then       
                        assign tt-ordens.data-entrega = prazo-compra.data-entrega.
                end.             
                else do:
                    if last-of(ordens-embarque.numero-ordem) then do:
                        find first tt-ordens 
                            where tt-ordens.it-codigo = ordem-compra.it-codigo 
                                  no-lock no-error.
                        find tt-itens
                            where tt-itens.it-codigo = ordem-compra.it-codigo no-error.                                                                    
                        if avail tt-ordens then do:
                            assign tt-ordens.quantidade = tt-itens.quantidade
                                   tt-ordens.qt-do-forn = tt-itens.qt-do-forn
                                   tt-ordens.valor      = tt-itens.valor.
                        end.                
                        else do:
                            create tt-ordens.
                            buffer-copy ordens-embarque except quantidade qt-do-forn to tt-ordens.
                            assign tt-ordens.quantidade   = tt-itens.quantidade
                                   tt-ordens.valor        = tt-itens.valor
                                   tt-ordens.qt-do-forn   = tt-itens.qt-do-forn
                                   tt-ordens.desc-item    = c-desc-item
                                   tt-ordens.it-codigo    = ordem-compra.it-codigo
                                   tt-ordens.num-pedido   = ordem-compra.num-pedido
                                   tt-ordens.r-rowid      = rowid(ordens-embarque).     
                        end.  
                    end.    
                end.         
            end.     
        end.     
    end.    
        
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
        when 2 then    
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock. 
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

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

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
            reposition {&query-name} to rowid to-rowid(pcRowIdent) no-error.
            get next {&query-name}.
        END.
        ELSE IF piStartRow NE ? AND piStartRow NE 0 THEN DO:
            REPOSITION  {&query-name} TO ROW piStartRow no-error.
            GET next {&query-name}.
        END.
        IF plNext THEN
            GET next {&query-name}.
        DO WHILE true:
            if available({&first-table-in-query})  and piRowsReturned < piRowsToReturn then do:
                create rowObject.
                buffer-copy {&table-name} to rowObject.
                assign rowObject.r-rowid      = {&table-name}.r-rowid
                       rowObject.valor        = {&table-name}.valor
                       rowObject.it-codigo    = {&table-name}.it-codigo
                       rowObject.data-entrega = {&table-name}.data-entrega
                       rowObject.num-pedido   = {&table-name}.num-pedido.
                GET NEXT {&query-name}.
                piRowsReturned = piRowsReturned + 1.
            end.
            else
                leave.
        END.
        IF piRowsReturned > 0 THEN DO:
            {&open-query}
            IF piStartRow = ? OR piStartRow = 0 THEN DO:
                get first {&query-name}.
                get prev {&query-name}.
            END.
            ELSE
                REPOSITION  {&query-name} TO ROW (piStartRow) no-error.
        END.
    END.
    RETURN.
end procedure.
 
procedure prevBrowseNavigation:
    /*
    **  Usado na navegação anterior do serverSendRows 
    */
    def input parameter c-rowid-atual as char no-undo.
    def input parameter i-linhas-prev as integer no-undo.
    def output parameter c-rowid-ant as char no-undo.
 
    def var i-cont as integer no-undo.
 
    reposition {&query-name} to rowid to-rowid(c-rowid-atual) no-error.
 
    do while (i-cont < (i-linhas-prev - 1)):
       get prev {&query-name}.
       assign i-cont = i-cont + 1.
    end.
    assign c-rowid-ant = string({&table-name}.r-rowid).
end procedure.

procedure calculaValorOrdem: 
/*
** Calcula o valor da ordem de embarque na moeda da cotacao do material
*/
def input  parameter p-numero-ordem like ordem-compra.numero-ordem  no-undo.
def input  parameter p-quantidade   like ordens-embarque.qt-do-forn no-undo.
def output param     p-valor        like cotacao-item.preco-unit    no-undo.
    
    find ordem-compra 
        where ordem-compra.numero-ordem = p-numero-ordem 
        no-lock no-error.            
    for each cotacao-item fields (cotacao-item.aliquota-ipi cotacao-item.pre-unit-for cotacao-item.cot-aprovada)
        where cotacao-item.numero-ordem = ordem-compra.numero-ordem 
          and cotacao-item.cod-emitente = ordem-compra.cod-emitente
          and cotacao-item.it-codigo    = ordem-compra.it-codigo
          no-lock:
        if cotacao-item.cot-aprovada then do:
            assign p-valor = ( ( (cotacao-item.pre-unit-for * 100 ) / 
                                 ( 100 + cotacao-item.aliquota-ipi) ) * p-quantidade ). 
            leave.
        end.            
    end.
end procedure.

procedure retornaTTOrdens:
def output param table for tt-ordens.

end procedure.

&IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &THEN
    PROCEDURE calculaTotaisEmb:
   
    def input  parameter p-cod-estabel    LIKE embarque-imp.cod-estabel       no-undo.
    def input  parameter p-embarque       LIKE embarque-imp.embarque          no-undo.
    def output param     p-peso-liq-tot   LIKE ordens-embarque.peso-liquido  no-undo.
    def output param     p-peso-bruto-tot LIKE ordens-embarque.peso-bruto    no-undo.
    def output param     p-cubagem-tot    LIKE ordens-embarque.val-cub-uni  no-undo.
    
    for each ordens-embarque 
        fields (ordens-embarque.peso-liquido
                ordens-embarque.peso-bruto
                ordens-embarque.val-cub-tot
                ordens-embarque.quantidade)
        where ordens-embarque.cod-estabel = p-cod-estabel
        and   ordens-embarque.embarque    = p-embarque no-lock:
    
        assign p-peso-liq-tot   = p-peso-liq-tot  + 
                                  &If '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN ordens-embarque.peso-liquido 
                                  &ELSE (ordens-embarque.quantidade * 
                                        ordens-embarque.peso-liquido)    
                                  &endif
               p-peso-bruto-tot = p-peso-bruto-tot  + 
                                  &If '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN ordens-embarque.peso-bruto 
                                  &else (ordens-embarque.quantidade * 
                                        ordens-embarque.peso-bruto)      
                                  &endif
               p-cubagem-tot    = p-cubagem-tot  +
                                  &If '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN ordens-embarque.val-cub-tot
                                  &else (ordens-embarque.quantidade * 
                                        ordens-embarque.val-cub-unit)
                                  &endif.
    end.
    END PROCEDURE.
&endif

        

    
