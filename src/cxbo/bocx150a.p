/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX150A 2.00.00.021 } /*** 010021 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx150a MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX150A.P - Espec°fica para o programa WIM0050 e WIM0550
**
**  historico-proc-imp - Historico dos processos
**
*******************************************************************************/
{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores */

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY historico-proc-imp
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME historico-proc-imp

{include/boini.i}
{cxbo/bocx150.i RowObject}

DEFINE TEMP-TABLE tt-hist-proc no-undo
    field i-sequencia as integer
    field r-hist  as rowid 
    index codigo is unique primary 
        i-sequencia.
        
DEFINE TEMP-TABLE tt-dif no-undo
     field r-rowid   as rowid
     field diferenca as integer.        
        
DEFINE BUFFER b-historico-proc-imp FOR historico-proc-imp.        
DEFINE BUFFER b-historico-proc-imp2 FOR historico-proc-imp.
/*Fo: 1806.191*/
DEFINE BUFFER b-ordem-compra FOR ordem-compra.
/*Fim Fo: 1806.191*/

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

DEFINE VARIABLE c-nr-proc-imp     AS   CHARACTER                                NO-UNDO.
DEFINE VARIABLE i-cod-itiner      AS   INTEGER                                  NO-UNDO.
DEFINE VARIABLE c-cod-pto-contr   AS   INTEGER                                  NO-UNDO.
DEFINE VARIABLE c-nr-proc-imp-fim AS   CHARACTER    initial "ZZZZZZZZZZZZZZZZZ" NO-UNDO. /* formato maior que o do campo nr-proc-imp */
DEFINE VARIABLE i-cod-itiner-fim  AS   INTEGER      initial 999.999             NO-UNDO. /* formato maior que o do campo cod-itiner  */
DEFINE VARIABLE da-efe-ant        AS   DATE                                     NO-UNDO.
DEFINE VARIABLE da-prev-ant       AS   DATE                                     NO-UNDO.
DEFINE VARIABLE da-efe-ult        AS   DATE                                     NO-UNDO.
DEFINE VARIABLE da-pre-ult        AS   DATE                                     NO-UNDO.
DEFINE VARIABLE i-seq-ult         AS   INTEGER                                  NO-UNDO.
DEFINE VARIABLE i-seq-pri         AS   INTEGER                                  NO-UNDO.
DEFINE VARIABLE i-nr-dias         AS   INTEGER                                  NO-UNDO.
DEFINE VARIABLE r-replan          AS   ROWID                                    NO-UNDO.
DEFINE VARIABLE ccod-estab-ini    AS   CHARACTER                                NO-UNDO.
DEFINE VARIABLE ccod-estab-fim    AS   CHARACTER                                NO-UNDO.
DEFINE VARIABLE cnr-proc-imp-ini  AS   CHARACTER                                NO-UNDO.
DEFINE VARIABLE cnr-proc-imp-fim  AS   CHARACTER                                NO-UNDO.
DEFINE VARIABLE ccod-itiner-ini   AS   INTEGER                                  NO-UNDO.
DEFINE VARIABLE ccod-itiner-fim   AS   INTEGER                                  NO-UNDO.
DEFINE VARIABLE ccod-estab        LIKE historico-proc-imp.cod-estabel           NO-UNDO.
DEFINE VARIABLE cnr-proc-imp      LIKE historico-proc-imp.nr-proc-imp           NO-UNDO.
DEFINE VARIABLE ccod-itiner       LIKE historico-proc-imp.cod-itiner            NO-UNDO.

DEFINE VARIABLE l-elimina-pai as logical  initial no no-undo.
DEFINE VARIABLE c-time            AS CHARACTER NO-UNDO.

/* Vari†veis procedure atualizaPrazoCompra ***********************************/
DEFINE VARIABLE i-pto-chegada   as integer no-undo.
DEFINE VARIABLE da-pto-cheg     as date    no-undo.
DEFINE VARIABLE data-base       as date    no-undo.

/* Vari†veis procedure atualizaUltPrev ***************************************/
DEFINE VARIABLE dt-prev-orig     as date no-undo.
DEFINE VARIABLE dt-efetiva-orig  as date no-undo.
DEFINE VARIABLE dt-prox-prev     as date no-undo.
DEFINE VARIABLE dt-ult-prev-orig as date no-undo.
DEFINE VARIABLE dt-efetiva-old   as date no-undo.
DEFINE VARIABLE da-ult-ant       as date no-undo.

/*FO: 1806.191*/
{utp/ut-glob.i}
/*FO: 1806.191*/

&if defined(bf-mat-comex) &then                                
    {cdp/cd7000.i "new"} /* Definicao de Variaveis do CD7000X */
&else
&endif   

procedure setConstraint1:
end procedure. 


PROCEDURE FindRowidProcessoImp:
    DEFINE INPUT PARAM c-cod-estabel AS CHAR.
    DEFINE INPUT PARAM c-nr-proc-imp AS CHAR.
    DEFINE OUTPUT PARAM r-rowid AS ROWID.
    
        FIND processo-imp
            WHERE processo-imp.cod-estabel = c-cod-estabel
            AND   processo-imp.nr-proc-imp = c-nr-proc-imp NO-LOCK NO-ERROR.
        IF AVAIL processo-imp THEN
           ASSIGN r-rowid =  ROWID(processo-imp).
        ELSE
           ASSIGN r-rowid = ?.
    
END.


procedure setConstraint2:
    def input parameter p-opcao       as char    no-undo.
    def input parameter p-r-chave     as rowid   no-undo.
    def input parameter p-nr-proc-imp as char    no-undo.
    def input parameter p-cod-itiner  as integer no-undo.
    
    assign c-nr-proc-imp-fim = "ZZZZZZZZZZZZZZZZZ" 
           i-cod-itiner-fim  = 999.999.
    case p-opcao:
    when "1" then do:
        find {&table-name} where rowid({&table-name}) = p-r-chave no-lock no-error.
         if avail {&table-name} then
           assign c-nr-proc-imp = {&table-name}.nr-proc-imp
                  i-cod-itiner = {&table-name}.cod-itiner.
        /** A tabela do Filho deve apresentar apenas registros do registro Pai corrente **/
        find last {&table-name} where historico-proc-imp.nr-proc-imp = c-nr-proc-imp and
                               historico-proc-imp.cod-itiner = i-cod-itiner no-lock no-error.
             assign c-nr-proc-imp-fim = {&Table-name}.nr-proc-imp
                  i-cod-itiner-fim = {&table-name}.cod-itiner.
     end.
    when "2" then do:
     /*find {&table-name} where historico-proc-imp.nr-proc-imp = c-nr-proc-imp and
                            historico-proc-imp.cod-itiner = i-cod-itiner no-lock no-error.*/
      assign c-nr-proc-imp = p-nr-proc-imp
             i-cod-itiner = p-cod-itiner.
    end.
    end case.
end procedure.

procedure setConstraint3:
def input param pcod-estab-ini as char no-undo.
def input param pcod-estab-fim as char no-undo.
def input param pnr-proc-imp-ini as char no-undo.
def input param pnr-proc-imp-fim as char no-undo.
def input param pcod-itiner-ini as integer no-undo.
def input param pcod-itiner-fim as integer no-undo.

assign ccod-estab-ini = pcod-estab-ini
       ccod-estab-fim = pcod-estab-fim
       cnr-proc-imp-ini = pnr-proc-imp-ini
       cnr-proc-imp-fim = pnr-proc-imp-fim
       ccod-itiner-ini = pcod-itiner-ini
       ccod-itiner-fim = pcod-itiner-fim.
end procedure.

PROCEDURE setConstraint4:
    /*
    ** Seta valores iniciais para abertura do programa IM0050.
    ** utilizado para abertura da query4
    */
    DEFINE INPUT PARAMETER pcod-estab   LIKE historico-proc-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-imp LIKE historico-proc-imp.nr-proc-imp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-itiner  LIKE historico-proc-imp.cod-itiner  NO-UNDO.
    
    ASSIGN ccod-estab   = pcod-estab
           cnr-proc-imp = pnr-proc-imp
           ccod-itiner  = pcod-itiner.

    RETURN "OK":U.
END PROCEDURE.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock where
                historico-proc-imp.nr-proc-imp >= c-nr-proc-imp and
                historico-proc-imp.cod-itiner >= i-cod-itiner and
                historico-proc-imp.nr-proc-imp <= c-nr-proc-imp-fim and
                historico-proc-imp.cod-itiner <= i-cod-itiner-fim by 
                historico-proc-imp.cod-estabel by
                historico-proc-imp.nr-proc-imp.  
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock where
                historico-proc-imp.cod-estabel >= ccod-estab-ini and
                historico-proc-imp.cod-estabel <= ccod-estab-fim and
                historico-proc-imp.nr-proc-imp >= cnr-proc-imp-ini and
                historico-proc-imp.nr-proc-imp <= cnr-proc-imp-fim and
                historico-proc-imp.cod-itiner  >= ccod-itiner-ini and
                historico-proc-imp.cod-itiner  <= ccod-itiner-fim 
                by historico-proc-imp.cod-estabel
                by historico-proc-imp.nr-proc-imp
                by historico-proc-imp.cod-itiner.
        WHEN 4 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} NO-LOCK 
                 WHERE historico-proc-imp.cod-estabel = ccod-estab    
                   AND historico-proc-imp.nr-proc-imp = cnr-proc-imp  
                   AND historico-proc-imp.cod-itiner  = ccod-itiner   
                BY historico-proc-imp.cod-estabel
                BY historico-proc-imp.nr-proc-imp.

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
/* {include/boexeupt.i} */
{include/boexedel.i}
/* {include/bovalupt.i} */
/*{include/bovaldel.i}*/

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

