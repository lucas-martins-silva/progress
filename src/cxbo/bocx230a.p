/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX230A 2.00.01.005 } /*** "010105" 09/10/2025 11:36:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx230a MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX230A.P
**
**  historico-embarque - Historico Embarque
**
*******************************************************************************/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */
{cdp/cdcfgdis.i} /* Defini‡Æo de pr‚-processadores */

{include/i-epc200.i bocx230a} /* Defini‡Æo tt-epc e dos programas de EPCs     */

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY historico-embarque
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME historico-embarque

{include/boini.i}
{cxbo/bocx230.i RowObject}
{cxbo/bocx230.i RowObjectAux}
{cxbo/bocx110.i tt-pto-contr}

/* definicao de variaveis usadas no m‚todo gravaMeioTransporte ---*/
{cdp/cd4300.i3}   /* variaveis para o cd4300.i4  */
{ccp/cc9019.i50} /* include tratamento atributo livre cotacao-item.char-1 */

DEFINE TEMP-TABLE tt-processo-embarque NO-UNDO
    FIELD nr-proc-imp LIKE processo-imp.nr-proc-imp.

DEFINE TEMP-TABLE tt-hist-emb no-undo
    field i-sequencia as integer
    field r-hist  as rowid
    index codigo is unique primary
       i-sequencia.

DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO LIKE ordens-embarque 
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-embarques NO-UNDO
    FIELD cod-estabel LIKE embarque-imp.cod-estabel
    FIELD embarque    LIKE embarque-imp.embarque
    INDEX codigo IS UNIQUE PRIMARY
          cod-estabel
          embarque.

DEFINE TEMP-TABLE tt-hist-emb-di NO-UNDO
    FIELD cod-estabel   AS CHARACTER
    FIELD embarque      AS CHARACTER 
    FIELD sequencia     AS INTEGER
    FIELD cod-pto-contr AS INTEGER
    INDEX seq IS UNIQUE PRIMARY
          cod-estabel
          embarque
          sequencia.

DEFINE TEMP-TABLE tt-campo-erro NO-UNDO
    FIELD campo       AS CHARACTER.

DEFINE BUFFER b-tt-ordens-embarque  FOR tt-ordens-embarque.
DEFINE BUFFER b-historico-embarque  for historico-embarque.
DEFINE BUFFER b-historico-embarque2 for historico-embarque.
DEFINE BUFFER b-historico-embarque3 for historico-embarque.
DEFINE BUFFER b-ordens-embarque     for ordens-embarque.
DEFINE BUFFER b-itinerario          for itinerario.
DEFINE BUFFER b-processo-imp        for processo-imp.
DEFINE BUFFER bf-RowObject          FOR RowObject.
DEFINE BUFFER bf-historico-embarque FOR historico-embarque.
DEFINE BUFFER bf-usuar-import       FOR usuar-import.

DEFINE QUERY {&QUERY-NAME} for historico-embarque scrolling.

DEFINE NEW GLOBAL SHARED VARIABLE gr-embarque-imp AS ROWID NO-UNDO.

def var c-cod-estabel          as char no-undo.
def var c-cod-estabelecimento  as char no-undo.
def var i-embarque             as char no-undo.
def var c-desc-pto-atual       as char no-undo.
def var c-desc-pto-anterior    as char no-undo.
def var c-desc-campo-validado  as char no-undo.
def var c-time                 as char no-undo.
def var c-lista-ptos           as char no-undo.
def var c-embarque             LIKE embarque-imp.embarque no-undo.
def var c-embarque-fim         LIKE embarque-imp.embarque no-undo.
def var i-cod-itiner           as integer no-undo.
def var c-cod-pto-contr        as integer no-undo.
def var c-cod-estabel-fim      as char    initial "ZZZZZ" no-undo. /* formato maior que o do campo cod-estabel */
def var i-cod-itiner-fim       as integer initial 999.999 no-undo. /* formato maior que o do campo cod-itiner  */
def var d-efe-ant              as date no-undo.
def var d-pre-ant              as date no-undo.
def var dt-prev-orig           as date no-undo.
def var dt-ult-prev-orig       as date no-undo.
def var dt-efetiva-orig        as date no-undo.
def var i-nr-dias              as integer no-undo.
def var de-prazo               as decimal no-undo.
def var de-ordens              as decimal no-undo.
def var l-aux                  as logical no-undo.
def var l-aux-proc             as logical no-undo.
def var r-aux                  as rowid   no-undo.
def var i-pto-emb              as integer no-undo.
def var i-pto-des              as integer no-undo.
def var i-pto-contr            as integer no-undo.
def var l-elimina-pai          as logical initial "no" no-undo.

DEFINE VARIABLE l-seq-nac AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-bocx407 AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-utiliza-param-recalcula AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-recalcula               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-criou-pto               AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-possui-decl-emitida     AS LOGICAL     NO-UNDO.
/*zoom - cxzoom/z01cx310*/
DEFINE VARIABLE r-rowid-embarque    AS ROWID       NO-UNDO.
DEFINE VARIABLE i-nr-sequencia-ini  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-sequencia-fim  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-pto-contr-ini AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-pto-contr-fim AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-intervalo-adic-aux AS INTEGER    NO-UNDO.

/*FO: 1806.191*/
{utp/ut-glob.i}
/*FO: 1806.191*/

/*
** validateUpdate atualizaStatus
*/
DEF VAR l-pto-embarque  AS LOGICAL NO-UNDO. /* verifica se o ponto alterado ‚ o ponto de embarque */
DEF VAR l-ult-ponto     AS LOGICAL NO-UNDO. /* verifica se o ponto alterado ‚ o £ltimo ponto do embarque */
DEF VAR l-previsao-alt  AS LOGICAL NO-UNDO. /* verifica se a data informada foi diferente da data prevista */

/*
** Utilizado para valida‡äes Update e Create
*/
def var c-opcao           as char    no-undo.

&if defined(bf-mat-comex) &then                                
    {cdp/cd7000.i "new"} /* Definicao de Variaveis do CD7000X */
&else
&endif   

procedure setConstraint1:
end procedure.

procedure setConstraint2:
    def input parameter p-opcao       as char    no-undo.
    def input parameter p-r-chave     as rowid   no-undo.
    def input parameter p-cod-estabel LIKE embarque-imp.cod-estabel no-undo.
    def input parameter p-cod-itiner  as integer no-undo.
    def input parameter p-embarque    LIKE embarque-imp.embarque no-undo.

    assign c-cod-estabel-fim = "ZZZZZ"
           i-cod-itiner-fim  = 999.999
           c-embarque-fim = "ZZZZZZZZZZZZZZZZ".
    case p-opcao:
    when "1" then do:
        for first b-historico-embarque fields(cod-estabel embarque cod-itiner) where 
             rowid(b-historico-embarque) = p-r-chave 
             no-lock:
        end. 
        if avail b-historico-embarque then
           assign c-cod-estabel = b-historico-embarque.cod-estabel
                  i-cod-itiner  = b-historico-embarque.cod-itiner
                  c-embarque    =  b-historico-embarque.embarque.
        /** A tabela do Filho deve apresentar apenas registros do registro Pai corrente **/
        for last b-historico-embarque where 
                 b-historico-embarque.cod-estabel = c-cod-estabel and
                 b-historico-embarque.embarque    = c-embarque    and
                 b-historico-embarque.cod-itiner = i-cod-itiner   
                 no-lock:
        end.
        if avail b-historico-embarque then
             assign c-cod-estabel-fim = b-historico-embarque.cod-estabel
                    i-cod-itiner-fim  = b-historico-embarque.cod-itiner
                    c-embarque-fim    = b-historico-embarque.embarque.
    end.
    when "2" then do:          /* para o zoom */
       find first historico-embarque where 
            historico-embarque.cod-estabel = c-cod-estabel and
            historico-embarque.cod-itiner  = i-cod-itiner 
            no-lock no-error.
      assign c-cod-estabel = p-cod-estabel 
             i-cod-itiner  = p-cod-itiner
             c-embarque    = p-embarque.
    end.
    end case.
end procedure.

procedure setConstraint3:
def input param p-cod-estabel-ini LIKE embarque-imp.cod-estabel no-undo.
def input param p-cod-estabel-fim LIKE embarque-imp.cod-estabel no-undo.
def input param p-embarque-ini    LIKE embarque-imp.embarque    no-undo.
def input param p-embarque-fim    LIKE embarque-imp.embarque    no-undo.
def input param p-cod-itiner-ini as integer no-undo.
def input param p-cod-itiner-fim as integer no-undo.

assign c-cod-estabel = p-cod-estabel-ini
       i-cod-itiner  = p-cod-itiner-ini
       c-embarque    = p-embarque-ini
       c-cod-estabel-fim = p-cod-estabel-fim
       i-cod-itiner-fim  = p-cod-itiner-fim
       c-embarque-fim = p-embarque-fim.
end procedure.

PROCEDURE setconstraint4:
    DEFINE INPUT PARAMETER p-r-chave     AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel AS CHAR  NO-UNDO.
    DEFINE INPUT PARAMETER p-itiner      AS INT   NO-UNDO.
    DEFINE INPUT PARAMETER p-embarque    LIKE embarque-imp.embarque  NO-UNDO.

    FIND historico-embarque WHERE
         rowid(historico-embarque) = p-r-chave NO-LOCK NO-ERROR.
    IF AVAIL historico-embarque THEN
        ASSIGN c-cod-estabel   = historico-embarque.cod-estabel
               i-cod-itiner    = historico-embarque.cod-itiner
               c-embarque      = historico-embarque.embarque.

END PROCEDURE.

PROCEDURE setconstraint5:
    DEFINE INPUT PARAMETER p-r-chave           AS ROWID                              NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-sequencia-ini  LIKE historico-proc-exp.sequencia     NO-UNDO.                             
    DEFINE INPUT PARAMETER p-nr-sequencia-fim  LIKE historico-proc-exp.sequencia     NO-UNDO.                             
    DEFINE INPUT PARAMETER p-cod-pto-contr-ini LIKE historico-proc-exp.cod-pto-contr NO-UNDO.                             
    DEFINE INPUT PARAMETER p-cod-pto-contr-fim LIKE historico-proc-exp.cod-pto-contr NO-UNDO.                             

    FIND FIRST historico-embarque 
         WHERE ROWID(historico-embarque) = p-r-chave NO-LOCK NO-ERROR.
    IF AVAIL historico-embarque THEN
        ASSIGN r-rowid-embarque    = p-r-chave
               i-nr-sequencia-ini  = int(p-nr-sequencia-ini)
               i-nr-sequencia-fim  = int(p-nr-sequencia-fim)
               i-cod-pto-contr-ini = int(p-cod-pto-contr-ini)
               i-cod-pto-contr-fim = int(p-cod-pto-contr-fim)
               c-cod-estabel   = historico-embarque.cod-estabel
               i-cod-itiner    = historico-embarque.cod-itiner
               c-embarque      = historico-embarque.embarque.

END PROCEDURE.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.

    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each historico-embarque no-lock
             {&v9indrep}.
        when 2 then 
            open query {&QUERY-NAME} for each historico-embarque no-lock
                where historico-embarque.cod-estabel >= c-cod-estabel     and
                      historico-embarque.cod-estabel <= c-cod-estabel-fim and
                      historico-embarque.embarque    >= c-embarque        and
                      historico-embarque.embarque    <= c-embarque-fim    and
                      historico-embarque.cod-itiner  >= i-cod-itiner      and
                      historico-embarque.cod-itiner  <= i-cod-itiner-fim
                      BY historico-embarque.sequencia.
        when 3 then 
            open query {&QUERY-NAME} for each historico-embarque no-lock
                  use-index codigo.
        WHEN 4 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH historico-embarque NO-LOCK
                WHERE historico-embarque.cod-estabel = c-cod-estabel     
                  AND historico-embarque.embarque    = c-embarque        
                  AND historico-embarque.cod-itiner  = i-cod-itiner     
            BY historico-embarque.sequencia.
        when 5 then do:
            OPEN QUERY {&QUERY-NAME} FOR EACH {&table-name} NO-LOCK
                WHERE {&table-name}.cod-estabel = c-cod-estabel     
                  AND {&table-name}.embarque    = c-embarque        
                  AND {&table-name}.cod-itiner  = i-cod-itiner 
                  AND {&table-name}.sequencia     >= i-nr-sequencia-ini 
                  AND {&table-name}.sequencia     <= i-nr-sequencia-fim 
                  AND {&table-name}.cod-pto-contr >= i-cod-pto-contr-ini
                  AND {&table-name}.cod-pto-contr <= i-cod-pto-contr-fim
            BY {&table-name}.sequencia.
        end.   

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

procedure setCurrent:
    /*
    **  Seta registro corrente para a temp-table que sera devolvida - {include/bosetcur.i}.
    */
    for each RowObject:
        delete RowObject.
    end.
    
    FIND CURRENT {&table-name} NO-LOCK NO-ERROR.
    if avail {&TABLE-NAME} then do:
        create RowObject.
        buffer-copy {&TABLE-NAME} to RowObject.
        assign rowObject.r-rowid = rowid({&TABLE-NAME}).
    end.
end procedure.

procedure findPrev2:
    /*
    **  Localiza bloco de registro anterior na tabela.
    **  O bloco ‚ formado pelos registros com mesmo nr-proc-imp e mesmo cod-itiner.
    */
    def output parameter c-return as char.

    IF  AVAIL {&TABLE-NAME} THEN
        assign c-cod-estabel = {&TABLE-NAME}.cod-estabel
               i-cod-itiner  = {&TABLE-NAME}.cod-itiner
               c-embarque    = {&TABLE-NAME}.embarque.

    if  l-query THEN DO:
        get prev {&QUERY-NAME} no-lock no-wait.

        DO  WHILE AVAILABLE {&TABLE-NAME}:
            IF  {&TABLE-NAME}.cod-estabel <> c-cod-estabel
            OR  {&TABLE-NAME}.embarque    <> c-embarque
            THEN LEAVE.
        
            get PREV {&QUERY-NAME} no-lock no-wait.
        END.
    END.
    ELSE DO:
        find first {&TABLE-NAME} 
            where {&TABLE-NAME}.cod-estabel = c-cod-estabel 
            AND   {&TABLE-NAME}.embarque    = c-embarque    
            AND   {&TABLE-NAME}.cod-itiner  = i-cod-itiner NO-LOCK NO-ERROR.

        find prev {&TABLE-NAME} no-lock no-error.
    END.

    if  not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg":U,
                           input 7998,
                           input "").
        assign c-return = return-value.                   
    end.
    else run setCurrent.
end procedure.

procedure findNext2:
    /*
    **  Localiza proximo bloco de registro na tabela.
    **  O bloco ‚ formado pelos registros com mesmo nr-proc-imp e mesmo cod-itiner.
    */

    def output parameter c-return as char.

    IF  AVAIL {&TABLE-NAME} THEN
        assign c-cod-estabel = {&TABLE-NAME}.cod-estabel
               i-cod-itiner  = {&TABLE-NAME}.cod-itiner
               c-embarque    = {&TABLE-NAME}.embarque.

    if  l-query THEN DO:
        get next {&QUERY-NAME} no-lock no-wait.

        DO  WHILE AVAILABLE {&TABLE-NAME}:  
            IF  {&TABLE-NAME}.cod-estabel <> c-cod-estabel
            OR  {&TABLE-NAME}.embarque    <> c-embarque
            THEN LEAVE.
        
            get next {&QUERY-NAME} no-lock no-wait.
        END.
    END.
    ELSE DO:
        find last {&TABLE-NAME} 
            where {&TABLE-NAME}.cod-estabel = c-cod-estabel 
            AND   {&TABLE-NAME}.embarque    = c-embarque    
            AND   {&TABLE-NAME}.cod-itiner  = i-cod-itiner NO-LOCK NO-ERROR.

        find next {&TABLE-NAME} no-lock no-error.
    END.

    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg":U,
                           input 7999,
                           input "").
        assign c-return = return-value.                   
    end.
    else run setCurrent.
end procedure.

