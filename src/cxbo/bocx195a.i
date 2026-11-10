/**********************************************************
**  BOCX195A.i - Relacionamento ped-ent e proc-ped-ent 
**
**********************************************************/

DEFINE VAR h-bocx195         as handle  no-undo.
DEFINE VAR i-nr-entrega      as integer no-undo.
DEFINE var i-cont            as integer no-undo.
DEFINE VAR l-val-nf-embarque as logical init yes no-undo.
DEFINE var l-vers            as logical initial no no-undo.
DEFINE VAR de-qt-devolvida   LIKE devol-cli.qt-devolvida NO-UNDO.
DEFINE VAR de-fator-conver   AS   DECIMAL INITIAL 1 NO-UNDO.

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY tt-ped-ent
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-ped-ent

{cdp/cdcfgdis.i}
{cdp/cdcfgcex.i}
{utp/ut-glob.i}
{method/dbotterr.i}

/************************* Defini‡Æo das Temp-Table *********************************/

DEFINE TEMP-TABLE tt-ped-ent NO-UNDO like ped-ent
       USE-INDEX codigo
       field r-rowid    as rowid
       field log-select as logical init no.
       
DEFINE TEMP-TABLE tt-proc-ped-ent NO-UNDO like proc-ped-ent
       field r-rowid  as rowid.

DEFINE TEMP-TABLE tt-proc-ped-ent-aux NO-UNDO like proc-ped-ent
       field r-rowid  as rowid.       
 
DEFINE TEMP-TABLE tt-proc-ped-ent-pai NO-UNDO like proc-ped-ent
       field r-rowid  as rowid.  

DEFINE TEMP-TABLE tt-proc-ped-ent-filho NO-UNDO like proc-ped-ent
       field r-rowid  as rowid.       
{include/boini.i}
{cxbo/bocx195.i rowObject}
define buffer b-tt-ped-ent for tt-ped-ent.
define buffer b-ped-item   for ped-item.

&IF "{&bf_dis_versao_ems}" >= "2.04" &THEN       
    &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN                     
        &GLOBAL-DEFINE TT-PROC-PED-ENT.IND-COMPONEN tt-proc-ped-ent.ind-componen
        &GLOBAL-DEFINE TT-PROC-PED-ENT-AUX.IND-COMPONEN tt-proc-ped-ent-aux.ind-componen
        &GLOBAL-DEFINE TT-PROC-PED-ENT-FILHO.IND-COMPONEN tt-proc-ped-ent-filho.ind-componen
        &GLOBAL-DEFINE ROWOBJECT.IND-COMPONEN rowObject.ind-componen
        &GLOBAL-DEFINE PROC-PED-ENT.IND-COMPONEN proc-ped-ent.ind-componen
    &ELSE        
        &GLOBAL-DEFINE TT-PROC-PED-ENT.IND-COMPONEN tt-proc-ped-ent.int-1
        &GLOBAL-DEFINE TT-PROC-PED-ENT-AUX.IND-COMPONEN tt-proc-ped-ent-aux.int-1
        &GLOBAL-DEFINE TT-PROC-PED-ENT-FILHO.IND-COMPONEN tt-proc-ped-ent-filho.int-1
        &GLOBAL-DEFINE ROWOBJECT.IND-COMPONEN rowObject.int-1
        &GLOBAL-DEFINE PROC-PED-ENT.IND-COMPONEN proc-ped-ent.int-1
    &ENDIF
&ENDIF

&IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
    DEF VAR h-exapi        AS HANDLE NO-UNDO.
    DEF VAR h-bocx185      AS HANDLE NO-UNDO.
    DEF VAR de-tot-peso    AS DEC    NO-UNDO.
    DEF VAR de-tot-val     AS DEC    NO-UNDO.
    DEF VAR de-tot-qt      AS DEC    NO-UNDO.
    DEF VAR de-tot-cub-ped AS DEC    NO-UNDO.
    DEF VAR de-tot-cub-ent AS DEC    NO-UNDO.

    DEFINE TEMP-TABLE tt-ped-ent2 NO-UNDO like tt-ped-ent
           USE-INDEX codigo.
    DEFINE TEMP-TABLE tt-ped-ent3 NO-UNDO like tt-ped-ent
       USE-INDEX codigo.
&ENDIF

DEFINE QUERY {&QUERY-NAME} for tt-ped-ent scrolling.

/*ConversÆo do valor do volume do item*/
 FOR FIRST para-dis NO-LOCK:
     /*Unidade de Medida da ConversÆo 1 = Cent¡metros 2 = Metros*/
     IF para-dis.int-1 = 1 THEN
         ASSIGN de-fator-conver = 0.000001.
     ELSE
         ASSIGN de-fator-conver = 1.
 END.

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
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.log-select = no no-lock by {&TABLE-NAME}.nr-sequencia.
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
end procedure.

PROCEDURE verificaTemplate:
/*verifica qual template esta chamando a BO, se "no" = cliente/servidor,
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
    **  Foi customizada a serverSendRows para verificar por qual template estÿ
    **  sendo executada, pois o browse dos programa wex0195b e wex0195ab, n’o
    **  funcionavam corretamente utilizando o rowid({&table-name}) para isso 
    **  foi feita essa condi»’o no momento da rowobject receber o rowid. 
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
                &if defined(bf_comex206b-1) &then
                    assign rowObject.quantidade[1] = {&table-name}.qt-pedida.
                &endif

                &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN                       
                    for first ped-item fields(ind-componen) 
                        WHERE ped-item.nome-abrev   = {&table-name}.nome-abrev  
                          AND ped-item.nr-pedcli    = {&table-name}.nr-pedcli   
                          AND ped-item.nr-sequencia = {&table-name}.nr-sequencia
                          AND ped-item.it-codigo    = {&table-name}.it-codigo   
                          AND ped-item.cod-refer    = {&table-name}.cod-refer    no-lock:  
                    end.                                                         
                    if avail ped-item then                                       
                       assign {&rowobject.ind-componen} = ped-item.ind-componen.   
                &ENDIF   

                /* se l-vers = YES, a BO ² chamada pela web, se l-vers = NO ² chamada pelo cliente/servidor */
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

PROCEDURE serverSendRows2 :

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

