/**********************************************************
**  BOCX195B.i - Carrega a tt-proc-ped-ent   
**
**********************************************************/

DEFINE VAR h-bocx195        as handle              no-undo.
DEFINE VAR i-nr-entrega     as integer             no-undo.
DEFINE var i-cont           as INTEGER             no-undo.
DEFINE var l-vers           as logical initial no  no-undo.
DEFINE VAR i-nr-sequencia   as integer             no-undo.
DEFINE VAR hShowMsg         AS HANDLE              NO-UNDO.

DEF VAR c-it-codigo-ini    AS CHAR INITIAL ""                  NO-UNDO.
DEF VAR c-it-codigo-fim    AS CHAR INITIAL "99999999999999999" NO-UNDO.
DEF VAR l-aberto           AS LOGICAL INITIAL YES              NO-UNDO.
DEF VAR l-aloc-parc-emb    AS LOGICAL INITIAL YES              NO-UNDO.
DEF VAR l-aloc-tot-emb     AS LOGICAL INITIAL YES              NO-UNDO.
DEF VAR l-faturado-parcial AS LOGICAL INITIAL YES              NO-UNDO.
DEF VAR l-faturado-total   AS LOGICAL INITIAL YES              NO-UNDO.
DEF VAR de-fator-conver    AS DECIMAL INITIAL 1                NO-UNDO.

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY tt-proc-ped-ent
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-proc-ped-ent

{cdp/cdcfgdis.i} /* Definicao de pre-processadores */
{cdp/cdcfgcex.i}

{method/dbotterr.i}

/************************* DEFiniá∆o das Temp-Table *********************************/

DEFINE TEMP-TABLE tt-proc-ped-ent NO-UNDO like proc-ped-ent
       field log-selec  as log init no
       field r-rowid    as rowid.

DEFINE TEMP-TABLE tt-proc-ped-ent-aux NO-UNDO like proc-ped-ent
       field r-rowid    as rowid.             

DEFINE TEMP-TABLE tt-proc-ped-ent-aux2 NO-UNDO like proc-ped-ent
       field r-rowid    as rowid.             

{cxbo/bocx195.i rowObject}

{include/boini.i}

&if defined(bf_dis_proc_ent) &then
      /*&if '{&ems_dbtype}' = 'progress' &then */
          /* Include i-epc200.i: Definicao Temp-Table tt-epc */
          {include/i-epc200.i "bocx195b"}
      /*&endif*/
&endif  

define buffer b-tt-proc-ped-ent for tt-proc-ped-ent.

&IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
    DEF VAR h-exapi        AS HANDLE NO-UNDO.
    DEF VAR de-tot-peso    AS DEC    NO-UNDO.
    DEF VAR de-tot-val     AS DEC    NO-UNDO.
    DEF VAR de-tot-qt      AS DEC    NO-UNDO.
    DEF VAR de-tot-cub-ped AS DEC    NO-UNDO.
    DEF VAR de-tot-cub-ent AS DEC    NO-UNDO.

    DEFINE TEMP-TABLE tt-ped-ent NO-UNDO like ped-ent
           USE-INDEX codigo
           field r-rowid    as rowid
           field log-select as logical init no.

    DEFINE TEMP-TABLE tt-ped-ent2 NO-UNDO like tt-ped-ent
           USE-INDEX codigo.
&ENDIF

&IF DEFINED (bf_comex206b-1) &THEN 
    DEF VAR h-bocx362      AS HANDLE  NO-UNDO.
    DEF VAR de-qt-atendida AS DECIMAL NO-UNDO.
&ENDIF

 /*Convers∆o do valor do volume do item*/
 FOR FIRST para-dis NO-LOCK:
     /*Unidade de Medida da Convers∆o 1 = Cent°metros 2 = Metros*/
     IF para-dis.int-1 = 1 THEN
         ASSIGN de-fator-conver = 0.000001.
     ELSE
         ASSIGN de-fator-conver = 1.
 END.

DEFINE QUERY {&QUERY-NAME} for tt-proc-ped-ent scrolling.


procedure setConstraint2:

    def input parameter r-chave as rowid no-undo.
    find processo-exp no-lock
         where rowid(processo-exp) = r-chave no-error.

end procedure.

procedure openQuery:

    define input parameter i-abertura as integer no-undo.
    assign l-query = yes.    
    
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.log-selec = no no-lock by {&TABLE-NAME}.nr-sequencia
            &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
                &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
                    BY {&table-name}.ind-componen
                &ELSE
                    BY {&table-name}.int-1
                &ENDIF
            &ENDIF .
    end case.

end procedure.

{include/bostrmet.i}
{include/boendmet.i}
&if defined(bf-dis-comex) &then    
&else
    {include/bocomver.i}
    {include/bogetver.i}
&endif
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
/*{include/bosersen.i}*/
{include/boprebro.i}


procedure initializeValidate:
    /*
    **  Inicializa Validate
    */

    run startMethod ("initializeValidade").

    run endMethod   ("initializeValidade").

End procedure.

PROCEDURE verificaTemplate:
/*verifica qual template est† chamando a BO, se "no" = cliente/servidor,
  se "yes" = WEB */

   define input parameter l-versao as logical.
   
   assign l-vers = l-versao.
END.

PROCEDURE serverSendRows :

    /*
    **  Disponivel no smart data object da V9, e foi reimplementado dentro
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query
    **  e facilitara a migracao destes programas para os Smart Data Objects.
    **
    **  Foi customizada a serverSendRows para verificar por qual template est†
    **  sendo executada, pois o browse dos programa wex0195b e wex0195ab, n∆o
    **  funcionavam corretamente utilizando o rowid({&table-name}) para isso 
    **  foi feita essa condiá∆o no momento da rowobject receber o rowid. 
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
            if available({&first-table-in-query}) and piRowsReturned < piRowsToReturn then do:
                create rowObject.
                buffer-copy {&table-name} to rowObject.

                &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN                       
                    for first ped-item fields(ind-componen) 
                        WHERE ped-item.nome-abrev   = {&table-name}.nome-abrev  
                          AND ped-item.nr-pedcli    = {&table-name}.nr-pedcli   
                          AND ped-item.nr-sequencia = {&table-name}.nr-sequencia
                          AND ped-item.it-codigo    = {&table-name}.it-codigo   
                          AND ped-item.cod-refer    = {&table-name}.cod-refer    no-lock:  
                    end.                                                         
                    if avail ped-item then                                       
                    &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN                  
                       assign rowObject.ind-componen  = ped-item.ind-componen.   
                    &ELSE                                                        
                       assign rowObject.int-1 = ped-item.ind-componen.           
                    &ENDIF                                                       
                &ENDIF   

                /* se l-vers = YES, a BO Ç chamada pela web, se l-vers = NO Ç chamada pelo cliente/servidor */
                if l-vers then
                    assign rowobject.r-rowid = {&table-name}.r-rowid.
                else 
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

