/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN053DB 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin053db MUT}
&ENDIF

/*******************************************************************************
**
**  boin053db.P - tt-componenete-aux
**
*******************************************************************************/

{cdp/cdcfgdis.i} /* pre-processadores distribuicao */

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY tt-componente-aux
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-componente-aux

{exp/ex4328.i} /* Definiá∆o TempTable Componente Drawback */

{include/boini.i}
DEFINE TEMP-TABLE rowObject NO-UNDO LIKE componente
    field it-codigo-pai like componente.it-codigo
    FIELD r-rowid AS ROWID
    field r-row-saldo-terc as rowid
    field r-row-tt-it-doc as rowid
   &if defined (bf_dis_versao_ems)  &then
     &if {&bf_dis_versao_ems} >= 2.03 &then
       field RowNum as integer
     &endif
   &endif
   .
    
DEFINE TEMP-TABLE tt-componente-aux NO-UNDO LIKE componente
    field it-codigo-pai like componente.it-codigo
    FIELD r-rowid AS ROWID
    field r-row-saldo-terc as rowid
    field r-row-tt-it-doc as rowid
   &if defined (bf_dis_versao_ems)  &then
     &if {&bf_dis_versao_ems} >= 2.03 &then
       field RowNum as integer
     &endif
   &endif
   index sequencia is primary sequencia
   .
    
DEFINE TEMP-TABLE tt-componente-aux2 NO-UNDO LIKE componente
    field it-codigo-pai like componente.it-codigo
    FIELD r-rowid AS ROWID
    field r-row-saldo-terc as rowid
    field r-row-tt-it-doc as rowid
   &if defined (bf_dis_versao_ems)  &then
     &if {&bf_dis_versao_ems} >= 2.03 &then
       field RowNum as integer
     &endif
   &endif
   .
            
{inbo/boin404.i  tt-saldo-terc-aux}
{inbo/boin111a.i tt-item-estrut}
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

DEFINE BUFFER b-componente-aux for {&TABLE-NAME}.
    
DEFINE TEMP-TABLE tt-erro no-undo
    field i-sequen as int
    field cd-erro  as int
    field mensagem as char format "x(255)".    
    
def var l-acomp        as logical initial no no-undo.

def var c-embarque     as char    no-undo.
def var c-cod-estabel  as char    no-undo.
def var i-cod-emitente as integer no-undo.
def var c-estab-fisc   as char    no-undo.
def var i-cont         as integer no-undo.
def var c-return1      as char    no-undo.
def var r-row-saldo    as rowid   no-undo.
def var i-increment    as integer no-undo.

procedure setConstraint1:
def input parameter r-row as rowid no-undo.
    assign r-row-saldo = r-row.
end procedure. 

procedure setConstraint2:
    def input parameter p-cod-emitente   as integer no-undo.
    def input parameter p-cod-estabel    as char    no-undo.
    def input parameter p-estab-fisc     as char    no-undo.
    
   
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then do:
/*            for each {&TABLE-NAME}:
 *                 assign tt-componente-aux.log-1 = yes. 
 *             end.*/
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                              {&TABLE-NAME}.quantidade <> 0  no-lock.
        end.    
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
/*{include/bosetcur.i}*/
{include/bogetcur.i}
/*{include/bosersen.i}*/
{include/boprebro.i}
{utp/ut-glob.i}


procedure setCurrent:
    /*
    **  Seta registro corrente para a temp-table que sera devolvida.
    */
/*    for each RowObject:
 *         delete RowObject.
 *     end.
 *     if avail {&TABLE-NAME} then do:
 *         create RowObject.
 *         buffer-copy {&TABLE-NAME} to RowObject.
 *     end.*/
end procedure.


procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.


PROCEDURE serverSendRows :

    /*
    **  Disponivel no smart data object da V9, e foi reimplementado dentro
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query
    **  e facilitara a migracao destes programas para os Smart Data Objects.
    */
    DEFine input  parameter piStartRow     as  integer   no-undo.
    DEFine input  parameter pcRowIdent     as  character no-undo.
    DEFine input  parameter plNext         as  logical   no-undo.
    DEFine input  parameter piRowsToReturn as  integer   no-undo.
    DEFine output parameter piRowsReturned as  integer   no-undo.
    DEFine output parameter table          for RowObject.
    DEFine variable hQuery        as handle    no-undo.
    DEFine variable hBuffer       as handle    no-undo.
    DEFine variable hRowObject    as handle    no-undo.
    DEFine variable hDataQuery    as handle    no-undo.
    DEFine variable cRowIdent     as character no-undo.
    DEFine variable rRowIDs       as rowid     extent 10 no-undo.
    DEFine variable lOK           as logical   no-undo.
    DEFine variable iRow          as integer   no-undo.
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
                assign rowobject.r-rowid = rowid({&table-name}).
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
END PROCEDURE.  