procedure findChEmbarque:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */ 
    def input parameter  c-cod-estabel LIKE embarque-imp.cod-estabel no-undo.
    def input parameter  c-embarque    LIKE embarque-imp.embarque    no-undo.
    def input parameter  i-cod-itiner  as   integer                  no-undo.
    def output parameter c-return      as char    no-undo.
 
    find first historico-embarque where
               historico-embarque.cod-estabel = c-cod-estabel and
               historico-embarque.embarque    = c-embarque    and
               historico-embarque.cod-itiner  = i-cod-itiner
               no-lock no-error.
    if not avail historico-embarque then do:
        {utp/ut-table.i mgcex historico-embarque 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign c-return = return-value.                   
    end.
    else do:
       run setCurrent.
    end.
end procedure.

procedure goToPtoCont:
    /*
    **Poisciona na chave primaria e unica da tabela
    */
    define input parameter c-cod-estabel   as char                      no-undo.
    define input parameter c-embarque      LIKE embarque-imp.embarque   no-undo.
    define input parameter i-cod-itiner    as integer                   no-undo.
    define input parameter i-cod-pto-contr as integer                   no-undo.

    find first historico-embarque
         where historico-embarque.cod-estabel   = c-cod-estabel
           AND historico-embarque.embarque      = c-embarque
           AND historico-embarque.cod-itiner    = i-cod-itiner
           AND historico-embarque.cod-pto-contr = i-cod-pto-contr NO-LOCK NO-ERROR.

    if not avail historico-embarque then return "NOK":U.

    run setCurrent.

    return "OK":U.

end procedure.

procedure findEmbarque:
    /*
    **  Procura pelo cod-estabel e pelo embarque, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */ 
    def input parameter  c-cod-estabel LIKE embarque-imp.cod-estabel no-undo.
    def input parameter  c-embarque    LIKE embarque-imp.embarque    no-undo.
    def output parameter c-return      as char    no-undo.
 
    for first historico-embarque where
              historico-embarque.cod-estabel = c-cod-estabel and
              historico-embarque.embarque    = c-embarque    
              no-lock:
    end.
    if not avail historico-embarque then do:
        {utp/ut-table.i mgcex historico-embarque 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign c-return = return-value.                   
    end.
    else do:
       run setCurrent.
    end.
end procedure.

procedure findPto-Controle:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-cod-estabel   LIKE embarque-imp.cod-estabel no-undo.
    def input parameter i-cod-itiner    as integer                    no-undo.
    def input parameter c-embarque      LIKE embarque-imp.embarque    no-undo.
    def input parameter i-cod-pto-contr as integer                    no-undo.
    def output parameter c-return       as char                       no-undo.

    run startMethod("find":U).

    find historico-embarque where
         historico-embarque.cod-estabel   = c-cod-estabel and
         historico-embarque.embarque      = c-embarque    and
         historico-embarque.cod-itiner    = i-cod-itiner  and
         historico-embarque.cod-pto-contr = i-cod-pto-contr
         no-lock no-error.
    if not avail historico-embarque then do:
        {utp/ut-table.i mgcex historico-embarque 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.
    run endMethod("find":U).
end procedure.

procedure findSub:
    /*
    **  Localiza bloco de registro subsequente na tabela.
    **  O bloco ‚ formado pelos registros com mesmo nr-proc-imp e mesmo cod-itiner.
    */
    def output parameter c-return as char no-undo.

    run startMethod("find":U).

    assign c-cod-estabel   = historico-embarque.cod-estabel
           i-cod-itiner    = historico-embarque.cod-itiner
           c-embarque  = historico-embarque.embarque
           c-cod-pto-contr = historico-embarque.cod-pto-contr.

    for first historico-embarque where 
              historico-embarque.cod-estabel = c-cod-estabel and
              historico-embarque.embarque    = c-embarque    and
              historico-embarque.cod-itiner  = i-cod-itiner  and
              historico-embarque.cod-pto-contr <> c-cod-pto-contr
              no-lock:
    end.
    if avail historico-embarque then do:
        run setCurrent.
    end.
    else do:
        for first historico-embarque where 
                  historico-embarque.cod-estabel = c-cod-estabel and
                  historico-embarque.embarque <> c-embarque      and
                  historico-embarque.cod-itiner  = i-cod-itiner  
                  no-lock:
        end.
        if avail historico-embarque
            then run setCurrent.
        else do:
            for first historico-embarque where 
                       historico-embarque.embarque <> c-embarque 
                       no-lock:
            end.
            if avail historico-embarque then run setCurrent.
        end.
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
             find first rowObject where 
                        rowObject.cod-estabel = historico-embarque.cod-estabel and   
                        rowObject.embarque    = historico-embarque.embarque    and
                        rowObject.cod-itiner  = historico-embarque.cod-itiner  
                        no-lock no-error.
             if not avail rowObject then do:
               
                create rowObject.
 		  buffer-copy historico-embarque to rowObject.
		  assign rowObject.r-rowid = rowid(historico-embarque)
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

procedure executeUpdate:
    /*
    **  Executa Update
    */
    buffer-copy RowObject except cod-estabel cod-itiner embarque sequencia r-rowid to historico-embarque .
end procedure.

procedure executeUpdateAcomp:
    /*  Executa Update para o acompanhamento do processo (im0055) - Precisa copiar a sequˆncia do ponto tamb‚m, pois ‚ poss¡vel altera-las no browser. */

    run startMethod ("executeUpdate").
                    
    buffer-copy RowObject EXCEPT cod-pto-contr cod-estabel cod-itiner embarque  r-rowid to {&table-name}. 
    
    run endMethod   ("executeUpdate").

end procedure.

procedure validateUpdate:
    /*
    **  Valida Update
    */
    def input parameter table for rowObject.
    def input parameter r-chave as rowid no-undo.
    def output parameter table for tt-bo-erro.
    
        
    def var dt-previsao-old as date no-undo.
    def var dt-ult-prev-old as date no-undo.
    def var dt-efetiva-old  as date no-undo.
    DEF VAR dt-efetiva-old-orig AS DATE NO-UNDO.
    
    def var dt-pto-ant       as date    no-undo.
    def var i-intervalo-adic as integer no-undo.    
    
    assign c-opcao = "Update":U.

    ASSIGN l-pto-embarque = NO
           l-ult-ponto    = NO
           l-previsao-alt = NO.

    run initializeValidate.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    find first rowObject no-error.

    find itinerario 
        where itinerario.cod-itiner = rowObject.cod-itiner no-lock no-error.

    FIND FIRST embarque-imp
         WHERE embarque-imp.embarque = RowObject.embarque
           AND embarque-imp.cod-estabel = RowObject.cod-estabel NO-LOCK NO-ERROR.

    /* Teste de duplicidade */
    if can-find(historico-embarque 
          where historico-embarque.cod-estabel   = rowObject.cod-estabel 
            and historico-embarque.embarque      = rowObject.embarque    
            and historico-embarque.cod-itiner    = rowObject.cod-itiner  
            and historico-embarque.cod-pto-contr = rowObject.cod-pto-contr
            and rowid(historico-embarque)       <> rowObject.r-rowid) then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Ponto_de_controle * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 8,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 8
               tt-bo-erro.mensagem     = return-value.
        create tt-campo-erro.
        assign tt-campo-erro.campo = "cod-pto-contr":U.
    end.

    /*
    ** Se estiver parametrizado para gerar historico do processo s¢ modifica ap¢s efetivar ponto de embarque
    */    
    find historico-embarque 
        where rowid(historico-embarque) = rowObject.r-rowid no-lock no-error.
    if avail historico-embarque then do:
        if avail itinerario then do:
            find param-imp 
                where param-imp.cod-estabel = historico-embarque.cod-estabel no-lock no-error.
            if avail param-imp and param-imp.hist-processo then do:
                FOR FIRST historico-embarque FIELDS (sequencia) where 
                          historico-embarque.cod-estabel   = rowObject.cod-estabel and
                          historico-embarque.embarque      = rowObject.embarque    and 
                          historico-embarque.cod-itiner    = rowObject.cod-itiner  and
                          historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq    NO-LOCK:
                END.
                if avail historico-embarque then do:
                    if rowObject.sequencia <= historico-embarque.sequencia then do:
                        assign i-seq-erro = i-seq-erro + 1.
                        /* Pto Contr nÆo pode ser alterado  */
                        run utp/ut-msgs.p (input "msg":U,
                                           input 17470,
                                           input "").
                        create tt-bo-erro.
                        assign tt-bo-erro.i-sequen     = i-seq-erro
                               tt-bo-erro.cd-erro      = 17470
                               tt-bo-erro.mensagem     = return-value.
                        create tt-campo-erro.
                        assign tt-campo-erro.campo = "cod-pto-contr":U.
                    end. 
                end.
            end.     
        end.
    end.
    
    /* Cria ponto de controle caso nÆo exista */
    run pi-verifica-pto-contr in this-procedure.
    IF CAN-FIND(FIRST tt-bo-erro WHERE tt-bo-erro.errorsubtype <> "WARNING":U) THEN
        RETURN.

    run validateFields.

    /* Se ocorreu algum erro e o ponto de controle nÆo existia (foi criado acima), deleta este ponto */
    IF CAN-FIND(FIRST tt-bo-erro WHERE tt-bo-erro.errorsubtype <> "WARNING":U) AND l-criou-pto THEN DO:
        RUN pi-deleta-pto-contr IN THIS-PROCEDURE (INPUT RowObject.cod-pto-contr).
        RETURN.
    END.

    FIND FIRST tt-bo-erro
         WHERE tt-bo-erro.errorsubtype <> "WARNING":U NO-LOCK NO-ERROR.

    if not avail tt-bo-erro then do:

        find historico-embarque 
            where rowid(historico-embarque) = r-chave exclusive-lock no-wait no-error.
        if locked(historico-embarque) then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg":U,
                               input 16096,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 16096
                   tt-bo-erro.mensagem = return-value.
            return.
        end.  
        
        run pi-atualiza-despesas in this-procedure.
        run pi-atualiza-declaracoes in this-procedure.
        run pi-atualiza-embarque in this-procedure.

        assign dt-previsao-old     = historico-embarque.dt-previsao
               dt-ult-prev-old     = historico-embarque.dt-ult-previsao
               dt-efetiva-old      = historico-embarque.dt-efetiva
               dt-efetiva-old-orig = historico-embarque.dt-efetiva.
               
        if dt-efetiva-old = ? then
            assign dt-efetiva-old = dt-ult-prev-old.

        find first historico-embarque 
             where rowid(historico-embarque) = r-chave exclusive-lock no-wait no-error.
        
        run executeUpdate.
        assign r-aux = rowid(historico-embarque).

        /*--- Chamada UPC ---*/
        FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
            DELETE tt-epc.
        END.
        
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AlteraSeq":U
               tt-epc.cod-parameter = "r-historico-embarque":U
               tt-epc.val-parameter = STRING(r-aux).

        /* Include i-epc201.i: Chamada do programa de EPC */
        {include/i-epc201.i '"AlteraSeq"'}

        FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
            DELETE tt-epc.
        END.
        /*--- Fim chamada UPC ---*/

        /*
        ** Se estiver parametrizado para recalcular dt ultima previsÆo 
        */       

        IF l-recalcula THEN DO:
            RUN pi-recalcula-dt-ult-prev IN THIS-PROCEDURE.
        end.

        /* 
        ** Verifica se o ponto ‚ o ponto de embarque 
        */
        IF rowObject.cod-pto-contr = embarque-imp.cdn-pto-embarq THEN
            ASSIGN l-pto-embarque = YES.

        /*
        ** Verifica se ‚ o £ltimo ponto do acompanhamento
        */
        IF NOT CAN-FIND(FIRST b-historico-embarque 
                            WHERE b-historico-embarque.cod-estabel = rowObject.cod-estabel 
                              AND b-historico-embarque.embarque    = rowObject.embarque    
                              AND b-historico-embarque.cod-itiner  = rowObject.cod-itiner  
                              AND b-historico-embarque.sequencia   > rowObject.sequencia) THEN
            ASSIGN l-ult-ponto = YES.

        /*
        ** Verifica se a data foi alterada e se ‚ diferente da previsÆo
        */ 
        IF dt-efetiva-old-orig <> rowObject.dt-efetiva THEN
            ASSIGN l-previsao-alt = YES.

        
        &IF "{&ems_dbtype}" <> "progress":U &THEN 
            RELEASE historico-embarque.
            FIND FIRST historico-embarque
                 WHERE historico-embarque.cod-estabel = rowObject.cod-estabel
                   AND historico-embarque.embarque    = rowobject.embarque
                   AND historico-embarque.cod-itiner  = rowobject.cod-itiner
                   AND historico-embarque.sequencia   = rowobject.sequencia NO-LOCK NO-ERROR.
        &endif
        /*
        ** Atualiza situa‡Æo do processo/embarque e datas de entrega
        */        
        RUN atualizaStatus.

        /*--- Chamada UPC ---*/
        FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
            DELETE tt-epc.
        END.
        
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AlteraSeq":U
               tt-epc.cod-parameter = "cod-estabel":U
               tt-epc.val-parameter = string(rowObject.cod-estabel).
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AlteraSeq":U
               tt-epc.cod-parameter = "embarque":U
               tt-epc.val-parameter = string(rowObject.embarque).
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AlteraSeq":U
               tt-epc.cod-parameter = "cod-itiner":U
               tt-epc.val-parameter = string(rowObject.cod-itiner).
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AlteraSeq":U
               tt-epc.cod-parameter = "sequencia":U
               tt-epc.val-parameter = string(rowObject.sequencia).

        /* Include i-epc201.i: Chamada do programa de EPC */
        {include/i-epc201.i '"AlteraSeq"'}

        FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
            DELETE tt-epc.
        END.
        /*--- Fim chamada UPC ---*/

        RUN GravaIdTransporte.
    END.

end procedure.

procedure validateUpdateAcomp:
    /*
    **  Valida Update para o acompanhamento do processo (im0055) pois precisa receber uma temp-table com todos os pontos
        e nÆo somente o registros a ser alterado.
    */
    def input parameter table for rowObject.
    def input parameter r-chave as rowid no-undo.
    def output parameter table for tt-bo-erro.
        
    def var dt-previsao-old as date no-undo.
    def var dt-ult-prev-old as date no-undo.
    def var dt-efetiva-old  as date no-undo.
    DEF VAR dt-efetiva-old-orig AS DATE NO-UNDO.

    DEFINE VARIABLE i-seq-despacho        LIKE pto-itiner.sequencia     NO-UNDO.
    DEFINE VARIABLE i-seq-embarque        LIKE pto-itiner.sequencia     NO-UNDO.
    DEFINE VARIABLE i-seq-desembarque     LIKE pto-itiner.sequencia     NO-UNDO.
    DEFINE VARIABLE i-seq-chegada         LIKE pto-itiner.sequencia     NO-UNDO.
    DEFINE VARIABLE i-seq-recebimento     LIKE pto-itiner.sequencia     NO-UNDO.
    DEFINE VARIABLE l-sequencia-invalida  AS LOGICAL                    NO-UNDO.
    DEFINE VARIABLE c-pto-invalido        AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE i-seq-invalida        AS INTEGER                    NO-UNDO.
    DEFINE VARIABLE l-possui-di           AS LOGICAL                    NO-UNDO.
    DEFINE VARIABLE i-seq-nac             AS INTEGER                    NO-UNDO.
    DEFINE VARIABLE l-manter-ordem-itiner AS LOGICAL                    NO-UNDO.
    DEFINE VARIABLE c-param1              AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-param2              AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-param3              AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-mensagem            AS CHARACTER                  NO-UNDO.

    def var dt-pto-ant       as date    no-undo.
    def var i-intervalo-adic as integer no-undo.    
    
    assign c-opcao = "Update":U.

    ASSIGN l-pto-embarque = NO
           l-ult-ponto    = NO
           l-previsao-alt = NO
           i-seq-erro     = 0.

    FOR FIRST bf-usuar-import
        WHERE bf-usuar-import.cod-usuar = c-seg-usuario NO-LOCK:
        /*Se marcado, valida Data Efetiva Ponto de Controle NÆo Obrigat¢rio*/
        ASSIGN l-manter-ordem-itiner = bf-usuar-import.log-livre-1. 
    END.

    run initializeValidate.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    BLOCK_update:
    DO TRANS ON ERROR UNDO,LEAVE :
    
        /*
        *** Se o embarque estiver vinculado a DI verifica se existe alguma sequˆncia alterada para ap¢s o ponto de nacionaliza‡Æo 
        */
        IF NOT VALID-HANDLE(h-bocx407) THEN
            RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.
        
        FOR FIRST RowObject:
            RUN pi-valida-integracao-di IN h-bocx407 (INPUT RowObject.embarque,
                                                      INPUT RowObject.cod-estabel,
                                                      OUTPUT l-possui-di).
            IF l-possui-di THEN DO:
                RUN retorna-seq-ponto-nacionaliz IN h-bocx407(INPUT RowObject.embarque,    
                                                              INPUT RowObject.cod-estabel, 
                                                              OUTPUT i-seq-nac).
            END.
        END.

        FOR FIRST embarque-imp FIELDS(cdn-pto-desembar)
            WHERE embarque-imp.embarque    = RowObject.embarque
              AND embarque-imp.cod-estabel = RowObject.cod-estabel NO-LOCK:
        END.

        IF l-possui-di THEN DO:
            FOR EACH RowObject,
                FIRST historico-embarque FIELDS(sequencia) NO-LOCK
                WHERE ROWID(historico-embarque) = RowObject.r-rowid:

                /* Se modificou sequˆncia para ap¢s o ponto de nacionaliza‡Æo */
                IF  RowObject.sequencia >= i-seq-nac 
                AND RowObject.sequencia <> historico-embarque.sequencia 
                AND historico-embarque.sequencia < i-seq-nac THEN DO:
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 54830,
                                       INPUT RowObject.sequencia).
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen     = 1
                           tt-bo-erro.cd-erro      = 54830
                           tt-bo-erro.mensagem     = RETURN-VALUE.
                    RUN utp/ut-msgs.p (INPUT "HELP":U,
                                       INPUT 54830,
                                       INPUT "").
                    ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
                    UNDO BLOCK_update, RETURN "NOK":U.
                END.
                /* Se modificou sequˆncia ap¢s nacionaliza‡Æo */
                ELSE 
                    IF  historico-embarque.sequencia >= i-seq-nac 
                    AND RowObject.sequencia <> historico-embarque.sequencia THEN DO:

                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 54833,
                                       INPUT "":U).
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen     = 1
                           tt-bo-erro.cd-erro      = 54833
                           tt-bo-erro.mensagem     = RETURN-VALUE.
                    RUN utp/ut-msgs.p (INPUT "HELP":U,
                                       INPUT 54833,
                                       INPUT "(" + STRING(embarque-imp.cdn-pto-desembar) + ")").
                    ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
                    UNDO BLOCK_update, RETURN "NOK":U.
                END.
            END.
        END.

        IF VALID-HANDLE(h-bocx407) THEN DO:
            DELETE PROCEDURE h-bocx407.
            ASSIGN h-bocx407 = ?.
        END.
        /****/

        /* Repassa as despesas/decalra‡äes de um pto/sequˆncia para o novo pto/sequˆncia e excluir o registro (ser  recriado abaixo) */
        FOR EACH RowObject:
            /*
            ** Se estiver parametrizado para gerar historico do processo s¢ modifica ap¢s efetivar ponto de embarque
            */              
			find param-imp 
				where param-imp.cod-estabel = historico-embarque.cod-estabel no-lock no-error.
			if avail param-imp and param-imp.hist-processo then do:
				FOR FIRST historico-embarque FIELDS (sequencia) where 
						  historico-embarque.cod-estabel   = rowObject.cod-estabel and
						  historico-embarque.embarque      = rowObject.embarque    and 
						  historico-embarque.cod-itiner    = rowObject.cod-itiner  and
						  historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq    NO-LOCK:
				END.
				FOR FIRST b-historico-embarque NO-LOCK
					WHERE ROWID(b-historico-embarque) = RowObject.r-rowid: END.
				if  avail historico-embarque 
                AND AVAIL b-historico-embarque then do:
					IF  b-historico-embarque.sequencia <>  rowObject.sequencia 
                    AND rowObject.sequencia <= historico-embarque.sequencia THEN DO:
						assign i-seq-erro = i-seq-erro + 1.
						/* Pto Contr nÆo pode ser alterado  */
						run utp/ut-msgs.p (input "msg":U,
										   input 17470,
										   input "").
						create tt-bo-erro.
						assign tt-bo-erro.i-sequen     = i-seq-erro
							   tt-bo-erro.cd-erro      = 17470
							   tt-bo-erro.mensagem     = return-value.
					   UNDO BLOCK_update, RETURN "NOK":U.
					end. 
				end.
			end.

            FIND FIRST {&table-name} NO-LOCK
                WHERE ROWID({&table-name}) = RowObject.r-rowid NO-ERROR.
            IF AVAIL {&table-name} THEN DO:
                /* Alterou a sequˆncia -> Verifica se possui declara‡Æo emitida */
                IF {&table-name}.sequencia <> RowObject.sequencia THEN DO:
                    RUN pi-verifica-decl-emitida IN THIS-PROCEDURE (INPUT {&table-name}.cod-estabel, 
                                                                    INPUT {&table-name}.embarque,       
                                                                    INPUT {&table-name}.cod-itiner,   
                                                                    INPUT {&table-name}.sequencia,     
                                                                    OUTPUT l-possui-decl-emitida).
                    IF l-possui-decl-emitida THEN DO:
						run utp/ut-msgs.p (input "msg":U,
										   input 54840,
										   input STRING({&table-name}.cod-pto-contr)).
						create tt-bo-erro.
						assign tt-bo-erro.i-sequen     = i-seq-erro
							   tt-bo-erro.cd-erro      = 54840
							   tt-bo-erro.mensagem     = return-value.
                        run utp/ut-msgs.p (input "HELP":U,
										   input 54840,
										   input STRING({&table-name}.cod-pto-contr)).
                        ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
                        UNDO BLOCK_update, RETURN "NOK":U.
                    END.
                END.

                run pi-atualiza-despesas in this-procedure.   
                run pi-atualiza-declaracoes in this-procedure.
                FIND CURRENT {&table-name} EXCLUSIVE-LOCK NO-ERROR.
                DELETE {&table-name}.
            END.
		END.

        FOR EACH rowObject:

            find itinerario
                where itinerario.cod-itiner = rowObject.cod-itiner no-lock no-error.
    
            FIND FIRST embarque-imp
                 WHERE embarque-imp.embarque = RowObject.embarque
                   AND embarque-imp.cod-estabel = RowObject.cod-estabel NO-LOCK NO-ERROR.
        
            ASSIGN r-chave = rowObject.r-rowid.
        
            if rowObject.sequencia = ? or rowObject.sequencia = 0 then do:
                assign i-seq-erro = i-seq-erro + 1.
                /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
                   pre-processador em chamada de includes */
                {utp/ut-field.i mgcex historico-embarque sequencia 1}
                /******************************************/
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.        
                run utp/ut-msgs.p (input "msg":u,
                                   input 265,
                                   input return-value).
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 265
                       tt-bo-erro.mensagem     = return-value.
            end.
        
            /*run validateFields. */ /* Ao alterar as sequˆncias dos pontos do itinerario no im0055.w esta procedure nÆo deve ser executada. */
            
            /* Valida a  sequˆncia dos pontos de controle obrigat¢rios */
            for first bf-RowObject fields(sequencia)
                where bf-RowObject.cod-pto-contr = embarque-imp.cdn-pto-despch no-lock:
                assign i-seq-despacho = bf-RowObject.sequencia.  
            end.                                             
        
            for first bf-RowObject fields(sequencia)
                where bf-RowObject.cod-pto-contr = embarque-imp.cdn-pto-embarq no-lock:
                assign i-seq-embarque = bf-RowObject.sequencia.  
            end.
        
            for first bf-RowObject fields(sequencia)
                where bf-RowObject.cod-pto-contr = embarque-imp.cdn-pto-desembar no-lock:
                assign i-seq-desembarque = bf-RowObject.sequencia.  
            end.
            
            for first bf-RowObject fields(sequencia)
                where bf-RowObject.cod-pto-contr = embarque-imp.cdn-pto-chegad no-lock:
                assign i-seq-chegada = bf-RowObject.sequencia.  
            end.

            for first bf-RowObject fields(sequencia)
                where bf-RowObject.cod-pto-contr = INT(TRIM(SUBSTRING(embarque-imp.char-1,86,5))) no-lock:
                assign i-seq-recebimento = bf-RowObject.sequencia.  
            end.
        
            ASSIGN l-sequencia-invalida = NO
                   c-pto-invalido       = "":U.
    
            /* Caso o ponto alterado seja algum dos pontos obrigat¢rios */
            CASE RowObject.cod-pto-contr:
                WHEN embarque-imp.cdn-pto-despch THEN DO:
                    IF ((RowObject.sequencia > i-seq-embarque) AND i-seq-embarque <> 0) OR 
                       ((RowObject.sequencia > i-seq-desembarque) AND i-seq-desembarque <> 0) OR 
                       ((RowObject.sequencia > i-seq-chegada) AND i-seq-chegada <> 0) THEN DO:
                        {utp/ut-field.i mgcex embarque-imp cdn-pto-despch 1}
                        ASSIGN l-sequencia-invalida = YES
                               c-pto-invalido = RETURN-VALUE
                               i-seq-invalida = RowObject.sequencia.
                    END.
                END.
                WHEN embarque-imp.cdn-pto-embarq THEN DO:
                    IF ((RowObject.sequencia < i-seq-despacho) AND i-seq-despacho <> 0) OR 
                       ((RowObject.sequencia > i-seq-desembarque) AND i-seq-desembarque <> 0) OR 
                       ((RowObject.sequencia > i-seq-chegada)  AND i-seq-chegada  <> 0) THEN DO:
                        {utp/ut-field.i mgcex embarque-imp cdn-pto-embarq 1}
                        ASSIGN l-sequencia-invalida = YES
                               c-pto-invalido = RETURN-VALUE
                               i-seq-invalida = RowObject.sequencia.
                    END.
                END.
                WHEN embarque-imp.cdn-pto-desembar THEN DO:
                    IF ((RowObject.sequencia < i-seq-despacho) AND i-seq-despacho <> 0) OR 
                       ((RowObject.sequencia < i-seq-embarque) AND i-seq-embarque <> 0) OR 
                       ((RowObject.sequencia > i-seq-chegada)  AND i-seq-chegada  <> 0) THEN DO:
                        {utp/ut-field.i mgcex embarque-imp cdn-pto-desembar 1}
                        ASSIGN l-sequencia-invalida = YES
                               c-pto-invalido = RETURN-VALUE
                               i-seq-invalida = RowObject.sequencia.
                    END.
                END.
                WHEN embarque-imp.cdn-pto-chegad THEN DO:
                    IF ((RowObject.sequencia < i-seq-despacho) AND i-seq-despacho <> 0) OR 
                       ((RowObject.sequencia < i-seq-embarque) AND i-seq-embarque <> 0) OR 
                       ((RowObject.sequencia < i-seq-desembarque)  AND i-seq-desembarque  <> 0) OR
                       ((RowObject.sequencia < i-seq-recebimento)  AND i-seq-recebimento  <> 0) THEN DO:
                        {utp/ut-field.i mgcex embarque-imp cdn-pto-chegad 1}
                        ASSIGN l-sequencia-invalida = YES
                               c-pto-invalido = RETURN-VALUE
                               i-seq-invalida = RowObject.sequencia.
                    END.
                END.
            END CASE.

            /*manuela*/
            IF  NOT l-sequencia-invalida 
            AND l-manter-ordem-itiner THEN DO:
                IF RowObject.dt-efetiva <> ? THEN DO:

                    FOR LAST historico-embarque NO-LOCK
                       WHERE historico-embarque.cod-estabel   = RowObject.cod-estabel
                         AND historico-embarque.embarque      = RowObject.embarque
                         AND historico-embarque.cod-itiner    = RowObject.cod-itiner
                         AND historico-embarque.sequencia     < RowObject.sequencia:

                        IF historico-embarque.dt-efetiva <> ? THEN DO:
                            IF historico-embarque.dt-efetiva > RowObject.dt-efetiva THEN DO:
                                assign i-seq-erro = i-seq-erro + 1.
                                {utp/ut-field.i mgcex historico-embarque dt-efetiva 1}
                                ASSIGN c-param1 = TRIM(RETURN-VALUE).
                                {utp/ut-liter.i _maior_ * r}
                                ASSIGN c-param2 = TRIM(RETURN-VALUE).
                                {utp/ut-liter.i _seguinte * r}
                                ASSIGN c-param3 = TRIM(RETURN-VALUE).
        
                                /* Data Efetiva ‚ maior que a do Pto Contr seguinte */
                                run utp/ut-msgs.p (input "msg":U,
                                                   input 55217,
                                                   input c-param1 + "~~" + c-param2  + "~~" + c-param3 + "~~").
        
                                ASSIGN c-mensagem = TRIM(RETURN-VALUE).
        
                                run utp/ut-msgs.p (input "help":U,
                                                   input 55217,
                                                   input c-param1 + "~~" + c-param2  + "~~" + c-param3 + "~~" +
                                                         string(historico-embarque.cod-pto-contr)    + " - " + historico-embarque.descricao + "~~" + 
                                                         string(RowObject.cod-pto-contr) + " - " + RowObject.descricao).
                                create tt-bo-erro.
                                assign tt-bo-erro.i-sequen     = i-seq-erro
                                       tt-bo-erro.cd-erro      = 55217
                                       tt-bo-erro.mensagem     = c-mensagem
                                       tt-bo-erro.errorhelp    = RETURN-VALUE.
                            END.
                        END.


                        IF historico-embarque.dt-efetiva = ? THEN DO:
                            ASSIGN i-seq-invalida = historico-embarque.sequencia.
                            assign i-seq-erro = i-seq-erro + 1.
                            run utp/ut-msgs.p (input "msg",
                                               input 2108,
                                               input STRING(i-seq-invalida)).
                            create tt-bo-erro.
                            assign tt-bo-erro.i-sequen     = i-seq-erro
                                   tt-bo-erro.cd-erro      = 2108
                                   tt-bo-erro.mensagem     = return-value.

                            IF historico-embarque.dt-ult-previsao > rowObject.dt-previsao THEN DO:
                                assign i-seq-erro = i-seq-erro + 1.
                                {cxbo/bocx230a.i1 historico-embarque dt-previsao}
                                
                                /* Data Efetiva ² menor que a do ponto anterior */
                                run utp/ut-msgs.p (input "msg":U,
                                                   input 55206, /* 17337 */
                                                   input c-desc-campo-validado + "~~" + c-desc-pto-atual + "~~" + c-desc-pto-anterior).
                                 create tt-bo-erro.
                                 assign tt-bo-erro.i-sequen     = i-seq-erro
                                        tt-bo-erro.cd-erro      = 55206
                                        tt-bo-erro.mensagem     = return-value.
                                 create tt-campo-erro.
                                 assign tt-campo-erro.campo = "dt-efetiva":U.
                            END.
                        END.
                    END.
                END.
            END.

            IF l-sequencia-invalida AND NOT CAN-FIND(FIRST tt-bo-erro
                                                     WHERE tt-bo-erro.cd-erro = 2108) THEN DO:
                assign i-seq-erro = i-seq-erro + 1.
                /* NAO ALTERAR - Distribuicao Magnus nao reconhece pre-processador em chamada de includes */
                {utp/ut-field.i mgcex itinerario c-pto-invalido 1}
                /******************************************/
                run utp/ut-msgs.p (input "msg",
                                   input 2108,
                                   input STRING(i-seq-invalida)).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 2108
                       tt-bo-erro.mensagem     = return-value.
            END.

            IF CAN-FIND(FIRST tt-bo-erro 
                        WHERE tt-bo-erro.errorsubtype <> "WARNING":U)  THEN 
                UNDO BLOCK_update, LEAVE BLOCK_update.
            ELSE DO:
        
                assign dt-previsao-old     = RowObject.dt-previsao
                       dt-ult-prev-old     = RowObject.dt-ult-previsao
                       dt-efetiva-old      = RowObject.dt-efetiva
                       dt-efetiva-old-orig = RowObject.dt-efetiva.
                       
                if dt-efetiva-old = ? then
                    assign dt-efetiva-old = dt-ult-prev-old.
        
                RUN executecreate.
        
                assign r-aux = rowid(historico-embarque).
        
                /*--- Chamada UPC ---*/
                FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
                    DELETE tt-epc.
                END.
                
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "AlteraSeq":U
                       tt-epc.cod-parameter = "r-historico-embarque":U
                       tt-epc.val-parameter = STRING(r-aux).
        
                /* Include i-epc201.i: Chamada do programa de EPC */
                {include/i-epc201.i '"AlteraSeq"'}
        
                FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
                    DELETE tt-epc.
                END.
                /*--- Fim chamada UPC ---*/

                /* 
                ** Verifica se o ponto ‚ o ponto de embarque 
                */
                IF rowObject.cod-pto-contr = embarque-imp.cdn-pto-embarq THEN
                    ASSIGN l-pto-embarque = YES.

                /*
                ** Verifica se a data foi alterada e se ‚ diferente da previsÆo
                */ 
                IF dt-efetiva-old-orig <> rowObject.dt-efetiva THEN
                    ASSIGN l-previsao-alt = YES.
        
                
                &IF "{&ems_dbtype}" <> "progress":U &THEN 
                    RELEASE historico-embarque.
                    FIND FIRST historico-embarque
                         WHERE historico-embarque.cod-estabel = rowObject.cod-estabel
                           AND historico-embarque.embarque    = rowobject.embarque
                           AND historico-embarque.cod-itiner  = rowobject.cod-itiner
                           AND historico-embarque.sequencia   = rowobject.sequencia NO-LOCK NO-ERROR.
                &endif
        
                /*--- Chamada UPC ---*/
                FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
                    DELETE tt-epc.
                END.
                
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "AlteraSeq":U
                       tt-epc.cod-parameter = "cod-estabel":U
                       tt-epc.val-parameter = string(rowObject.cod-estabel).
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "AlteraSeq":U
                       tt-epc.cod-parameter = "embarque":U
                       tt-epc.val-parameter = string(rowObject.embarque).
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "AlteraSeq":U
                       tt-epc.cod-parameter = "cod-itiner":U
                       tt-epc.val-parameter = string(rowObject.cod-itiner).
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "AlteraSeq":U
                       tt-epc.cod-parameter = "sequencia":U
                       tt-epc.val-parameter = string(rowObject.sequencia).
        
                /* Include i-epc201.i: Chamada do programa de EPC */
                {include/i-epc201.i '"AlteraSeq"'}
        
                FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
                    DELETE tt-epc.
                END.
                /*--- Fim chamada UPC ---*/
        
                RUN GravaIdTransporte.
            END.
        END.
		
        /*
        ** Atualiza situa‡Æo do processo/embarque e datas de entrega
        */        
        FOR LAST RowObject BY RowObject.sequencia:
            ASSIGN l-ult-ponto = YES.
            RUN atualizaStatus.
        END.

        /*
        ** Se estiver parametrizado para recalcular dt ultima previsÆo 
        */
        FOR FIRST RowObject BY RowObject.sequencia: /* Posiciona na primeira sequˆncia para recalcular */
            IF l-recalcula THEN DO:
                RUN pi-recalcula-dt-ult-prev IN THIS-PROCEDURE.
            end.
        END.
    END.

    RETURN "OK":U.
end procedure.

PROCEDURE validateFields:
    DEFINE BUFFER b-historico-embarque FOR historico-embarque.

    DEFINE VARIABLE l-obrigatorio-n-efetivado       AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-manter-ordem-itiner AS LOGICAL     NO-UNDO.

    empty temp-table tt-campo-erro.

    FOR FIRST bf-usuar-import
        WHERE bf-usuar-import.cod-usuar = c-seg-usuario NO-LOCK:
        /*Se marcado, valida Data Efetiva Ponto de Controle NÆo Obrigat¢rio*/
        ASSIGN l-manter-ordem-itiner = bf-usuar-import.log-livre-1. 
    END.

    /*--- Chamada UPC ---*/
    IF rowObject.dt-efetiva <> ? then do:
        FOR EACH tt-epc WHERE tt-epc.cod-event = "ValidaDtEfetiva".
            DELETE tt-epc.
        END.
        
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "ValidaDtEfetiva":U
               tt-epc.cod-parameter = "cod-estabel":U
               tt-epc.val-parameter = rowObject.cod-estabel.

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "ValidaDtEfetiva":U
               tt-epc.cod-parameter = "embarque":U
               tt-epc.val-parameter = rowObject.embarque.

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "ValidaDtEfetiva":U
               tt-epc.cod-parameter = "cod-itiner":U
               tt-epc.val-parameter = STRING(rowObject.cod-itiner).

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "ValidaDtEfetiva":U
               tt-epc.cod-parameter = "sequencia":U
               tt-epc.val-parameter = STRING(rowObject.sequencia).

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "ValidaDtEfetiva":U
               tt-epc.cod-parameter = "dt-efetiva":U
               tt-epc.val-parameter = STRING(rowObject.dt-efetiva).

        /* Include i-epc201.i: Chamada do programa de EPC */
        {include/i-epc201.i '"ValidaDtEfetiva"'}
        
       /*--- Fim chamada UPC ---*/
    END.

    /*Se retornar "YES", nÆo executar a valida‡Æo*/
    IF CAN-FIND(FIRST tt-epc 
                 WHERE tt-epc.cod-event     = "ValidaDtEfetiva":U 
                   AND tt-epc.cod-parameter = "c-valida":U
                   AND tt-epc.val-parameter = "YES") THEN DO:

        IF RETURN-VALUE = "NOK":U THEN DO:

            FIND FIRST tt-epc NO-LOCK
                WHERE tt-epc.cod-event     = "ValidaDtEfetiva":U 
                  AND tt-epc.cod-parameter = "i-erro":U NO-ERROR.
                  
            IF AVAIL tt-epc THEN DO:

                ASSIGN i-seq-erro = i-seq-erro + 1.
                IF tt-epc.val-parameter = "17335" THEN DO:
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 17335,
                                       INPUT "").
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 17335
                           tt-bo-erro.mensagem     = RETURN-VALUE.
                END.
                ELSE IF tt-epc.val-parameter = "17337" THEN DO:
                    {utp/ut-field.i mgcex historico-embarque dt-efetiva 1}
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 17337,
                                       INPUT RETURN-VALUE).
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 17337
                           tt-bo-erro.mensagem     = RETURN-VALUE.

                END.

            END.
            FOR EACH tt-epc WHERE tt-epc.cod-event = "ValidaDtEfetiva".
                DELETE tt-epc.
            END.
            RETURN "NOK":U.
        END.
        ELSE DO:
            FOR EACH tt-epc WHERE tt-epc.cod-event = "ValidaDtEfetiva".
                DELETE tt-epc.
            END.
            RETURN "OK":U.
        END.
    END.
    ELSE DO:
        FIND FIRST param-global NO-LOCK NO-ERROR.
        
        for first embarque-imp NO-LOCK
            WHERE embarque-imp.cod-estabel = RowObject.cod-estabel
              AND embarque-imp.embarque = RowObject.embarque:
        END.
        /*
        ** Valida‡Æo dos campos
        */
        def var c-return as char no-undo.

        if rowObject.cod-pto-contr = 0 then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex historico-embarque cod-pto-contr 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input 265,
                               input tt-bo-erro.parametros).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
            create tt-campo-erro.
            assign tt-campo-erro.campo = "cod-pto-contr":U.
        end.
        else if not can-find(pto-contr where pto-contr.cod-pto-contr = rowObject.cod-pto-contr) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex pto-contr 1}
            create tt-bo-erro.             
            assign tt-bo-erro.parametros = trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input tt-bo-erro.parametros + "~~" + string(rowObject.cod-pto-contr)).
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
            create tt-campo-erro.
            assign tt-campo-erro.campo = "cod-pto-contr":U.
        end.

        IF CAN-FIND(FIRST historico-embarque WHERE historico-embarque.cod-pto-contr = rowObject.cod-pto-contr) 
                                               AND (rowObject.descricao = ? or trim(rowObject.descricao) = "":U) then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
               pre-processador em chamada de includes */
            {utp/ut-field.i mgcex historico-proc-exp descricao 1}
            /******************************************/
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.        
            run utp/ut-msgs.p (input "msg":u,
                               input 265,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
            create tt-campo-erro.
            assign tt-campo-erro.campo = "descricao":U.
        end.

        /* Ponto possui declara‡Æo emitida -> nÆo pode ser alterado */
        FOR FIRST {&table-name}
            WHERE ROWID({&table-name}) = RowObject.r-rowid:
            IF {&table-name}.cod-pto-contr <> RowObject.cod-pto-contr 
            OR {&table-name}.sequencia     <> RowObject.sequencia  THEN DO:
                RUN pi-verifica-decl-emitida IN THIS-PROCEDURE (INPUT RowObject.cod-estabel, 
                                                                INPUT RowObject.embarque,       
                                                                INPUT RowObject.cod-itiner,   
                                                                INPUT RowObject.sequencia,     
                                                                OUTPUT l-possui-decl-emitida).
                IF l-possui-decl-emitida THEN DO:
                    run utp/ut-msgs.p (input "msg":U,
                                       input 54840,
                                       input STRING({&table-name}.cod-pto-contr)).
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 54840
                           tt-bo-erro.mensagem     = return-value.
                    run utp/ut-msgs.p (input "HELP":U,
                                       input 54840,
                                       input STRING({&table-name}.cod-pto-contr)).
                    ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.
                    create tt-campo-erro.
                    assign tt-campo-erro.campo = "cod-pto-contr":U.
                END.
            END.
        END.
    
        IF NOT l-manter-ordem-itiner THEN DO:
            IF rowObject.dt-efetiva <> ? AND 
                      (rowObject.cod-pto-contr = embarque-imp.cdn-pto-despch OR
                       rowObject.cod-pto-contr = embarque-imp.cdn-pto-embarq OR
                       rowObject.cod-pto-contr = embarque-imp.cdn-pto-desembar OR
                       rowObject.cod-pto-contr = embarque-imp.cdn-pto-chegad) THEN DO:
                
                ASSIGN l-obrigatorio-n-efetivado = NO.
    
                /* Verifica efetiva»’o dos pontos obrigat½rios anteriores */
                FOR EACH historico-embarque fields(dt-efetiva cod-pto-contr) where 
                         historico-embarque.cod-estabel = rowObject.cod-estabel and
                         historico-embarque.embarque    = rowObject.embarque    and
                         historico-embarque.cod-itiner  = rowObject.cod-itiner  and
                         historico-embarque.sequencia   < rowObject.sequencia   and
                        (historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch OR
                         historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq OR
                         historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar OR
                         historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad) no-lock:
                    IF historico-embarque.dt-efetiva = ? THEN
                        ASSIGN l-obrigatorio-n-efetivado = YES.
                end.
        
                if l-obrigatorio-n-efetivado then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    /* Pto Contr n’o pode ser efetivado */
                    run utp/ut-msgs.p (input "msg":U,
                                       input 17335,
                                       input "").
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 17335
                           tt-bo-erro.mensagem     = return-value.
                end.
            END.

        
            for last historico-embarque fields(dt-efetiva dt-previsao dt-ult-previsao cod-pto-contr) where 
                     historico-embarque.cod-estabel = rowObject.cod-estabel and
                     historico-embarque.embarque    = rowObject.embarque    and
                     historico-embarque.cod-itiner  = rowObject.cod-itiner  and
                     historico-embarque.sequencia   < rowObject.sequencia and
                        (historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch OR
                         historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq OR
                         historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar OR
                         historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad) no-lock:
            end.
        END.
        ELSE DO:
            for last historico-embarque fields(dt-efetiva dt-previsao dt-ult-previsao cod-pto-contr) where 
                     historico-embarque.cod-estabel = rowObject.cod-estabel and
                     historico-embarque.embarque    = rowObject.embarque    and
                     historico-embarque.cod-itiner  = rowObject.cod-itiner  and
                     historico-embarque.sequencia   < rowObject.sequencia NO-LOCK:
            END.
        END.

        if avail historico-embarque then do:
            if rowObject.dt-efetiva <> ? then do:
                IF l-manter-ordem-itiner THEN DO:
                    IF historico-embarque.dt-efetiva = ? THEN DO:
                        ASSIGN i-seq-erro = i-seq-erro + 1.
                        /* Pto Contr nÆo pode ser efetivado */
                        RUN utp/ut-msgs.p (INPUT "msg":U,
                                           INPUT 17335,
                                           INPUT "").
                        CREATE tt-bo-erro.
                        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                               tt-bo-erro.cd-erro  = 17335
                               tt-bo-erro.mensagem = RETURN-VALUE.
                    END.
                    if historico-embarque.dt-efetiva > rowObject.dt-efetiva then do:
    
                        assign i-seq-erro = i-seq-erro + 1.
                        {utp/ut-field.i mgcex historico-embarque dt-efetiva 1}
                        /* Data Efetiva ² menor que a do ponto anterior */
                        run utp/ut-msgs.p (input "msg":U,
                                           input 17337,
                                           input RETURN-VALUE).
                         create tt-bo-erro.
                         assign tt-bo-erro.i-sequen     = i-seq-erro
                                tt-bo-erro.cd-erro      = 17337
                                tt-bo-erro.mensagem     = return-value.
                    end.
                END.
                ELSE DO:
                    if historico-embarque.dt-efetiva > rowObject.dt-efetiva and
                       (rowObject.cod-pto-contr = embarque-imp.cdn-pto-despch OR
                        rowObject.cod-pto-contr = embarque-imp.cdn-pto-embarq OR
                        rowObject.cod-pto-contr = embarque-imp.cdn-pto-desembar OR
                        rowObject.cod-pto-contr = embarque-imp.cdn-pto-chegad) then do:
    
                        assign i-seq-erro = i-seq-erro + 1.
                        {cxbo/bocx230a.i1 historico-embarque dt-efetiva}
                        
                        /* Data Efetiva ² menor que a do ponto anterior */
                        run utp/ut-msgs.p (input "msg":U,
                                           input 55206, /* 17337 */
                                           input c-desc-campo-validado + "~~" + c-desc-pto-atual + "~~" + c-desc-pto-anterior).
                         create tt-bo-erro.
                         assign tt-bo-erro.i-sequen     = i-seq-erro
                                tt-bo-erro.cd-erro      = 55206
                                tt-bo-erro.mensagem     = return-value.
                        create tt-campo-erro.
                        assign tt-campo-erro.campo = "dt-efetiva":U.
                    end.
                END.
            end.
            else do:
                if historico-embarque.dt-previsao = ? then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    /* Pto Contr n’o pode ser efetivado */
                    run utp/ut-msgs.p (input "msg":U,
                                       input 17335,
                                       input "").
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 17335
                           tt-bo-erro.mensagem     = return-value.
                    create tt-campo-erro.
                    assign tt-campo-erro.campo = "dt-previsao":U.
                end.
                if c-opcao = "Create":U then do:
                    if historico-embarque.dt-efetiva = ? then do:
                        if historico-embarque.dt-ult-previsao > rowObject.dt-previsao then do:
                            
                            assign i-seq-erro = i-seq-erro + 1.
                            {utp/ut-field.i mgcex historico-embarque dt-previsao 1}
                            /* Data Efetiva ‚ menor que a do ponto anterior */
                            run utp/ut-msgs.p (input "msg":U,
                                               input 17337,
                                               input return-value).
                             create tt-bo-erro.
                             assign tt-bo-erro.i-sequen     = i-seq-erro
                                    tt-bo-erro.cd-erro      = 17337
                                    tt-bo-erro.mensagem     = return-value.
                        end.
                    end.                
                    else
                    if historico-embarque.dt-efetiva > rowObject.dt-previsao then do:
                        assign i-seq-erro = i-seq-erro + 1.
                        {utp/ut-field.i mgcex historico-embarque dt-previsao 1}
                        /* Data Efetiva ‚ menor que a do ponto anterior */
                        run utp/ut-msgs.p (input "msg":U,
                                           input 17337,
                                           input return-value).
                         create tt-bo-erro.
                         assign tt-bo-erro.i-sequen     = i-seq-erro
                                tt-bo-erro.cd-erro      = 17337
                                tt-bo-erro.mensagem     = return-value.
                    end.
                end.
            end.
        end.
        ELSE DO:
            for first ordens-embarque FIELDS (nr-proc-imp cod-estabel)
                where ordens-embarque.cod-estabel = rowObject.cod-estabel
                  and ordens-embarque.embarque    = rowObject.embarque no-lock:
            end.
            if avail ordens-embarque then              
                find processo-imp
                    where processo-imp.cod-estabel = ordens-embarque.cod-estabel and
                          processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp 
                          no-lock no-error.    
            if avail processo-imp then do:
                if rowObject.dt-efetiva <> ? then do:
                    if rowObject.dt-efetiva < processo-imp.dt-emissao then do:
                        assign i-seq-erro = i-seq-erro + 1.
                        {utp/ut-field.i mgcex processo-imp dt-emissao 1}
                        assign c-return = trim(return-value).
                        {utp/ut-field.i mgcex historico-embarque dt-efetiva 1}
                        /* Data Efetiva ² menor que a do ponto anterior */
                        create tt-bo-erro.
                        assign tt-bo-erro.parametros = trim(return-value) + "~~" + c-return.
                        run utp/ut-msgs.p (input "msg":U,
                                           input 416,
                                           input tt-bo-erro.parametros).                     
                         assign tt-bo-erro.i-sequen     = i-seq-erro
                                tt-bo-erro.cd-erro      = 416
                                tt-bo-erro.mensagem     = return-value.                
                         create tt-campo-erro.
                         assign tt-campo-erro.campo = "dt-efetiva":U.
                    end.
                end.
                else do:
                    if c-opcao = "Create":U then 
                        if rowObject.dt-previsao < processo-imp.dt-emissao then do:
                            assign i-seq-erro = i-seq-erro + 1.
                            {utp/ut-field.i mgcex processo-imp dt-emissao 1}
                            assign c-return = trim(return-value).                        
                            {utp/ut-field.i mgcex historico-embarque dt-previsao 1}
                            /* Data Efetiva ² menor que a do ponto anterior */
                            create tt-bo-erro.
                            assign tt-bo-erro.parametros = trim(return-value) + "~~" + c-return.                        
                            run utp/ut-msgs.p (input "msg":U,
                                               input 416,
                                               input tt-bo-erro.parametros).
                             assign tt-bo-erro.i-sequen     = i-seq-erro
                                    tt-bo-erro.cd-erro      = 416
                                    tt-bo-erro.mensagem     = return-value.
                             create tt-campo-erro.
                             assign tt-campo-erro.campo = "dt-previsao":U.
                        end.
                END.
            end.                  
        END.
        
        
        /*manuela*/
        IF NOT l-manter-ordem-itiner THEN DO:
            for first historico-embarque FIELDS (dt-efetiva) where 
                      historico-embarque.cod-estabel    = rowObject.cod-estabel     and
                      historico-embarque.embarque       = rowObject.embarque        and
                      historico-embarque.cod-itiner     = rowObject.cod-itiner      and 
                      historico-embarque.sequencia      >= rowObject.sequencia      and
                      historico-embarque.cod-pto-contr  <> rowObject.cod-pto-contr  AND 
                    (historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch OR
                     historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq OR
                     historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar OR
                     historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad) no-lock:
            end.
        END.
        ELSE DO:
            for first historico-embarque FIELDS (dt-efetiva) where 
                      historico-embarque.cod-estabel    = rowObject.cod-estabel     and
                      historico-embarque.embarque       = rowObject.embarque        and
                      historico-embarque.cod-itiner     = rowObject.cod-itiner      and 
                      historico-embarque.sequencia      >= rowObject.sequencia      and
                      historico-embarque.cod-pto-contr  <> rowObject.cod-pto-contr  NO-LOCK:
            END.
        END.

        if avail historico-embarque THEN DO:
            IF ( NOT l-manter-ordem-itiner AND
                 (rowObject.cod-pto-contr = embarque-imp.cdn-pto-despch OR  
                  rowObject.cod-pto-contr = embarque-imp.cdn-pto-embarq OR  
                  rowObject.cod-pto-contr = embarque-imp.cdn-pto-desembar OR
                  rowObject.cod-pto-contr = embarque-imp.cdn-pto-chegad)) 
            OR l-manter-ordem-itiner  then do:

                if rowObject.dt-efetiva <> ? then do:
                    IF  rowObject.dt-efetiva > historico-embarque.dt-efetiva then do:
                        assign i-seq-erro = i-seq-erro + 1.
                        {utp/ut-field.i mgcex historico-embarque dt-efetiva 1}
                        /* Data Efetiva ² maior que a do Pto Contr seguinte */
                        run utp/ut-msgs.p (input "msg":U,
                                           input 17316,
                                           input return-value).
                        create tt-bo-erro.
                        assign tt-bo-erro.i-sequen     = i-seq-erro
                               tt-bo-erro.cd-erro      = 17316
                               tt-bo-erro.mensagem     = return-value.
                        create tt-campo-erro.
                        assign tt-campo-erro.campo = "dt-efetiva":U.
                    end.        
                end.
                else do:
                    if historico-embarque.dt-efetiva <> ? then do:
                        assign i-seq-erro = i-seq-erro + 1.
                        {utp/ut-field.i mgcex historico-embarque dt-efetiva 1}
                        create tt-bo-erro.
                        assign tt-bo-erro.parametros = trim(return-value).                
                        run utp/ut-msgs.p (input "msg":U,
                                           input 265,
                                           input tt-bo-erro.parametros).
                        assign tt-bo-erro.i-sequen     = i-seq-erro
                               tt-bo-erro.cd-erro      = 265
                               tt-bo-erro.mensagem     = return-value.            
                        create tt-campo-erro.
                        assign tt-campo-erro.campo = "dt-efetiva":U.
                    end.
                end.            
            end.
        END.
       
        IF CAN-FIND (FIRST tt-bo-erro
                     WHERE tt-bo-erro.errorsubtype <> "WARNING":U NO-LOCK) THEN
            RETURN "NOK":U.
        ELSE
            RETURN "OK":U.

    END.

    RETURN "OK":U.
end procedure.

procedure validateDelete:
    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.
    
    def var dt-ult-prev-old as date    no-undo.
    def var dt-ult-prev     as date    no-undo.
    def var i-intervalo-del as integer no-undo.
    def var i-sequencia-del as integer no-undo.
    def var l-ponto-base    as log     no-undo.
    
    def var c-embarque      like embarque-imp.embarque    no-undo.
    def var c-cod-estabel   like embarque-imp.cod-estabel no-undo.
    def var i-cod-itiner    like itinerario.cod-itiner    no-undo.
    def var i-cod-pto-contr like pto-contr.cod-pto-contr  no-undo.   
    
    for each tt-bo-erro no-lock:
        delete tt-bo-erro.
    end.

    ASSIGN i-seq-erro = 0.
    
    run InitializeValidate.

    find historico-embarque 
        where rowid(historico-embarque) = r-chave exclusive-lock no-error.
    if avail historico-embarque then do:
        if historico-embarque.dt-efetiva <> ? then do:
             assign i-seq-erro = i-seq-erro + 1.
             {utp/ut-liter.i Ponto_de_Controle * R}
             create tt-bo-erro.
             assign tt-bo-erro.parametros = trim(return-value).
             run utp/ut-msgs.p (input "msg":U,
                                input 18510,
                                input tt-bo-erro.parametros).
             assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 18510
                    tt-bo-erro.mensagem = return-value.
        end.
      
        /* Verifica se est  eliminando o ponto base na cota‡Æo */
        assign l-ponto-base = NO.
        for each ordens-embarque 
            where ordens-embarque.cod-estabel = historico-embarque.cod-estabel
              and ordens-embarque.embarque    = historico-embarque.embarque no-lock:
            for first cotacao-item fields(char-1)
                where cotacao-item.numero-ordem = ordens-embarque.numero-ordem 
                  and cotacao-item.cot-aprovada no-lock:
                {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                {ccp/cc9019.i51 "yes"}
                if i-cod-pto-contr-i50 = historico-embarque.cod-pto-contr then do:
                   assign l-ponto-base = YES.
                   leave.
                end.
            end. 
        end.
        IF l-ponto-base then do:
             assign i-seq-erro = i-seq-erro + 1.
             create tt-bo-erro.
             assign tt-bo-erro.parametros = string(historico-embarque.cod-pto-contr).              
             run utp/ut-msgs.p (input "msg":U,
                                input 56014, 
                                input tt-bo-erro.parametros).
             assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 56014 
                    tt-bo-erro.mensagem = return-value.
        end.

        find itinerario 
            where itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK no-error.
        FOR FIRST embarque-imp FIELDS(cdn-pto-despch cdn-pto-embarq cdn-pto-desembar cdn-pto-chegad) NO-LOCK
            WHERE embarque-imp.cod-estabel = historico-embarque.cod-estabel
              AND embarque-imp.embarque    = historico-embarque.embarque: END.

        if avail itinerario then do:
        
            if embarque-imp.cdn-pto-embarq = historico-embarque.cod-pto-contr then do:
                assign i-seq-erro = i-seq-erro + 1.
                create tt-bo-erro.
                assign tt-bo-erro.parametros = string(historico-embarque.cod-pto-contr).              
                run utp/ut-msgs.p (input "msg":U,
                                   input 19628,
                                   input tt-bo-erro.parametros).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 19628
                       tt-bo-erro.mensagem = return-value.
            end.
 
            if embarque-imp.cdn-pto-desembar = historico-embarque.cod-pto-contr then do:
                assign i-seq-erro = i-seq-erro + 1.
                create tt-bo-erro.                
                assign tt-bo-erro.parametros = string(historico-embarque.cod-pto-contr).
                run utp/ut-msgs.p (input "msg":U,
                                   input 19629,
                                   input tt-bo-erro.parametros).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 19629
                       tt-bo-erro.mensagem = return-value.
            end.
 
            if embarque-imp.cdn-pto-chegad = historico-embarque.cod-pto-contr then do:
                assign i-seq-erro = i-seq-erro + 1.
                create tt-bo-erro.
                assign tt-bo-erro.parametros = string(historico-embarque.cod-pto-contr).
                run utp/ut-msgs.p (input "msg":U,
                                   input 19630,
                                   input tt-bo-erro.parametros).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 19630
                       tt-bo-erro.mensagem = return-value.
            end.
            
        end.

        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
            IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-imp-forma-preco-compr" 
                                       AND funcao.ativo = YES) THEN DO:
                FIND desp-embarque
                    WHERE desp-embarque.cod-estabel   = historico-embarque.cod-estabel
                      AND desp-embarque.embarque      = historico-embarque.embarque
                      AND desp-embarque.cod-itiner    = historico-embarque.cod-itiner 
                      AND desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr NO-LOCK NO-ERROR.
                IF AVAIL desp-embarque THEN DO:
                    assign i-seq-erro = i-seq-erro + 1.
                    create tt-bo-erro.
                    run utp/ut-msgs.p (input "msg":U,
                                       input 31505,
                                       input '').
                    assign tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 31505
                           tt-bo-erro.mensagem = return-value.
                END.
            END.
        &ELSE
        &ENDIF
    
        
        find first tt-bo-erro 
            no-lock no-error.
        if not avail tt-bo-erro then do:
            run eliminaRelacionamentos (input historico-embarque.embarque,
                                        input historico-embarque.cod-estabel,
                                        input historico-embarque.cod-itiner,
                                        input historico-embarque.sequencia,
                                        input historico-embarque.cod-pto-contr).

            assign c-embarque      = historico-embarque.embarque
                   c-cod-estabel   = historico-embarque.cod-estabel
                   i-cod-itiner    = historico-embarque.cod-itiner
                   i-cod-pto-contr = historico-embarque.cod-pto-contr
                   dt-ult-prev-old = historico-embarque.dt-ult-previsao
                   i-sequencia-del = historico-embarque.sequencia.
                   
            run executeDelete.
            
            /*
            ** Verifica se ponto esta parametrizado para recalcular data da ultima previsao
            */            

            IF l-recalcula THEN DO:
                /*
                ** Encontra a data de previsao do proximo ponto
                */            
                for last historico-embarque fields(dt-ult-previsao dt-efetiva)
                    where historico-embarque.cod-estabel = c-cod-estabel and
                          historico-embarque.embarque    = c-embarque    and
                          historico-embarque.cod-itiner  = i-cod-itiner  and
                          historico-embarque.sequencia   < i-sequencia-del no-lock:
                end.
                /**************
                if not avail historico-embarque then do:                      
                    for first ordens-embarque fields(nr-proc-imp)
                        where ordens-embarque.cod-estabel = c-cod-estabel and
                              ordens-embarque.embarque    = c-embarque 
                              no-lock:
                    end.
                    if avail ordens-embarque then
                        find processo-imp
                            where processo-imp.cod-estabel = c-cod-estabel
                              and processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp no-lock no-error.
                        assign dt-ult-prev = processo-imp.dt-emissao.                      
                end.
                else do:
                    if historico-embarque.dt-efetiva <> ? then
                        assign dt-ult-prev = historico-embarque.dt-efetiva.
                    else
                        assign dt-ult-prev = historico-embarque.dt-ult-prev.
                end.
                *******/
                IF AVAIL historico-embarque THEN DO:
                    if historico-embarque.dt-efetiva <> ? then
                        assign dt-ult-prev = historico-embarque.dt-efetiva.
                    else
                        assign dt-ult-prev = historico-embarque.dt-ult-previsao.

                    assign i-intervalo-del = integer(dt-ult-prev-old) - integer(dt-ult-prev).

                    for each historico-embarque fields(dt-ult-previsao)
                        where historico-embarque.cod-estabel = c-cod-estabel and
                              historico-embarque.embarque    = c-embarque    and
                              historico-embarque.cod-itiner  = i-cod-itiner  and
                              historico-embarque.sequencia   > i-sequencia-del 
                              exclusive-lock:

                        assign historico-embarque.dt-ult-previsao = historico-embarque.dt-ult-previsao
                                                              - i-intervalo-del.

                    end.

                END.

                RUN pi-recalcula-dt-ult-prev IN THIS-PROCEDURE.
            end.                
        end.        
    end.
 
    if l-query then
        get next {&QUERY-NAME}
            no-lock no-wait.
    else
        find next historico-embarque
            no-lock no-error.

    if not avail historico-embarque then do:
       if l-query then
           get prev {&QUERY-NAME}
               no-lock no-wait.
       else
           find prev historico-embarque
               no-lock no-error.
    end.
    assign r-chave = rowid(historico-embarque).
    /*
    ** Atualiza data de entrega do prazo compra
    */
    
    run atualizaPrazoCompra (input r-chave).
    return "".
    
end procedure.

procedure executeDeleteitem:

    /* Elimina registro filhos e o pr¢prio pai */
    def input-output parameter r-chave as rowid no-undo.
    
    def var c-cod-estabel as char no-undo.
    def var c-embarque LIKE embarque-imp.embarque no-undo.
    def var i-cod-itiner as integer no-undo.

    find historico-embarque where rowid(historico-embarque) = r-chave no-lock no-error.
    if avail historico-embarque then
      assign c-cod-estabel = historico-embarque.cod-estabel
             c-embarque  = historico-embarque.embarque
             i-cod-itiner = historico-embarque.cod-itiner.                             

    for each historico-embarque where
             historico-embarque.cod-estabel = c-cod-estabel and
             historico-embarque.embarque  = c-embarque      and       
             historico-embarque.cod-itiner = i-cod-itiner 
             exclusive-lock:  
       delete historico-embarque.
    end.
    
    find next historico-embarque no-lock no-error.
    if not avail historico-embarque then
       find prev historico-embarque no-lock no-error.
       if not avail historico-embarque then
          find historico-embarque where rowid(historico-embarque) = r-chave no-lock no-error.

       if avail historico-embarque then assign r-chave = rowid(historico-embarque).    
end procedure.

procedure validateDelete2:

    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.

    run InitializeValidate.

    find historico-embarque where
        rowid(historico-embarque) = r-chave
        exclusive-lock no-error.

    if avail historico-embarque then do:
         assign c-cod-estabel   = historico-embarque.cod-estabel
                i-cod-itiner    = historico-embarque.cod-itiner
                c-embarque      = historico-embarque.embarque.
         for each decl-hist-embarq-imp where
                  decl-hist-embarq-imp.cod-estabel = historico-embarque.cod-estabel and
                  decl-hist-embarq-imp.embarque    = historico-embarque.embarque    and
                  decl-hist-embarq-imp.cod-itiner  = historico-embarque.cod-itiner  
                  exclusive-lock:
              delete decl-hist-embarq-imp.     
         end.
         for each desp-embarque where
                  desp-embarque.cod-estabel = historico-embarque.cod-estabel and
                  desp-embarque.embarque    = historico-embarque.embarque    and
                  desp-embarque.cod-itiner  = historico-embarque.cod-itiner  
                  exclusive-lock:

             delete desp-embarque.     
         end.         
         for each historico-embarque 
            where historico-embarque.cod-estabel = c-cod-estabel and
                  historico-embarque.cod-itiner  = i-cod-itiner  and
                  historico-embarque.embarque    = c-embarque 
                  exclusive-lock:
             run executeDelete.
         end.
    end.

    if l-query then
        get next {&QUERY-NAME}
            no-lock no-wait.
    else
        find next historico-embarque
            no-lock no-error.

    if not avail historico-embarque then do:
       if l-query then
           get prev {&QUERY-NAME}
               no-lock no-wait.
       else
           find prev historico-embarque
               no-lock no-error.
    end.
    assign r-chave = rowid(historico-embarque).
    return "".
end procedure.

procedure validateCreate:
    /*
    **  Valida cria‡Æo da tabela/duplicidade de registro.
    */
    def input  parameter table for rowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
    
    def var dt-pto-ant        as date    no-undo.
    def var dt-pto-pro        as date    no-undo.
    def var i-intervalo-adic  as integer no-undo.

    run initializeValidate.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.    
    
    assign c-opcao = "Create":U.

    find first rowObject no-error.
         
    IF CAN-FIND(FIRST decla-import-embarq
                WHERE decla-import-embarq.cod-estab  = RowObject.cod-estabel
                AND   decla-import-embarq.cod-embarq = RowObject.embarque) 
       AND substring(rowObject.char-2,1,2) = "" THEN DO: /* Quando for chamado a partir do Im0400b(Itinerario da DI) o ponto deve ser criado */
        IF NOT VALID-HANDLE(h-bocx407) THEN
            RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.
        
        RUN retorna-seq-ponto-nacionaliz IN h-bocx407(INPUT RowObject.embarque,
                                                      INPUT RowObject.cod-estabel,
                                                      OUTPUT l-seq-nac).
        IF l-seq-nac <= RowObject.sequencia THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            /* Pto Contr nÆo pode ser efetivado */
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Ponto_de_Controle_nÆo_pode_ser_INCLUÖDO" *}
            run utp/ut-msgs.p (input "msg":U,
                               input 17006,
                               input RETURN-VALUE + '!').
            create tt-bo-erro.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-embarque-esta-vinculado-a-uma AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Embarque_est _vinculado_a_uma_Declara‡Æo_Importa‡Æo_e_nÆo_‚_permitido_incluir_pontos_de_controle_ap¢s_o_ponto_de_nacionaliza‡Æo" *}
            ASSIGN c-lbl-liter-embarque-esta-vinculado-a-uma = TRIM(RETURN-VALUE).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 17006
                   tt-bo-erro.mensagem     = c-lbl-liter
                   tt-bo-erro.parametros   = trim(c-lbl-liter) + "~~" + c-lbl-liter-embarque-esta-vinculado-a-uma + '!'.
        END.
    END.

    if rowObject.sequencia = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex historico-embarque sequencia 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 265,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    
    if rowObject.dt-previsao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex historico-embarque dt-previsao 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 265,
                           input return-value).        
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.    
    end.
    else
        assign rowobject.dt-ult-previsao = rowObject.dt-previsao.
        
    /* 
    ** Teste de duplicidade
    */        
     if can-find(historico-embarque 
          where historico-embarque.cod-estabel   = rowObject.cod-estabel and
                historico-embarque.embarque      = rowObject.embarque    and 
                historico-embarque.cod-itiner    = rowObject.cod-itiner  and
                historico-embarque.cod-pto-contr = rowObject.cod-pto-contr) then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Ponto_de_controle * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 8,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 8
               tt-bo-erro.mensagem     = return-value.
    end.

    run validateFields.
    
    find first tt-bo-erro no-error.

    if not avail tt-bo-erro then do:
        run alteraSequencia.
        run executeCreate.

        assign r-aux = rowid({&TABLE-NAME}).

         /*--- Chamada UPC ---*/
        FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
            DELETE tt-epc.
        END.
        
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AlteraSeq":U
               tt-epc.cod-parameter = "r-historico-embarque":U
               tt-epc.val-parameter = STRING(r-aux).

        /* Include i-epc201.i: Chamada do programa de EPC */
        {include/i-epc201.i '"AlteraSeq"'}

        FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
            DELETE tt-epc.
        END.
        /*--- Fim chamada UPC ---*/
        

        /* 
        ** Se estiver parametrizado para recalcular dt ultima previsÆo 
        */

        IF l-recalcula THEN DO: 
            /*
            ** Procura data do ponto anterior, se for o primeiro procura data de emissao do processo
            */
            for last historico-embarque fields(dt-ult-previsao dt-efetiva) where 
                     historico-embarque.cod-estabel = rowObject.cod-estabel and
                     historico-embarque.embarque    = rowObject.embarque    and
                     historico-embarque.cod-itiner  = rowObject.cod-itiner  and
                     historico-embarque.sequencia   < rowObject.sequencia no-lock:
            end.
            if avail historico-embarque then do:
                if historico-embarque.dt-efetiva <> ? then
                    assign dt-pto-ant = historico-embarque.dt-efetiva.
                else
                    assign dt-pto-ant = historico-embarque.dt-ult-previsao.
            end.
            else do:
                for first ordens-embarque fields(nr-proc-imp)
                    where ordens-embarque.cod-estabel = rowObject.cod-estabel and
                          ordens-embarque.embarque    = rowObject.embarque
                      no-lock:
                end.
                if avail ordens-embarque THEN DO:
                
                    FOR FIRST processo-imp FIELDS(dt-emissao)
                        where processo-imp.cod-estabel = rowObject.cod-estabel
                          and processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp
                          NO-LOCK:
                    END.
                    if avail processo-imp then
                       assign dt-pto-ant = processo-imp.dt-emissao.
                END.
            end.
            
            if rowObject.dt-efetiva <> ? then
                assign i-intervalo-adic-aux = integer(rowObject.dt-efetiva) - integer(dt-pto-ant).
            else               
                assign i-intervalo-adic-aux = integer(rowObject.dt-previsao) - integer(dt-pto-ant). 

            RUN pi-recalcula-dt-ult-prev IN THIS-PROCEDURE.

            /*
            ** Atualiza data de entrega do prazo compra
            */
            run atualizaPrazoCompra (input r-aux).
            
        end.
        
        /*--- Chamada UPC ---*/
        FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
            DELETE tt-epc.
        END.
        
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AlteraSeq":U
               tt-epc.cod-parameter = "cod-estabel":U
               tt-epc.val-parameter = string(rowObject.cod-estabel).
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AlteraSeq":U
               tt-epc.cod-parameter = "embarque":U
               tt-epc.val-parameter = string(rowObject.embarque).
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AlteraSeq":U
               tt-epc.cod-parameter = "cod-itiner":U
               tt-epc.val-parameter = string(rowObject.cod-itiner).
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AlteraSeq":U
               tt-epc.cod-parameter = "sequencia":U
               tt-epc.val-parameter = string(rowObject.sequencia).

        /* Include i-epc201.i: Chamada do programa de EPC */
        {include/i-epc201.i '"AlteraSeq"'}

        FOR EACH tt-epc WHERE tt-epc.cod-event = "AlteraSeq".
            DELETE tt-epc.
        END.
        /*--- Fim chamada UPC ---*/
        
        /**/        
        RUN GravaIdTransporte.
    end.
    IF VALID-HANDLE(h-bocx407) THEN DO:
        DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    END.