PROCEDURE verifica-procPedEnt:
 /*verifica se h† entregas para esse processo*/

    DEF INPUT PARAM c-cod-estabel AS CHAR NO-UNDO.
    DEF INPUT PARAM c-nr-proc-exp AS CHAR NO-UNDO.
    DEF OUTPUT PARAM l-existe     AS LOG NO-UNDO.
    
    ASSIGN l-existe = CAN-FIND (FIRST proc-ped-ent
                                WHERE proc-ped-ent.cod-estabel = c-cod-estabel
                                AND   proc-ped-ent.nr-proc-exp = c-nr-proc-exp).
        
    RETURN "OK":U.
           
END PROCEDURE.

PROCEDURE carregaTempTableProcPedEnt:

    DEF input parameter table for tt-proc-ped-ent-aux.
    DEF input parameter numrows   as char  no-undo. 
    DEF input parameter r-chave   as rowid no-undo.
    def var l-clientServer as log no-undo.

    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
        &IF DEFINED(bf_comex206b-1) = 0 &THEN
            RUN exp/exapi010.p PERSISTENT SET h-exapi.
        &ENDIF
        FOR EACH tt-ped-ent EXCLUSIVE-LOCK:

            &IF DEFINED(bf_comex206b-1) = 0 &THEN
                {exp/exapi010.i1 tt-ped-ent}
            &ENDIF

            FOR EACH tt-ped-ent2 EXCLUSIVE-LOCK.
                DELETE tt-ped-ent2.
            END.

            CREATE tt-ped-ent2.
            BUFFER-COPY tt-ped-ent TO tt-ped-ent2.
        /*Para o ambiente h°dribo Ç superiores as despesas n∆o s∆o mais retiradas do processo de exportaá∆o,
        pois as despesas do pedido ser∆o utilizadas somente como default para o processo*/
        &if defined(bf_comex206b-1) &then
        &else
            RUN RetiraProcdespItiner IN h-exapi (INPUT TABLE tt-ped-ent2,
                                                 INPUT de-tot-peso,
                                                 INPUT de-tot-val,
                                                 INPUT de-tot-qt,
                                                 INPUT de-tot-cub-ped,
                                                 INPUT de-tot-cub-ent,
                                                 INPUT r-chave).
        &ENDIF
        END.
        &IF DEFINED(bf_comex206b-1) = 0 &THEN
            DELETE PROCEDURE h-exapi.
        &ENDIF
        FOR EACH tt-ped-ent EXCLUSIVE-LOCK.
            DELETE tt-ped-ent.
        END.
    &ENDIF                   
    
    for each rowObject:
        delete rowObject.
    end.
    /***Na posiá∆o 10 Ç passado um caracter qualquer que ser† gravado quando a bo
        for chamada pelo cliente servidor, para que a procedure seja utilizado 
        na web e no cliente sevidor***/ 
    if substr(numrows,10,1) <> " " then do:
        assign substr(numrows,10,1) = ""
               l-clientServer       = yes.
    end.
  
    if l-clientServer then do:
        find first tt-proc-ped-ent-aux NO-LOCK no-error.
        if not avail tt-proc-ped-ent-aux then
            run carregaTTProcPedEnt (input r-chave).
    end.
    else run carregaTTProcPedEnt (input r-chave).
    
    find first tt-proc-ped-ent-aux NO-LOCK no-error.
    if avail tt-proc-ped-ent-aux then do:
       RUN cxbo/bocx195.p persistent set h-bocx195.
       run deleteSelectRegistro (input table tt-proc-ped-ent-aux, 
                                 input numrows).
       
       IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
       
       delete procedure h-bocx195.
       for each tt-proc-ped-ent-aux NO-LOCK:
           &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
              find FIRST b-tt-proc-ped-ent EXCLUSIVE-LOCK 
                   where b-tt-proc-ped-ent.nr-sequencia = tt-proc-ped-ent.nr-sequencia
                     AND b-tt-proc-ped-ent.it-codigo    = tt-proc-ped-ent.it-codigo no-error.
              if avail b-tt-proc-ped-ent then 
                  assign b-tt-proc-ped-ent.log-selec = yes.     
           &ELSE
              find b-tt-proc-ped-ent EXCLUSIVE-LOCK 
                   where b-tt-proc-ped-ent.nr-sequencia = tt-proc-ped-ent.nr-sequencia no-error.
              if avail b-tt-proc-ped-ent then 
                  assign b-tt-proc-ped-ent.log-selec = yes.     
           &ENDIF 
       end.     /* bloco do for  */ 

    end.    /* if tt-proc-ped-ent-aux  */

END PROCEDURE.

