/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX300A 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX300A MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX300A.P
**
**  cot-ordem - Cota‡äes por Grupo Ordem
**
*******************************************************************************/

{cdp/cdcfgmat.i}  /* Pre processador Integra‡Æo Magnus */
{cxbo/bocx300a.i} /* Temp-table tt-cotacao */
        
def temp-table tt-cot-rowid no-undo
    field r-rowid as rowid.        

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.002
&scoped-define FIRST-TABLE-IN-QUERY tt-cotacao
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-cotacao

def temp-table rowObject NO-UNDO like tt-cotacao.

def var c-cod-incoterm like cotacao-item-cex.cod-incoterm no-undo.    
def var c-cod-agrup    like cot-ordem.cod-agrup           no-undo.
def var i-mapa-ordem   like cot-ordem.mapa-ordem          no-undo.


{cxbo/bocx300.i tt-cot-ordem}
{include/boini.i}
{cdp/cd4300.i3}  /* include depuracao atributo livre */
{ccp/cc9019.i50} /* include atributo livre cotacao-item */

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

procedure setConstraint1:
end procedure.  

procedure setConstraint2:
    /* rowid primeira ordem cadastrada ou ordem selecionada */
    def input parameter p-numero-ordem like cotacao-item.numero-ordem no-undo.
    
    def var i-cod-emitente like cot-ordem.cod-emitente        no-undo.
    def var de-quantidade  like prazo-compra.quantidade       no-undo.
    def var de-qtd-do-forn like prazo-compra.qtd-do-forn      no-undo.
    
    for each tt-cotacao:
        delete tt-cotacao.
    end.
    
    for each ordem-compra fields (numero-ordem situacao) where
        ordem-compra.numero-ordem >= p-numero-ordem no-lock:
        &if defined(bf-mat-comex) &then 
         if ordem-compra.situacao <> "M" then next.
        &else
         if ordem-compra.situacao <> 5 then next.           
        &endif 
        else do:
          assign de-quantidade  = 0
                 de-qtd-do-forn = 0.
          for each prazo-compra fields (quantidade qtd-do-forn) no-lock
              where prazo-compra.numero-ordem = ordem-compra.numero-ordem:
              assign de-quantidade  = de-quantidade + prazo-compra.quantidade
                     de-qtd-do-forn = de-qtd-do-forn + prazo-compra.qtd-do-forn.
          end. 
          for each cotacao-item where
              cotacao-item.numero-ordem = ordem-compra.numero-ordem no-lock:                                                               
              find item 
                  where item.it-codigo = cotacao-item.it-codigo no-lock no-error.
              find emitente 
                 where emitente.cod-emitente = cotacao-item.cod-emitente 
                 no-lock no-error.
              if avail emitente and 
                 &if defined(bf-mat-comex) &then 
                  (emitente.natureza = "E" or emitente.natureza = "T") then do:
                  assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
                         c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
                         i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
                 &else
                  (emitente.natureza = 3 or emitente.natureza = 4) then do:
                  {cdp/cd4300.i4 yes cotacao-item.char-1}
                  {ccp/cc9019.i51 yes}
                 &endif
                  if c-cod-incoterm = c-cod-incoterm-i50 then do:
                     if not can-find(cot-ordem 
                        where cot-ordem.numero-ordem = cotacao-item.numero-ordem 
                        and   cot-ordem.cod-emitente = cotacao-item.cod-emitente 
                      &if defined(bf-mat-comex) &then 
                      &else
                        and   cot-ordem.seq-cotac    = cotacao-item.seq-cotac 
                      &endif 
                        and   cot-ordem.data-1       = cotacao-item.data-cotacao ) then do:   
                        create tt-cotacao.
                        assign tt-cotacao.numero-ordem  = cotacao-item.numero-ordem
                               tt-cotacao.cod-emitente  = cotacao-item.cod-emitente
                               tt-cotacao.it-codigo     = cotacao-item.it-codigo
                               tt-cotacao.data-cotacao  = cotacao-item.data-cotacao
                              &if defined(bf-mat-comex) &then
                              &else
                               tt-cotacao.seq-cotac = cotacao-item.seq-cotac
                              &endif
                               tt-cotacao.cod-cond-pag  = cotacao-item.cod-cond-pag
                               tt-cotacao.mo-codigo     = cotacao-item.mo-codigo
                               tt-cotacao.quantidade    = de-quantidade
                               tt-cotacao.qtd-do-forn   = de-qtd-do-forn
                               tt-cotacao.un            = item.un
                               tt-cotacao.un-fornec     = cotacao-item.un
                               tt-cotacao.preco-unit    = (cotacao-item.preco-unit   * 100) / ( 100 + cotacao-item.aliquota-ipi)
                               tt-cotacao.pre-unit-for  = (cotacao-item.pre-unit-for * 100) / ( 100 + cotacao-item.aliquota-ipi)
                               tt-cotacao.r-rowid       = rowid(cotacao-item).
                     end.                               
                  end.
              end.                                
          end.                                                
        end.   
    end.          