end procedure.

PROCEDURE GravaIdTransporte:

    DEF VAR c-meio-transporte-aux AS CHAR NO-UNDO.
    {imp/im0045.i50} /* Include tratamento atributo livre */        
    
    IF RowObject.dt-efetiva     <> ? OR
       RowObject.id-meio-transp <> "" THEN DO:
       ASSIGN c-meio-transporte-aux = RowObject.id-meio-transp.
    END.
    
    FIND embarque-imp where 
         embarque-imp.cod-estabel = Rowobject.cod-estabel and
         embarque-imp.embarque    = RowObject.embarque exclusive-lock no-error.
    if  avail embarque-imp then do:
        {cdp/cd4300.i4 "yes" embarque-imp.char-1}
        {imp/im0045.i51 "yes"}

        assign c-embarque-orig-i50 = c-embarque-orig-i50
               c-meio-transporte = c-meio-transporte-aux.

        {imp/im0045.i51 no}
        {cdp/cd4300.i4  no embarque-imp.char-1}
    END.
    RELEASE embarque-imp.
    ASSIGN c-meio-transporte-aux = "".

END PROCEDURE.


PROCEDURE atualizaPrazoCompra:

    /*
    ** Atualiza a data de entrega no prazo de compra 
    */
    def input parameter r-chave as rowid no-undo.

    DEFINE VARIABLE l-disableTriggers AS LOGICAL INITIAL YES NO-UNDO.
    
    IF c-nom-prog-upc-mg97 <> "" THEN DO:
        
        FOR EACH tt-epc WHERE tt-epc.cod-event = "beginAtualizaPrazoCompra".
            DELETE tt-epc.
        END.
        
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "beginAtualizaPrazoCompra":U
               tt-epc.cod-parameter = "Rowid-historico-embarque.":U
               tt-epc.val-parameter = STRING(r-chave).

        /* Include i-epc201.i: Chamada do programa de EPC */
        {include/i-epc201.i '"beginAtualizaPrazoCompra"'}

        FOR FIRST tt-epc WHERE tt-epc.cod-event = "beginAtualizaPrazoCompra" AND tt-epc.cod-parameter = "disable triggers":
            ASSIGN l-disableTriggers = LOGICAL(tt-epc.val-parameter).
        END.
    END.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND historico-embarque 
        WHERE ROWID(historico-embarque) = r-chave NO-LOCK NO-ERROR.
    IF AVAIL historico-embarque THEN DO:

        FIND itinerario 
            WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK NO-ERROR.

        FOR FIRST embarque-imp FIELDS(cdn-pto-despch cdn-pto-embarq cdn-pto-desembar cdn-pto-chegad) NO-LOCK
            WHERE embarque-imp.cod-estabel = historico-embarque.cod-estabel
              AND embarque-imp.embarque    = historico-embarque.embarque: END.

        FOR FIRST  b-historico-embarque
            FIELDS (cod-estabel embarque dt-ult-previsao dt-efetiva)
            WHERE  b-historico-embarque.cod-estabel   = historico-embarque.cod-estabel AND
                   b-historico-embarque.embarque      = historico-embarque.embarque    AND
                   b-historico-embarque.cod-itiner    = historico-embarque.cod-itiner  AND
                   b-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad    NO-LOCK:
        END.

        IF AVAIL b-historico-embarque THEN DO:

            FOR EACH ordens-embarque FIELDS(numero-ordem parcela cod-estabel) 
                WHERE ordens-embarque.cod-estabel = b-historico-embarque.cod-estabel 
                  AND ordens-embarque.embarque    = b-historico-embarque.embarque NO-LOCK:

                /* 
                ** Para melhor a performance, pois a trigger de write, nao e necessario neste momento do programa
                */
                IF l-disableTriggers = YES THEN
                   DISABLE TRIGGERS FOR LOAD OF prazo-compra.  

                FIND prazo-compra 
                    WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem 
                      AND prazo-compra.parcela      = ordens-embarque.parcela EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL prazo-compra THEN
                    IF b-historico-embarque.dt-ult-previsao <> prazo-compra.data-entrega THEN DO:
                        IF b-historico-embarque.dt-efetiva <> ? THEN DO:
                            if b-historico-embarque.dt-efetiva <> prazo-compra.data-entrega THEN DO:
                                find first ordem-compra where ordem-compra.numero-ordem = prazo-compra.numero-ordem exclusive-lock no-error.  
                                IF AVAIL ordem-compra THEN DO:
                                    {cxbo/bocx140.i03 today 
                                       c-seg-usuario 
                                       ordem-compra.num-pedido
                                       ordem-compra.numero-ordem 
                                       prazo-compra.parcela
                                       prazo-compra.data-entrega
                                       ?
                                       ?
                                       ordem-compra.cod-emitente
                                       ordem-compra.gera-edi
                                       ordem-compra.num-pedido
                                       b-historico-embarque.dt-efetiva }  
                                END.
                            END.
                            ASSIGN prazo-compra.data-entrega = b-historico-embarque.dt-efetiva.
                        END.
                        ELSE DO:
                            if prazo-compra.data-entrega <> b-historico-embarque.dt-ult-previsao THEN DO:
                                find first ordem-compra where ordem-compra.numero-ordem = prazo-compra.numero-ordem exclusive-lock no-error.  
                                IF AVAIL ordem-compra THEN DO:
                                    {cxbo/bocx140.i03 today 
                                       c-seg-usuario 
                                       ordem-compra.num-pedido
                                       ordem-compra.numero-ordem 
                                       prazo-compra.parcela
                                       prazo-compra.data-entrega
                                       ?
                                       ?
                                       ordem-compra.cod-emitente
                                       ordem-compra.gera-edi
                                       ordem-compra.num-pedido
                                       b-historico-embarque.dt-ult-previsao}
                                       ASSIGN prazo-compra.data-entrega = b-historico-embarque.dt-ult-previsao.
                                END.
                            END.
                        END.
                        /*
                        ** Verifica se a tabela pl-it-calc est  locada com outro usu rio, caso esteja repete o find at‚ que esta seja liberada
                        */
                        &IF DEFINED(bf-mat-comex) &THEN
                            REPEAT:
                                FIND pl-it-calc 
                                    WHERE pl-it-calc.it-codigo = prazo-compra.it-codigo EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                                IF NOT LOCKED pl-it-calc THEN 
                                    LEAVE.
                            END.
                            {cdp/cd7000.i7 "prazo-compra"} /* replanejamento do item */
                            RELEASE pl-it-calc.
                        &ELSE
                            IF avail param-global and
                              (param-global.modulo-pl = yes 
                                &IF DEFINED(bf-mat-comex) &THEN
                                &ELSE
                                     or param-global.modulo-pi = yes                             
                                &ENDIF
                                  ) THEN DO:
                                run cdp/cd7000.p (input 0, prazo-compra.it-codigo, ordens-embarque.cod-estabel). 
                            END.
                        &ENDIF
                  END.
                RELEASE prazo-compra.
                RELEASE ordem-compra.
                RELEASE alt-ped.
             END.
        END.
    END.