PROCEDURE carregattprocpedentaux:
   /* Cria‡Æo da tt-proc-ped-ent-aux com os registros a serem disvinculados do 
      embarque */
    def input  parameter i-sequencia     as integer no-undo.
    def input  parameter i-entrega       as integer no-undo.
    &if defined(bf_comex206b-1) &then
        def input  parameter pde-qt-proc-ext as decimal no-undo.
    &endif
    def output parameter table for tt-proc-ped-ent-aux.

    if not valid-handle(h-bocx195) then
        run cxbo/bocx195.p persistent set h-bocx195.

    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN    
        DEF BUFFER btt-ped-ent FOR tt-ped-ent.
        DEF BUFFER bped-item   FOR ped-item.

        DEFINE VARIABLE de-qt-item-pai  AS DECIMAL    NO-UNDO.
        DEFINE VARIABLE de-qt-vinculada AS DECIMAL    NO-UNDO.

        find first tt-ped-ent where 
                   tt-ped-ent.nr-sequencia = i-sequencia and
                   tt-ped-ent.nr-entrega   = i-entrega   no-lock no-error.
        if avail tt-ped-ent then do:
            
            for first ped-item of tt-ped-ent no-lock:  
            end.     
            if avail ped-item then DO:
                IF ped-item.ind-componen = 3 THEN DO: /* componente de configurado */
                    FIND FIRST bped-item NO-LOCK
                         WHERE bped-item.nome-abrev   = ped-item.nome-abrev  
                           AND bped-item.nr-pedcli    = ped-item.nr-pedcli   
                           AND bped-item.nr-sequencia = ped-item.nr-sequencia
                           AND bped-item.ind-componen = 2 NO-ERROR. /* produto configurado - Pai */
                    IF AVAIL bped-item THEN DO:
                       
                        FIND FIRST btt-ped-ent
                             WHERE btt-ped-ent.nome-abrev   = bped-item.nome-abrev
                               AND btt-ped-ent.nr-pedcli    = bped-item.nr-pedcli   
                               AND btt-ped-ent.nr-sequencia = bped-item.nr-sequencia
                               AND btt-ped-ent.it-codigo    = bped-item.it-codigo
                               AND btt-ped-ent.cod-refer    = bped-item.cod-refer 
                               AND btt-ped-ent.nr-entrega   = tt-ped-ent.nr-entrega NO-LOCK NO-ERROR.
                        IF AVAIL btt-ped-ent THEN DO:
                             
                            FIND FIRST tt-proc-ped-ent-aux
                                 WHERE tt-proc-ped-ent-aux.nome-abrev   = btt-ped-ent.nome-abrev  
                                   AND tt-proc-ped-ent-aux.nr-pedcli    = btt-ped-ent.nr-pedcli   
                                   AND tt-proc-ped-ent-aux.nr-sequencia = btt-ped-ent.nr-sequencia
                                   AND tt-proc-ped-ent-aux.it-codigo    = btt-ped-ent.it-codigo 
                                   AND tt-proc-ped-ent-aux.cod-refer    = btt-ped-ent.cod-refer   
                                   AND tt-proc-ped-ent-aux.nr-entrega   = btt-ped-ent.nr-entrega NO-LOCK NO-ERROR.
                            IF NOT AVAIL tt-proc-ped-ent-aux THEN DO:
                                create tt-proc-ped-ent-aux.
                                buffer-copy btt-ped-ent to tt-proc-ped-ent-aux.                                
                                assign {&tt-proc-ped-ent-aux.ind-componen} = bped-item.ind-componen.   

                                find FIRST ped-ent NO-LOCK
                                     where ped-ent.nome-abrev   = btt-ped-ent.nome-abrev
                                       and ped-ent.nr-pedcli    = btt-ped-ent.nr-pedcli
                                       and ped-ent.nr-sequencia = btt-ped-ent.nr-sequencia
                                       and ped-ent.it-codigo    = btt-ped-ent.it-codigo
                                       and ped-ent.cod-refer    = btt-ped-ent.cod-refer
                                       and ped-ent.nr-entrega   = btt-ped-ent.nr-entrega
                                       no-error.
                                IF AVAIL ped-ent THEN DO:
                                    FIND FIRST tt-ped-ent2
                                         WHERE tt-ped-ent2.nome-abrev   = ped-ent.nome-abrev  
                                           AND tt-ped-ent2.nr-pedcli    = ped-ent.nr-pedcli   
                                           AND tt-ped-ent2.nr-sequencia = ped-ent.nr-sequencia
                                           AND tt-ped-ent2.it-codigo    = ped-ent.it-codigo   
                                           AND tt-ped-ent2.cod-refer    = ped-ent.cod-refer     
                                           AND tt-ped-ent2.nr-entrega   = ped-ent.nr-entrega NO-LOCK NO-ERROR.
                                    IF NOT AVAIL tt-ped-ent2 THEN DO:
                                        CREATE tt-ped-ent2.
                                        BUFFER-COPY ped-ent TO tt-ped-ent2.
                                    END.
                                END.
                            END.
                            &if defined(bf_comex206b-1) &then
                                ASSIGN tt-proc-ped-ent-aux.quantidade[1] = pde-qt-proc-ext /* quant item pai no processo */
                                       de-qt-item-pai                    = btt-ped-ent.qt-pedida. /* quant item pai no pedido */
                            &endif
                        END.
                    END.    
                END.
                ELSE DO:
                    
                    FIND FIRST tt-proc-ped-ent-aux
                         WHERE tt-proc-ped-ent-aux.nome-abrev   = tt-ped-ent.nome-abrev  
                           AND tt-proc-ped-ent-aux.nr-pedcli    = tt-ped-ent.nr-pedcli   
                           AND tt-proc-ped-ent-aux.nr-sequencia = tt-ped-ent.nr-sequencia
                           AND tt-proc-ped-ent-aux.it-codigo    = tt-ped-ent.it-codigo 
                           AND tt-proc-ped-ent-aux.cod-refer    = tt-ped-ent.cod-refer   
                           AND tt-proc-ped-ent-aux.nr-entrega   = tt-ped-ent.nr-entrega NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-proc-ped-ent-aux THEN DO:
                        
                        create tt-proc-ped-ent-aux.
                        buffer-copy tt-ped-ent to tt-proc-ped-ent-aux.
                        assign {&tt-proc-ped-ent-aux.ind-componen} = ped-item.ind-componen.   

                        find FIRST ped-ent NO-LOCK
                             where ped-ent.nome-abrev   = tt-ped-ent.nome-abrev
                               and ped-ent.nr-pedcli    = tt-ped-ent.nr-pedcli
                               and ped-ent.nr-sequencia = tt-ped-ent.nr-sequencia
                               and ped-ent.it-codigo    = tt-ped-ent.it-codigo
                               and ped-ent.cod-refer    = tt-ped-ent.cod-refer
                               and ped-ent.nr-entrega   = tt-ped-ent.nr-entrega
                               no-error.
                        IF AVAIL ped-ent THEN DO:
                            FIND FIRST tt-ped-ent2
                                 WHERE tt-ped-ent2.nome-abrev   = ped-ent.nome-abrev  
                                   AND tt-ped-ent2.nr-pedcli    = ped-ent.nr-pedcli   
                                   AND tt-ped-ent2.nr-sequencia = ped-ent.nr-sequencia
                                   AND tt-ped-ent2.it-codigo    = ped-ent.it-codigo   
                                   AND tt-ped-ent2.cod-refer    = ped-ent.cod-refer     
                                   AND tt-ped-ent2.nr-entrega   = ped-ent.nr-entrega NO-LOCK NO-ERROR.
                            IF NOT AVAIL tt-ped-ent2 THEN DO:
                                CREATE tt-ped-ent2.
                                BUFFER-COPY ped-ent TO tt-ped-ent2.
                            END.
                        END.
                    END.
                    &if defined(bf_comex206b-1) &then                        
                        ASSIGN tt-proc-ped-ent-aux.quantidade[1] = pde-qt-proc-ext.
                    &endif
                    
                END.

                FOR EACH bped-item NO-LOCK
                   WHERE bped-item.nome-abrev   = ped-item.nome-abrev  
                     AND bped-item.nr-pedcli    = ped-item.nr-pedcli   
                     AND bped-item.nr-sequencia = ped-item.nr-sequencia
                     AND bped-item.ind-componen = 3,
                    FIRST ped-ent NO-LOCK
                    where ped-ent.nome-abrev   = bped-item.nome-abrev
                    and   ped-ent.nr-pedcli    = bped-item.nr-pedcli
                    and   ped-ent.nr-sequencia = bped-item.nr-sequencia
                    and   ped-ent.it-codigo    = bped-item.it-codigo
                    and   ped-ent.cod-refer    = bped-item.cod-refer
                    and   ped-ent.nr-entrega   = i-entrega:

                    &if defined(bf_comex206b-1) &then
                    run calculaQuantidadeVinculada IN h-bocx195 (INPUT  ped-ent.nome-abrev   ,
                                                                     INPUT  ped-ent.nr-pedcli    ,
                                                                     INPUT  ped-ent.nr-sequencia ,
                                                                     INPUT  ped-ent.it-codigo    ,
                                                                     INPUT  ped-ent.cod-refer    ,
                                                                     INPUT  ped-ent.nr-entrega   ,
                                                                     OUTPUT de-qt-vinculada).
    
                        /*NÆo tem saldo para vincular*/
                        if (ped-ent.qt-pedida - de-qt-vinculada) <= 0 then next.
                    &endif

                    FIND FIRST btt-ped-ent
                         WHERE btt-ped-ent.nome-abrev   = bped-item.nome-abrev
                           AND btt-ped-ent.nr-pedcli    = bped-item.nr-pedcli   
                           AND btt-ped-ent.nr-sequencia = bped-item.nr-sequencia
                           AND btt-ped-ent.it-codigo    = bped-item.it-codigo
                           AND btt-ped-ent.cod-refer    = bped-item.cod-refer 
                           AND btt-ped-ent.nr-entrega   = tt-ped-ent.nr-entrega NO-LOCK NO-ERROR.
                    IF AVAIL btt-ped-ent THEN DO:
                        FIND FIRST tt-proc-ped-ent-aux
                             WHERE tt-proc-ped-ent-aux.nome-abrev   = btt-ped-ent.nome-abrev  
                               AND tt-proc-ped-ent-aux.nr-pedcli    = btt-ped-ent.nr-pedcli   
                               AND tt-proc-ped-ent-aux.nr-sequencia = btt-ped-ent.nr-sequencia
                               AND tt-proc-ped-ent-aux.it-codigo    = btt-ped-ent.it-codigo 
                               AND tt-proc-ped-ent-aux.cod-refer    = btt-ped-ent.cod-refer   
                               AND tt-proc-ped-ent-aux.nr-entrega   = btt-ped-ent.nr-entrega NO-LOCK NO-ERROR.
                        IF NOT AVAIL tt-proc-ped-ent-aux THEN DO:
                            create tt-proc-ped-ent-aux.
                            buffer-copy btt-ped-ent to tt-proc-ped-ent-aux.
                            assign {&tt-proc-ped-ent-aux.ind-componen} = bped-item.ind-componen.   
                           
                            FIND FIRST tt-ped-ent2
                                 WHERE tt-ped-ent2.nome-abrev   = ped-ent.nome-abrev  
                                   AND tt-ped-ent2.nr-pedcli    = ped-ent.nr-pedcli   
                                   AND tt-ped-ent2.nr-sequencia = ped-ent.nr-sequencia
                                   AND tt-ped-ent2.it-codigo    = ped-ent.it-codigo   
                                   AND tt-ped-ent2.cod-refer    = ped-ent.cod-refer     
                                   AND tt-ped-ent2.nr-entrega   = ped-ent.nr-entrega NO-LOCK NO-ERROR.
                            IF NOT AVAIL tt-ped-ent2 THEN DO:
                                CREATE tt-ped-ent2.
                                BUFFER-COPY ped-ent TO tt-ped-ent2.
                            END.
                            
                        END.

                        &if defined(bf_comex206b-1) &then
                            ASSIGN tt-proc-ped-ent-aux.quantidade[1] = pde-qt-proc-ext / de-qt-item-pai * btt-ped-ent.qt-pedida.
                        &endif
                    END.
                END.
            END.
        END.
    &ELSE
        find tt-ped-ent where
             tt-ped-ent.nr-sequencia = i-sequencia and
             tt-ped-ent.nr-entrega   = i-entrega NO-LOCK no-error.
        if avail tt-ped-ent then do:
            create tt-proc-ped-ent-aux.
            buffer-copy tt-ped-ent to tt-proc-ped-ent-aux.
        end.
    &ENDIF  
    
    if valid-handle (h-bocx195) then do:
        delete procedure h-bocx195.
        assign h-bocx195 = ?.
    end.