end procedure.

procedure setConstraint3:
    def input parameter p-chave as rowid no-undo. 
    /* rowid primeira ordem cadastrada */
    def output parameter p-numero-ordem like cotacao-item.numero-ordem no-undo.

    for first cot-ordem fields (numero-ordem cod-agrup mapa-ordem cod-incoterm) 
        where rowid(cot-ordem) = p-chave no-lock:
        assign p-numero-ordem = cot-ordem.numero-ordem
               c-cod-agrup    = cot-ordem.cod-agrup
               i-mapa-ordem   = cot-ordem.mapa-ordem
               c-cod-incoterm = cot-ordem.cod-incoterm.
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
/* {include/bosersen.i} */
/* {include/boprebro.i} */
/* {include/boexecre.i} */
/* {include/boexeupt.i} */
/* {include/boexedel.i} */
/* {include/bovalupt.i} */
/* {include/bovaldel.i} */

procedure createCotordem:
    def input parameter table for tt-cot-rowid.
    def input parameter p-chave-pai as rowid no-undo.
    def output parameter table for tt-bo-erro.
    
    def var c-cod-agrup    like cot-ordem.cod-agrup    no-undo.
    def var i-mapa-ordem   like cot-ordem.mapa-ordem   no-undo.
    def var c-cod-incoterm like cot-ordem.cod-incoterm no-undo.
    def var i-cod-itiner   like cot-ordem.cod-itiner   no-undo.    
    def var r-retorno      as rowid                    no-undo.
    def var h-bocx300      as handle                   no-undo.    
    
    find cot-ordem where rowid(cot-ordem) = p-chave-pai no-lock no-error.
    if avail cot-ordem then do:
       assign c-cod-agrup    = cot-ordem.cod-agrup
              i-mapa-ordem   = cot-ordem.mapa-ordem
              c-cod-incoterm = cot-ordem.cod-incoterm
              i-cod-itiner   = cot-ordem.cod-itiner.               
       for each tt-cot-rowid:
           for each tt-cot-ordem:
               delete tt-cot-ordem.
           end.            
           find cotacao-item where rowid(cotacao-item) = tt-cot-rowid.r-rowid no-lock no-error.
           if avail cotacao-item then do:
              create tt-cot-ordem.        
              assign tt-cot-ordem.cod-agrup    = c-cod-agrup
                     tt-cot-ordem.numero-ordem = cotacao-item.numero-ordem
                     tt-cot-ordem.cod-emitente = cotacao-item.cod-emitente
                     tt-cot-ordem.data-1 = cotacao-item.data-cotacao                       
                     &if defined(bf-mat-comex) &then
                     &else
                       tt-cot-ordem.seq-cotac = cotacao-item.seq-cotac
                     &endif
                     tt-cot-ordem.mapa-ordem   = i-mapa-ordem
                     tt-cot-ordem.cod-incoterm = c-cod-incoterm
                     tt-cot-ordem.cod-itiner   = i-cod-itiner.
              run cxbo/bocx300.p persistent set h-bocx300.
              run validateCreate in h-bocx300(input table tt-cot-ordem,
                                              output table tt-bo-erro,
                                              output r-retorno).
              delete procedure h-bocx300.
              find first tt-bo-erro no-error.
              if avail tt-bo-erro then
                 undo, leave.
           end.
       end.
    end.
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
            assign rowobject.r-rowid = {&table-name}.r-rowid.
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

procedure prevBrowseNavigation:
    /*
    **  Usado na navega‡Æo anterior do serverSendRows 
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

procedure retornaTTCotacao:
def output param table for tt-cotacao.

end procedure.