PROCEDURE carregattprocpedentaux:
   /* Criaá∆o da tt-proc-ped-ent-aux com os registros a serem relacionados ao 
      embarque */
    def input  parameter i-sequencia  as integer no-undo.
    def input  parameter i-nr-entrega as integer no-undo.
    def output parameter table for tt-proc-ped-ent-aux.


    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
        DEFINE BUFFER btt-proc-ped-ent FOR tt-proc-ped-ent.

        find FIRST tt-proc-ped-ent where 
           tt-proc-ped-ent.nr-sequencia = i-sequencia and
           tt-proc-ped-ent.nr-entrega   = i-nr-entrega  NO-LOCK no-error.

        if avail tt-proc-ped-ent then do:

            &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
            IF tt-proc-ped-ent.ind-componen = 3 THEN DO:
            &ELSE
            IF tt-proc-ped-ent.int-1 = 3 THEN DO:
            &ENDIF
                FIND FIRST btt-proc-ped-ent
                     WHERE btt-proc-ped-ent.cod-estabel  = tt-proc-ped-ent.cod-estabel 
                       AND btt-proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent.nr-proc-exp 
                       AND btt-proc-ped-ent.nome-abrev   = tt-proc-ped-ent.nome-abrev  
                       AND btt-proc-ped-ent.nr-pedcli    = tt-proc-ped-ent.nr-pedcli   
                       AND btt-proc-ped-ent.nr-sequencia = tt-proc-ped-ent.nr-sequencia
                       AND &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
                           btt-proc-ped-ent.ind-componen = 2
                           &ELSE
                           btt-proc-ped-ent.int-1        = 2
                           &ENDIF
                           NO-LOCK NO-ERROR.
                IF AVAIL btt-proc-ped-ent THEN DO:
                    FIND FIRST tt-proc-ped-ent-aux
                         WHERE tt-proc-ped-ent-aux.cod-estabel  = btt-proc-ped-ent.cod-estabel 
                           AND tt-proc-ped-ent-aux.nr-proc-exp  = btt-proc-ped-ent.nr-proc-exp 
                           AND tt-proc-ped-ent-aux.nome-abrev   = btt-proc-ped-ent.nome-abrev  
                           AND tt-proc-ped-ent-aux.nr-pedcli    = btt-proc-ped-ent.nr-pedcli   
                           AND tt-proc-ped-ent-aux.nr-sequencia = btt-proc-ped-ent.nr-sequencia
                           AND tt-proc-ped-ent-aux.it-codigo    = btt-proc-ped-ent.it-codigo 
                           AND tt-proc-ped-ent-aux.cod-refer    = btt-proc-ped-ent.cod-refer  
                           AND tt-proc-ped-ent-aux.nr-entrega   = btt-proc-ped-ent.nr-entrega NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-proc-ped-ent-aux THEN DO:
                        create tt-proc-ped-ent-aux.
                        buffer-copy btt-proc-ped-ent to tt-proc-ped-ent-aux.
                        find FIRST ped-ent NO-LOCK
                             where ped-ent.nome-abrev   = btt-proc-ped-ent.nome-abrev
                               and ped-ent.nr-pedcli    = btt-proc-ped-ent.nr-pedcli
                               and ped-ent.nr-sequencia = btt-proc-ped-ent.nr-sequencia
                               and ped-ent.it-codigo    = btt-proc-ped-ent.it-codigo
                               and ped-ent.cod-refer    = btt-proc-ped-ent.cod-refer
                               and ped-ent.nr-entrega   = btt-proc-ped-ent.nr-entrega
                               no-error.
                        IF AVAIL ped-ent THEN DO:
                            CREATE tt-ped-ent.
                            BUFFER-COPY ped-ent TO tt-ped-ent.
                        END.
                    END.
                END.
            END.
            ELSE DO:
                FIND FIRST tt-proc-ped-ent-aux
                     WHERE tt-proc-ped-ent-aux.cod-estabel  = tt-proc-ped-ent.cod-estabel 
                       AND tt-proc-ped-ent-aux.nr-proc-exp  = tt-proc-ped-ent.nr-proc-exp 
                       AND tt-proc-ped-ent-aux.nome-abrev   = tt-proc-ped-ent.nome-abrev  
                       AND tt-proc-ped-ent-aux.nr-pedcli    = tt-proc-ped-ent.nr-pedcli   
                       AND tt-proc-ped-ent-aux.nr-sequencia = tt-proc-ped-ent.nr-sequencia
                       AND tt-proc-ped-ent-aux.it-codigo    = tt-proc-ped-ent.it-codigo 
                       AND tt-proc-ped-ent-aux.cod-refer    = tt-proc-ped-ent.cod-refer
                       AND tt-proc-ped-ent-aux.nr-entrega   = tt-proc-ped-ent.nr-entrega NO-LOCK NO-ERROR.
                IF NOT AVAIL tt-proc-ped-ent-aux THEN DO:
                    create tt-proc-ped-ent-aux.
                    buffer-copy tt-proc-ped-ent to tt-proc-ped-ent-aux.
                    find FIRST ped-ent NO-LOCK
                         where ped-ent.nome-abrev   = tt-proc-ped-ent.nome-abrev
                           and ped-ent.nr-pedcli    = tt-proc-ped-ent.nr-pedcli
                           and ped-ent.nr-sequencia = tt-proc-ped-ent.nr-sequencia
                           and ped-ent.it-codigo    = tt-proc-ped-ent.it-codigo
                           and ped-ent.cod-refer    = tt-proc-ped-ent.cod-refer
                           and ped-ent.nr-entrega   = tt-proc-ped-ent.nr-entrega
                           no-error.
                    IF AVAIL ped-ent THEN DO:
                        CREATE tt-ped-ent.
                        BUFFER-COPY ped-ent TO tt-ped-ent.
                    END.
                END.
            END.

            FOR EACH btt-proc-ped-ent
               WHERE btt-proc-ped-ent.cod-estabel  = tt-proc-ped-ent.cod-estabel 
                 AND btt-proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent.nr-proc-exp 
                 AND btt-proc-ped-ent.nome-abrev   = tt-proc-ped-ent.nome-abrev  
                 AND btt-proc-ped-ent.nr-pedcli    = tt-proc-ped-ent.nr-pedcli   
                 AND btt-proc-ped-ent.nr-sequencia = tt-proc-ped-ent.nr-sequencia
                 AND &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
                     btt-proc-ped-ent.ind-componen = 3
                     &ELSE
                     btt-proc-ped-ent.int-1        = 3
                     &ENDIF NO-LOCK:
                FIND FIRST tt-proc-ped-ent-aux
                     WHERE tt-proc-ped-ent-aux.cod-estabel  = btt-proc-ped-ent.cod-estabel 
                       AND tt-proc-ped-ent-aux.nr-proc-exp  = btt-proc-ped-ent.nr-proc-exp 
                       AND tt-proc-ped-ent-aux.nome-abrev   = btt-proc-ped-ent.nome-abrev  
                       AND tt-proc-ped-ent-aux.nr-pedcli    = btt-proc-ped-ent.nr-pedcli   
                       AND tt-proc-ped-ent-aux.nr-sequencia = btt-proc-ped-ent.nr-sequencia
                       AND tt-proc-ped-ent-aux.it-codigo    = btt-proc-ped-ent.it-codigo 
                       AND tt-proc-ped-ent-aux.cod-refer    = btt-proc-ped-ent.cod-refer   
                       AND tt-proc-ped-ent-aux.nr-entrega   = btt-proc-ped-ent.nr-entrega NO-LOCK NO-ERROR.
                IF NOT AVAIL tt-proc-ped-ent-aux THEN DO:
                    create tt-proc-ped-ent-aux.
                    buffer-copy btt-proc-ped-ent to tt-proc-ped-ent-aux.
                    find FIRST ped-ent NO-LOCK
                         where ped-ent.nome-abrev   = btt-proc-ped-ent.nome-abrev
                           and ped-ent.nr-pedcli    = btt-proc-ped-ent.nr-pedcli
                           and ped-ent.nr-sequencia = btt-proc-ped-ent.nr-sequencia
                           and ped-ent.it-codigo    = btt-proc-ped-ent.it-codigo
                           and ped-ent.cod-refer    = btt-proc-ped-ent.cod-refer
                           and ped-ent.nr-entrega   = btt-proc-ped-ent.nr-entrega
                           no-error.
                    IF AVAIL ped-ent THEN DO:
                        CREATE tt-ped-ent.
                        BUFFER-COPY ped-ent TO tt-ped-ent.
                    END.
                END.
            END.
        end.
    &ELSE
        find tt-proc-ped-ent where 
           tt-proc-ped-ent.nr-sequencia = i-sequencia and
           tt-proc-ped-ent.nr-entrega   = i-nr-entrega NO-LOCK no-error.
        if avail tt-proc-ped-ent then do:
             create tt-proc-ped-ent-aux.
             buffer-copy tt-proc-ped-ent to tt-proc-ped-ent-aux.
        end.
    &ENDIF

