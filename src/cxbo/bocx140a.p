/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX140A 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX140A MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX140a.P
**
**  processo-imp - Processo de Importacao para Consulta Acompanhamento Processo 
**                 botäes Ordens/Itens - wim0550.p
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY tt-ordens
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-ordens

{include/boini.i}
{cdp/cdcfgmat.i}

DEFINE TEMP-TABLE rowObject NO-UNDO like prazo-compra
    field r-rowid     as rowid
    field valor      as decimal format ">>>>>,>>>,>>9.9999"
    field num-pedido  like processo-imp.num-pedido.
    
DEFINE TEMP-TABLE tt-ordens NO-UNDO like prazo-compra
    field r-rowid     as rowid
    field valor      as decimal format ">>>>>,>>>,>>9.9999"
    field num-pedido  like processo-imp.num-pedido.    

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var c-nr-proc-imp  as char    no-undo. 
def var c-cod-estabel  as char    no-undo.
def var c-idioma       as char    no-undo.
def var i-cod-emitente as integer no-undo.
def var c-par          as char    no-undo.
def var da-emis        as date    no-undo.
def var de-quant       as decimal no-undo.
def var de-valor       as decimal no-undo.
def var i-var          as integer no-undo.
def var de-item        as integer no-undo.

procedure setConstraint1:

end procedure.

procedure setConstraint2:

def input parameter p-proc  as char    no-undo.
def input parameter p-est   as char    no-undo.
def input parameter p-param as integer no-undo.

assign c-nr-proc-imp    = p-proc
       c-cod-estabel    = p-est
       i-var            = p-param.
    find processo-imp where 
         processo-imp.cod-estabel = c-cod-estabel and
         processo-imp.nr-proc-imp = c-nr-proc-imp
         no-lock no-error.
    if   avail processo-imp then do:
         for each ordem-compra no-lock where
                  ordem-compra.num-pedido = processo-imp.num-pedido
                  break by ordem-compra.numero-ordem:
             find cotacao-item where 
                  cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                  cotacao-item.it-codigo    = ordem-compra.it-codigo    and
                  cotacao-item.cod-emitente = ordem-compra.cod-emitente and
                  cotacao-item.cot-aprovada = yes no-lock no-error.     
             if   avail cotacao-item then 
                  assign de-valor = cotacao-item.preco-unit.     
             assign de-quant = 0.
             for each prazo-compra NO-LOCK where
                      prazo-compra.numero-ordem = ordem-compra.numero-ordem
                      break by prazo-compra.numero-ordem:
                 assign de-quant = de-quant + prazo-compra.quantidade.     
                 if  i-var = 1 then do:
                     create tt-ordens.
                     buffer-copy prazo-compra to tt-ordens.
                     assign tt-ordens.valor   = de-valor * tt-ordens.quantidade
                            tt-ordens.num-pedido = ordem-compra.num-pedido
                            tt-ordens.r-rowid = rowid(ordem-compra).
                 end.           
                 else do:
                      if  last-of(prazo-compra.numero-ordem) then do:
                          find first tt-ordens where 
                                     tt-ordens.it-codigo = ordem-compra.it-codigo
                                     no-lock no-error.
                          if   avail tt-ordens then do:
                               assign tt-ordens.quantidade = tt-ordens.quantidade + de-quant
                                      de-item              = de-quant * de-valor
                                      tt-ordens.valor      = tt-ordens.valor + de-item.
                          end.                
                          else do:
                               create tt-ordens.
                               buffer-copy prazo-compra except quantidade to tt-ordens.
                               assign tt-ordens.quantidade   = de-quant
                                      tt-ordens.valor        = de-valor * tt-ordens.quantidade
                                      tt-ordens.num-pedido   = ordem-compra.num-pedido
                                      tt-ordens.r-rowid      = rowid(ordem-compra).     
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
 

PROCEDURE piRetornaDescItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined(bf-mat-comex) &then
&else

    DEF INPUT  PARAM p-it-codigo   LIKE ITEM.it-codigo  NO-UNDO.
    DEF OUTPUT PARAM p-desc-item   like item.desc-item  NO-UNDO.

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo:
        ASSIGN p-desc-item = ITEM.desc-item.
    END.
  
    RETURN "OK":U.

&endif
END PROCEDURE.




PROCEDURE piRetornaNeceLi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if "{&bf_mat_versao_ems}" >= "2.062" &then   
        DEF INPUT  PARAM i-it-codigo LIKE ITEM.it-codigo   NO-UNDO.
        DEF OUTPUT PARAM p-nece-li   LIKE ITEM.log-necessita-li   NO-UNDO.
    
        FIND FIRST param-imp NO-LOCK
             WHERE param-imp.cod-estabel = c-cod-estabel NO-ERROR.  
    
        /* Solicita LI para todos os itens */ 
        IF AVAIL param-imp AND SUBSTRING(param-imp.char-1,167,1) = "S" THEN
            ASSIGN p-nece-li = YES.  
        ELSE
            FOR FIRST item NO-LOCK
                WHERE item.it-codigo = i-it-codigo:
                ASSIGN p-nece-li = item.log-necessita-li.
            END.
          
        RETURN "OK":U.
    &endif
END PROCEDURE.




/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
        DO WHILE true:
            if available({&first-table-in-query})  and piRowsReturned < piRowsToReturn then do:
                create rowObject.
                buffer-copy {&table-name} to rowObject.
                assign rowObject.r-rowid    = {&table-name}.r-rowid
                       rowObject.valor      = {&table-name}.valor
                       rowObject.num-pedido = {&table-name}.num-pedido.
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
                REPOSITION  {&query-name} TO ROW (piStartRow).
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
 
    reposition {&query-name} to rowid to-rowid(c-rowid-atual).
 
    do while (i-cont < (i-linhas-prev - 1)):
       get prev {&query-name}.
       assign i-cont = i-cont + 1.
    end.
    assign c-rowid-ant = string({&table-name}.r-rowid).
end procedure.
 
procedure retornaTTOrdens:
def output param table for tt-ordens.
find first tt-ordens no-error.
end procedure.