procedure findPrev2:
    /*
    **  Localiza bloco de registro anterior na tabela. 
    **  O bloco È formado pelos registros com mesmo nr-proc-imp e mesmo cod-itiner.
    */
    def output parameter c-return as char.
    
    assign c-nr-proc-imp = {&Table-name}.nr-proc-imp
           i-cod-itiner = {&table-name}.cod-itiner.

    find first {&table-name} where historico-proc-imp.nr-proc-imp = c-nr-proc-imp and
                                   historico-proc-imp.cod-itiner = i-cod-itiner no-lock no-error.
    find prev {&TABLE-NAME}
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg",
                           input 7998,
                           input "").
        assign c-return = return-value.                           
    end.
    else run setCurrent.
end procedure.
 

procedure findNext2:
    /*
    **  Localiza proximo bloco de registro na tabela.
    **  O bloco È formado pelos registros com mesmo nr-proc-imp e mesmo cod-itiner.
    */
    def output parameter c-return as char.    

    assign c-nr-proc-imp = {&Table-name}.nr-proc-imp
           i-cod-itiner = {&table-name}.cod-itiner.

    find last {&table-name} where historico-proc-imp.nr-proc-imp = c-nr-proc-imp and
                                  historico-proc-imp.cod-itiner = i-cod-itiner no-lock no-error.
    find next {&TABLE-NAME} no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg",
                           input 7999,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.

end procedure.