END.

PROCEDURE carregattprocpedentaux1:
   /* Criaá∆o da tt-proc-ped-ent-aux com os registros a serem relacionados ao 
      embarque */
    def input  parameter rowselect as char no-undo.
    def input  parameter numrows   as char no-undo.
    def output parameter table for tt-proc-ped-ent-aux.
    &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN
        def output parameter table for tt-bo-erro.

        FOR EACH tt-bo-erro:
            DELETE tt-bo-erro.
        END.
    
        ASSIGN i-nr-sequencia = 0.
    &ENDIF
    
    do i-cont = 1 to int(numrows):
       find proc-ped-ent NO-LOCK
             where rowid(proc-ped-ent) = to-rowid(entry(i-cont,rowselect)) no-error.
       if avail proc-ped-ent then do:
         &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN
            RUN validaPedEnt1 (INPUT-OUTPUT table tt-bo-erro).

            find first tt-bo-erro no-error.
            IF not avail tt-bo-erro THEN do:
         &ENDIF

         create tt-proc-ped-ent-aux.
         buffer-copy proc-ped-ent to tt-proc-ped-ent-aux.

         &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &THEN
            END.
         &ENDIF
       end.
    end.
END.


PROCEDURE deleteSelectRegistro:

    DEF input parameter table for tt-proc-ped-ent-aux.
    DEF input parameter numrows   as char  no-undo.
    def var             r-chave   as rowid no-undo.
    DEF VAR c-processo  AS CHAR NO-UNDO.
    DEF VAR l-encontrou AS LOG NO-UNDO.
    DEF BUFFER b-embarque FOR embarque.
    DEF VAR c-msg       AS CHAR NO-UNDO.
    DEF VAR c-emb       AS CHAR NO-UNDO.
    for each tt-proc-ped-ent-aux
        &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
            &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
            BY tt-proc-ped-ent-aux.ind-componen DESC
            &ELSE
            BY tt-proc-ped-ent-aux.int-1 DESC
            &ENDIF
        &ENDIF :
        
        ASSIGN c-processo = tt-proc-ped-ent-aux.nr-proc-exp.

        find proc-ped-ent exclusive-lock
            where  proc-ped-ent.cod-estabel  = tt-proc-ped-ent-aux.cod-estabel
              and  proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent-aux.nr-proc-exp
              and  proc-ped-ent.nome-abrev   = tt-proc-ped-ent-aux.nome-abrev
              and  proc-ped-ent.nr-pedcli    = tt-proc-ped-ent-aux.nr-pedcli
              and  proc-ped-ent.nr-sequencia = tt-proc-ped-ent-aux.nr-sequencia
              and  proc-ped-ent.it-codigo    = tt-proc-ped-ent-aux.it-codigo 
              and  proc-ped-ent.cod-refer    = tt-proc-ped-ent-aux.cod-refer
              and  proc-ped-ent.nr-entrega   = tt-proc-ped-ent-aux.nr-entrega no-error.
        if avail proc-ped-ent then do:

              FIND it-pre-fat WHERE
                   it-pre-fat.nome-abrev   = proc-ped-ent.nome-abrev   AND        
                   it-pre-fat.nr-pedcli    = proc-ped-ent.nr-pedcli    AND       
                   it-pre-fat.nr-sequencia = proc-ped-ent.nr-sequencia AND        
                   it-pre-fat.it-codigo    = proc-ped-ent.it-codigo    AND       
                   it-pre-fat.cod-refer    = proc-ped-ent.cod-refer    AND       
                   it-pre-fat.nr-entrega   = proc-ped-ent.nr-entrega   NO-LOCK NO-ERROR.
              IF AVAIL it-pre-fat THEN DO:        
                 find first embarque NO-LOCK                                          
                      where embarque.cdd-embarq = it-pre-fat.cdd-embarq no-error.   
                 if avail embarque THEN DO:                                           
                                                                                      
                    assign c-emb   = STRING(embarque.cdd-embarq)  
                           c-msg   = "O item " + trim(tt-proc-ped-ent-aux.it-codigo) + " possui alocaá∆o no embarque " + trim(c-emb) + ". Confirma a exclus∆o?".
                           
                    run utp/ut-msgs.p (input "show",                                  
                                       input 32699,                                   
                                       input c-msg).            
                    if return-value = 'no' then                                       
                       RETURN "NOK":U.                                                
                 END.                                                                 
              END.

              assign r-chave = rowid(proc-ped-ent).
              run validateDelete in h-bocx195 (input-output r-chave, 
                                               output table tt-bo-erro).
              assign r-chave = ?.
              
              FOR EACH tt-bo-erro:
                    RUN pi-cria-row-errors(INPUT tt-bo-erro.cd-erro,
              	                    	   INPUT tt-bo-erro.parametros,
              			    	           INPUT tt-bo-erro.mensagem).
              END.
              IF CAN-FIND(FIRST RowErrors) THEN DO:
                  
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal="yes"}

                    RETURN "NOK":U.
              END.
        end. /* if avail proc-ped-ent */
        &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
        find FIRST tt-proc-ped-ent 
             where tt-proc-ped-ent.nr-sequencia = tt-proc-ped-ent-aux.nr-sequencia
               AND tt-proc-ped-ent.it-codigo    = tt-proc-ped-ent-aux.it-codigo EXCLUSIVE-LOCK no-error.
        &ELSE
        find tt-proc-ped-ent where tt-proc-ped-ent.nr-sequencia = tt-proc-ped-ent-aux.nr-sequencia EXCLUSIVE-LOCK no-error.
        &ENDIF
        if avail tt-proc-ped-ent then 
              delete tt-proc-ped-ent.

    end.  /* for */  
    
    FOR EACH b-embarque NO-LOCK 
        &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN 
           WHERE b-embarque.nr-proc-exp = c-processo:  
        &ELSE                                      
           WHERE substring(b-embarque.char-1,2,12) = c-processo:                 
        &ENDIF  
        ASSIGN l-encontrou = NO.
        FOR EACH it-pre-fat OF b-embarque NO-LOCK:
            IF CAN-FIND(proc-ped-ent WHERE
               proc-ped-ent.nome-abrev   = it-pre-fat.nome-abrev   AND        
               proc-ped-ent.nr-pedcli    = it-pre-fat.nr-pedcli    AND       
               proc-ped-ent.nr-sequencia = it-pre-fat.nr-sequencia AND        
               proc-ped-ent.it-codigo    = it-pre-fat.it-codigo    AND       
               proc-ped-ent.cod-refer    = it-pre-fat.cod-refer    AND       
               proc-ped-ent.nr-entrega   = it-pre-fat.nr-entrega)  THEN
               ASSIGN l-encontrou = YES.
        END.
        IF NOT l-encontrou THEN DO:
           FIND embarque WHERE 
               ROWID(embarque) = ROWID(b-embarque) EXCLUSIVE-LOCK NO-ERROR.
           IF  AVAIL embarque THEN
               &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN 
                  ASSIGN  embarque.nr-proc-exp     = ""
                          embarque.cdn-tip-relacto = 1.
               &ELSE
                  ASSIGN OVERLAY(embarque.char-1,2,12) = ""
                         embarque.int-1                = 0.                  
               &ENDIF 
        END.
    END.