procedure carregaTTReClassFisc:
def input param c-item        like proc-ped-ent.it-codigo.
def input param c-nr-proc-exp like processo-exp.nr-proc-exp.
def input param c-cod-estabel like processo-exp.cod-estabel.

end procedure.

procedure criaTTComponenteAux:

def input-output param table for tt-componente-aux.
def output param table       for tt-componente-rest.
def input  param r-row-saldo-terc as rowid no-undo.
def input  param d-qt-pedida      as decimal no-undo.
def input-output param table for tt-saldo-terc-aux.
def input  param table       for tt-item-estrut.
def input  param c-it-codigo-docto as char no-undo.
def input  param i-nr-seq-fat      as int no-undo.
def input  param qtfaturar         as dec no-undo.
def input  param l-verificar       as log no-undo.
def output param table       for tt-bo-erro.
    
def var cont as int no-undo initial 0.
def var valor as dec no-undo.
def var valor2 as dec no-undo.

for each tt-bo-erro:
    delete tt-bo-erro.
end.
    
find first tt-saldo-terc-aux where tt-saldo-terc-aux.r-rowid = r-row-saldo-terc no-error.
if avail tt-saldo-terc-aux then do:
   find first tt-item-estrut where tt-item-estrut.it-codigo = tt-saldo-terc-aux.it-codigo no-error. 
    if avail tt-item-estrut then do:
       find first item where item.it-codigo = tt-item-estrut.it-codigo no-error.
        find last tt-componente-aux use-index sequencia no-error.
           if not avail tt-componente-aux then 
               ASSIGN cont = 1.
           else 
               assign cont = tt-componente-aux.sequencia + 1.
       
       find first tt-componente-aux where 
           tt-componente-aux.serie-comp         = tt-saldo-terc-aux.serie-docto         and
           tt-componente-aux.nro-comp           = tt-saldo-terc-aux.nro-docto           and
           tt-componente-aux.nat-comp           = tt-saldo-terc-aux.nat-operacao        and
           tt-componente-aux.seq-comp           = tt-saldo-terc-aux.sequencia           and
           tt-componente-aux.emite-comp         = tt-saldo-terc-aux.cod-emitente        and
           tt-componente-aux.nr-ato-concessorio = tt-saldo-terc-aux.nr-ato-concessorio  no-error.
             
           
         if not avail tt-componente-aux then do:
           create tt-componente-aux.
           assign tt-componente-aux.it-codigo-pai       = c-it-codigo-docto
                  tt-componente-aux.sequencia           = cont
                  tt-componente-aux.serie-comp          = tt-saldo-terc-aux.serie-docto
                  tt-componente-aux.nro-comp            = tt-saldo-terc-aux.nro-docto
                  tt-componente-aux.nat-comp            = tt-saldo-terc-aux.nat-operacao
                  tt-componente-aux.seq-comp            = tt-saldo-terc-aux.sequencia
                  tt-componente-aux.emite-comp          = tt-saldo-terc-aux.cod-emitente
                  tt-componente-aux.nr-ato-concessorio  = tt-saldo-terc-aux.nr-ato-concessorio
                  tt-componente-aux.cod-emitente        = tt-saldo-terc-aux.cod-emitente. /* drranka*/
           assign tt-componente-aux.it-codigo           = tt-saldo-terc-aux.it-codigo
                  tt-componente-aux.cod-refer           = tt-saldo-terc-aux.cod-refer
                  tt-componente-aux.un                  = if avail item then item.un else ""
                  tt-componente-aux.r-row-saldo-terc    = r-row-saldo-terc.
            /* ê gravado a sequencia da nota de sa°da do item para carregar o browse de componente
               do programa ex4328.w */
           assign tt-componente-aux.int-1               = i-nr-seq-fat.       
         end. /* if not avail ... */
         else do:
              if  l-verificar = no then do:
                    assign i-seq-erro = i-seq-erro + 1.       
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 26123.
              
                    run utp/ut-msgs.p (input "msg",
                                       input 26123,
                                       input return-value).
                    assign tt-bo-erro.parametros = return-value.
                    assign tt-bo-erro.mensagem   = return-value.
              end.
         end.  
         find first tt-bo-erro no-error.
         if not avail tt-bo-erro then do:
            /* Se l-verificar = yes entao a procedure foi chamado pelo processo automatico */
            if tt-saldo-terc-aux.quantidade < qtfaturar and l-verificar then do:
   
                assign tt-componente-aux.quantidade = tt-saldo-terc-aux.quantidade
                       tt-saldo-terc-aux.quantidade = 0
                       qtfaturar = qtfaturar - tt-componente-aux.quantidade.
                       
                create tt-componente-rest.
                assign tt-componente-rest.serie-comp  = tt-saldo-terc-aux.serie-docto
                       tt-componente-rest.nro-comp    = tt-saldo-terc-aux.nro-docto
                       tt-componente-rest.nat-comp    = tt-saldo-terc-aux.nat-operacao
                       tt-componente-rest.seq-comp    = tt-saldo-terc-aux.sequencia
                       tt-componente-rest.emite-comp  = tt-saldo-terc-aux.cod-emitente
                       tt-componente-rest.nr-ato-concessorio = tt-saldo-terc-aux.nr-ato-concessorio.
                       tt-componente-rest.it-codigo   = tt-saldo-terc-aux.it-codigo.
                assign tt-componente-rest.cod-refer   = tt-saldo-terc-aux.cod-refer
                       tt-componente-rest.un          = if avail item then item.un else ""
                       tt-componente-rest.r-row-saldo-terc = r-row-saldo-terc
                       tt-componente-rest.quantidade  = qtfaturar.
            end.
            else if tt-saldo-terc-aux.quantidade < qtfaturar and l-verificar = no then 
                     assign tt-componente-aux.quantidade  = tt-saldo-terc-aux.quantidade
                            tt-saldo-terc-aux.quantidade   = 0.                
                 else assign tt-componente-aux.quantidade  = tt-componente-aux.quantidade + qtfaturar
                             tt-saldo-terc-aux.quantidade   = (tt-saldo-terc-aux.quantidade - tt-componente-aux.quantidade).
            assign tt-componente-aux.log-1 = yes.           
         end.
    end.  /* if avail tt-item-estrut .. */
    
    
    /********** Tratar a d-qt-pedida, no caso dela ficar com a diferenca da saldo-terc - componente. **********/
    
    