END.

PROCEDURE carregattprocpedentaux1:
   /* Cria»’o da tt-proc-ped-ent-aux com os registros a serem disvinculados do 
      embarque */
    
    def input  parameter rowselect as char no-undo.
    def input  parameter numrows   as char no-undo.
    def output parameter table for tt-proc-ped-ent-aux.
    
    do i-cont = 1 to int(numrows):
       find ped-ent
             where rowid(ped-ent) = to-rowid(entry(i-cont,rowselect)) NO-LOCK no-error.
       if avail ped-ent then do:
         create tt-proc-ped-ent-aux.
         buffer-copy ped-ent to tt-proc-ped-ent-aux.
       end.
    end.
END.

PROCEDURE carregaTempTablePedEnt:

    DEF input parameter table for tt-proc-ped-ent-aux.
    DEF input parameter numrows   as char  no-undo.
    DEF input parameter r-chave   as rowid no-undo.

    DEF VAR de-volume-inf  AS DEC    NO-UNDO.
    def var i-idi-unid-fatur as int no-undo.
    def var c-un-fatur as char no-undo.
    def var de-qtd-conver as decimal format ">>>,>>>,>>9.9999" no-undo.
                                                    
    FIND FIRST tt-proc-ped-ent-aux NO-LOCK NO-ERROR.
    
    &if defined(bf_comex206b-1) &then    
        
        FOR EACH tt-proc-ped-ent-aux NO-LOCK: 
            
            FOR FIRST ped-ent NO-LOCK
                 WHERE ped-ent.nome-abrev    =  tt-proc-ped-ent-aux.nome-abrev  
                   AND ped-ent.nr-pedcli     =  tt-proc-ped-ent-aux.nr-pedcli   
                   AND ped-ent.nr-sequencia  =  tt-proc-ped-ent-aux.nr-sequencia
                   AND ped-ent.it-codigo     =  tt-proc-ped-ent-aux.it-codigo   
                   AND ped-ent.cod-refer     =  tt-proc-ped-ent-aux.cod-refer     
                   AND ped-ent.nr-entrega    =  tt-proc-ped-ent-aux.nr-entrega: 
                
                FOR FIRST tt-ped-ent2
                    WHERE tt-ped-ent2.nome-abrev   = ped-ent.nome-abrev  
                    AND   tt-ped-ent2.nr-pedcli    = ped-ent.nr-pedcli   
                    AND   tt-ped-ent2.nr-sequencia = ped-ent.nr-sequencia
                    AND   tt-ped-ent2.it-codigo    = ped-ent.it-codigo   
                    AND   tt-ped-ent2.cod-refer    = ped-ent.cod-refer     
                    AND   tt-ped-ent2.nr-entrega   = ped-ent.nr-entrega NO-LOCK: 
                    
                    FOR FIRST ped-item NO-LOCK
                        WHERE ped-item.nome-abrev    = tt-proc-ped-ent-aux.nome-abrev    
                        AND   ped-item.nr-pedcli     = tt-proc-ped-ent-aux.nr-pedcli     
                        AND   ped-item.nr-sequencia  = tt-proc-ped-ent-aux.nr-sequencia  
                        AND   ped-item.it-codigo     = tt-proc-ped-ent-aux.it-codigo     
                        AND   ped-item.cod-refer     = tt-proc-ped-ent-aux.cod-refer:
                        
                        FOR FIRST proc-ped-ent 
                            WHERE proc-ped-ent.cod-estabel  = tt-proc-ped-ent-aux.cod-estabel
                            AND   proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent-aux.nr-proc-exp
                            AND   proc-ped-ent.nome-abrev   = tt-ped-ent2.nome-abrev
                            AND   proc-ped-ent.nr-pedcli    = tt-ped-ent2.nr-pedcli
                            AND   proc-ped-ent.nr-sequencia = tt-ped-ent2.nr-sequencia
                            AND   proc-ped-ent.it-codigo    = tt-ped-ent2.it-codigo
                            AND   proc-ped-ent.cod-refer    = tt-ped-ent2.cod-refer
                            AND   proc-ped-ent.nr-entrega   = tt-ped-ent2.nr-entrega NO-LOCK:
                        END.

                        IF  AVAIL proc-ped-ent THEN DO:
                            IF  ped-item.ind-fat-qtfam = NO THEN 
                                ASSIGN tt-ped-ent2.vl-tot-it             = (tt-proc-ped-ent-aux.quantidade[1] - proc-ped-ent.quantidade[1]) * ped-item.vl-preuni
                                       tt-proc-ped-ent-aux.quantidade[2] = tt-proc-ped-ent-aux.quantidade[1]
                                       tt-proc-ped-ent-aux.un-fatur      = tt-proc-ped-ent-aux.un-fatur.
                            ELSE DO:
                                if  not valid-handle(h-bocx195) then
                                    run cxbo/bocx195.p persistent set h-bocx195.

                                RUN converteQtdUnMedidaClienteFamilia IN h-bocx195 (INPUT  tt-proc-ped-ent-aux.it-codigo,
                                                                                    INPUT  tt-proc-ped-ent-aux.nome-abrev,
                                                                                    INPUT  tt-proc-ped-ent-aux.idi-unid-fatur,
                                                                                    INPUT  tt-proc-ped-ent-aux.quantidade[1],
                                                                                    INPUT  ped-item.des-un-medida,
                                                                                    OUTPUT tt-proc-ped-ent-aux.quantidade[2],
                                                                                    OUTPUT tt-proc-ped-ent-aux.un-fatur).
                                ASSIGN tt-ped-ent2.vl-tot-it = (tt-proc-ped-ent-aux.quantidade[2] - proc-ped-ent.quantidade[2]) * ped-item.vl-preuni.
                            END.

                        END.
                        ELSE DO:
                            IF  ped-item.ind-fat-qtfam = NO THEN
                                ASSIGN tt-ped-ent2.vl-tot-it             = (tt-proc-ped-ent-aux.quantidade[1]) * ped-item.vl-preuni
                                       tt-proc-ped-ent-aux.quantidade[2] = tt-proc-ped-ent-aux.quantidade[1]
                                       tt-proc-ped-ent-aux.un-fatur      = tt-proc-ped-ent-aux.un-fatur.
                            ELSE DO:
                                if not valid-handle(h-bocx195) then
                                    run cxbo/bocx195.p persistent set h-bocx195.

                                RUN converteQtdUnMedidaClienteFamilia IN h-bocx195 (INPUT  tt-proc-ped-ent-aux.it-codigo,
                                                                                    INPUT  tt-proc-ped-ent-aux.nome-abrev,
                                                                                    INPUT  tt-proc-ped-ent-aux.idi-unid-fatur,
                                                                                    INPUT  tt-proc-ped-ent-aux.quantidade[1],
                                                                                    INPUT  ped-item.des-un-medida,
                                                                                    OUTPUT tt-proc-ped-ent-aux.quantidade[2],
                                                                                    OUTPUT tt-proc-ped-ent-aux.un-fatur).
                                ASSIGN tt-ped-ent2.vl-tot-it = (tt-proc-ped-ent-aux.quantidade[2]) * ped-item.vl-preuni.
                            END.
                                
                        END.

                    END. /* FOR FIRST ped-item  */
                END. /* FOR FIRST tt-ped-ent2  */
            END. /* FOR FIRST ped-ent  */
        END. /* FOR EACH tt-proc-ped-ent-aux */
    
    &endif

    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
        
        RUN exp/exapi010.p PERSISTENT SET h-exapi.
        
        FOR EACH tt-ped-ent2 EXCLUSIVE-LOCK:

            &if defined(bf_comex206b-1) &then
                {exp/exapi010.i2 tt-ped-ent2}
            &else            
                {exp/exapi010.i1 tt-ped-ent2}
            &endif

            assign de-volume-inf = de-tot-cub-ent.

            FOR EACH tt-ped-ent3 EXCLUSIVE-LOCK.
                DELETE tt-ped-ent3.
            END.                  
                        
            CREATE tt-ped-ent3.
            BUFFER-COPY tt-ped-ent2 TO tt-ped-ent3.

            &IF DEFINED(bf_comex206b-1) &THEN
                
                FIND FIRST tt-proc-ped-ent-aux NO-LOCK 
                     WHERE tt-proc-ped-ent-aux.it-codigo    = tt-ped-ent2.it-codigo 
                       AND tt-proc-ped-ent-aux.nr-pedcli    = tt-ped-ent2.nr-pedcli
                       AND tt-proc-ped-ent-aux.nr-sequencia = tt-ped-ent2.nr-sequencia
                       AND tt-proc-ped-ent-aux.it-codigo    = tt-ped-ent2.it-codigo
                       AND tt-proc-ped-ent-aux.cod-refer    = tt-ped-ent2.cod-refer
                       AND tt-proc-ped-ent-aux.nr-entrega   = tt-ped-ent2.nr-entrega NO-ERROR.
                IF AVAIL tt-proc-ped-ent-aux THEN DO:
                    FOR FIRST proc-ped-ent 
                        WHERE proc-ped-ent.cod-estabel  = tt-proc-ped-ent-aux.cod-estabel
                          AND proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent-aux.nr-proc-exp
                          AND proc-ped-ent.nome-abrev   = tt-ped-ent2.nome-abrev
                          AND proc-ped-ent.nr-pedcli    = tt-ped-ent2.nr-pedcli
                          AND proc-ped-ent.nr-sequencia = tt-ped-ent2.nr-sequencia
                          AND proc-ped-ent.it-codigo    = tt-ped-ent2.it-codigo
                          AND proc-ped-ent.cod-refer    = tt-ped-ent2.cod-refer
                          AND proc-ped-ent.nr-entrega   = tt-ped-ent2.nr-entrega NO-LOCK. END.
                    IF AVAIL proc-ped-ent THEN DO:        
                        ASSIGN tt-ped-ent3.qt-pedida = tt-proc-ped-ent-aux.quantidade[1] - proc-ped-ent.quantidade[1].
    
                        FOR FIRST ped-item  NO-LOCK
                            WHERE ped-item.nome-abrev    = tt-proc-ped-ent-aux.nome-abrev    
                              AND ped-item.nr-pedcli     = tt-proc-ped-ent-aux.nr-pedcli     
                              AND ped-item.nr-sequencia  = tt-proc-ped-ent-aux.nr-sequencia  
                              AND ped-item.it-codigo     = tt-proc-ped-ent-aux.it-codigo     
                              AND ped-item.cod-refer     = tt-proc-ped-ent-aux.cod-refer :  END.
                        IF AVAIL ped-item THEN 
                            ASSIGN tt-ped-ent3.vl-tot-it = (tt-proc-ped-ent-aux.quantidade[1] - proc-ped-ent.quantidade[1]) * ped-item.vl-preuni.
                    END.
                    ELSE 
                        ASSIGN tt-ped-ent3.qt-pedida = tt-proc-ped-ent-aux.quantidade[1].
                END.
            &ENDIF

            RUN AdicionaProcdespItiner IN h-exapi (INPUT TABLE tt-ped-ent3,
                                                   INPUT de-tot-peso,
                                                   INPUT de-tot-val,
                                                   INPUT de-tot-qt,
                                                   INPUT de-tot-cub-ped,
                                                   INPUT de-tot-cub-ent,
                                                   INPUT r-chave).
        END. /* FOR EACH tt-ped-ent2  */

        FOR FIRST processo-exp 
            WHERE processo-exp.cod-estabel = tt-proc-ped-ent-aux.cod-estabel 
            AND   processo-exp.nr-proc-exp = tt-proc-ped-ent-aux.nr-proc-exp EXCLUSIVE-LOCK:

            FIND ped-venda-cex 
                 WHERE ped-venda-cex.nome-abrev = tt-proc-ped-ent-aux.nome-abrev 
                 AND   ped-venda-cex.nr-pedcli  = tt-proc-ped-ent-aux.nr-pedcli NO-LOCK NO-ERROR.

            IF  AVAIL ped-venda-cex THEN DO:
                &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
                    if  ped-venda-cex.volume = 0 then do:
                        if  processo-exp.volume-inf = 0 then
                            assign processo-exp.volume-inf = de-volume-inf.
                    end.
                &else
                    if  ped-venda-cex.dec-1 = 0 then do:
                        if  processo-exp.dec-1 = 0 then
                            assign processo-exp.dec-1 = de-volume-inf.
                        ASSIGN processo-exp.volume = processo-exp.dec-1.
                    end.
                    else do:
                        if  processo-exp.dec-1 = 0 then
                           assign processo-exp.dec-1 = ped-venda-cex.dec-1.
                        ASSIGN processo-exp.volume = processo-exp.dec-1.
                    end.
                &ENDIF
                
            END. /* IF  AVAIL ped-venda-cex  */
        END. /* FOR FIRST processo-exp */

        DELETE PROCEDURE h-exapi.
        FOR EACH tt-ped-ent2 EXCLUSIVE-LOCK.
            DELETE tt-ped-ent2.
        END.
    &ENDIF                   

    for each rowObject:
       delete rowObject.
    end.
    
    run atualizaProcPedEnt (input table tt-proc-ped-ent-aux,
                            input numrows,
                            input r-chave).

    run carregaTTpedent (input table tt-proc-ped-ent-aux,
                         input numrows,
                         input r-chave).

    find first tt-proc-ped-ent-aux NO-LOCK no-error.
    if avail tt-proc-ped-ent-aux then do:
       for each tt-proc-ped-ent-aux:

         find b-tt-ped-ent EXCLUSIVE-LOCK
               where b-tt-ped-ent.nome-abrev   = tt-proc-ped-ent-aux.nome-abrev
                 and b-tt-ped-ent.nr-pedcli    = tt-proc-ped-ent-aux.nr-pedcli
                 and b-tt-ped-ent.nr-sequencia = tt-proc-ped-ent-aux.nr-sequencia
                 and b-tt-ped-ent.it-codigo    = tt-proc-ped-ent-aux.it-codigo
                 and b-tt-ped-ent.cod-refer    = tt-proc-ped-ent-aux.cod-refer
                 and b-tt-ped-ent.nr-entrega   = tt-proc-ped-ent-aux.nr-entrega
                     no-error.
          if avail b-tt-ped-ent then do:
             assign b-tt-ped-ent.log-select =  yes.
          end.
       end.     /* bloco do i-cont  */
    end.    /*  if tt-prod-ped-ent-aux  */