procedure findSub:
    /*
    **  Localiza bloco de registro subsequente na tabela. 
    **  O bloco Ç formado pelos registros com mesmo nr-proc-imp e mesmo cod-itiner.
    */
    def output parameter c-return as char no-undo.
    
    run startMethod("find":U).
    
    assign c-nr-proc-imp   = {&table-name}.nr-proc-imp
           i-cod-itiner    = {&table-name}.cod-itiner
           c-cod-pto-contr = {&table-name}.cod-pto-contr.

    find first {&table-name} where historico-proc-imp.nr-proc-imp = c-nr-proc-imp 
                             and   historico-proc-imp.cod-itiner = i-cod-itiner 
                             and   historico-proc-imp.cod-pto-contr <> c-cod-pto-contr 
                             no-lock no-error.
    if avail {&table-name} then do:
        run setCurrent.
    end.
    else do:
        find first {&table-name} where historico-proc-imp.nr-proc-imp <> c-nr-proc-imp no-lock no-error.
        if avail {&TABLE-NAME} then run setCurrent.
                               else assign c-return = "1".
    end.   
    run endMethod("find":U).
end procedure.

procedure serverSendRows2 :
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
             find first rowObject where rowObject.nr-proc-imp = historico-proc-imp.nr-proc-imp
                  and   rowObject.cod-itiner = historico-proc-imp.cod-itiner no-lock no-error.
             if not avail rowObject then do:
                create rowObject.
		  buffer-copy {&table-name} to rowObject.
		  assign rowObject.r-rowid = rowid({&table-name}).

                piRowsReturned = piRowsReturned + 1.
             end.
             GET NEXT {&query-name}.
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

procedure findCh-itiner:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-nr-proc-imp   as char    no-undo.
    def input parameter i-cod-itiner    as integer no-undo.
    def input parameter i-cod-pto-contr as integer no-undo.
    def output parameter c-return as char no-undo.
    
    run startMethod("find":U).
 
    find historico-proc-imp where
        historico-proc-imp.nr-proc-imp = c-nr-proc-imp and
        historico-proc-imp.cod-itiner = i-cod-itiner   and
        historico-proc-imp.cod-pto-contr = i-cod-pto-contr
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
    run endMethod("find":U).
end procedure.

procedure findChProcesso:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-cod-estabel as char no-undo.
    def input parameter c-nr-proc-imp as char no-undo.
    def output parameter c-return as char no-undo.
    
    run startMethod("find":U).
    find first historico-proc-imp where
        historico-proc-imp.cod-estabel = c-cod-estabel and
        historico-proc-imp.nr-proc-imp = c-nr-proc-imp
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
    run endMethod("find":U).    
end procedure.

procedure findPto-Controle:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-nr-proc-imp   as char    no-undo.
    def input parameter i-cod-itiner    as integer no-undo.
    def input parameter i-cod-pto-contr as integer no-undo.
    def output parameter c-return as char no-undo.
    
    run startMethod("find":U).
 
    find historico-proc-imp where
        historico-proc-imp.nr-proc-imp = c-nr-proc-imp and
        historico-proc-imp.cod-itiner  = i-cod-itiner  and
        historico-proc-imp.cod-pto-contr = i-cod-pto-contr
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
    run endMethod("find":U).
end procedure.

procedure executeUpdate:
    /*
    **  Executa Update
    */
      
    buffer-copy RowObject except nr-proc-imp cod-itiner cod-pto-contr r-rowid to {&TABLE-NAME}.
end procedure.

procedure validateUpdate:
    /*
    **  Valida Update
    */
    def input  parameter table for rowObject.
    def input  parameter r-chave as rowid no-undo.
    def output parameter table for tt-bo-erro.
    
    run startMethod("validateUpdate":U).
    
    run InitializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.     
    
    find first rowObject 
         no-lock no-error.
         
    find {&table-name} where
         rowid({&table-name}) = rowObject.r-rowid no-lock no-error.
    if   avail {&table-name} then do:
         find itinerario where itinerario.cod-itiner = rowObject.cod-itiner no-lock no-error.
         if   avail itinerario then do:
              find {&table-name} where 
                   {&table-name}.cod-estabel   = rowObject.cod-estabel and
                   {&table-name}.nr-proc-imp   = rowObject.nr-proc-imp and
                   {&table-name}.cod-itiner    = rowObject.cod-itiner  and
                   {&table-name}.cod-pto-contr = itinerario.pto-embarque no-lock no-error.
               if  avail {&table-name}  then do:
                   if    rowObject.sequencia > {&table-name}.sequencia then do:
                         assign i-seq-erro = i-seq-erro + 1.
                         /* Pto Contr Ç posterior ao Pto Emb do material */
                         run utp/ut-msgs.p (input "msg",
                                            input 17259,
                                            input "").
                         create tt-bo-erro.
                         assign tt-bo-erro.i-sequen     = i-seq-erro
                                tt-bo-erro.cd-erro      = 17259
                                tt-bo-erro.mensagem     = return-value.
                   end.
               end.                 
         end.
    end.         

    run validateFields.
   
    find first tt-bo-erro
        no-lock no-error.
        
    if not avail tt-bo-erro then do:
       find {&TABLE-NAME} where rowid({&TABLE-NAME}) = r-chave exclusive-lock no-error.        
       if   avail {&table-name} then do:
            assign dt-efetiva-old            = {&table-name}.dt-efetiva
                   rowObject.dt-ult-previsao = rowObject.dt-previsao
                   da-ult-ant                = {&table-name}.dt-ult-previsao
                   r-replan                  = rowid({&table-name}).        
               
            run executeUpdate.
        
            if {&table-name}.dt-efetiva <> dt-efetiva-old then do:
                    find pto-contr 
                         where pto-contr.cod-pto-contr = {&table-name}.cod-pto-contr
                         no-lock no-error.
                    if (avail pto-contr and pto-contr.log-1 = no) or (not avail pto-contr) then do: /* se estiver parametrizado para recalcular dt ultima previs∆o */
                        for each historico-proc-imp NO-LOCK where              
                                 historico-proc-imp.cod-estabel = rowObject.cod-estabel and
                                 historico-proc-imp.nr-proc-imp = rowObject.nr-proc-imp and
                                 historico-proc-imp.cod-itiner  = rowObject.cod-itiner:
        
                                    find b-historico-proc-imp where 
                                         rowid(b-historico-proc-imp) = rowid(historico-proc-imp) 
                                         exclusive-lock no-error.
                                                
                                    assign dt-prev-orig     = b-historico-proc-imp.dt-previsao
                                          dt-ult-prev-orig = b-historico-proc-imp.dt-ult-previsao
                                          dt-efetiva-orig  = b-historico-proc-imp.dt-efetiva.                                            
                
                                    find next b-historico-proc-imp where
                                              b-historico-proc-imp.cod-estabel = rowObject.cod-estabel and
                                              b-historico-proc-imp.nr-proc-imp = rowObject.nr-proc-imp and
                                              b-historico-proc-imp.cod-itiner  = rowObject.cod-itiner
                                              exclusive-lock no-error.                
                                    if  avail b-historico-proc-imp then do:                    
                                        assign i-nr-dias = b-historico-proc-imp.dt-previsao - dt-prev-orig.
                
                                        if  dt-efetiva-orig <> ? then
                                            assign b-historico-proc-imp.dt-ult-previsao = dt-efetiva-orig  + i-nr-dias.
                                        else 
                                           assign b-historico-proc-imp.dt-ult-previsao = dt-ult-prev-orig + i-nr-dias. 
                                    end.
                        end.
                        run atualizaPrazoCompra (input r-replan). /*1*/
                    end.
            end.
       end.
    end.
    run endMethod("validateUpdate":U).