end.         
end procedure.

procedure EliminaTTComponenteAux:

def input param c-item as char no-undo.
def input param c-ato  as char no-undo.
def input param i-seq as int no-undo.
def input-output param table for tt-componente-aux.
def input-output param table for tt-saldo-terc-aux.
def input param r-row-componente as rowid no-undo.

find first tt-componente-aux where tt-componente-aux.it-codigo = c-item and
                                   tt-componente-aux.nr-ato-concessorio = c-ato and
                                   tt-componente-aux.sequencia = i-seq no-error.
if avail tt-componente-aux then do:
    find first tt-saldo-terc-aux where tt-saldo-terc-aux.r-rowid = r-row-componente no-error.
     if avail tt-saldo-terc-aux then do:
        assign tt-saldo-terc-aux.quantidade = (tt-saldo-terc-aux.quantidade + tt-componente-aux.quantidade).
     end.
     assign tt-componente-aux.log-1 = no.     
     delete tt-componente-aux.
     run openQuery (input 1).
end.         

end procedure.


procedure modificaTTComponenteAux:
def input param c-item as char no-undo.
def input param c-ato  as char no-undo.
def input param i-seq as int no-undo.
def input-output param table for tt-componente-aux.
def input-output param table for tt-saldo-terc-aux.
def input param r-row-componente as rowid no-undo.
def input param d-quantidade as dec no-undo.
def var d-saldo as dec no-undo.

find first tt-componente-aux where tt-componente-aux.it-codigo = c-item and
                                   tt-componente-aux.nr-ato-concessorio = c-ato and
                                   tt-componente-aux.sequencia = i-seq no-error.
if avail tt-componente-aux then do:
     find first tt-saldo-terc-aux where tt-saldo-terc-aux.r-rowid = r-row-componente no-error. 
     if avail tt-saldo-terc-aux then do:
        assign d-saldo = (tt-saldo-terc-aux.quantidade + tt-componente-aux.quantidade).
        if d-quantidade <= d-saldo then
           assign tt-saldo-terc-aux.quantidade = (d-saldo - d-quantidade).
     end.