END PROCEDURE.



PROCEDURE atualizaProcPedEnt:

    def input parameter table for tt-proc-ped-ent-aux.
    def input parameter numrows   as char  no-undo.
    def input parameter p-chave   as rowid no-undo.

    def var r-chave       as rowid no-undo.
    def var de-qtd-conver like ped-ent.qt-pedida no-undo.
    def var c-unid-conver as char                no-undo.

    def var c-return as char  no-undo.

    DEF VAR c-cod-estabel as char  no-undo.
    DEF VAR c-nr-proc-exp as char  no-undo.

    assign r-chave = p-chave.
    find first tt-proc-ped-ent-aux NO-LOCK no-error.

    if avail tt-proc-ped-ent-aux then do:

       for each tt-proc-ped-ent-aux NO-LOCK
           &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
               where {&tt-proc-ped-ent-aux.ind-componen} <> 3
           &ENDIF : 
            find ped-ent exclusive-lock
                 where ped-ent.nome-abrev   = tt-proc-ped-ent-aux.nome-abrev
                   and ped-ent.nr-pedcli    = tt-proc-ped-ent-aux.nr-pedcli
                   and ped-ent.nr-sequencia = tt-proc-ped-ent-aux.nr-sequencia
                   and ped-ent.it-codigo    = tt-proc-ped-ent-aux.it-codigo
                   and ped-ent.cod-refer    = tt-proc-ped-ent-aux.cod-refer
                   and ped-ent.nr-entrega   = tt-proc-ped-ent-aux.nr-entrega
                       no-error.
             if avail ped-ent then do:
                find proc-ped-venda no-lock
                     where rowid(proc-ped-venda) = r-chave no-error.
                if avail proc-ped-venda then do:
                   
                    FOR EACH tt-proc-ped-ent:
                        DELETE tt-proc-ped-ent.
                    END.
                    
                   create tt-proc-ped-ent.
                   assign tt-proc-ped-ent.cod-estabel  = proc-ped-venda.cod-estabel
                          tt-proc-ped-ent.nr-proc-exp  = proc-ped-venda.nr-proc-exp
                          tt-proc-ped-ent.nome-abrev   = ped-ent.nome-abrev
                          tt-proc-ped-ent.nr-pedcli    = ped-ent.nr-pedcli
                          tt-proc-ped-ent.nr-sequencia = ped-ent.nr-sequencia
                          tt-proc-ped-ent.it-codigo    = ped-ent.it-codigo
                          tt-proc-ped-ent.cod-refer    = ped-ent.cod-refer
                          tt-proc-ped-ent.nr-entrega   = ped-ent.nr-entrega
                          tt-proc-ped-ent.nr-pedido    = tt-proc-ped-ent-aux.nr-pedido.     

                   ASSIGN c-cod-estabel = proc-ped-venda.cod-estabel
                          c-nr-proc-exp = proc-ped-venda.nr-proc-exp.
                   
                    
                   &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN                       
                       for first ped-item fields(ind-componen) of ped-ent no-lock:  
                       end.                                                         
                       if avail ped-item then                                       
                          assign {&tt-proc-ped-ent.ind-componen} = ped-item.ind-componen.   
                   &ENDIF                                                           

                   if not valid-handle(h-bocx195) then
                       run cxbo/bocx195.p persistent set h-bocx195.

				   run setValidaNfEmbarque IN h-bocx195 (input l-val-nf-embarque).

                   &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
                       RUN atualizaQuantidade IN h-bocx195 (input ROWID(ped-ent),
                                                            input-output table tt-proc-ped-ent
                                                            &if defined(bf_comex206b-1) &then
                                                                ,tt-proc-ped-ent-aux.quantidade[1]
                                                            &endif
                                                            ).

                       FIND FIRST tt-proc-ped-ent NO-ERROR.
                   &ENDIF
                                      
                   &if defined(bf_comex206b-1) &then
                   
                        find first proc-ped-ent no-lock 
                             where proc-ped-ent.cod-estabel  = tt-proc-ped-ent.cod-estabel 
                               and proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent.nr-proc-exp 
                               and proc-ped-ent.nome-abrev   = tt-proc-ped-ent.nome-abrev  
                               and proc-ped-ent.nr-pedcli    = tt-proc-ped-ent.nr-pedcli   
                               and proc-ped-ent.nr-sequencia = tt-proc-ped-ent.nr-sequencia
                               and proc-ped-ent.it-codigo    = tt-proc-ped-ent.it-codigo   
                               and proc-ped-ent.cod-refer    = tt-proc-ped-ent.cod-refer   
                               and proc-ped-ent.nr-entrega   = tt-proc-ped-ent.nr-entrega  no-error.
                        if avail proc-ped-ent then
                           run validateUpdate in h-bocx195 (input  table tt-proc-ped-ent,
                                                            input  rowid (proc-ped-ent),
                                                            output table tt-bo-erro).
                        else
                   &endif

                   run validateCreate in h-bocx195(input  table tt-proc-ped-ent,
                                                   output table tt-bo-erro,
                                                   output p-chave).

                   find first tt-bo-erro NO-LOCK no-error.
                   if not avail tt-bo-erro then do:
                         &if defined(bf_dis_proc_ent) &then
                            &if defined(bf_comex206b-1) = 0 &then  
                                assign ped-ent.nr-proc-exp = tt-proc-ped-ent.nr-proc-exp.
                            &endif
                         &endif
                         &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
                             IF NOT AVAIL processo-exp OR
                                          processo-exp.cod-estabel <> tt-proc-ped-ent.cod-estabel OR
                                          processo-exp.nr-proc-exp <> tt-proc-ped-ent.nr-proc-exp THEN
                                 FIND FIRST processo-exp 
                                      WHERE processo-exp.cod-estabel = tt-proc-ped-ent.cod-estabel
                                      AND   processo-exp.nr-proc-exp = tt-proc-ped-ent.nr-proc-exp
                                    NO-LOCK NO-ERROR.
                             IF AVAIL processo-exp AND processo-exp.cod-sit-proc = 3 THEN DO:
                                 RUN cxbo/bocx185.p PERSISTENT SET h-bocx185.
                                 RUN AtualizaSituacaoProcesso IN h-bocx185 (INPUT processo-exp.cod-estabel,
                                                                            input processo-exp.nr-proc-exp).
                                 DELETE PROCEDURE h-bocx185.          
                             END.                                   
                         &ENDIF
                   
                       &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN       
                       
                           IF {&tt-proc-ped-ent.ind-componen} = 2 THEN DO:

                               find b-ped-item of tt-proc-ped-ent where b-ped-item.ind-componen = 2 no-lock no-error.

                               RUN atualizaProcPedEntFilho(INPUT TABLE tt-proc-ped-ent).

                               &if defined(bf_comex206b-1) &then

                                   if not can-find(first proc-ped-ent                               
                                                   where proc-ped-ent.cod-estabel  = tt-proc-ped-ent.cod-estabel  
                                                   and   proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent.nr-proc-exp 
                                                   and   proc-ped-ent.nome-abrev   = tt-proc-ped-ent.nome-abrev  
                                                   and   proc-ped-ent.nr-pedcli    = tt-proc-ped-ent.nr-pedcli   
                                                   and   proc-ped-ent.nr-sequencia = tt-proc-ped-ent.nr-sequencia
                                                   and   proc-ped-ent.nr-entrega   = tt-proc-ped-ent.nr-entrega  
                                                   and   {&proc-ped-ent.ind-componen} = 3) then do:
    
                                       run utp/ut-msgs.p (input "msg",
                                                          input 32597,
                                                          input tt-proc-ped-ent.it-codigo).
                                       create tt-bo-erro.
                                       assign tt-bo-erro.i-sequen     = i-seq-erro
                                              tt-bo-erro.cd-erro      = 32597
                                              tt-bo-erro.mensagem     = return-value.
    
                                       RUN utp/ut-msgs.p (INPUT "help",
                                                          INPUT 32597,
                                                          INPUT tt-proc-ped-ent.it-codigo).
    
                                       assign tt-bo-erro.ErrorHelp = return-value.
    
                                       find first proc-ped-ent exclusive-lock
                                            where proc-ped-ent.cod-estabel  = tt-proc-ped-ent.cod-estabel  
                                            and   proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent.nr-proc-exp 
                                            and   proc-ped-ent.nome-abrev   = tt-proc-ped-ent.nome-abrev  
                                            and   proc-ped-ent.nr-pedcli    = tt-proc-ped-ent.nr-pedcli   
                                            and   proc-ped-ent.nr-sequencia = tt-proc-ped-ent.nr-sequencia
                                            and   proc-ped-ent.it-codigo    = tt-proc-ped-ent.it-codigo   
                                            and   proc-ped-ent.cod-refer    = tt-proc-ped-ent.cod-refer   
                                            and   proc-ped-ent.nr-entrega   = tt-proc-ped-ent.nr-entrega no-error.
                                       if avail proc-ped-ent then
                                           delete proc-ped-ent.
                                   end.
                               &endif
                           END.
                       &ENDIF                            
                   end.
                   delete tt-proc-ped-ent. 
   
                end.   /* if avail proc-ped-venda */ 

             end.     /* if avail ped-ent */

       end.     /* bloco do tt-proc-ped-ent-aux  */
    
       &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN
           if not valid-handle(h-bocx195) then
               run cxbo/bocx195.p persistent set h-bocx195.
           RUN atualizaPesoItensPais IN h-bocx195 (INPUT c-cod-estabel,
                                                   INPUT c-nr-proc-exp).           
       &ENDIF
    
    end.   /*if avail tt-proc-ped-ent-aux  */
    if valid-handle (h-bocx195) then do:
        delete procedure h-bocx195.
        assign h-bocx195 = ?.
    end.