end procedure.

procedure setItempai:
/* Grava se o registro que est† sendo eliminado Ç um registro pai */
def input parameter p-elimina-pai as logical no-undo.

assign l-elimina-pai = p-elimina-pai.
end procedure.

procedure validateDelete:
    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.
 
    for each tt-bo-erro no-lock:
       delete tt-bo-erro.
    end.
    
    run InitializeValidate.
    find {&TABLE-NAME} where
        rowid({&TABLE-NAME}) = r-chave
        exclusive-lock no-error.
    if avail {&TABLE-NAME} then do:            
        if l-elimina-pai then do:
            run executeDeleteitem (input-output r-chave).
            leave.
        end.            
        else do:  
            if {&TABLE-NAME}.dt-efetiva <> ? then do:
                 assign i-seq-erro = i-seq-erro + 1.
                 {utp/ut-liter.i Ponto_de_Controle * R}
                 run utp/ut-msgs.p (input "msg",
                                    input 18510,
                                    input return-value).
                 create tt-bo-erro.
                 assign tt-bo-erro.i-sequen = i-seq-erro
                        tt-bo-erro.cd-erro  = 18510
                        tt-bo-erro.mensagem = return-value.
            end.
          
            find itinerario where itinerario.cod-itiner = {&TABLE-NAME}.cod-itiner NO-LOCK no-error.
            if avail itinerario then do:
               if itinerario.pto-embarque = {&TABLE-NAME}.cod-pto-contr then do:
                  assign i-seq-erro = i-seq-erro + 1.
                  run utp/ut-msgs.p (input "msg",
                                     input 19628,
                                     input string({&TABLE-NAME}.cod-pto-contr)).
                  create tt-bo-erro.
                  assign tt-bo-erro.i-sequen = i-seq-erro
                         tt-bo-erro.cd-erro  = 19628
                         tt-bo-erro.mensagem = return-value.
               end.
     
               if itinerario.pto-desembarque = {&TABLE-NAME}.cod-pto-contr then do:
                  assign i-seq-erro = i-seq-erro + 1.
                  run utp/ut-msgs.p (input "msg",
                                     input 19629,
                                     input string({&TABLE-NAME}.cod-pto-contr)).
                  create tt-bo-erro.
                  assign tt-bo-erro.i-sequen = i-seq-erro
                         tt-bo-erro.cd-erro  = 19629
                         tt-bo-erro.mensagem = return-value.
               end.
     
               if itinerario.pto-chegada = {&TABLE-NAME}.cod-pto-contr then do:
                  assign i-seq-erro = i-seq-erro + 1.
                  run utp/ut-msgs.p (input "msg",
                                     input 19630,
                                     input string({&TABLE-NAME}.cod-pto-contr)).
                  create tt-bo-erro.
                  assign tt-bo-erro.i-sequen = i-seq-erro
                         tt-bo-erro.cd-erro  = 19630
                         tt-bo-erro.mensagem = return-value.
               end.
            end.
            find first tt-bo-erro no-lock no-error.
            if not avail tt-bo-erro then do:
                run eliminaRelacionamentos (input historico-proc-imp.nr-proc-imp,
                                            input historico-proc-imp.cod-estabel,
                                            input historico-proc-imp.cod-itiner,
                                            input historico-proc-imp.sequencia).
                run executeDelete.                                             
            end.
        end.
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

procedure executeDeleteitem:
    /* Elimina registro filhos e o pr¢prio pai */
    def input-output parameter r-chave as rowid no-undo.
    
    def var c-nr-proc-imp as char no-undo.
    def var i-cod-itiner as integer no-undo.

    find {&TABLE-NAME} where rowid({&TABLE-NAME}) = r-chave no-lock no-error.
    if avail {&TABLE-NAME} then
      assign c-nr-proc-imp  = {&TABLE-NAME}.nr-proc-imp
             i-cod-itiner = {&TABLE-NAME}.cod-itiner.                             
    for each {&TABLE-NAME} where
       {&TABLE-NAME}.nr-proc-imp  = c-nr-proc-imp and       
       {&TABLE-NAME}.cod-itiner = i-cod-itiner exclusive-lock:  
       delete {&TABLE-NAME}.
    end.
    
    find first {&TABLE-NAME} where {&TABLE-NAME}.nr-proc-imp > c-nr-proc-imp and
                                   {&TABLE-NAME}.cod-itiner = i-cod-itiner no-lock no-error.                                               
    if not avail {&TABLE-NAME} then 
      find first {&TABLE-NAME} where {&TABLE-NAME}.cod-itiner > i-cod-itiner no-lock no-error. 
    if not avail {&TABLE-NAME} then
      find last {&TABLE-NAME} where {&TABLE-NAME}.nr-proc-imp < c-nr-proc-imp and        
                                    {&TABLE-NAME}.cod-itiner = i-cod-itiner no-lock no-error.          
    if not avail {&TABLE-NAME} then 
      find last {&TABLE-NAME} where {&TABLE-NAME}.cod-itiner < i-cod-itiner no-lock no-error. 
      
    if avail {&TABLE-NAME} then assign r-chave = rowid({&TABLE-NAME}).    