END. 


PROCEDURE carregaTTProcPedEnt:
    def input parameter r-chave   as rowid no-undo.  
   

    find proc-ped-venda no-lock
         where rowid(proc-ped-venda) = r-chave no-error.

    if avail proc-ped-venda then do:    

       find ped-venda no-lock
            where ped-venda.nome-abrev = proc-ped-venda.nome-abrev
              and ped-venda.nr-pedcli  = proc-ped-venda.nr-pedcli no-error.
              
       if avail ped-venda then do:          
          for each tt-proc-ped-ent:
              delete tt-proc-ped-ent.
          end.  
          for each proc-ped-ent no-lock
              where proc-ped-ent.cod-estabel  = proc-ped-venda.cod-estabel
              and   proc-ped-ent.nr-proc-exp  = proc-ped-venda.nr-proc-exp
              and   proc-ped-ent.nome-abrev   = proc-ped-venda.nome-abrev
              and   proc-ped-ent.nr-pedcli    = proc-ped-venda.nr-pedcli,
              first ped-ent no-lock
             where ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
               and ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli
               and ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia
               and ped-ent.it-codigo    = proc-ped-ent.it-codigo
               and ped-ent.cod-refer    = proc-ped-ent.cod-refer
               and ped-ent.nr-entrega   = proc-ped-ent.nr-entrega:
              create tt-proc-ped-ent.
              buffer-copy proc-ped-ent to tt-proc-ped-ent.
              assign tt-proc-ped-ent.r-rowid = rowid(proc-ped-ent).


              IF ped-ent.cod-sit-pre = 2 THEN
                ASSIGN overlay(tt-proc-ped-ent.char-1,1,1) = "1". /* alocado parcial embarque */
              ELSE
                  IF ped-ent.cod-sit-pre = 3 THEN
                      ASSIGN overlay(tt-proc-ped-ent.char-1,1,1) = "2". /* alocado total embarque */
              
              IF ped-ent.cod-sit-ent = 2 THEN
                  ASSIGN overlay(tt-proc-ped-ent.char-1,1,1) = "3". /* faturado parcial */
              ELSE
                  IF ped-ent.cod-sit-ent = 3 THEN
                      ASSIGN overlay(tt-proc-ped-ent.char-1,1,1) = "4". /* faturado total */
              
              IF ped-ent.cod-sit-pre = 1 THEN
                  ASSIGN overlay(tt-proc-ped-ent.char-1,1,1) = "5". /* aberto */
              
          end.  /* for each proc-ped-ent  */

       end.   /*  IF avail ped-venda */

    end.    /* if avail proc-ped-venda  */

END PROCEDURE.