/*        assign tt-saldo-terc-aux.quantidade = (tt-saldo-terc-aux.quantidade + tt-componente-aux.quantidade) - d-quantidade.*/
        
     assign tt-componente-aux.quantidade    = d-quantidade.

   
end.         

end procedure.

procedure CreateComponente:
    /*
    ** Cria componente
    */
    def input param table  for rowObject.
    def input param table  for tt-componente-rest.
    def input param c-item like componente.it-codigo no-undo.
    def input param i-seq  like componente.sequencia no-undo.
      
    def var i-nr-seq      as int  no-undo.
    def var l-verifica    as log  no-undo.
    def var c-cod-estabel as char no-undo.

    find first rowObject
       where rowobject.it-codigo = c-item
         and rowobject.sequencia = i-seq no-error.         
   
    create componente.
    buffer-copy rowObject except it-codigo-pai r-rowid /*sequencia*/ r-row-saldo-terc r-row-tt-it-doc
        to componente.
   
    find saldo-terc
        where saldo-terc.serie-docto  = componente.serie-comp
          and saldo-terc.nro-docto    = componente.nro-comp
          and saldo-terc.cod-emitente = componente.cod-emitente
          and saldo-terc.nat-operacao = componente.nat-comp
          and saldo-terc.it-codigo    = componente.it-codigo
          and saldo-terc.cod-refer    = componente.cod-refer
          and saldo-terc.sequencia    = componente.seq-comp exclusive-lock no-error.
    if avail saldo-terc then do:
    
        assign c-cod-estabel = saldo-terc.cod-estabel.

        if rowObject.componente = 2 then do:    /* Saida Drawback */
            assign saldo-terc.quantidade = saldo-terc.quantidade
                                         - componente.quantidade.
            assign i-increment           = 10.
        end.        
        else                                    /* Entrada Drawback */
            assign saldo-terc.quantidade = saldo-terc.quantidade
                                         + RowObject.quantidade.

    end.
    
    if rowObject.componente = 1 then            /* Entrada Drawback */
        leave.
    
    def buffer b-saldo-terc for saldo-terc.
    
    if rowObject.componente = 2 then do:        /* Saida Drawback */    
            
        find first tt-componente-rest
            where tt-componente-rest.serie-comp = componente.serie-comp
              and tt-componente-rest.nro-comp   = componente.nro-comp
              and tt-componente-rest.nat-comp   = componente.nat-comp
              and tt-componente-rest.seq-comp   = componente.seq-comp
              and tt-componente-rest.emite-comp = componente.cod-emitente
              and tt-componente-rest.it-codigo  = componente.it-codigo no-error.
   
        if avail tt-componente-rest then do:
            repeat:
                assign l-verifica = no.
                
                for each saldo-terc fields(cod-emitente it-codigo cod-refer nr-ato-concessorio
                                           serie-docto nro-docto nat-operacao sequencia quantidade)
                    where saldo-terc.it-codigo = tt-componente-rest.it-codigo
                      and saldo-terc.nr-ato-concessorio > ""
                      and saldo-terc.quantidade         > 0 no-lock,
                    first pedido-drb fields() no-lock
                    where pedido-drb.nr-ato-concessorio = saldo-terc.nr-ato-concessorio
                       by pedido-drb.data-validade-ato:

                    assign l-verifica = yes.
                    
                    create componente.
                    assign componente.cod-emitente       = saldo-terc.cod-emitente 
                           componente.nro-docto          = tt-componente-rest.nro-docto 
                           componente.serie-docto        = tt-componente-rest.serie-docto
                           componente.nat-operacao       = tt-componente-rest.nat-operacao
                           componente.it-codigo          = saldo-terc.it-codigo
                           componente.sequencia          = tt-componente-rest.sequencia
                                                         + i-increment
                           componente.cod-refer          = saldo-terc.cod-refer
                           componente.componente         = 2
                           componente.nr-ato-concessorio = saldo-terc.nr-ato-concessorio
                           componente.baixa-ce           = no
                           componente.serie-comp         = saldo-terc.serie-docto
                           componente.nro-comp           = saldo-terc.nro-docto
                           componente.nat-comp           = saldo-terc.nat-operacao
                           componente.seq-comp           = saldo-terc.sequencia
                           componente.emite-comp         = tt-componente-rest.emite-comp
                           componente.quantidade         = saldo-terc.quantidade
                           componente.un                 = rowObject.un.
                           
                    find b-saldo-terc
                        where rowid(b-saldo-terc) = rowid(saldo-terc) exclusive-lock no-error.
                    if avail b-saldo-terc then do:                    
                        if b-saldo-terc.quantidade < tt-componente-rest.quantidade then
                            assign tt-componente-rest.quantidade = tt-componente-rest.quantidade
                                                                 - b-saldo-terc.quantidade
                                   b-saldo-terc.quantidade       = 0.
                        else
                            assign b-saldo-terc.quantidade = b-saldo-terc.quantidade
                                                           - tt-componente-rest.quantidade.
                    end.
                    
                    assign i-increment = i-increment + 10.

                end. /* for each ...*/
                
                if tt-componente-rest.quantidade = 0 then 
                    leave.
                
                if l-verifica = no then do:
                    /*
                    ** Gera log quando a quantidade n„o foi cumprida pelo Drawback
                    */
                    RUN exp/ex4329.p (input tt-componente-rest.it-codigo,
                                      input tt-componente-rest.nro-docto,
                                      input "1",
                                      input componente.nro-docto,
                                      input componente.serie-docto,
                                      input c-cod-estabel).
                    leave.
                end.
                
            end. /* repeat... */
        end.
    end.