end procedure.


procedure validateDelete2:
    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.    
 
    run InitializeValidate.
 
    find {&TABLE-NAME} where
        rowid({&TABLE-NAME}) = r-chave
        exclusive-lock no-error.
    if avail {&TABLE-NAME} then do:       
        find {&table-name} where rowid({&table-name}) = r-chave exclusive-lock no-error.
        if avail {&table-name} then do:       
            assign c-nr-proc-imp   = {&table-name}.nr-proc-imp
                   i-cod-itiner    = {&table-name}.cod-itiner.  
            for each {&TABLE-NAME} where 
                     {&table-name}.nr-proc-imp = c-nr-proc-imp and
                     {&table-name}.cod-itiner  = i-cod-itiner exclusive-lock:
               run executeDelete.
            end.
        end.
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

procedure validateFields:
find itinerario where itinerario.cod-itiner = rowObject.cod-itiner no-lock no-error.
if   avail itinerario then do:
     find {&table-name} where 
          {&table-name}.cod-estabel   = rowObject.cod-estabel and
          {&table-name}.nr-proc-imp   = rowObject.nr-proc-imp and
          {&table-name}.cod-itiner    = rowObject.cod-itiner  and
          {&table-name}.cod-pto-contr = itinerario.pto-embarque NO-LOCK no-error.
     if   avail {&table-name} then do:
          if    {&table-name}.dt-efetiva <> ? then do:
                find first ordens-embarque where 
                           ordens-embarque.cod-estabel = {&table-name}.cod-estabel and
                           ordens-embarque.nr-proc-imp = {&table-name}.nr-proc-imp
                           no-lock no-error.
                if   avail ordens-embarque then do:           
                     assign i-seq-erro = i-seq-erro + 1.
                     /* Embarque jˇ efetivado */
                     run utp/ut-msgs.p (input "msg",
                                        input 17264,
                                        input "").
                     create tt-bo-erro.
                     assign tt-bo-erro.i-sequen     = i-seq-erro
                            tt-bo-erro.cd-erro      = 17264
                            tt-bo-erro.mensagem     = return-value.
                end.
                                
          end.             
     end.
     if  rowobject.dt-efetiva <> ? then do:
         find {&table-name} where rowid({&table-name}) = rowObject.r-rowid NO-LOCK no-error.
         if   avail {&table-name} then do:
              find prev {&table-name} where 
                        {&table-name}.nr-proc-imp = rowObject.nr-proc-imp and
                        {&table-name}.cod-estabel = rowObject.cod-estabel and
                        {&table-name}.cod-itiner  = rowObject.cod-itiner NO-LOCK no-error.
              if avail {&table-name} then do:
                 if {&table-name}.dt-efetiva = ? then do:
                     assign i-seq-erro = i-seq-erro + 1.
                     /* Pto Contr n∆o pode ser efetivado */
                     run utp/ut-msgs.p (input "msg",
                                        input 17335,
                                        input "").
                     create tt-bo-erro.
                     assign tt-bo-erro.i-sequen     = i-seq-erro
                            tt-bo-erro.cd-erro      = 17335
                            tt-bo-erro.mensagem     = return-value.
                 end.
                 if {&table-name}.dt-efetiva > rowObject.dt-efetiva then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-field.i mgcex {&table-name} dt-efetiva 1}
                    /* Data Efetiva Ç menor que a do ponto anterior */
                    run utp/ut-msgs.p (input "msg",
                                       input 17337,
                                       input return-value).
                     create tt-bo-erro.
                     assign tt-bo-erro.i-sequen     = i-seq-erro
                            tt-bo-erro.cd-erro      = 17335
                            tt-bo-erro.mensagem     = return-value.
                 end.           
              end.
         end.
         find {&table-name} where rowid({&table-name}) = rowObject.r-rowid no-error.
         if   avail {&table-name} then do:
              find next {&table-name} where 
                        {&table-name}.nr-proc-imp = rowObject.nr-proc-imp and
                        {&table-name}.cod-estabel = rowObject.cod-estabel and
                        {&table-name}.cod-itiner  = rowObject.cod-itiner NO-LOCK no-error.
              if avail  {&table-name} and {&table-name}.dt-efetiva <> ? then do:
                 if  rowObject.dt-efetiva > {&table-name}.dt-efetiva then do:
                     assign i-seq-erro = i-seq-erro + 1.
                     {utp/ut-field.i mgcex {&table-name} dt-efetiva 1}
                     /* Data Efetiva Ç maior que a do Pto Contr seguinte */
                     run utp/ut-msgs.p (input "msg",
                                        input 17316,
                                        input return-value).
                     create tt-bo-erro.
                     assign tt-bo-erro.i-sequen     = i-seq-erro
                            tt-bo-erro.cd-erro      = 17316
                            tt-bo-erro.mensagem     = return-value.
                 end.
              end.
         end.                            
     end.        
end.           
end procedure.