PROCEDURE validaPedEnt:
    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
   /* Validar se a entrega j† foi atendida */
    def input  parameter i-sequencia  as integer no-undo.
    def input  parameter i-nr-entrega as integer no-undo.
    def output parameter table for tt-bo-erro.

    def var c-msg      as char no-undo.
    def var c-lista-re as char no-undo.

    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.

    ASSIGN i-nr-sequencia = 0.
    
    for each tt-epc 
       where tt-epc.cod-event = "VALIDA-ENTREGA": 
        delete tt-epc. 
    end. 
    
    {include/i-epc200.i2 &CodEvent='"VALIDA-ENTREGA"'
                         &CodParameter='"ENTREGA-FATURADA"'
                         &ValueParameter='"NO"' }

    {include/i-epc201.i "VALIDA-ENTREGA"}

    /* Chamada EPC inserida para os clientes que necessitam vincular/desvincular do processo de exportaá∆o entregas j† faturadas*/
    FIND FIRST tt-epc WHERE 
               tt-epc.cod-event = "VALIDA-ENTREGA" AND
               tt-epc.cod-parameter = "ENTREGA-FATURADA" AND
               tt-epc.val-parameter = "YES" NO-ERROR.
    IF NOT AVAIL tt-epc THEN DO:
        find FIRST tt-proc-ped-ent where 
           tt-proc-ped-ent.nr-sequencia = i-sequencia and
           tt-proc-ped-ent.nr-entrega   = i-nr-entrega NO-LOCK no-error.

        IF  AVAIL tt-proc-ped-ent AND 
            &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
                tt-proc-ped-ent.ind-componen = 3
            &ELSE
                tt-proc-ped-ent.int-1 = 3
            &ENDIF  THEN
            FIND FIRST tt-proc-ped-ent 
                 WHERE tt-proc-ped-ent.nr-sequencia = i-sequencia 
                   AND tt-proc-ped-ent.nr-entrega   = i-nr-entrega 
                   AND &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
                           tt-proc-ped-ent.ind-componen = 2 
                       &ELSE
                           tt-proc-ped-ent.int-1 = 2
                       &ENDIF 
            NO-LOCK NO-ERROR.

        IF AVAIL tt-proc-ped-ent THEN DO:
             &IF DEFINED(bf_comex206b-1) &THEN
                 IF  NOT VALID-HANDLE(h-bocx195) THEN
                     RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.

                 run calculaQuantidadeAtendida IN h-bocx195 (INPUT  tt-proc-ped-ent.cod-estabel,
                                                             INPUT  tt-proc-ped-ent.nr-proc-exp,  
                                                             INPUT  tt-proc-ped-ent.nome-abrev ,
                                                             INPUT  tt-proc-ped-ent.nr-pedcli  ,
                                                             INPUT  tt-proc-ped-ent.nr-sequencia ,
                                                             INPUT  tt-proc-ped-ent.it-codigo    ,
                                                             INPUT  tt-proc-ped-ent.cod-refer    ,
                                                             INPUT  tt-proc-ped-ent.nr-entrega ,
                                                             OUTPUT de-qt-atendida). 
                 IF VALID-HANDLE(h-bocx195) THEN DO:
                     DELETE PROCEDURE h-bocx195.
                     ASSIGN h-bocx195 = ?.
                 END.

                 IF de-qt-atendida <> 0 THEN DO:
             &ELSE
                 IF CAN-FIND (FIRST ped-ent 
                              WHERE ped-ent.nome-abrev    = tt-proc-ped-ent.nome-abrev 
                                AND ped-ent.nr-pedcli     = tt-proc-ped-ent.nr-pedcli 
                                AND ped-ent.nr-sequencia  = tt-proc-ped-ent.nr-sequencia 
                                AND ped-ent.it-codigo     = tt-proc-ped-ent.it-codigo 
                                AND ped-ent.cod-refer     = tt-proc-ped-ent.cod-refer 
                                AND ped-ent.nr-entrega    = tt-proc-ped-ent.nr-entrega
                                AND ped-ent.cod-sit-ent <> 1 ) THEN DO:
             &ENDIF
                 
                 assign i-seq-erro = i-seq-erro + 1.
                 run utp/ut-msgs.p (input "msg",
                                    input 28383,
                                    input "").
                 create tt-bo-erro.
                 assign tt-bo-erro.i-sequen     = i-seq-erro
                        tt-bo-erro.cd-erro      = 28383
                        tt-bo-erro.mensagem     = return-value.
             END.                        
        end.
    END.
    &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
        for first proces-acond-item fields(cod-acond)  no-lock
            where proces-acond-item.cod-estabel  = tt-proc-ped-ent.cod-estabel
              and proces-acond-item.nr-proc-exp  = tt-proc-ped-ent.nr-proc-exp
              and proces-acond-item.nome-abrev   = tt-proc-ped-ent.nome-abrev
              and proces-acond-item.nr-pedcli    = tt-proc-ped-ent.nr-pedcli
              and proces-acond-item.nr-sequencia = tt-proc-ped-ent.nr-sequencia
              and proces-acond-item.it-codigo    = tt-proc-ped-ent.it-codigo   
              and proces-acond-item.cod-refer    = tt-proc-ped-ent.cod-refer     
              and proces-acond-item.nr-entrega   = tt-proc-ped-ent.nr-entrega:  
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i "Item"}
            assign c-msg = trim(return-value) + ":" + tt-proc-ped-ent.it-codigo.
            run utp/ut-msgs.p (input "msg",
                               input 30647,
                               input c-msg + "~~" + proces-acond-item.cod-acond).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 30647
                   tt-bo-erro.mensagem     = return-value
                   tt-bo-erro.parametros   = c-msg + "~~" + proces-acond-item.cod-acond.
        end.                      
    
        if can-find(first proces-embal-volum no-lock
                    where proces-embal-volum.cod-estabel  = tt-proc-ped-ent.cod-estabel
                      and proces-embal-volum.nr-proc-exp  = tt-proc-ped-ent.nr-proc-exp
                      and proces-embal-volum.nome-abrev   = tt-proc-ped-ent.nome-abrev
                      and proces-embal-volum.nr-pedcli    = tt-proc-ped-ent.nr-pedcli
                      and proces-embal-volum.nr-sequencia = tt-proc-ped-ent.nr-sequencia
                      and proces-embal-volum.it-codigo    = tt-proc-ped-ent.it-codigo   
                      and proces-embal-volum.cod-refer    = tt-proc-ped-ent.cod-refer     
                      and proces-embal-volum.nr-entrega   = tt-proc-ped-ent.nr-entrega) then do:  
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i "Item"}
            assign c-msg = trim(return-value) + ":" + tt-proc-ped-ent.it-codigo.
            run utp/ut-msgs.p (input "msg",
                               input 30516,
                               input c-msg).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 30516
                   tt-bo-erro.mensagem     = return-value
                   tt-bo-erro.parametros   = c-msg.
        end.         
        assign c-lista-re = "".
        for each  reg-export-item fields(nr-re-ems) no-lock
            where reg-export-item.cod-estabel  =  tt-proc-ped-ent.cod-estabel
              and reg-export-item.nr-proc-exp  =  tt-proc-ped-ent.nr-proc-exp
              and reg-export-item.nome-abrev   =  tt-proc-ped-ent.nome-abrev
              and reg-export-item.nr-pedcli    =  tt-proc-ped-ent.nr-pedcli
              and reg-export-item.num-seq      =  tt-proc-ped-ent.nr-sequencia
              and reg-export-item.it-codigo    =  tt-proc-ped-ent.it-codigo
              and reg-export-item.cod-refer    =  tt-proc-ped-ent.cod-refer
              and reg-export-item.nr-entrega   =  tt-proc-ped-ent.nr-entrega:
            if  lookup(string(reg-export-item.nr-re-ems),c-lista-re) = 0 then do:
                if  c-lista-re = "" then
                    assign c-lista-re = string(reg-export-item.nr-re-ems).
                else
                    assign c-lista-re = c-lista-re + " ," + string(reg-export-item.nr-re-ems).
            end.
        end.

        if  c-lista-re <> "" then do:
            assign i-seq-erro = i-seq-erro + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "item_do_pedido" *}
            run utp/ut-msgs.p (input "msg",
                               input 30557,
                               input RETURN-VALUE + "~~" + c-lista-re).
            create tt-bo-erro.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-item-do-pedido AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "item_do_pedido" *}
            ASSIGN c-lbl-liter-item-do-pedido = TRIM(RETURN-VALUE).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 30557
                   tt-bo-erro.mensagem     = c-lbl-liter
                   tt-bo-erro.parametros   = c-lbl-liter-item-do-pedido + "~~" + c-lista-re.
        end.
    &ENDIF
    
    &ENDIF