end procedure.

procedure carregaTTComponenteAux:
def input param table for tt-componente-aux.
def input param table for tt-saldo-terc-aux.

def input param i-it-docto-seq as int no-undo.

for each tt-componente-aux:

   assign  tt-componente-aux.log-1 = (tt-componente-aux.int-1 = i-it-docto-seq).

end.
end procedure.

procedure criaTTComponenteAuxAutomatico:
    /*
    ** Atualiza tt-componente-aux / tt-saldo-terc-aux
    */
    def input        param r-rowid-it-nf    as rowid no-undo.
    def input-output param table            for tt-componente-aux.
    def output       param table            for tt-componente-rest.
    def input        param r-row-saldo-terc as rowid   no-undo.
    def input        param d-qt-pedida      as decimal no-undo.
    def input-output param table            for tt-saldo-terc-aux.
    def input        param table            for tt-item-estrut.
    def input        param l-verificar      as log     no-undo.
    def output       param table            for tt-bo-erro.
    
    def var cont       as int no-undo.
    def var valor      as dec no-undo.
    def var valor2     as dec no-undo.
    def var qt-faturar as dec no-undo.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    for first it-nota-fisc fields(serie nr-nota-fis nat-operacao nr-seq-fat it-codigo un-fatur)
        where rowid(it-nota-fisc) = r-rowid-it-nf no-lock:
    end.

    for first nota-fiscal fields(cod-emitente) 
        of it-nota-fisc no-lock:
    end.
    
    assign qt-faturar = d-qt-pedida.
    
    find tt-saldo-terc-aux 
        where tt-saldo-terc-aux.r-rowid = r-row-saldo-terc no-error.
    if avail tt-saldo-terc-aux then do:

        find first tt-componente-aux 
            where tt-componente-aux.serie-docto          = it-nota-fisc.serie            
              and tt-componente-aux.nro-docto            = it-nota-fisc.nr-nota-fis      
              and tt-componente-aux.cod-emitente         = nota-fiscal.cod-emitente     
              and tt-componente-aux.nat-operacao         = it-nota-fisc.nat-operacao     
              and tt-componente-aux.it-codigo            = tt-saldo-terc-aux.it-codigo   
              and tt-componente-aux.cod-refer            = tt-saldo-terc-aux.cod-refer   
              and tt-componente-aux.sequencia            = it-nota-fisc.nr-seq-fat no-error.
          
        if not avail tt-componente-aux then do:
            create tt-componente-aux.
            assign tt-componente-aux.serie-docto         = it-nota-fisc.serie
                   tt-componente-aux.nro-docto           = it-nota-fisc.nr-nota-fis 
                   tt-componente-aux.cod-emitente        = nota-fiscal.cod-emitente
                   tt-componente-aux.nat-operacao        = it-nota-fisc.nat-operacao 
                   tt-componente-aux.it-codigo           = tt-saldo-terc-aux.it-codigo  
                   tt-componente-aux.cod-refer           = tt-saldo-terc-aux.cod-refer  
                   tt-componente-aux.sequencia           = it-nota-fisc.nr-seq-fat
                   tt-componente-aux.serie-comp          = tt-saldo-terc-aux.serie-docto
                   tt-componente-aux.nro-comp            = tt-saldo-terc-aux.nro-docto
                   tt-componente-aux.nat-comp            = tt-saldo-terc-aux.nat-operacao
                   tt-componente-aux.seq-comp            = tt-saldo-terc-aux.sequencia
                   tt-componente-aux.emite-comp          = tt-saldo-terc-aux.cod-emitente
                   tt-componente-aux.nr-ato-concessorio  = tt-saldo-terc-aux.nr-ato-concessorio
                   tt-componente-aux.it-codigo-pai       = it-nota-fisc.it-codigo
                   tt-componente-aux.int-1               = it-nota-fisc.nr-seq-fat
                   tt-componente-aux.un                  = it-nota-fisc.un-fatur[1]
                   tt-componente-aux.r-row-saldo-terc    = r-row-saldo-terc.
        end.  /* if not avail tt-componente-aux */
        
        if tt-saldo-terc-aux.quantidade < qt-faturar then do:

            assign tt-componente-aux.quantidade = tt-saldo-terc-aux.quantidade
                   tt-saldo-terc-aux.quantidade = 0
                   qt-faturar                   = qt-faturar 
                                                - tt-componente-aux.quantidade.
            
            find first tt-componente-rest
                where tt-componente-rest.serie-docto          = it-nota-fisc.serie            
                  and tt-componente-rest.nro-docto            = it-nota-fisc.nr-nota-fis      
                  and tt-componente-rest.cod-emitente         = nota-fiscal.cod-emitente      
                  and tt-componente-rest.nat-operacao         = it-nota-fisc.nat-operacao     
                  and tt-componente-rest.it-codigo            = tt-saldo-terc-aux.it-codigo   
                  and tt-componente-rest.cod-refer            = tt-saldo-terc-aux.cod-refer   
                  and tt-componente-rest.sequencia            = it-nota-fisc.nr-seq-fat no-error.
            if not avail tt-componente-rest then do:
            
                create tt-componente-rest.
                assign tt-componente-rest.serie-docto        = it-nota-fisc.serie
                       tt-componente-rest.nro-docto          = it-nota-fisc.nr-nota-fis 
                       tt-componente-rest.cod-emitente       = nota-fiscal.cod-emitente
                       tt-componente-rest.nat-operacao       = it-nota-fisc.nat-operacao 
                       tt-componente-rest.it-codigo          = tt-saldo-terc-aux.it-codigo  
                       tt-componente-rest.cod-refer          = tt-saldo-terc-aux.cod-refer  
                       tt-componente-rest.sequencia          = it-nota-fisc.nr-seq-fat
                       tt-componente-rest.serie-comp         = tt-saldo-terc-aux.serie-docto
                       tt-componente-rest.nro-comp           = tt-saldo-terc-aux.nro-docto
                       tt-componente-rest.nat-comp           = tt-saldo-terc-aux.nat-operacao
                       tt-componente-rest.seq-comp           = tt-saldo-terc-aux.sequencia
                       tt-componente-rest.emite-comp         = tt-saldo-terc-aux.cod-emitente
                       tt-componente-rest.nr-ato-concessorio = tt-saldo-terc-aux.nr-ato-concessorio
                       tt-componente-rest.cod-refer          = tt-saldo-terc-aux.cod-refer
                       tt-componente-rest.un                 = it-nota-fisc.un-fatur[1]
                       tt-componente-rest.r-row-saldo-terc   = r-row-saldo-terc.
                 
            end. /* if not avail tt-componente-rest */
            
            assign  tt-componente-rest.quantidade = tt-componente-rest.quantidade
                                                  + qt-faturar.
  
        end.
        else
            if tt-saldo-terc-aux.quantidade < qt-faturar then
                assign tt-componente-aux.quantidade = tt-saldo-terc-aux.quantidade
                       tt-saldo-terc-aux.quantidade = 0.
            else
                assign tt-componente-aux.quantidade = tt-componente-aux.quantidade
                                                    + qt-faturar
                       tt-saldo-terc-aux.quantidade = (tt-saldo-terc-aux.quantidade
                                                    - tt-componente-aux.quantidade).
        assign tt-componente-aux.log-1 = yes.
              
    end.         
end procedure.