procedure validateCreate:
    /*
    **  Valida criaá∆o da tabela/duplicidade de registro.
    */
    def input  parameter table for rowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
    
    run startMethod("validateCreate":U).
    
    run initializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find last rowObject exclusive-lock no-error.
         
    if rowObject.cod-pto-contr = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-pto-contr 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else if not can-find(pto-contr where pto-contr.cod-pto-contr = rowObject.cod-pto-contr) then do:
             assign i-seq-erro = i-seq-erro + 1.
             {utp/ut-table.i mgcex pto-contr 1}
             run utp/ut-msgs.p (input "msg",
                                input 2,
                                input return-value).
             create tt-bo-erro.
             assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 2
                    tt-bo-erro.mensagem = return-value.
         end.         
         
    if rowObject.sequencia = 0 then do:
       assign i-seq-erro = i-seq-erro + 1.
      {utp/ut-field.i mgcex {&table-name} sequencia 1}
       run utp/ut-msgs.p (input "msg",
                          input 265,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 265
              tt-bo-erro.mensagem     = return-value.
    end.      
    
    if rowObject.dt-previsao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} dt-previsao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else
        assign rowObject.dt-ult-previsao = rowObject.dt-previsao.
    
    find last {&table-name} where
              {&table-name}.cod-estabel = rowObject.cod-estabel and
              {&table-name}.nr-proc-imp = rowObject.nr-proc-imp and
              {&table-name}.cod-itiner  = rowObject.cod-itiner  and
              {&table-name}.sequencia   < rowObject.sequencia
              no-lock no-error.
    if  avail {&table-name} then do: 
        if {&table-name}.dt-previsao > rowObject.dt-previsao then do:
           assign i-seq-erro = i-seq-erro + 1.
           {utp/ut-field.i mgcex {&table-name} dt-previsao 1}
           /* Previs∆o Original Ç menor que a do Pto Contr anterior */
           run utp/ut-msgs.p (input "msg",
                              input 17337,
                              input return-value).
           create tt-bo-erro.
           assign tt-bo-erro.i-sequen     = i-seq-erro
                  tt-bo-erro.cd-erro      = 17337
                  tt-bo-erro.mensagem     = return-value.
        end.
        if rowObject.dt-efetiva <> ? then do:
           if  {&table-name}.dt-efetiva <> ? and 
               {&table-name}.dt-efetiva > rowObject.dt-efetiva then do:
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-field.i mgcex {&table-name} dt-efetiva 1}
               /* Data Efetiva Ç menor que a do Pto Contr anterior */
               run utp/ut-msgs.p (input "msg",
                                  input 17337,
                                  input return-value).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 17337
                      tt-bo-erro.mensagem     = return-value.    
           end.
        end.
    end.          
    find first {&table-name} where
               {&table-name}.cod-estabel = rowObject.cod-estabel and
               {&table-name}.nr-proc-imp = rowObject.nr-proc-imp and
               {&table-name}.cod-itiner  = rowObject.cod-itiner  and
               {&table-name}.sequencia   > rowObject.sequencia
               no-lock no-error.
    if avail {&table-name} then do: 
       if {&table-name}.dt-previsao < rowObject.dt-previsao then do:
          assign i-seq-erro = i-seq-erro + 1.
          {utp/ut-field.i mgcex {&table-name} dt-previsao 1}
          /* Previs∆o Original Ç maior que a do Pto Contr seguinte */
          run utp/ut-msgs.p (input "msg",
                             input 17316,
                             input return-value).
          create tt-bo-erro.
          assign tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 17316
                 tt-bo-erro.mensagem     = return-value.
       end.
       if rowObject.dt-efetiva <> ? then do:
          if  {&table-name}.dt-efetiva <> ? and 
              {&table-name}.dt-efetiva < rowObject.dt-efetiva then do:
              assign i-seq-erro = i-seq-erro + 1.
              {utp/ut-field.i mgcex historico-proc-imp dt-efetiva 1}
              /* Data Efetiva Ç maior que a do Pto Contr seguinte */
              run utp/ut-msgs.p (input "msg",
                                 input 17316,
                                 input return-value).
              create tt-bo-erro.
              assign tt-bo-erro.i-sequen     = i-seq-erro
                     tt-bo-erro.cd-erro      = 17316
                     tt-bo-erro.mensagem     = return-value.    
          end.
       end.
       else do:
            if {&table-name}.dt-efetiva <> ? then do:
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-field.i mgcex historico-proc-imp dt-efetiva 1}
               /* Data Efetiva deve ser informada (pois a do Pto Contr seguinte est†!) */
               run utp/ut-msgs.p (input "msg",
                                  input 265,
                                  input return-value).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 265
                      tt-bo-erro.mensagem     = return-value.
            end.   
       end.          
    end.
    for each {&TABLE-NAME} where
             {&TABLE-NAME}.cod-estabel = rowObject.cod-estabel and
             {&TABLE-NAME}.nr-proc-imp = rowObject.nr-proc-imp  and
             {&TABLE-NAME}.cod-itiner  = rowObject.cod-itiner no-lock:
        if {&TABLE-NAME}.cod-pto-contr  = rowObject.cod-pto-contr then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i mgcex {&TABLE-NAME} dt-efetiva 1}
                /* Ponto de controle j† cadastrado */
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Ponto_de_Controle" *}
                run utp/ut-msgs.p (input "msg",
                                   input 8,
                                   input RETURN-VALUE).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 8
                       tt-bo-erro.mensagem     = return-value.
       end.
       if  {&TABLE-NAME}.sequencia  = rowObject.sequencia then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i mgcex {&TABLE-NAME} dt-efetiva 1}
                /* Sequencia do Ponto de controle j† cadastrado */
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Sequància_do_Ponto_de_Controle" *}
                run utp/ut-msgs.p (input "msg",
                                   input 8,
                                   input RETURN-VALUE).
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
       run alteraSequencia.    
       run executeCreate.       
       assign r-chave = rowid({&table-name}).       
       
       find pto-contr 
            where pto-contr.cod-pto-contr = {&table-name}.cod-pto-contr
            no-lock no-error.
       if (avail pto-contr and pto-contr.log-1 = no) or (not avail pto-contr) then do: /* se estiver parametrizado para recalcular dt ultima previs∆o */
           for each historico-proc-imp where              
                    historico-proc-imp.cod-estabel = rowObject.cod-estabel and
                    historico-proc-imp.nr-proc-imp = rowObject.nr-proc-imp and
                    historico-proc-imp.cod-itiner  = rowObject.cod-itiner NO-LOCK:   
               find b-historico-proc-imp where 
                    rowid(b-historico-proc-imp) = rowid(historico-proc-imp) 
                    exclusive-lock no-error.
                                
               assign dt-prev-orig     = b-historico-proc-imp.dt-previsao
                      dt-ult-prev-orig = b-historico-proc-imp.dt-ult-previsao
                      dt-efetiva-orig  = b-historico-proc-imp.dt-efetiva.                                            

               find next b-historico-proc-imp where
                         b-historico-proc-imp.cod-estabel = rowObject.cod-estabel and
                         b-historico-proc-imp.nr-proc-imp = rowObject.nr-proc-imp and
                         b-historico-proc-imp.cod-itiner  = rowObject.cod-itiner
                         exclusive-lock no-error.                
               if  avail b-historico-proc-imp then do:                    
                   assign i-nr-dias = b-historico-proc-imp.dt-previsao - dt-prev-orig.

                   if dt-efetiva-orig <> ? then
                       assign b-historico-proc-imp.dt-ult-previsao = dt-efetiva-orig  + i-nr-dias.
                   else 
                       assign b-historico-proc-imp.dt-ult-previsao = dt-ult-prev-orig + i-nr-dias. 
               end.
           end.
           run atualizaPrazoCompra (input r-chave). /*2*/
       end.                            
    end.   
    run endMethod("validateCreate":U). 