END PROCEDURE.

PROCEDURE carregaTTpedent:

    def input parameter table for tt-proc-ped-ent-aux.
    def input parameter numrows   as char  no-undo.
    def input parameter r-chave   as rowid no-undo.
   
    &if defined(bf_comex206b-1) &then
        def var de-quantidadeVinculada as decimal init 0 no-undo.
        def var de-quantidadeFaturada  as decimal init 0 no-undo.
    &endif

    find first tt-proc-ped-ent-aux NO-LOCK no-error.
    if not avail tt-proc-ped-ent-aux then do:
        find proc-ped-venda no-lock
             where rowid(proc-ped-venda) = r-chave no-error.
        if avail proc-ped-venda then do:
           find ped-venda no-lock
                where ped-venda.nome-abrev = proc-ped-venda.nome-abrev
                and   ped-venda.nr-pedcli  = proc-ped-venda.nr-pedcli no-error.
           if avail ped-venda then do:
               for each tt-ped-ent:
                  delete tt-ped-ent.
               end.
              for each ped-item of ped-venda no-lock
                  where ped-item.cod-sit-item <> 6:

                  /* L¼ todos os registros da tabela PED-ENT e verifica  se  jÿ
                     existe Processo de Exporta»’o para cada entrega.  Se exis-
                     tir, ent’o n’o carrega a temp-table.                    */
                  for each ped-ent of ped-item
                      where ped-ent.cod-sit-ent <> 6 no-lock:                        
                      &if defined(bf_comex206b-1) = 0 &then
                          find first proc-ped-ent no-lock
                               where proc-ped-ent.cod-estabel  = proc-ped-venda.cod-estabel
                               /*and   proc-ped-ent.nr-proc-exp  = ped-ent.nr-proc-exp*/
                               and   proc-ped-ent.nome-abrev   = ped-ent.nome-abrev
                               and   proc-ped-ent.nr-pedcli    = ped-ent.nr-pedcli
                               and   proc-ped-ent.nr-sequencia = ped-ent.nr-sequencia
                               and   proc-ped-ent.it-codigo    = ped-ent.it-codigo
                               and   proc-ped-ent.cod-refer    = ped-ent.cod-refer
                               and   proc-ped-ent.nr-entrega   = ped-ent.nr-entrega no-error.
                          if not avail proc-ped-ent then do:
                             create tt-ped-ent.
                             assign tt-ped-ent.nome-abrev   = ped-ent.nome-abrev
                                    tt-ped-ent.nr-pedcli    = ped-ent.nr-pedcli
                                    tt-ped-ent.nr-sequencia = ped-ent.nr-sequencia
                                    tt-ped-ent.it-codigo    = ped-ent.it-codigo
                                    tt-ped-ent.cod-refer    = ped-ent.cod-refer
                                    tt-ped-ent.nr-entrega   = ped-ent.nr-entrega
                                    tt-ped-ent.r-rowid      = rowid(ped-ent).
                          end.
                      &else
                      
                          assign de-quantidadeVinculada = 0.
                          for each proc-ped-ent no-lock
                                 where proc-ped-ent.cod-estabel  = proc-ped-venda.cod-estabel                                 
                                 and   proc-ped-ent.nome-abrev   = ped-ent.nome-abrev
                                 and   proc-ped-ent.nr-pedcli    = ped-ent.nr-pedcli
                                 and   proc-ped-ent.nr-sequencia = ped-ent.nr-sequencia
                                 and   proc-ped-ent.it-codigo    = ped-ent.it-codigo
                                 and   proc-ped-ent.cod-refer    = ped-ent.cod-refer
                                 and   proc-ped-ent.nr-entrega   = ped-ent.nr-entrega.
                      
                              assign de-quantidadeVinculada = de-quantidadeVinculada + proc-ped-ent.quantidade[1].
                          end.
                          
                          ASSIGN de-quantidadeFaturada = 0.
                          for each it-nota-fisc no-lock
                             where it-nota-fisc.nome-ab-cli  = ped-ent.nome-abrev
                               and it-nota-fisc.nr-pedcli    = ped-ent.nr-pedcli
                               and it-nota-fisc.nr-seq-ped   = ped-ent.nr-sequencia
                               and it-nota-fisc.it-codigo    = ped-ent.it-codigo
                               and it-nota-fisc.cod-refer    = ped-ent.cod-refer
                               and it-nota-fisc.nr-entrega   = ped-ent.nr-entrega:

                              /* Desconsidera notas fiscais canceladas */                                                     
                              IF CAN-FIND(FIRST nota-fiscal
                                          WHERE nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel
                                            AND nota-fiscal.serie       = it-nota-fisc.serie
                                            AND nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                            AND nota-fiscal.dt-cancela  <> ?) THEN NEXT.
                              
                              /*Desconsidera notas fiscais devolvidas*/
                              FOR FIRST devol-cli FIELDS(qt-devolvida) WHERE 
                                        devol-cli.cod-estabel = it-nota-fisc.cod-estabel and
                                        devol-cli.serie       = it-nota-fisc.serie       and
                                        devol-cli.nr-nota-fis = it-nota-fisc.nr-nota-fis and
                                        devol-cli.it-codigo   = it-nota-fisc.it-codigo no-lock: 
                                  ASSIGN de-qt-devolvida = de-qt-devolvida + devol-cli.qt-devolvida.
                              END.

                              assign de-quantidadeFaturada = de-quantidadeFaturada + it-nota-fisc.qt-faturada[1]. 
                          end.

                          if (de-quantidadeFaturada - de-qt-devolvida) >= ped-ent.qt-pedida then next.

                          create tt-ped-ent.
                          assign tt-ped-ent.nome-abrev   = ped-ent.nome-abrev
                                 tt-ped-ent.nr-pedcli    = ped-ent.nr-pedcli
                                 tt-ped-ent.nr-sequencia = ped-ent.nr-sequencia
                                 tt-ped-ent.it-codigo    = ped-ent.it-codigo
                                 tt-ped-ent.cod-refer    = ped-ent.cod-refer
                                 tt-ped-ent.nr-entrega   = ped-ent.nr-entrega
                                 tt-ped-ent.r-rowid      = rowid(ped-ent)
                                 tt-ped-ent.qt-pedida    = ped-ent.qt-pedida.

                      &endif

                  end.         /*    for each ped-ent         */
    
              end.         /*    for each ped-item        */
    
           end.        /*     IF avail ped-venda      */
 
        end.        /*     if avail proc-ped-venda  */
    end.