END PROCEDURE.


PROCEDURE validateCodigo:

def input-output parameter c-seq       as char no-undo.
def input-output parameter c-pto-contr as char no-undo.
def output parameter table for tt-bo-erro.

def var i-teste as integer no-undo.

  assign i-teste = int(c-seq) no-error.
  if  error-status:error then do:
      assign i-seq-erro = i-seq-erro + 1
             c-seq = "0".
      {utp/ut-field.i mgcex historico-embarque sequencia 1}
      run utp/ut-msgs.p (input "msg":U,
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
       {utp/ut-field.i mgcex historico-embarque cod-pto-contr 1}
       run utp/ut-msgs.p (input "msg":U,
                          input 16963,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 16963
              tt-bo-erro.mensagem     = return-value.
   end.

end procedure.


PROCEDURE alteraSequencia:

def var l-seq as logical init yes no-undo.
def var i-seq as integer no-undo.

assign i-seq = rowObject.sequencia.

for each tt-hist-emb:
    delete tt-hist-emb.
end.

do while l-seq:
  if avail rowObject then do:
      find historico-embarque where
           historico-embarque.cod-estabel = rowObject.cod-estabel and
           historico-embarque.embarque    = rowObject.embarque    and
           historico-embarque.cod-itiner  = rowObject.cod-itiner  and
           historico-embarque.sequencia   = i-seq 
           no-lock no-error. /*dranka*/
      if avail historico-embarque then do:
         create tt-hist-emb.
         assign tt-hist-emb.i-sequencia = historico-embarque.sequencia
                tt-hist-emb.r-hist    = rowid(historico-embarque)
                i-seq = i-seq + 1.
      end.
      else assign l-seq = no.
  end.
end.

for each tt-hist-emb by tt-hist-emb.i-sequencia desc:
   find historico-embarque where rowid(historico-embarque) = tt-hist-emb.r-hist exclusive-lock no-error.
   if avail historico-embarque then
     assign historico-embarque.sequencia = tt-hist-emb.i-sequencia + 1.
end.

end procedure.


PROCEDURE calculateDefasagem:

def input  parameter r-chave as rowid no-undo.
def output parameter i-dias as integer no-undo.

find historico-embarque where rowid(historico-embarque) = r-chave no-lock no-error.
if avail historico-embarque then do:
   if historico-embarque.dt-efetiva <> ? then
      assign i-dias = historico-embarque.dt-efetiva - historico-embarque.dt-previsao.
   else
      assign i-dias = historico-embarque.dt-ult-previsao - historico-embarque.dt-previsao.
end.

end procedure.


PROCEDURE validaDespEmbarque:

def input  parameter r-emb   as rowid no-undo.
def output parameter l-desab as log   no-undo.

assign l-desab = no.

find historico-embarque where
     rowid(historico-embarque) = r-emb
     no-lock no-error.
if   avail historico-embarque then do:
     find embarque-imp where
          embarque-imp.cod-estabel = historico-embarque.cod-estabel and
          embarque-imp.embarque    = historico-embarque.embarque 
          no-lock no-error.
     if   avail embarque-imp then
          if embarque-imp.situacao = 2 then
                assign l-desab = yes.     

end.     

end procedure.


PROCEDURE atualizaStatus:

/* frank
** Procedure de atualiza do Status do Processo e do Embarque.
*/

    DEF VAR de-quant-ordem               LIKE ordens-embarque.quantidade NO-UNDO.
    DEF VAR de-quant-embarque            LIKE ordens-embarque.quantidade NO-UNDO.
    DEF VAR de-quant-n-embarque          LIKE ordens-embarque.quantidade NO-UNDO.
    DEF VAR da-data-entrega-prevista     LIKE prazo-compra.data-entrega  NO-UNDO.
    DEF VAR l-encerrado                  AS LOG                          NO-UNDO.
    DEF VAR l-func-nao-atualiza-proc-imp AS LOG INITIAL NO               NO-UNDO.   

    ASSIGN l-func-nao-atualiza-proc-imp = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-nao-atu-proc":U
                                                                  AND funcao.ativo = YES).

    IF NOT AVAIL param-global THEN
       FIND FIRST param-global NO-LOCK NO-ERROR.

    /*
    ** Atualiza situa‡Æo do embarque: se todos os pontos estiverem efetivados o embarque passa para encerrado.
    */
    IF l-ult-ponto THEN DO:
        &IF "{&ems_dbtype}" <> "progress":U &THEN 
            FIND FIRST b-historico-embarque3
                 WHERE b-historico-embarque3.cod-estabel   = rowObject.cod-estabel
                   AND b-historico-embarque3.embarque      = rowObject.embarque 
                   AND b-historico-embarque3.cod-itiner    = rowObject.cod-itiner 
                   AND b-historico-embarque3.sequencia     = rowobject.sequencia
                   AND b-historico-embarque3.dt-efetiva    = ? NO-LOCK NO-ERROR.
            IF AVAIL b-historico-embarque3 THEN DO:
        &ELSE
            IF CAN-FIND (FIRST b-historico-embarque
                         WHERE b-historico-embarque.cod-estabel = rowObject.cod-estabel
                           AND b-historico-embarque.embarque    = rowObject.embarque 
                           AND b-historico-embarque.cod-itiner  = rowObject.cod-itiner 
                           AND b-historico-embarque.dt-efetiva  = ?) THEN DO: 
        &ENDIF
            FIND embarque-imp
                WHERE embarque-imp.cod-estabel = rowObject.cod-estabel
                  AND embarque-imp.embarque    = rowObject.embarque EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL embarque-imp THEN
                ASSIGN embarque-imp.situacao = 1. /* NÆo Encerrado */
        END.
        ELSE DO:
            FIND embarque-imp
                WHERE embarque-imp.cod-estabel = rowObject.cod-estabel
                  AND embarque-imp.embarque    = rowObject.embarque EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL embarque-imp THEN
                ASSIGN embarque-imp.situacao = 2. /* Encerrado */
        END.
        RELEASE embarque-imp.
    END.

    /*
    ** Carrega processos de importa‡Æo;
    ** Atualiza planejamento 
    */
    FOR FIRST embarque-imp FIELDS(cdn-pto-despch cdn-pto-embarq cdn-pto-desembar cdn-pto-chegad) NO-LOCK
        WHERE embarque-imp.cod-estabel = rowObject.cod-estabel
          AND embarque-imp.embarque    = rowObject.embarque: END.

    FOR FIRST b-historico-embarque FIELDS(dt-efetiva dt-ult-previsao) USE-INDEX pto-contr
        WHERE b-historico-embarque.cod-estabel   = rowObject.cod-estabel
          AND b-historico-embarque.embarque      = rowObject.embarque 
          AND b-historico-embarque.cod-itiner    = rowObject.cod-itiner 
          AND b-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad NO-LOCK:
    END.

    IF AVAIL b-historico-embarque THEN DO:
        IF b-historico-embarque.dt-efetiva <> ? THEN
            ASSIGN da-data-entrega-prevista = b-historico-embarque.dt-efetiva.
        ELSE
            ASSIGN da-data-entrega-prevista = b-historico-embarque.dt-ult-previsao.
    END.

    FOR EACH ordens-embarque FIELDS(nr-proc-imp numero-ordem parcela cod-estabel)
        WHERE ordens-embarque.cod-estabel = rowObject.cod-estabel
          AND ordens-embarque.embarque    = rowObject.embarque NO-LOCK:

        IF NOT CAN-FIND(FIRST tt-processo-embarque
                        WHERE tt-processo-embarque.nr-proc-imp = ordens-embarque.nr-proc-imp) THEN DO:
            CREATE tt-processo-embarque.
            ASSIGN tt-processo-embarque.nr-proc-imp = ordens-embarque.nr-proc-imp.
        END.

        IF l-previsao-alt THEN DO:
            FOR FIRST prazo-compra USE-INDEX ordem
                 WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem
                   AND prazo-compra.parcela      = ordens-embarque.parcela NO-LOCK:
            END.
            IF AVAIL prazo-compra THEN
            
                IF da-data-entrega-prevista <> prazo-compra.data-entrega THEN DO:
                          
                    FIND CURRENT prazo-compra EXCLUSIVE-LOCK NO-ERROR.
        
                    /*FO: 1806.191 Modifica‡äes para Criar a alt-ped*/
                    find first ordem-compra where ordem-compra.numero-ordem = prazo-compra.numero-ordem exclusive-lock no-error.
                        {cxbo/bocx140.i03 today
                            c-seg-usuario
                            ordem-compra.num-pedido
                            ordem-compra.numero-ordem 
                            prazo-compra.parcela
                            prazo-compra.data-entrega
                            ?
                            ?
                            ordem-compra.cod-emitente
                            ordem-compra.gera-edi
                            ordem-compra.num-pedido
                            da-data-entrega-prevista }   
                    /*Fim FO: 1806.191 */
                    ASSIGN prazo-compra.data-entrega = da-data-entrega-prevista.
                    /*
                    ** Verifica se a tabela pl-it-calc est  locada com outro usu rio, caso esteja repete o find at‚ que esta seja liberada
                    */
                    IF avail param-global and
                      (param-global.modulo-pl = yes or param-global.modulo-pi = yes) THEN DO:
                        run cdp/cd7000.p (input 0, prazo-compra.it-codigo, ordens-embarque.cod-estabel).
                    END.
                END.
        END.
        RELEASE prazo-compra.
        RELEASE ordem-compra.
        RELEASE alt-ped.
    END.
    

    /*l-func-nao-atualiza-proc-imp: função criada para não atualizar a situação do processo de importação,
      devido ao problema de performance quando se possui muitos registros. Nesse caso o cliente deve
      executar o programa spp/imp/spim001.r para atualizar a situação do processo*/
    IF NOT l-func-nao-atualiza-proc-imp THEN DO:

        /*
        ** Atualiza situa‡Æo do processo de importa‡Æo
        */
        IF l-pto-embarque OR
           l-ult-ponto THEN DO:
            FOR EACH tt-processo-embarque:
        
                FOR FIRST processo-imp FIELDS(num-pedido cod-estabel nr-proc-imp situacao)
                    WHERE processo-imp.cod-estabel = RowObject.cod-estabel
                      AND processo-imp.nr-proc-imp = tt-processo-embarque.nr-proc-imp NO-LOCK:
                END.
        
                ASSIGN de-quant-ordem      = 0
                       de-quant-embarque   = 0 
                       de-quant-n-embarque = 0.
        
                FOR EACH ordem-compra FIELDS (numero-ordem &IF DEFINED(bf-mat-comex) &THEN &else qt-solic &endif)
                    WHERE ordem-compra.num-pedido = processo-imp.num-pedido 
                      AND ordem-compra.situacao   = 2 NO-LOCK: /* Confirmada */
                        ASSIGN de-quant-ordem     = de-quant-ordem + ordem-compra.qt-solic.
        
                    FOR EACH ordens-embarque FIELDS (cod-estabel embarque quantidade) USE-INDEX ordem
                        WHERE ordens-embarque.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
    
                        FOR FIRST b-historico-embarque FIELDS(dt-efetiva) USE-INDEX pto-contr
                            WHERE b-historico-embarque.cod-estabel   = ordens-embarque.cod-estabel
                              AND b-historico-embarque.embarque      = ordens-embarque.embarque 
                              AND b-historico-embarque.cod-itiner    = itinerario.cod-itiner
                              AND b-historico-embarque.cod-pto-contr = itinerario.pto-embarque NO-LOCK:
                        END.
                        IF NOT AVAIL b-historico-embarque THEN
                            NEXT.
        
                        IF b-historico-embarque.dt-efetiva <> ? THEN
                            ASSIGN de-quant-embarque = de-quant-embarque + ordens-embarque.quantidade.
    
                        IF NOT CAN-FIND(FIRST tt-embarques
                                        WHERE tt-embarques.cod-estabel = ordens-embarque.cod-estabel
                                          AND tt-embarques.embarque    = ordens-embarque.embarque) THEN DO:
                            CREATE tt-embarques.
                            ASSIGN tt-embarques.cod-estabel = ordens-embarque.cod-estabel
                                   tt-embarques.embarque    = ordens-embarque.embarque.
                        END.
    
                    END.
        
                    ASSIGN de-quant-n-embarque = de-quant-n-embarque + (de-quant-ordem - de-quant-embarque).
        
                    IF de-quant-n-embarque > 0 AND de-quant-embarque > 0 THEN
                        LEAVE.
                END.
    
                FIND CURRENT processo-imp EXCLUSIVE-LOCK NO-ERROR.
                IF de-quant-n-embarque > 0 AND de-quant-embarque = 0 THEN
                    ASSIGN processo-imp.situacao = 1. /* NÆo embarcado     */
                IF de-quant-n-embarque > 0 AND de-quant-embarque > 0 THEN
                    ASSIGN processo-imp.situacao = 2. /* Embarcado parcial */
                IF de-quant-n-embarque = 0 THEN
                    ASSIGN processo-imp.situacao = 3. /* Embarcado total   */

                IF processo-imp.situacao = 1  THEN DO: /* Se o processo de importação está com a situação de Não Embarcado, mas o pedido já tem uma ordem de compra Recebida, */
                    IF CAN-FIND (FIRST ordem-compra    /* a situação correta é Embarcado Parcial */                                                                                                                          
                                 WHERE ordem-compra.num-pedido = processo-imp.num-pedido 
                                   AND ordem-compra.situacao   = 6 /* Recebida */  ) THEN
                        ASSIGN processo-imp.situacao = 2. /* Embarcado parcial */
                END.

                ASSIGN l-encerrado = NO.
                IF processo-imp.situacao = 3 then do:  /* Embarcado Total */
                    ASSIGN l-encerrado = YES.
    
                    tt-embarques:
                    FOR EACH tt-embarques USE-INDEX codigo:
                         IF CAN-FIND(FIRST historico-embarque
                                     WHERE historico-embarque.cod-estabel = tt-embarques.cod-estabel
                                       AND historico-embarque.embarque    = tt-embarques.embarque 
                                       AND historico-embarque.dt-efetiva = ?) THEN DO:
                            ASSIGN l-encerrado = NO.
                            LEAVE tt-embarques.
                         END.
                    END.
                END.
                IF l-encerrado THEN
                    ASSIGN processo-imp.situacao = 4. /* Encerrado */
            END.
            EMPTY TEMP-TABLE tt-processo-embarque.
            RELEASE processo-imp. 
        END.
    END.

END PROCEDURE.


PROCEDURE eliminaRelacionamentos:

/*
** Elimina Declara‡äes/Comunica‡äes do Hist¢rico do Embarque de Importa‡Æo.
*/
def input parameter c-embarque    like historico-embarque.embarque      no-undo. 
def input parameter c-cod-estabel like historico-embarque.cod-estabel   no-undo.
def input parameter i-cod-itiner  like historico-embarque.cod-itiner    no-undo.
def input parameter i-sequencia   like historico-embarque.sequencia     no-undo.
def input parameter i-pto-contr   like historico-embarque.cod-pto-contr no-undo.

    for each decl-hist-embarq-imp exclusive-lock where
             decl-hist-embarq-imp.cod-estabel   = c-cod-estabel and
             decl-hist-embarq-imp.embarque      = c-embarque    and
             decl-hist-embarq-imp.cod-itiner    = i-cod-itiner  and
             decl-hist-embarq-imp.sequencia     = i-sequencia:
             
        delete decl-hist-embarq-imp.         
    end.         
    
    for each desp-embarque exclusive-lock where
             desp-embarque.cod-estabel   = c-cod-estabel and
             desp-embarque.embarque      = c-embarque    and
             desp-embarque.cod-itiner    = i-cod-itiner  and
             desp-embarque.cod-pto-contr = i-pto-contr:

        delete desp-embarque.     
             
    end.
    
end procedure.


PROCEDURE retornaTransportePontoAnterior:
    /* 
    ** busca o meio de transporte anterior … aquele que est  sendo alterado no programa
    ** acompanhamento do embarque de importa‡Æo(im0055) 
    */  
    def input  parameter p-cod-estabel like historico-embarque.cod-estabel    no-undo.
    def input  parameter p-embarque    like historico-embarque.embarque       no-undo.
    def input  parameter p-cod-itiner  like historico-embarque.cod-itiner     no-undo.
    def input  parameter p-sequencia   like historico-embarque.sequencia      no-undo.
    def output parameter p-meio-transp like historico-embarque.id-meio-transp no-undo.
    
    for each b-historico-embarque2 fields(sequencia id-meio-transp) no-lock
       where b-historico-embarque2.cod-estabel = p-cod-estabel and
             b-historico-embarque2.embarque    = p-embarque    and
             b-historico-embarque2.cod-itiner  = p-cod-itiner  and
             b-historico-embarque2.sequencia < p-sequencia
            break by b-historico-embarque2.sequencia:
        if last-of(b-historico-embarque2.sequencia) then
            assign p-meio-transp = b-historico-embarque2.id-meio-transp.
    end.

end procedure.

PROCEDURE calcularDiasAcompanhamento:
    /* 
    ** Calcula o n£mero de dias e distƒncia total do acompanhamento do embarque
    */
    def input  parameter p-cod-estabel like embarque-imp.cod-estabel no-undo.
    def input  parameter p-embarque    like embarque-imp.embarque    no-undo.
    def output parameter p-dias-total  LIKE itinerario.nr-dias       no-undo.
    def output parameter table for tt-bo-erro.
    
    def var dt-inicio    as date    no-undo.
    def var dt-chegada   as date    no-undo.
    DEF VAR i-dias-pri   LIKE pto-itiner.nr-dias NO-UNDO.
                                            
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    for first historico-embarque fields(cod-itiner sequencia cod-pto-contr dt-efetiva dt-ult-previsao)
        where historico-embarque.cod-estabel = p-cod-estabel and
              historico-embarque.embarque    = p-embarque 
              no-lock:
    end.
    if not avail historico-embarque then do:
        {utp/ut-table.i mgcex processo-imp 1}
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = tt-bo-erro.parametros.
        leave.
    end.
    
    if historico-embarque.dt-efetiva <> ? then
        assign dt-inicio = historico-embarque.dt-efetiva.
    else
        assign dt-inicio = historico-embarque.dt-ult-previsao.
        
    /* Busca o n£mero de dias do primeiro ponto de controle do itinerario para compor 
    o total de dias */
    FOR FIRST pto-itiner FIELDS(nr-dias) WHERE 
         pto-itiner.cod-itiner     = historico-embarque.cod-itiner AND
         pto-itiner.cod-pto-contr  = historico-embarque.cod-pto-contr 
         NO-LOCK:
    END.
    IF AVAIL pto-itiner THEN
        ASSIGN i-dias-pri = pto-itiner.nr-dias.
    ELSE ASSIGN i-dias-pri = 0.
    
    for last historico-embarque fields(dt-efetiva dt-ult-previsao cod-estabel embarque cod-itiner)
        where historico-embarque.cod-estabel = p-cod-estabel and
              historico-embarque.embarque    = p-embarque 
              no-lock:
    end.
    if not avail historico-embarque then do:
        {utp/ut-table.i mgcex processo-imp 1}
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = tt-bo-erro.parametros.
        leave.
    end.
    
    if historico-embarque.dt-efetiva <> ? then
        assign dt-chegada = historico-embarque.dt-efetiva.
    else
        assign dt-chegada = historico-embarque.dt-ult-previsao.
    
    assign p-dias-total = (dt-chegada - dt-inicio) + i-dias-pri.
    
    if p-dias-total < 0 then
        assign p-dias-total = 0.

end procedure.


PROCEDURE returnrowid:
    DEF INPUT PARAMETER p-estabel AS CHAR NO-UNDO.
    def INPUT parameter p-embarque as char no-undo.
    def OUTPUT parameter p-rowid as rowid no-undo.

    FIND FIRST historico-embarque 
         WHERE historico-embarque.cod-estabel = p-estabel AND
               historico-embarque.embarque    = p-embarque
               NO-LOCK NO-ERROR.
    IF AVAIL historico-embarque THEN
        ASSIGN p-rowid = ROWID(historico-embarque).

end procedure.

PROCEDURE returnDisableExpense:
    /*
    ** Retorna Yes para desabilitar botao "Despesa" nas situacoes: - Embarque encerrado 
    **                                                             - Se for o ultimo ponto de controle do embarque
    ** Somente vai habilitar o botao "Despesa" se: - Nao for o ultimo ponto de controle do embarque 
    **                                             - Se j  houverem despesas cadastradas anteriormente para o 
    **                                               ultimo ponto de controle atraves do programa im0010
    */
    DEFINE INPUT  PARAMETER TABLE FOR RowObject.
    DEFINE INPUT  PARAMETER r-chave       AS ROWID   NO-UNDO.
    DEFINE OUTPUT PARAMETER l-desabilita  AS LOGICAL NO-UNDO.

    DEFINE VARIABLE l-last-pto-contr      AS LOGICAL NO-UNDO.

    FIND FIRST RowObject NO-ERROR.

    IF NOT CAN-FIND(FIRST b-historico-embarque 
                    WHERE b-historico-embarque.cod-estabel = rowObject.cod-estabel 
                      AND b-historico-embarque.embarque    = rowObject.embarque    
                      AND b-historico-embarque.cod-itiner  = rowObject.cod-itiner  
                      AND b-historico-embarque.sequencia   > rowObject.sequencia) THEN DO:

        ASSIGN l-last-pto-contr = YES.

    END.

    ASSIGN l-desabilita = NO.

    IF l-last-pto-contr THEN DO:
        FIND historico-embarque WHERE 
             ROWID(historico-embarque) = r-chave NO-LOCK NO-ERROR. 
        IF AVAIL historico-embarque THEN DO:
           FIND embarque-imp WHERE
                embarque-imp.cod-estabel = historico-embarque.cod-estabel AND
                embarque-imp.embarque    = historico-embarque.embarque    NO-LOCK NO-ERROR.
           IF AVAIL embarque-imp THEN DO:
              IF CAN-FIND (FIRST desp-embarque 
                           WHERE desp-embarque.cod-estabel   = historico-embarque.cod-estabel
                             AND desp-embarque.embarque      = historico-embarque.embarque
                             AND desp-embarque.cod-itiner    = historico-embarque.cod-itiner
                             AND desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr) THEN 
                   
                 ASSIGN l-desabilita = NO.
              ELSE 
                 ASSIGN l-desabilita = YES.
           END.
        END.     
    END.
    
END PROCEDURE.


PROCEDURE calcularDiasAcompanhamentoHistEmb:
    /* 
    ** Calcula o n£mero de dias e distƒncia total do acompanhamento do embarque
    */
    DEF INPUT  PARAMETER p-cod-estabel LIKE embarque-imp.cod-estabel NO-UNDO.
    DEF INPUT  PARAMETER p-embarque    LIKE embarque-imp.embarque    NO-UNDO.
    DEF OUTPUT PARAMETER p-dias-total  LIKE itinerario.nr-dias       NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR tt-bo-erro.
    
    DEF VAR dt-inicio    AS   DATE               NO-UNDO.
    DEF VAR dt-chegada   AS   DATE               NO-UNDO.
    DEF VAR i-dias-pri   LIKE pto-itiner.nr-dias NO-UNDO.
                                            
    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.

    ASSIGN p-dias-total = 0.
    
    FOR FIRST historico-embarque FIELDS(cod-itiner sequencia cod-pto-contr dt-efetiva dt-ult-previsao)
        WHERE historico-embarque.cod-estabel = p-cod-estabel
          AND historico-embarque.embarque    = p-embarque NO-LOCK:
    END.
    IF NOT AVAIL historico-embarque THEN DO:
        {utp/ut-table.i mgcex processo-imp 1}
        ASSIGN i-seq-erro = i-seq-erro + 1.
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT tt-bo-erro.parametros).
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = tt-bo-erro.parametros.
        LEAVE.
    END.
    
    IF historico-embarque.dt-efetiva <> ? THEN
        ASSIGN dt-inicio = historico-embarque.dt-efetiva.
    ELSE
        ASSIGN dt-inicio = historico-embarque.dt-ult-previsao.
        
    FOR LAST historico-embarque FIELDS(dt-efetiva dt-ult-previsao cod-estabel embarque cod-itiner /**/ cod-pto-contr)
        WHERE historico-embarque.cod-estabel = p-cod-estabel 
          AND historico-embarque.embarque    = p-embarque NO-LOCK:
    END.
    
    IF NOT AVAIL historico-embarque THEN DO:
        {utp/ut-table.i mgcex processo-imp 1}
        ASSIGN i-seq-erro = i-seq-erro + 1.
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT tt-bo-erro.parametros).
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = tt-bo-erro.parametros.
        LEAVE.
    END.
    
    IF historico-embarque.dt-efetiva <> ? THEN
        ASSIGN dt-chegada = historico-embarque.dt-efetiva.
    ELSE
        ASSIGN dt-chegada = historico-embarque.dt-ult-previsao.

    ASSIGN p-dias-total = (dt-chegada - dt-inicio).
    
    IF p-dias-total < 0 THEN
        ASSIGN p-dias-total = 0.