END.

PROCEDURE find_despesa:

   def input  parameter p-cod-estabel  AS CHAR NO-UNDO.
   def INPUT  parameter p-nr-proc-exp  AS CHAR NO-UNDO.
   def INPUT-OUTPUT parameter c-return as CHAR NO-UNDO.
   
   IF CAN-FIND (FIRST proc-desp-itiner
      where proc-desp-itiner.cod-estabel  = p-cod-estabel
        and proc-desp-itiner.nr-proc-exp  = p-nr-proc-exp)THEN
       assign c-return = "OK".
   else
       assign c-return = "NOK".

END procedure.

PROCEDURE EliminaDespesas:
   define input parameter c-cod-estabel like processo-exp.cod-estabel no-undo.
   define input parameter c-nr-proc-exp like processo-exp.nr-proc-exp no-undo.

   for each proc-desp-itiner
      where proc-desp-itiner.cod-estabel = c-cod-estabel
        and proc-desp-itiner.nr-proc-exp = c-nr-proc-exp exclusive-lock:
      
     delete proc-desp-itiner.
   end.
     
   return "OK":U.

END PROCEDURE. 


PROCEDURE pi-cria-row-errors:
    
    DEFINE INPUT PARAM pErrorNumber      LIKE RowErrors.errorNumber     NO-UNDO.
    DEFINE INPUT PARAM pErrorParameter   LIKE RowErrors.ErrorParameters NO-UNDO.
    DEFINE INPUT PARAM pErrorDescription LIKE tt-bo-erro.mensagem       NO-UNDO.
    
    IF pErrorDescription = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT 'msg',
                           INPUT pErrorNumber,
                           INPUT pErrorParameter).
        ASSIGN pErrorDescription = RETURN-VALUE.
    
    END.
    
    IF NOT CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.errorNumber = pErrorNumber) THEN DO:
        
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorNumber      = pErrorNumber
               RowErrors.ErrorType        = "EMS"
               RowErrors.ErrorParameters  = pErrorParameter
               RowErrors.errorDescription = pErrorDescription.
        ASSIGN RowErrors.errorHelp        = ENTRY(2, pErrorParameter, "~~").
                                                  
    END.
    
    RUN utp/ut-msgs.p (INPUT 'CodType',
                INPUT pErrorNumber,
                INPUT pErrorParameter).
    
    CASE RETURN-VALUE:
        WHEN '1' THEN
            ASSIGN RowErrors.ErrorSubType     = "ERROR".
        WHEN '2' THEN
            ASSIGN RowErrors.ErrorSubType     = "WARNING".
        WHEN '3' THEN
            ASSIGN RowErrors.ErrorSubType     = "QUESTION".
        WHEN '4' THEN
            ASSIGN RowErrors.ErrorSubType     = "INFORMATION".
    END CASE.


END PROCEDURE.