END.

PROCEDURE atualizaProcPedEntFilho:

    def input parameter table for tt-proc-ped-ent-pai.

    DEFINE VARIABLE r-chave         AS ROWID      NO-UNDO.
    DEFINE VARIABLE de-qt-vinculada AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE de-qt-saldo     AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE de-qt-pedida-pai AS DECIMAL    NO-UNDO.

    def buffer b-ped-ent for ped-ent.

    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN       
    EMPTY TEMP-TABLE tt-proc-ped-ent-filho.

    if not valid-handle(h-bocx195) then
        run cxbo/bocx195.p persistent set h-bocx195.
    FIND FIRST tt-proc-ped-ent-pai NO-LOCK NO-ERROR.
    IF AVAIL tt-proc-ped-ent-pai THEN DO:
        FOR EACH ped-ent exclusive-lock
           where ped-ent.nome-abrev   = tt-proc-ped-ent-pai.nome-abrev
             and ped-ent.nr-pedcli    = tt-proc-ped-ent-pai.nr-pedcli
             and ped-ent.nr-sequencia = tt-proc-ped-ent-pai.nr-sequencia, 
             each ped-item of ped-ent 
            where ped-item.ind-componen = 3 no-lock:
    
            &if defined(bf_comex206b-1) &then
                if ped-ent.nr-entrega <> tt-proc-ped-ent-pai.nr-entrega then next.

                RUN calculaQuantidadeVinculada IN h-bocx195(INPUT  ped-ent.nome-abrev   ,
                                                            INPUT  ped-ent.nr-pedcli    ,
                                                            INPUT  ped-ent.nr-sequencia ,
                                                            INPUT  ped-ent.it-codigo    ,
                                                            INPUT  ped-ent.cod-refer    ,
                                                            INPUT  ped-ent.nr-entrega   ,
                                                            OUTPUT de-qt-vinculada).
                /*NÆo tem saldo para vincular*/
                if (ped-ent.qt-pedida - de-qt-vinculada) <= 0 then next.
                find first b-ped-ent no-lock
                     where b-ped-ent.nome-abrev   = tt-proc-ped-ent-pai.nome-abrev
                       and b-ped-ent.nr-pedcli    = tt-proc-ped-ent-pai.nr-pedcli
                       and b-ped-ent.nr-sequencia = tt-proc-ped-ent-pai.nr-sequencia
                       and b-ped-ent.it-codigo    = tt-proc-ped-ent-pai.it-codigo
                       and b-ped-ent.cod-refer    = tt-proc-ped-ent-pai.cod-refer
                       and b-ped-ent.nr-entrega   = tt-proc-ped-ent-pai.nr-entrega no-error.
                if avail b-ped-ent then
                   assign de-qt-pedida-pai = b-ped-ent.qt-pedida.
            &endif
    
            IF NOT CAN-FIND(FIRST proc-ped-ent
                            WHERE proc-ped-ent.cod-estabel  = tt-proc-ped-ent-pai.cod-estabel
                              AND proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent-pai.nr-proc-exp
                              AND proc-ped-ent.nome-abrev   = ped-ent.nome-abrev  
                              AND proc-ped-ent.nr-pedcli    = ped-ent.nr-pedcli   
                              AND proc-ped-ent.nr-sequencia = ped-ent.nr-sequencia
                              AND proc-ped-ent.it-codigo    = ped-ent.it-codigo   
                              AND proc-ped-ent.cod-refer    = ped-ent.cod-refer     
                              AND proc-ped-ent.nr-entrega   = ped-ent.nr-entrega) THEN DO:
                
    
               create tt-proc-ped-ent-filho.
               assign tt-proc-ped-ent-filho.cod-estabel  = tt-proc-ped-ent-pai.cod-estabel
                      tt-proc-ped-ent-filho.nr-proc-exp  = tt-proc-ped-ent-pai.nr-proc-exp
                      tt-proc-ped-ent-filho.nome-abrev   = ped-ent.nome-abrev
                      tt-proc-ped-ent-filho.nr-pedcli    = ped-ent.nr-pedcli
                      tt-proc-ped-ent-filho.nr-sequencia = ped-ent.nr-sequencia
                      tt-proc-ped-ent-filho.it-codigo    = ped-ent.it-codigo
                      tt-proc-ped-ent-filho.cod-refer    = ped-ent.cod-refer
                      tt-proc-ped-ent-filho.nr-entrega   = ped-ent.nr-entrega
                      tt-proc-ped-ent-filho.nr-pedido    = tt-proc-ped-ent-pai.nr-pedido
                      &if defined(bf_comex206b-1) &then                                           
                      tt-proc-ped-ent-filho.quantidade[1] = tt-proc-ped-ent-pai.quantidade[1] / de-qt-pedida-pai * ped-ent.qt-pedida
                      &endif
                      {&tt-proc-ped-ent-filho.ind-componen}  = ped-item.ind-componen
                      de-qt-saldo                         = ped-ent.qt-pedida - de-qt-vinculada.

               &if defined(bf_comex206b-1) &then                   
               
                    /* Quantidade proporcional nÆo pode ser maior que quantidade nÆo vinculada */
                    if tt-proc-ped-ent-filho.quantidade[1] > de-qt-saldo then 
                        assign tt-proc-ped-ent-filho.quantidade[1] = de-qt-saldo.
               
                    if not valid-handle(h-bocx195) then
                        run cxbo/bocx195.p persistent set h-bocx195.

		            run setValidaNfEmbarque IN h-bocx195 (input l-val-nf-embarque).

                    RUN atualizaQuantidade IN h-bocx195 (input ROWID(ped-ent),
                                                         input-output table tt-proc-ped-ent-filho
                                                         &if defined(bf_comex206b-1) &then
                                                             ,tt-proc-ped-ent-filho.quantidade[1]
                                                         &endif
                                                         ).

                    FIND FIRST tt-proc-ped-ent-filho NO-ERROR.

                    find first proc-ped-ent no-lock 
                         where proc-ped-ent.cod-estabel  = tt-proc-ped-ent-filho.cod-estabel 
                           and proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent-filho.nr-proc-exp 
                           and proc-ped-ent.nome-abrev   = tt-proc-ped-ent-filho.nome-abrev  
                           and proc-ped-ent.nr-pedcli    = tt-proc-ped-ent-filho.nr-pedcli   
                           and proc-ped-ent.nr-sequencia = tt-proc-ped-ent-filho.nr-sequencia
                           and proc-ped-ent.it-codigo    = tt-proc-ped-ent-filho.it-codigo   
                           and proc-ped-ent.cod-refer    = tt-proc-ped-ent-filho.cod-refer   
                           and proc-ped-ent.nr-entrega   = tt-proc-ped-ent-filho.nr-entrega  no-error.
                    if avail proc-ped-ent then
                       run validateUpdate in h-bocx195 (input  table tt-proc-ped-ent-filho,
                                                        input  rowid (proc-ped-ent),
                                                        output table tt-bo-erro).
                    else
               &endif
    
               run validateCreate in h-bocx195(input table tt-proc-ped-ent-filho,
                                               output table tt-bo-erro,
                                               output r-chave).
               
               find first tt-bo-erro NO-LOCK no-error.
               if not avail tt-bo-erro then do:
                     &if defined(bf_dis_proc_ent) &then
                        &if defined(bf_comex206b-1) = 0 &then  
                            assign ped-ent.nr-proc-exp = tt-proc-ped-ent-filho.nr-proc-exp.
                        &endif
                     &endif
               end. 
    
               delete tt-proc-ped-ent-filho. 
    
             END.

        end.     /* for each ped-ent */
        if valid-handle (h-bocx195) then do:
            delete procedure h-bocx195.                                
            assign h-bocx195 = ?.
        end.
    
        DELETE tt-proc-ped-ent-pai.

    END.

    &ENDIF