end PROCEDURE.

procedure atualSitEmb:
    /* Procedure criada para atualizar a situacao do embarque, quando ‚ eliminado o ultimo 
    ** ponto de controle que nÆo est  efetiva, e alterar a situacao do embarque-imp para
    ** Encerrado.
    */
    def input parameter p-cod-estabel like historico-embarque.cod-estabel no-undo.
    def input parameter p-embarque    like historico-embarque.embarque    no-undo.

    if not can-find(first historico-embarque 
                        where historico-embarque.cod-estabel = p-cod-estabel 
                          and historico-embarque.embarque    = p-embarque    
                          and historico-embarque.dt-efetiva  = ?) then do:

         find first embarque-imp  
              where embarque-imp.cod-estabel = p-cod-estabel 
                and embarque-imp.embarque    = p-embarque exclusive-lock no-error.
         
         if avail embarque-imp then
             assign embarque-imp.situacao = 2.
         else 
             return "NOK":U.

    end.
    else 
        return "NOK":U.

    return "OK":U.
end procedure.

procedure verificaPontosDisponiveis:

    define input parameter p-cod-estabel     as character no-undo.
    define input parameter p-embarque        as character no-undo.
    define input parameter p-num-seq         as integer   no-undo.
    define input parameter p-cdn-pto-control as integer   no-undo.
    define input parameter p-seq-anterior    as integer   no-undo.
    define input parameter p-ponto-anterior  as integer   no-undo.
    define input parameter p-seq-posterior   as integer   no-undo.
    define input parameter p-ponto-posterior as integer   no-undo.
    define output parameter i-seq-encontrada as integer   no-undo.
    define output parameter table for tt-bo-erro.

    
    DEFINE VAR i-seq-anterior-emb  AS INTEGER            NO-UNDO.
    DEFINE VAR i-pto-anterior-emb  AS INTEGER            NO-UNDO.
    DEFINE VAR qr-tt               AS HANDLE             NO-UNDO.
    DEFINE VAR i-seq-erro          AS INTEGER            NO-UNDO.
    DEFINE VAR c-lit-trad-msg      AS CHARACTER          NO-UNDO.
    DEFINE VAR c-lit-trad-help     AS CHARACTER          NO-UNDO.
    DEFINE VAR c-lit-trad-help-aux AS CHARACTER          NO-UNDO.

    EMPTY TEMP-TABLE tt-bo-erro.
    EMPTY TEMP-TABLE tt-hist-emb-di.

    CREATE QUERY qr-tt.
    qr-tt:SET-BUFFERS(BUFFER tt-hist-emb-di:HANDLE). 
    qr-tt:QUERY-PREPARE("FOR EACH tt-hist-emb-di").
    qr-tt:QUERY-OPEN.
    
    
    /* Logica para verificar se o embarque possui a mesma ordem que os pontos controles da DI */
    FOR EACH historico-embarque
           WHERE historico-embarque.cod-estabel   = p-cod-estabel       
             AND historico-embarque.embarque      = p-embarque NO-LOCK:    
    
            CREATE tt-hist-emb-di.
            ASSIGN tt-hist-emb-di.cod-estabel   = historico-embarque.cod-estabel
                   tt-hist-emb-di.embarque      = historico-embarque.embarque
                   tt-hist-emb-di.sequencia     = historico-embarque.sequencia
                   tt-hist-emb-di.cod-pto-contr = historico-embarque.cod-pto-contr.
    END.

    IF p-seq-anterior <> 0 THEN DO:
        REPEAT:
            /*Posicionar no ponto anterior DI */
            qr-tt:GET-NEXT().
            IF AVAIL tt-hist-emb-di AND tt-hist-emb-di.cod-pto-contr = p-ponto-anterior THEN LEAVE.
            IF qr-tt:QUERY-OFF-END THEN DO:
                
                {utp/ut-liter.i Ponto_de_controle}
                ASSIGN c-lit-trad-help-aux = RETURN-VALUE.
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 33243,
                                   INPUT RETURN-VALUE).
                ASSIGN c-lit-trad-msg = RETURN-VALUE.
        
                
                {utp/ut-liter.i existente_na_DI_(sequencia_anterior_ao_que_est _sendo_incluso)_nÆo_foi_encontrado_no_embarque}
                ASSIGN c-lit-trad-help = c-lit-trad-help-aux + ": " + string(p-ponto-anterior) + " " + return-value + ": " + p-embarque.
    
                {utp/ut-liter.i Por_poder_causar_divergˆncias_e_inconsistˆncias_entre_embarques_e_DI's_o_ponto_de_controle/sequencia_nÆo_pode_ser_incluso}
    
                CREATE tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro + 1
                       tt-bo-erro.cd-erro      = 33243
                       tt-bo-erro.mensagem     = c-lit-trad-msg.
                       tt-bo-erro.errorhelp    = c-lit-trad-help + CHR(10) + RETURN-VALUE .
    
                
                RETURN "NOK":U.
            END. 
        END.
        ASSIGN  i-seq-anterior-emb = tt-hist-emb-di.sequencia.
        /*Posicionar no ponto posterior DI */
        qr-tt:GET-NEXT().
    END.
    ELSE DO:
        /*Quando eh o primeiro ponto da DI, nao necessariamente sera o primeiro ponto do embarque
          Por isso necessario posicionar no ponto posterior*/
        REPEAT:
            qr-tt:GET-NEXT().
            IF AVAIL tt-hist-emb-di AND tt-hist-emb-di.cod-pto-contr = p-ponto-posterior THEN DO:
                
                qr-tt:GET-PREV().
                IF AVAIL tt-hist-emb-di THEN 
                    ASSIGN i-seq-anterior-emb = tt-hist-emb-di.sequencia
                           i-pto-anterior-emb = tt-hist-emb-di.cod-pto-contr.
                qr-tt:GET-NEXT().
                LEAVE.
            END.
            IF qr-tt:QUERY-OFF-END THEN DO:
                    
                    {utp/ut-liter.i Ponto_de_controle}
                    ASSIGN c-lit-trad-help-aux = RETURN-VALUE.
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 33243,
                                       INPUT RETURN-VALUE).
                    ASSIGN c-lit-trad-msg = RETURN-VALUE.
            
                    
                    {utp/ut-liter.i existente_na_DI_(sequencia_posterior_ao_que_est _sendo_incluso)_nÆo_foi_encontrado_no_embarque}
                    ASSIGN c-lit-trad-help = c-lit-trad-help-aux + ": " + string(p-ponto-anterior) + " " + return-value + ": " + p-embarque.
        
                    {utp/ut-liter.i Por_poder_causar_divergˆncias_e_inconsistˆncias_entre_embarques_e_DI's_o_ponto_de_controle/sequencia_nÆo_pode_ser_incluso}
        
                    CREATE tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro + 1
                           tt-bo-erro.cd-erro      = 33243
                           tt-bo-erro.mensagem     = c-lit-trad-msg.
                           tt-bo-erro.errorhelp    = c-lit-trad-help + CHR(10) + RETURN-VALUE .
        
                    
                    RETURN "NOK":U.
            END. 
        END.
    END.

    
    IF p-seq-posterior <> 0
    OR (p-seq-posterior = 0 AND AVAIL tt-hist-emb-di)  THEN DO:
        
        IF  AVAIL tt-hist-emb-di
        AND tt-hist-emb-di.cod-pto-contr = p-ponto-posterior THEN DO:
            
            /* Verificar se a Sequencia da DI serve para os embarques, se nao procurar uma disponivel */
            IF  p-num-seq > i-seq-anterior-emb
            AND p-num-seq < tt-hist-emb-di.sequencia THEN
                ASSIGN i-seq-encontrada = p-num-seq.
            ELSE DO:
                ASSIGN i-seq-encontrada = i-seq-anterior-emb.
    
                REPEAT:
                    ASSIGN i-seq-encontrada = i-seq-encontrada + 1.
                    IF  i-seq-encontrada > i-seq-anterior-emb
                    AND i-seq-encontrada < tt-hist-emb-di.sequencia THEN LEAVE.
                    
                    IF i-seq-encontrada = tt-hist-emb-di.sequencia THEN DO:
                        
                        {utp/ut-liter.i Sequencia}
                        RUN utp/ut-msgs.p (INPUT "msg":U,
                                           INPUT 33243,
                                           INPUT RETURN-VALUE).
                        ASSIGN c-lit-trad-msg = RETURN-VALUE.
    
                        {utp/ut-liter.i NÆo_existe_uma_sequencia_disponivel_no_embarque}
                        ASSIGN c-lit-trad-help = RETURN-VALUE + ": " + p-embarque.
                        {utp/ut-liter.i entre_os_pontos_de_controle}

                        IF p-ponto-anterior = 0 THEN
                            ASSIGN c-lit-trad-help = c-lit-trad-help + RETURN-VALUE + ": " +  string(i-pto-anterior-emb) + " e: " + string(p-ponto-posterior).
                        ELSE
                            ASSIGN c-lit-trad-help = c-lit-trad-help + RETURN-VALUE + ": " +  string(p-ponto-anterior) + " e: " + string(p-ponto-posterior).

    
                        {utp/ut-liter.i Por_poder_causar_divergˆncias_e_inconsistˆncias_entre_embarques_e_DI's_o_ponto_de_controle/sequencia_nÆo_pode_ser_incluso}
    
                        CREATE tt-bo-erro.
                        assign tt-bo-erro.i-sequen     = i-seq-erro + 1
                               tt-bo-erro.cd-erro      = 33243
                               tt-bo-erro.mensagem     = c-lit-trad-msg.
                               tt-bo-erro.errorhelp    = c-lit-trad-help + CHR(10) + RETURN-VALUE .
    
    
                        RETURN "NOK".
                    END.
                END.
            END.
        END.
        ELSE DO:
            
            {utp/ut-liter.i "Ponto_de_controle"}
            ASSIGN c-lit-trad-help-aux = RETURN-VALUE.
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 33243,
                               INPUT RETURN-VALUE).
            ASSIGN c-lit-trad-msg = RETURN-VALUE.
    
            {utp/ut-liter.i existente_na_DI_(posterior_a_sequencia_que_est _sendo_inclusa)_nÆo_foi_encontrado_ou_nÆo_est _respeitando_a_ordem_do_embarque}
            ASSIGN c-lit-trad-help = c-lit-trad-help-aux + ": " + string(p-ponto-posterior) + CHR(10) + return-value + ": " + p-embarque.
    
            {utp/ut-liter.i Por_poder_causar_divergˆncias_e_inconsistˆncias_entre_embarques_e_DI's_o_ponto_de_controle/sequencia_nÆo_pode_ser_incluso}
    
            CREATE tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro + 1
                   tt-bo-erro.cd-erro      = 33243
                   tt-bo-erro.mensagem     = c-lit-trad-msg.
                   tt-bo-erro.errorhelp    = c-lit-trad-help + CHR(10) + RETURN-VALUE.
    
    
            RETURN "NOK":U.
        END.
    END.
    ELSE
        /* se for o ultimo ponto do embarque */
        ASSIGN i-seq-encontrada = i-seq-anterior-emb + 10.
    
    
    qr-tt:QUERY-CLOSE().
    DELETE OBJECT qr-tt. 

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE setRecalcula:
    DEFINE INPUT  PARAMETER pl-recalcula               AS LOGICAL     NO-UNDO.
    
    ASSIGN l-recalcula = pl-recalcula.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-verifica-pto-contr:
/*------------------------------------------------------------------------------------------
Purpose:    Verifica se o ponto de controle existe. Se nÆo existir cria um novo.
Parameters: 
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-bocx110 AS HANDLE NO-UNDO.
    DEFINE VARIABLE r-rowid   AS ROWID  NO-UNDO.
    
    ASSIGN l-criou-pto = NO.

    if not valid-handle(h-bocx110) then
        run cxbo/bocx110.p persistent set h-bocx110.
        
    run findCodigo in h-bocx110 (input rowObject.cod-pto-contr,
                                 output c-return).
    if c-return <> "":U then do:
        empty temp-table tt-pto-contr.
        create tt-pto-contr.
        assign tt-pto-contr.cod-pto-contr = rowObject.cod-pto-contr
               tt-pto-contr.descricao     = rowObject.descricao.
        run validateCreate in h-bocx110 (input table tt-pto-contr,
                                         output table tt-bo-erro append,
                                         output r-rowid).
        IF NOT CAN-FIND(FIRST tt-bo-erro)
                        AND CAN-FIND(FIRST pto-contr
                                     WHERE pto-contr.cod-pto-contr = RowObject.cod-pto-contr) THEN
            ASSIGN l-criou-pto = YES.
    end.
        

    RETURN "OK":U.
END PROCEDURE. 

PROCEDURE pi-deleta-pto-contr:
/*------------------------------------------------------------------------------------------
Purpose:    Verifica se o ponto de controle existe e deleta.
Parameters: 
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-pto-contr AS INTEGER     NO-UNDO.

    FOR FIRST pto-contr EXCLUSIVE-LOCK
        WHERE pto-contr.cod-pto-contr = pi-pto-contr:
        DELETE pto-contr.
    END.

    RETURN "OK":U.
END PROCEDURE. 

PROCEDURE pi-atualiza-despesas:
/*------------------------------------------------------------------------------------------
Purpose: Mover as despesas do processo de exporta‡Æo caso o c¢digo ou sequˆncia dos pontos de controle tenham sido alterados.
Parameters: 
Notes: 
------------------------------------------------------------------------------------------*/
    for first {&table-name} no-lock
        where rowid({&table-name}) = RowObject.r-rowid:
        if RowObject.cod-pto-contr <> {&table-name}.cod-pto-contr then do:
            for each desp-embarque exclusive-lock
               where desp-embarque.cod-estabel   = RowObject.cod-estabel
                 and desp-embarque.embarque      = RowObject.embarque
                 and desp-embarque.cod-itiner    = RowObject.cod-itiner
                 and desp-embarque.cod-pto-contr = {&table-name}.cod-pto-contr:
                assign desp-embarque.cod-pto-contr = RowObject.cod-pto-contr.
            end. 
        end.
    end.

    RETURN "OK":U.
END PROCEDURE. 

PROCEDURE pi-atualiza-declaracoes:
/*------------------------------------------------------------------------------------------
Purpose: Mover as declara‡äes do processo de exporta‡Æo caso o c¢digo ou sequˆncia dos pontos de controle tenham sido alterados.
Parameters: 
Notes: 
------------------------------------------------------------------------------------------*/
    for first {&table-name} no-lock
        where rowid({&table-name}) = RowObject.r-rowid:
        if (RowObject.cod-pto-contr <> {&table-name}.cod-pto-contr) or (RowObject.sequencia <> {&table-name}.sequencia) then do:
            for each decl-hist-embarq-imp exclusive-lock
               where decl-hist-embarq-imp.cod-estabel   = RowObject.cod-estabel
                 and decl-hist-embarq-imp.embarque      = RowObject.embarque
                 and decl-hist-embarq-imp.cod-itiner    = RowObject.cod-itiner
                 and decl-hist-embarq-imp.sequencia     = {&table-name}.sequencia:
                assign decl-hist-embarq-imp.sequencia = RowObject.sequencia.
            end.
        end.
    end.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setRecord:
/*------------------------------------------------------------------------------------------
Purpose: Seta a RowObject.
Parameters: 
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR RowObjectAux.
    FOR EACH RowObject:
        DELETE RowObject.
    END.
    FOR FIRST RowObjectAux:
        CREATE RowObject.
        BUFFER-COPY RowObjectAux TO RowObject.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-atualiza-embarque:
/*------------------------------------------------------------------------------------------
Purpose: Atualiza o c¢digo dos pontos de controle obrigat¢rios na tabela embarque-imp.
Parameters: 
Notes: 
------------------------------------------------------------------------------------------*/

    FOR FIRST embarque-imp EXCLUSIVE-LOCK
        WHERE embarque-imp.cod-estabel = RowObject.cod-estabel
          AND embarque-imp.embarque = RowObject.embarque,
        FIRST historico-embarque 
        WHERE ROWID(historico-embarque) = RowObject.r-rowid NO-LOCK:
        IF AVAIL {&table-name} THEN DO:
            CASE {&table-name}.cod-pto-contr:
                WHEN embarque-imp.cdn-pto-despch THEN DO:
                    ASSIGN embarque-imp.cdn-pto-despch = RowObject.cod-pto-contr.
                END.
                WHEN embarque-imp.cdn-pto-embarq THEN DO:
                    ASSIGN embarque-imp.cdn-pto-embarq = RowObject.cod-pto-contr.
                END.
                WHEN embarque-imp.cdn-pto-desembar THEN DO:
                    ASSIGN embarque-imp.cdn-pto-desembar = RowObject.cod-pto-contr.
                END.
                WHEN embarque-imp.cdn-pto-chegad THEN DO:
                    ASSIGN embarque-imp.cdn-pto-chegad = RowObject.cod-pto-contr.
                END.
            END CASE.

            /* ponto eadi */
            IF {&table-name}.cod-pto-contr = INT(TRIM(SUBSTRING(embarque-imp.char-1,81,5))) THEN
                ASSIGN OVERLAY(embarque-imp.char-1,81,5) = STRING(RowObject.cod-pto-contr).

            /* ponto recebimento */
            IF {&table-name}.cod-pto-contr = INT(TRIM(SUBSTRING(embarque-imp.char-1,86,5))) THEN
                ASSIGN OVERLAY(embarque-imp.char-1,86,5) = STRING(RowObject.cod-pto-contr).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE getFieldErrors:
/*------------------------------------------------------------------------------------------
Purpose: Retornar uma temp-table com informa‡äes dos erros ocorridos durante altera‡Æo/cria‡Æo.
Parameters:  (output) (temp-table) tt-campo-erro: Nome do campo em que ocorreu o erro.
Notes: 
------------------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER TABLE FOR tt-campo-erro.

   RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-recalcula-dt-ult-prev:
/*------------------------------------------------------------------------------------------
Purpose: Atualiza dt de previsÆo de acordo com o nr-dias informado pelo usu rio. (Se marcado para recalcular data prev)
Parameters:  
Notes:   A procedure assume que a RowObject estar  posicionada
------------------------------------------------------------------------------------------*/
    for each b-historico-embarque exclusive-lock
       where b-historico-embarque.cod-estabel = rowObject.cod-estabel
         and b-historico-embarque.embarque = rowObject.embarque
         and b-historico-embarque.cod-itiner  = rowObject.cod-itiner
         and b-historico-embarque.sequencia   > rowObject.sequencia: /* ao inserir um ponto de controle, se o sistema olha os pontos anteriores,  */
                                                                     /*o recálculo da nova data de previsão dos pontos a partir do ponto novo inserido, fica incorreto*/

         IF b-historico-embarque.dt-efetiva <> ? THEN NEXT.
         
         /* posiciona na sequˆncia anterior */
         for last b-historico-embarque2 fields(dt-ult-previsao dt-efetiva nr-dias sequencia LOG-1) no-lock
            where b-historico-embarque2.cod-estabel = rowObject.cod-estabel
              and b-historico-embarque2.embarque = rowObject.embarque
              and b-historico-embarque2.cod-itiner  = rowObject.cod-itiner
              and b-historico-embarque2.sequencia  < b-historico-embarque.sequencia:
             /* IF b-historico-embarque2.log-1 = YES  THEN DO: /* garantia que s¢ recalcule se o ponto est  para recalcular */ */
                 IF b-historico-embarque2.dt-efetiva <> ? THEN 
                    assign b-historico-embarque.dt-ult-previsao = b-historico-embarque2.dt-efetiva + b-historico-embarque.nr-dias.
                 ELSE
                    assign b-historico-embarque.dt-ult-previsao = b-historico-embarque2.dt-ult-previsao + b-historico-embarque.nr-dias.
             /* END. */
        end.
    end.
    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-verifica-decl-emitida:
    /****
    ** Verifica se o ponto de controle possui alguma declara‡Æo emitida. 
    *****/
    DEFINE INPUT  PARAMETER pc-cod-estabel AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-embarque    AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-itiner  AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pi-sequencia   AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER l-existe-decl AS LOGICAL     NO-UNDO.

    /* Ponto possui declara‡Æo emitida -> nÆo pode ser alterado */
    ASSIGN l-existe-decl = CAN-FIND(FIRST decl-hist-embarq-imp
                                    WHERE decl-hist-embarq-imp.cod-estabel = pc-cod-estabel
                                      AND decl-hist-embarq-imp.embarque = pc-embarque
                                      AND decl-hist-embarq-imp.cod-itiner = pi-cod-itiner
                                      AND decl-hist-embarq-imp.sequencia = pi-sequencia
                                      AND decl-hist-embarq-imp.decl-emitida). 

    RETURN "OK":U.
END PROCEDURE.

/* BOCX200.I1 */