end procedure.

procedure calculateDefasagem:
def input parameter r-chave as rowid no-undo.
def output parameter i-dias as integer no-undo.

find {&table-name} where rowid({&table-name}) = r-chave no-lock no-error.
if avail {&table-name} then do:
    if {&table-name}.dt-efetiva <> ? then
        assign i-dias = {&table-name}.dt-efetiva - {&table-name}.dt-previsao.   
    else
        assign i-dias = {&table-name}.dt-ult-previsao - {&table-name}.dt-previsao.   
end.
end procedure.

procedure validateCodigo:
/*
** Valida formato e tipo de dados dos campos
*/
    def input-output parameter c-seq       as char no-undo.
    def input-output parameter c-pto-contr as char no-undo.
    def output parameter table for tt-bo-erro.
  
    def var i-teste as integer no-undo.
    
    assign i-teste = int(c-seq) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-seq = "0".
        {utp/ut-field.i mgcex {&table-name} sequencia 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.   
    assign i-teste = int(c-pto-contr) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-pto-contr = "0".
        {utp/ut-field.i mgcex {&table-name} cod-pto-contr 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.
end procedure.

procedure alteraSequencia:
    def var l-seq as logical init yes no-undo.
    def var i-seq as integer no-undo.
    
    assign i-seq = rowObject.sequencia.
    
    for each tt-hist-proc:
        delete tt-hist-proc.
    end.   
     
    do while l-seq:
        if avail rowObject then do:
            find {&table-name} where 
                {&table-name}.nr-proc-imp = rowObject.nr-proc-imp and
                {&table-name}.cod-estabel = rowObject.cod-estabel and
                {&table-name}.cod-itiner  = rowObject.cod-itiner  and
                {&table-name}.sequencia   = i-seq exclusive-lock no-error.
            if avail {&table-name} then do:
                create tt-hist-proc.         
                assign tt-hist-proc.i-sequencia = {&table-name}.sequencia
                       tt-hist-proc.r-hist      = rowid({&table-name})
                       i-seq = i-seq + 1.                 
            end.
            else assign l-seq = no.      
        end.      
    end.
    for each tt-hist-proc by tt-hist-proc.i-sequencia desc:
        find {&table-name} where rowid({&table-name}) = tt-hist-proc.r-hist exclusive-lock no-error.
        if avail {&table-name} then
            assign {&table-name}.sequencia = tt-hist-proc.i-sequencia + 1.
    end.
end procedure.

procedure atualizaUltPrev:
/*
**
*/
  if {&table-name}.dt-efetiva <> dt-efetiva-old then do:     
    for each historico-proc-imp where              
        historico-proc-imp.cod-estabel = rowObject.cod-estabel and
        historico-proc-imp.nr-proc-imp = rowObject.nr-proc-imp and
        historico-proc-imp.cod-itiner  = rowObject.cod-itiner NO-LOCK:
        find b-historico-proc-imp where 
            rowid(b-historico-proc-imp) = rowid(historico-proc-imp) 
            exclusive-lock no-error.                                
        assign dt-prev-orig     = b-historico-proc-imp.dt-previsao
               dt-ult-prev-orig = b-historico-proc-imp.dt-ult-previsao
               dt-efetiva-orig  = b-historico-proc-imp.dt-efetiva.                                            
        find next b-historico-proc-imp where
            b-historico-proc-imp.cod-estabel = rowObject.cod-estabel and
            b-historico-proc-imp.nr-proc-imp = rowObject.nr-proc-imp and
            b-historico-proc-imp.cod-itiner  = rowObject.cod-itiner
            exclusive-lock no-error.                
        if avail b-historico-proc-imp then do:                    
            assign i-nr-dias = b-historico-proc-imp.dt-previsao - dt-prev-orig.
            if dt-efetiva-orig <> ? then
                assign b-historico-proc-imp.dt-ult-previsao = dt-efetiva-orig  + i-nr-dias.
            else 
                assign b-historico-proc-imp.dt-ult-previsao = dt-ult-prev-orig + i-nr-dias. 
            end.
       end.       
    end.
end procedure.

procedure atualizaPrazoCompra:
/*
**  Atualizaá∆o da Data de Entrega da Prazo Compra conforme Hist¢rico Proc Imp.
*/
    def input parameter r-chave    as rowid no-undo.
    DEF VAR d-calc-data AS DATE NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR EACH tt-dif:
        DELETE tt-dif.
    END.

    find {&table-name} where rowid({&table-name}) = r-chave no-lock no-error.
    if   avail {&table-name} then do:
         find itinerario where 
              itinerario.cod-itiner = {&table-name}.cod-itiner 
              no-lock no-error.
         if   avail itinerario then 
              assign i-pto-chegada = itinerario.pto-chegada.                    
         find b-{&table-name} where 
              b-{&table-name}.cod-estabel   = {&table-name}.cod-estabel and
              b-{&table-name}.nr-proc-imp   = {&table-name}.nr-proc-imp and
              b-{&table-name}.cod-itiner    = {&table-name}.cod-itiner  and
              b-{&table-name}.cod-pto-contr = i-pto-chegada
              no-lock no-error.
         if   avail b-{&table-name} then do:
              assign da-pto-cheg = b-{&table-name}.dt-ult-previsao.        
              find processo-imp where 
                   processo-imp.nr-proc-imp = b-{&table-name}.nr-proc-imp
                   no-lock no-error.
              if   avail processo-imp then do:
                   for each ordem-compra where 
                            ordem-compra.num-pedido = processo-imp.num-pedido no-lock:

                       if  avail param-global and
                           ( param-global.modulo-pl = yes 
                             &IF DEFINED(bf-mat-comex) &THEN
                             &else
                                or 
                                param-global.modulo-pi = yes                             
                             &ENDIF
                             ) then do:           
                           run cdp/cd7000.p (input 0, ordem-compra.it-codigo, ordem-compra.cod-estabel). 
                       end.

                       /*{cdp/cd7000.i7 "ordem-compra"} /* replanejamento do item */ */    
                       
                       for  each prazo-compra no-lock where
                                 prazo-compra.numero-ordem = ordem-compra.numero-ordem
                                 break by prazo-compra.parcela:
                            if   first-of(prazo-compra.parcela) then do:
                                 assign data-base = prazo-compra.data-entrega.
                            end.  
                            create tt-dif.
                            assign tt-dif.r-rowid   = rowid(prazo-compra)
                                   tt-dif.diferenca = prazo-compra.data-entrega - data-base
                                   data-base        = prazo-compra.data-entrega.
                       end.
                       for each tt-dif:
                           find prazo-compra where 
                                rowid(prazo-compra) = tt-dif.r-rowid
                                exclusive-lock no-error.
                           if   avail  prazo-compra then do:
                                /*FO: 1806.191 Modificaá‰es para Criar a alt-ped*/
                                if prazo-compra.data-entrega <> (da-pto-cheg + tt-dif.diferenca) then do:
                                    ASSIGN d-calc-data = da-pto-cheg + tt-dif.diferenca.
                                    FIND b-ordem-compra WHERE ROWID(b-ordem-compra) = ROWID(ordem-compra) EXCLUSIVE-LOCK NO-ERROR.
                                        {cxbo/bocx140.i03 today
                                            c-seg-usuario 
                                            b-ordem-compra.num-pedido 
                                            b-ordem-compra.numero-ordem 
                                            prazo-compra.parcela 
                                            prazo-compra.data-entrega 
                                            ? 
                                            ?
                                            b-ordem-compra.cod-emitente
                                            b-ordem-compra.gera-edi
                                            ordem-compra.num-pedido
                                            d-calc-data}
                                end.
                                assign prazo-compra.data-entrega = da-pto-cheg + tt-dif.diferenca.
                                 /*FIM FO: 1806.191 Modificaá‰es para Criar a alt-ped*/
                           end.     
                       end.     
                   end.
              end.
         end.                      
         else do:
              /* mensagem */
         end.
    end. 
end procedure.

procedure eliminaRelacionamentos:
/*
** Elimina Declaraá‰es/Comunicaá‰es do Hist¢rico do Processo de Importaá∆o.
*/

def input parameter c-nr-proc-imp like historico-proc-imp.nr-proc-imp no-undo. 
def input parameter c-cod-estabel like historico-proc-imp.cod-estabel no-undo.
def input parameter i-cod-itiner  like historico-proc-imp.cod-itiner  no-undo.
def input parameter i-sequencia   like historico-proc-imp.sequencia   no-undo.

    
    for each decl-hist-proc-imp exclusive-lock where
             decl-hist-proc-imp.cod-estabel = c-cod-estabel and
             decl-hist-proc-imp.nr-proc-imp = c-nr-proc-imp and
             decl-hist-proc-imp.cod-itiner  = i-cod-itiner  and
             decl-hist-proc-imp.sequencia   = i-sequencia:
             
        delete decl-hist-proc-imp.         
    
    end.         
end procedure.

procedure retornaTransportePtoAnterior:
/*busca o meio de transporte anterior Ö aquele que est† sendo alterado no programa
  acompanhamento de processo de importaá∆o(im0050) */
  
def input  parameter p-cod-estabel like historico-proc-imp.cod-estabel    no-undo.
def input  parameter p-nr-proc-imp like historico-proc-imp.nr-proc-imp    no-undo.
def input  parameter p-cod-itiner  like historico-proc-imp.cod-itiner     no-undo.
def input  parameter p-sequencia   like historico-proc-imp.sequencia      no-undo.
def output parameter p-meio-transp like historico-proc-imp.id-meio-transp no-undo.

for each b-historico-proc-imp2 
   where b-historico-proc-imp2.cod-estabel = p-cod-estabel and
         b-historico-proc-imp2.nr-proc-imp = p-nr-proc-imp and
         b-historico-proc-imp2.cod-itiner  = p-cod-itiner  and
         b-historico-proc-imp2.sequencia < p-sequencia NO-LOCK
        break by b-historico-proc-imp2.sequencia:
  if last-of(b-historico-proc-imp2.sequencia) then
     assign p-meio-transp = b-historico-proc-imp2.id-meio-transp.
end.
end procedure.