PROCEDURE validaPedEnt1:
    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
       /* Validar se a entrega j† foi atendida */
        def INPUT-OUTPUT parameter table for tt-bo-erro.
        
        for each tt-epc 
           where tt-epc.cod-event = "VALIDA-ENTREGA": 
            delete tt-epc. 
        end. 
        
        {include/i-epc200.i2 &CodEvent='"VALIDA-ENTREGA"'
                             &CodParameter='"ENTREGA-FATURADA"'
                             &ValueParameter='"NO"' }
                             
        {include/i-epc201.i "VALIDA-ENTREGA"}

        /* Chamada EPC inserida para os clientes que necessitam vincular/desvincular do processo de exportaá∆o entregas j† faturadas*/
        FIND FIRST tt-epc WHERE 
                   tt-epc.cod-event = "VALIDA-ENTREGA" AND
                   tt-epc.cod-parameter = "ENTREGA-FATURADA" AND
                   tt-epc.val-parameter = "YES" NO-ERROR.
        IF NOT AVAIL tt-epc THEN DO:
    
            find FIRST ped-ent NO-LOCK
                 where ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
                   and ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli
                   and ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia
                   and ped-ent.it-codigo    = proc-ped-ent.it-codigo
                   and ped-ent.cod-refer    = proc-ped-ent.cod-refer
                   and ped-ent.nr-entrega   = proc-ped-ent.nr-entrega
                   no-error.
            IF AVAIL ped-ent AND 
                     ped-ent.cod-sit-ent <> 1 THEN DO:
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg",
                                   input 28383,
                                   input "").
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 28383
                       tt-bo-erro.mensagem     = return-value.
            END.
        END.

        &IF DEFINED (bf_comex206b-1) &THEN 
            IF  NOT VALID-HANDLE(h-bocx362) THEN  
                RUN cxbo/bocx362.p PERSISTENT SET h-bocx362.
            
            RUN VerificaLogPendente IN h-bocx362 (INPUT {&TABLE-NAME}.cod-estabel,
                                                  input {&TABLE-NAME}.nr-proc-exp).
            IF  RETURN-VALUE = "NOK" THEN DO:
                assign i-seq-erro = i-seq-erro + 1.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Sequància_do_Pedido_de_Venda" *}
                run utp/ut-msgs.p (input "msg",
                                   input 31546,
                                   input RETURN-VALUE).
                create tt-bo-erro.
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-2 AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-liter-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-sequencia-do-pedido-de-venda AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Sequància_do_Pedido_de_Venda" *}
                ASSIGN c-lbl-liter-sequencia-do-pedido-de-venda = TRIM(RETURN-VALUE).
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 31546
                       tt-bo-erro.mensagem     = c-lbl-liter-2
                       tt-bo-erro.parametros   = c-lbl-liter-sequencia-do-pedido-de-venda.
            END.                                                        
            DELETE PROCEDURE h-bocx362.          
        &ENDIF
    &ENDIF
END.

PROCEDURE pi-recebe-parametros:
    DEFINE INPUT PARAMETER p-estab       LIKE proc-ped-ent.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-proc-exp LIKE proc-ped-ent.nr-proc-exp NO-UNDO.
    /*DEFINE INPUT PARAMETER p-nome-abrev  LIKE proc-ped-ent.nome-abrev  NO-UNDO.*/
    DEFINE INPUT PARAMETER p-nr-pedcli  LIKE proc-ped-ent.nr-pedcli  NO-UNDO.

    DEFINE INPUT PARAMETER p-it-codigo-ini    AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo-fim    AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-aberto           AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-aloc-parc-emb    AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-aloc-tot-emb     AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-faturado-parcial AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER p-faturado-total   AS LOGICAL NO-UNDO.

    DEFINE OUTPUT PARAMETER TABLE FOR tt-proc-ped-ent-aux2.
    DEFINE VARIABLE i-tip-situacao AS INTEGER NO-UNDO.

    ASSIGN c-it-codigo-ini     = p-it-codigo-ini
           c-it-codigo-fim     = p-it-codigo-fim
           l-aberto            = p-aberto
           l-aloc-parc-emb     = p-aloc-parc-emb
           l-aloc-tot-emb      = p-aloc-tot-emb
           l-faturado-parcial  = p-faturado-parcial
           l-faturado-total    = p-faturado-total.
    EMPTY TEMP-TABLE tt-proc-ped-ent-aux2.
    FOR EACH proc-ped-ent NO-LOCK
          WHERE proc-ped-ent.cod-estabel  =  p-estab
          AND   proc-ped-ent.nr-proc-exp  =  p-nr-proc-exp
          /*AND   proc-ped-ent.nome-abrev   = p-nome-abrev */
          AND   proc-ped-ent.nr-pedcli    =  p-nr-pedcli
          AND   proc-ped-ent.it-codigo    >= c-it-codigo-ini
          AND   proc-ped-ent.it-codigo    <= c-it-codigo-fim,
        FIRST ped-ent NO-LOCK
             WHERE ped-ent.nome-abrev   = proc-ped-ent.nome-abrev
               AND ped-ent.nr-pedcli    = proc-ped-ent.nr-pedcli
               AND ped-ent.nr-sequencia = proc-ped-ent.nr-sequencia
               AND ped-ent.it-codigo    = proc-ped-ent.it-codigo
               AND ped-ent.cod-refer    = proc-ped-ent.cod-refer
               AND ped-ent.nr-entrega   = proc-ped-ent.nr-entrega:
        
        /* s¢ deve ver a alocaá∆o no embarque se o item ainda n∆o tiver faturado. Caso o item j† tiver sido faturado manter a situaá∆o da ped-ent.cod-sit-ent */
        IF ped-ent.cod-sit-ent <> 2 AND ped-ent.cod-sit-ent <> 3 THEN DO:
            IF NOT l-aloc-parc-emb AND ped-ent.cod-sit-pre = 2 THEN
                NEXT.
            
            IF NOT l-aloc-tot-emb AND ped-ent.cod-sit-pre = 3 THEN
                NEXT.
        END.

        IF NOT l-faturado-parcial AND ped-ent.cod-sit-ent = 2 THEN
            NEXT.

        IF NOT l-faturado-total AND ped-ent.cod-sit-ent = 3 THEN
            NEXT.

        IF NOT l-aberto AND ped-ent.cod-sit-pre = 1 THEN
            NEXT.
        
        IF ped-ent.cod-sit-pre = 2 THEN
            ASSIGN i-tip-situacao = 1. /* alocado parcial embarque */
        
        IF ped-ent.cod-sit-pre = 3 THEN
            ASSIGN i-tip-situacao = 2. /* alocado total embarque */
        
        IF ped-ent.cod-sit-ent = 2 THEN
            ASSIGN i-tip-situacao = 3. /* faturado parcial */
        
        IF ped-ent.cod-sit-ent = 3 THEN
            ASSIGN i-tip-situacao = 4. /* faturado total */
        
        IF ped-ent.cod-sit-pre = 1 THEN
            ASSIGN i-tip-situacao = 5. /* aberto */
        
        CREATE tt-proc-ped-ent-aux2.
        BUFFER-COPY proc-ped-ent TO tt-proc-ped-ent-aux2.
        &IF  "{&bf_cex_versao_ems}" >= "2.09" &THEN
            ASSIGN tt-proc-ped-ent.ind-sit = i-tip-situacao.
        &ELSE    
            ASSIGN OVERLAY(tt-proc-ped-ent-aux2.char-1,1,1) = STRING(i-tip-situacao).
        &ENDIF
    END.
END PROCEDURE.