END PROCEDURE.
&if defined(bf_comex206b-1) &then
  PROCEDURE outputTTErros:
  
      def output param table for rowErrors.

      for each RowErrors:
          delete RowErrors.
      end.
      
      for each tt-bo-erro:
          create rowErrors.
          assign rowErrors.ErrorSequence    = tt-bo-erro.i-sequen
                 rowErrors.ErrorNumber      = tt-bo-erro.cd-erro 
                 rowErrors.ErrorDescription = tt-bo-erro.mensagem
                 rowErrors.ErrorParameters  = tt-bo-erro.parametros
                 rowErrors.ErrorType        = tt-bo-erro.errortype 
                 rowErrors.ErrorHelp        = tt-bo-erro.errorhelp 
                 rowErrors.ErrorSubType     = tt-bo-erro.errorsubtype.
      end.

          
  END PROCEDURE.
&endif    

PROCEDURE pi-retorna-num-registro:
    DEFINE INPUT PARAMETER pc-nr-pedcli   LIKE ped-ent.nr-pedcli  NO-UNDO.
    DEFINE INPUT PARAMETER pc-nome-abrev  LIKE ped-ent.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-num-reg    AS   INT                NO-UNDO.
   
    FIND FIRST ped-venda
         WHERE ped-venda.nr-pedcli   = pc-nr-pedcli
           AND ped-venda.nome-abrev  = pc-nome-abrev NO-LOCK NO-ERROR.
    IF AVAIL ped-venda THEN DO:
        FOR EACH ped-ent
           WHERE ped-ent.nr-pedcli = ped-venda.nr-pedcli
             AND ped-ent.nome-abrev = ped-venda.nome-abrev NO-LOCK:
            ASSIGN pi-num-reg = pi-num-reg + 1.
        END.
    END.
     
END PROCEDURE. 

PROCEDURE carregaTTpedentAVincular:

    def input parameter r-chave   as rowid no-undo.
   
    &if defined(bf_comex206b-1) &then
        def var de-quantidadeVinculada as decimal init 0 no-undo.
        def var de-quantidadeFaturada  as decimal init 0 no-undo.
    &endif

    find proc-ped-venda no-lock
         where rowid(proc-ped-venda) = r-chave no-error.
    if avail proc-ped-venda then do:
       find ped-venda no-lock
            where ped-venda.nome-abrev = proc-ped-venda.nome-abrev
            and   ped-venda.nr-pedcli  = proc-ped-venda.nr-pedcli no-error.
       if avail ped-venda then do:
           for each tt-ped-ent:
              delete tt-ped-ent.
           end.
          for each ped-item of ped-venda no-lock
              where ped-item.cod-sit-item <> 6:

              /* L¼ todos os registros da tabela PED-ENT e verifica  se  jÿ
                 existe Processo de Exporta»’o para cada entrega.  Se exis-
                 tir, ent’o n’o carrega a temp-table.                    */
              for each ped-ent of ped-item
                  where ped-ent.cod-sit-ent <> 6 no-lock:                        
                  &if defined(bf_comex206b-1) = 0 &then
                      find first proc-ped-ent no-lock
                           where proc-ped-ent.cod-estabel  = proc-ped-venda.cod-estabel
                           /*and   proc-ped-ent.nr-proc-exp  = ped-ent.nr-proc-exp*/
                           and   proc-ped-ent.nome-abrev   = ped-ent.nome-abrev
                           and   proc-ped-ent.nr-pedcli    = ped-ent.nr-pedcli
                           and   proc-ped-ent.nr-sequencia = ped-ent.nr-sequencia
                           and   proc-ped-ent.it-codigo    = ped-ent.it-codigo
                           and   proc-ped-ent.cod-refer    = ped-ent.cod-refer
                           and   proc-ped-ent.nr-entrega   = ped-ent.nr-entrega no-error.
                      if not avail proc-ped-ent then do:
                         create tt-ped-ent.
                         assign tt-ped-ent.nome-abrev   = ped-ent.nome-abrev
                                tt-ped-ent.nr-pedcli    = ped-ent.nr-pedcli
                                tt-ped-ent.nr-sequencia = ped-ent.nr-sequencia
                                tt-ped-ent.it-codigo    = ped-ent.it-codigo
                                tt-ped-ent.cod-refer    = ped-ent.cod-refer
                                tt-ped-ent.nr-entrega   = ped-ent.nr-entrega
                                tt-ped-ent.r-rowid      = rowid(ped-ent).
                      end.
                  &else
                  
                      assign de-quantidadeVinculada = 0.
                      for each proc-ped-ent no-lock
                             where proc-ped-ent.cod-estabel  = proc-ped-venda.cod-estabel                                 
                             and   proc-ped-ent.nome-abrev   = ped-ent.nome-abrev
                             and   proc-ped-ent.nr-pedcli    = ped-ent.nr-pedcli
                             and   proc-ped-ent.nr-sequencia = ped-ent.nr-sequencia
                             and   proc-ped-ent.it-codigo    = ped-ent.it-codigo
                             and   proc-ped-ent.cod-refer    = ped-ent.cod-refer
                             and   proc-ped-ent.nr-entrega   = ped-ent.nr-entrega.
                  
                          assign de-quantidadeVinculada = de-quantidadeVinculada + proc-ped-ent.quantidade[1].
                      end.
                      
                      ASSIGN de-quantidadeFaturada = 0.
                      for each it-nota-fisc no-lock
                         where it-nota-fisc.nome-ab-cli  = ped-ent.nome-abrev
                           and it-nota-fisc.nr-pedcli    = ped-ent.nr-pedcli
                           and it-nota-fisc.nr-seq-ped   = ped-ent.nr-sequencia
                           and it-nota-fisc.it-codigo    = ped-ent.it-codigo
                           and it-nota-fisc.cod-refer    = ped-ent.cod-refer
                           and it-nota-fisc.nr-entrega   = ped-ent.nr-entrega:

                          FIND FIRST proc-it-nota-fisc
                               WHERE proc-it-nota-fisc.cod-estab-faturam = it-nota-fisc.cod-estabel
                                 AND proc-it-nota-fisc.serie             = it-nota-fisc.serie      
                                 AND proc-it-nota-fisc.nr-nota-fis       = it-nota-fisc.nr-nota-fis
                                 AND proc-it-nota-fisc.nr-seq-fat        = it-nota-fisc.nr-seq-fat 
                                 AND proc-it-nota-fisc.it-codigo         = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
                          IF AVAIL proc-it-nota-fisc THEN DO:
                              /*Desconsidera notas fiscais devolvidas*/
/*                               IF CAN-FIND(FIRST proc-nota-fiscal                                                          */
/*                                            WHERE proc-nota-fiscal.cod-estabel       = proc-it-nota-fisc.cod-estabel       */
/*                                              AND proc-nota-fiscal.nr-proc-exp       = proc-it-nota-fisc.nr-proc-exp       */
/*                                              and proc-nota-fiscal.cod-estab-faturam = proc-it-nota-fisc.cod-estab-faturam */
/*                                              AND proc-nota-fiscal.serie             = proc-it-nota-fisc.serie             */
/*                                              AND proc-nota-fiscal.nr-nota-fis       = proc-it-nota-fisc.nr-nota-fis       */
/*                                              AND proc-nota-fiscal.log-nf-devolvid ) THEN DO:                              */
                                 ASSIGN de-qt-devolvida = 0.
                                 for first devol-cli fields(qt-devolvida) where
                                           devol-cli.cod-estabel = proc-it-nota-fisc.cod-estabel and
                                           devol-cli.serie       = proc-it-nota-fisc.serie       and
                                           devol-cli.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis and
                                           devol-cli.it-codigo   = it-nota-fisc.it-codigo no-lock: 

                                     ASSIGN de-qt-devolvida = de-qt-devolvida + devol-cli.qt-devolvida.
                                 end.
/*                                  NEXT. */
/*                               END.     */

                              /* Desconsidera notas fiscais canceladas */                                                     
                              IF CAN-FIND(FIRST nota-fiscal
                                          WHERE nota-fiscal.cod-estabel = proc-it-nota-fisc.cod-estab-faturam
                                            AND nota-fiscal.serie       = proc-it-nota-fisc.serie
                                            AND nota-fiscal.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis
                                            AND nota-fiscal.dt-cancela  <> ?) THEN NEXT.
                          END.

                          assign de-quantidadeFaturada = de-quantidadeFaturada + it-nota-fisc.qt-faturada[1].
                      end.

                      if de-quantidadeFaturada - de-qt-devolvida >= ped-ent.qt-pedida then next.

                      create tt-ped-ent.
                      assign tt-ped-ent.nome-abrev   = ped-ent.nome-abrev
                             tt-ped-ent.nr-pedcli    = ped-ent.nr-pedcli
                             tt-ped-ent.nr-sequencia = ped-ent.nr-sequencia
                             tt-ped-ent.it-codigo    = ped-ent.it-codigo
                             tt-ped-ent.cod-refer    = ped-ent.cod-refer
                             tt-ped-ent.nr-entrega   = ped-ent.nr-entrega
                             tt-ped-ent.r-rowid      = rowid(ped-ent)
                             tt-ped-ent.qt-pedida    = ped-ent.qt-pedida.

                  &endif

              end.         /*    for each ped-ent         */

          end.         /*    for each ped-item        */

       end.        /*     IF avail ped-venda      */

    end.        /*     if avail proc-ped-venda  */
END.

PROCEDURE setValidaNfEmbarque:
    /*M‚todo utilizado para nÆo realizar algumas valida‡äes quando estiver 
    sendo transferida a Nota/Embarque pela rotina de subprocesso*/
    DEF INPUT PARAM pi-val-nf-embarque AS LOGICAL NO-UNDO.

    ASSIGN l-val-nf-embarque = pi-val-nf-embarque.
    
    RETURN "OK":U.
END PROCEDURE.

