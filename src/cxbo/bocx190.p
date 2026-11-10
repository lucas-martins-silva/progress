/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX190 2.00.00.046 } /*** "010046" 25/06/2025 06:16:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx190 MUT}
&ENDIF
/*
**  BOCX190.P
**
**  proc-ped-venda - 
**
*/
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY proc-ped-venda
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME proc-ped-venda

{utp/ut-glob.i}
{cdp/cdcfgdis.i} /* Definicao de pre-processadores */
{cdp/cdcfgcex.i} /* Definicao de pre-processadores */
{cdp/cdcfgmat.i}

{include/i_dbtype.i}
{include/i-epc200.i "bocx190"}
{include/boini.i}

{cxbo/bocx190.i RowObject}
{cxbo/bocx190.i tt-proc-ped-venda-aux}

/*Definicao de vari†veis*/
DEFINE VARIABLE c-unid-conver              AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c_mensagem_1               AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c_mensagem_2               AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-return-msg               AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-notas                    AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE de-qtd-conver              AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE pde-qt-proc-ext            AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE de-tot-peso                AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE de-tot-val                 AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE de-tot-qt                  AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE de-tot-cub-ped             AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE de-tot-cub-ent             AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE l-recebe-bodi317efm04      AS   LOGICAL   INITIAL NO       NO-UNDO.
DEFINE VARIABLE l-not-achou-proc-ped-venda AS   LOGICAL   INITIAL NO       NO-UNDO.
DEFINE VARIABLE h-bocx195                  AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-bocx195a                 AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-bocx260                  AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-bocx205                  AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-bocx185                  AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-bocx362                  AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE h-exapi                    AS   HANDLE                     NO-UNDO.
DEFINE VARIABLE r-proc-ped-venda           AS   ROWID                      NO-UNDO.
DEFINE VARIABLE c-cod-estabel              LIKE proc-ped-venda.cod-estabel NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp              LIKE proc-ped-venda.nr-proc-exp NO-UNDO. 
DEFINE VARIABLE c-nr-pedido                LIKE proc-ped-venda.nr-pedido   NO-UNDO.
DEFINE VARIABLE l-faturado                 as   log                        no-undo.
DEFINE VARIABLE c-un-medida                LIKE ITEM.un                    NO-UNDO.
DEFINE VARIABLE l-cria-subprocesso         AS LOGICAL   INIT NO            NO-UNDO.
DEFINE VARIABLE l-return-msg               AS LOGICAL   INIT NO            NO-UNDO.
DEFINE VARIABLE c-lista-re      AS   CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-cod-estab-del LIKE proc-ped-venda.cod-estabel NO-UNDO.
DEFINE VARIABLE c-proc-exp-del  LIKE proc-ped-venda.nr-proc-exp NO-UNDO.
DEFINE VARIABLE de-qt-atendida  AS   DECIMAL                    NO-UNDO.
DEFINE VARIABLE c-msg           AS   CHAR FORMAT "X(100)"       NO-UNDO.
DEFINE VARIABLE c-msg2          AS   CHAR FORMAT "X(100)"       NO-UNDO.
DEFINE VARIABLE l-elimina-todos AS   LOGICAL                    NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE p-relaciona-nota-embarque-ex0190 AS LOGICAL INITIAL "no" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gl-possui-embarque AS LOGICAL INITIAL YES NO-UNDO.

/*Definicao de temp-table*/
DEFINE TEMP-TABLE tt-proc-nota-fiscal NO-UNDO LIKE proc-nota-fiscal 
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-proc-ped-venda  NO-UNDO  LIKE proc-ped-venda 
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-proc-ped-ent NO-UNDO LIKE proc-ped-ent 
    FIELD r-rowid AS ROWID.   

DEFINE TEMP-TABLE tt-proc-ped-ent-aux NO-UNDO LIKE proc-ped-ent 
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-proc-desp-itiner NO-UNDO LIKE proc-desp-itiner.

DEFINE TEMP-TABLE tt-proc-ped-ent-filho NO-UNDO LIKE tt-proc-ped-ent.    

DEFINE TEMP-TABLE tt-embarque NO-UNDO
     FIELD cdd-embarq    LIKE embarque.cdd-embarq
     FIELD dt-embarque   AS   DATE FORMAT "99/99/9999":U
     FIELD identific     LIKE embarque.identific
     FIELD situacao      AS   CHARACTER FORMAT "x(15)":U
     FIELD tipo          AS   CHARACTER FORMAT "x(15)":U
     field r-rowid       AS   ROWID
     INDEX id IS PRIMARY cdd-embarq.

DEFINE TEMP-TABLE tt-bo-erro-aux NO-UNDO
     FIELD i-sequen     AS INTEGER
     FIELD cd-erro      AS INTEGER
     FIELD mensagem     AS CHARACTER FORMAT "x(255)":U
     FIELD parametros   AS CHARACTER FORMAT "x(255)":U INIT "":U
     FIELD errortype    AS CHARACTER FORMAT "x(20)":U
     FIELD errorhelp    AS CHARACTER FORMAT "x(20)":U
     FIELD errorsubtype AS CHARACTER.

DEFINE TEMP-TABLE tt-ped-ent NO-UNDO LIKE ped-ent USE-INDEX codigo
     FIELD r-rowid     AS ROWID
     FIELD log-select  AS LOGICAL INIT NO.

DEFINE TEMP-TABLE tt-bo-erro-aux1 NO-UNDO like tt-bo-erro.

DEFINE TEMP-TABLE tt-nota NO-UNDO
    FIELD cod-estabel LIKE nota-fiscal.cod-estabel
    FIELD serie       LIKE nota-fiscal.serie
    FIELD nr-nota-fis LIKE nota-fiscal.nr-nota-fis
    FIELD r-rowid     AS   ROWID.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

DEFINE BUFFER bf_nota_fiscal      FOR nota-fiscal.
DEFINE BUFFER b-ped-ent           FOR ped-ent.
DEFINE BUFFER b-it-pre-fat        FOR it-pre-fat.
DEFINE BUFFER bf-proc-nota-fiscal FOR proc-nota-fiscal.
DEFINE BUFFER bf-embarque         FOR embarque.
DEFINE BUFFER b-proc-ped-venda    FOR proc-ped-venda.

DEFINE VARIABLE de-fator-conver AS   DECIMAL INITIAL 1                  NO-UNDO.

 /*Convers∆o do valor do volume do item*/
 FOR FIRST para-dis NO-LOCK:
     /*Unidade de Medida da Convers∆o 1 = Cent°metros 2 = Metros*/
     IF para-dis.int-1 = 1 THEN
         ASSIGN de-fator-conver = 0.000001.
     ELSE
         ASSIGN de-fator-conver = 1.
 END.

PROCEDURE setConstraint1:
END PROCEDURE.

PROCEDURE setConstraint2:
    DEFINE INPUT PARAMETER p-cod-estab LIKE proc-ped-venda.cod-estabel NO-UNDO. 
    DEFINE INPUT PARAMETER p-proc-exp  LIKE proc-ped-venda.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER p-pedido    LIKE proc-ped-venda.nr-pedido   NO-UNDO.

    ASSIGN c-cod-estabel    = p-cod-estab 
           c-nr-proc-exp    = p-proc-exp
           c-nr-pedido      = p-pedido.

END PROCEDURE.


PROCEDURE setConstraint3:
    DEFINE INPUT PARAMETER r-chave AS ROWID NO-UNDO.
    
    FIND FIRST processo-exp
         WHERE ROWID(processo-exp) = r-chave NO-LOCK NO-ERROR.
   
END PROCEDURE.

 
PROCEDURE openQuery:
    DEFINE INPUT PARAMETER i-abertura AS INTEGER NO-UNDO.
    
    ASSIGN i-bo-query = i-abertura.
           l-query    = YES.

    CASE i-abertura:
        WHEN 1 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} NO-LOCK.
     
        WHEN 2 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} 
                                        WHERE proc-ped-venda.cod-estabel >= c-cod-estabel 
                                          AND proc-ped-venda.nr-proc-exp >= c-nr-proc-exp 
                                          AND proc-ped-venda.nr-pedido   >= c-nr-pedido NO-LOCK.
        WHEN 3 THEN
            OPEN QUERY {&QUERY-NAME} FOR EACH {&TABLE-NAME} OF processo-exp NO-LOCK
                                         BY proc-ped-venda.cod-estabel
                                         BY proc-ped-venda.nr-proc-exp
                                         BY proc-ped-venda.nr-pedido.


    END CASE.
END PROCEDURE.
 
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
/*{include/boexecre.i}*/
/*{include/boexeupt.i}*/
{include/boexedel.i}
{include/bovalupt.i}
/*{include/bovaldel.i}*/


PROCEDURE findCh_pedcli_proc:
    /*  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.*/
    DEFINE INPUT  PARAMETER p-nome-abrev  LIKE proc-ped-venda.nome-abrev  NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli   LIKE proc-ped-venda.nr-pedcli   NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE proc-ped-venda.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-proc-exp LIKE proc-ped-venda.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.
 
    FIND FIRST {&TABLE-NAME} 
         WHERE {&TABLE-NAME}.nome-abrev  = p-nome-abrev  
           AND {&TABLE-NAME}.nr-pedcli   = p-nr-pedcli
           AND {&TABLE-NAME}.cod-estabel = p-cod-estabel 
           AND {&TABLE-NAME}.nr-proc-exp = p-nr-proc-exp NO-LOCK NO-ERROR.
    IF NOT AVAIL {&TABLE-NAME} THEN  DO:
        {utp/ut-table.i mgcex proc-ped-venda 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        RETURN RETURN-VALUE.
    END.
    ELSE DO:
        RUN setCurrent.
        RETURN "":U.
    END.

END PROCEDURE.


PROCEDURE findCh_proc_exp:
    /*  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.*/
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE proc-ped-venda.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-proc-exp LIKE proc-ped-venda.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.
 
    FIND FIRST proc-ped-venda 
         WHERE proc-ped-venda.nr-proc-exp = p-nr-proc-exp         
           AND proc-ped-venda.cod-estabel = p-cod-estabel NO-LOCK NO-ERROR.
    IF  NOT AVAIL {&TABLE-NAME} THEN DO:
        {utp/ut-table.i mgcex proc-ped-venda 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
    END.
    ELSE DO:
        RUN setCurrent.
    END.

END PROCEDURE.


PROCEDURE findCh_proc_pedcli:
    /*  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.*/
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE proc-ped-venda.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-proc-exp LIKE proc-ped-venda.nr-proc-exp NO-UNDO.
    DEFINE INPUT  PARAMETER p-nome-abrev  LIKE proc-ped-venda.nome-abrev  NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedcli   LIKE proc-ped-venda.nr-pedcli   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.
 
    FIND FIRST proc-ped-venda 
         WHERE proc-ped-venda.cod-estabel = p-cod-estabel 
           AND proc-ped-venda.nr-proc-exp = p-nr-proc-exp 
           AND proc-ped-venda.nome-abrev  = p-nome-abrev  
           AND proc-ped-venda.nr-pedcli   = p-nr-pedcli NO-LOCK NO-ERROR.
    IF  NOT AVAIL {&TABLE-NAME} THEN DO:
        {utp/ut-table.i mgcex proc-ped-venda 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
    END.
    ELSE DO:
        RUN setCurrent.
    END.

END PROCEDURE.


PROCEDURE findpk_pro_pedvenda:
    /*  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.*/
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE proc-ped-venda.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-proc-exp LIKE proc-ped-venda.nr-proc-exp  NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedido   LIKE proc-ped-venda.nr-pedido    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.
 
    FIND FIRST proc-ped-venda 
         WHERE proc-ped-venda.cod-estabel = p-cod-estabel 
           AND proc-ped-venda.nr-proc-exp = p-nr-proc-exp 
           AND proc-ped-venda.nr-pedido   = p-nr-pedido NO-LOCK NO-ERROR.
    IF NOT AVAIL {&TABLE-NAME} THEN DO:
       {utp/ut-table.i mgcex proc-ped-venda 1}
       RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
    END.
    ELSE DO:
        RUN setCurrent.
    END.

END PROCEDURE.


PROCEDURE validateDelete:
    DEFINE INPUT-OUTPUT PARAMETER r-chave AS ROWID.
    DEFINE OUTPUT       PARAMETER TABLE FOR tt-bo-erro.
    
    def var cdd-embarq like embarque.cdd-embarq no-undo.

    RUN InitializeValidate.

    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.

    FIND FIRST {&TABLE-NAME} 
         WHERE ROWID({&TABLE-NAME}) = r-chave NO-LOCK NO-ERROR.
    
    IF AVAIL {&TABLE-NAME} THEN DO:
        ASSIGN gl-possui-embarque = NO
               l-elimina-todos    = NO
               l-return-msg       = NO.
    
        FOR FIRST it-pre-fat 
            WHERE it-pre-fat.nome-abrev = {&TABLE-NAME}.nome-abrev 
              AND it-pre-fat.nr-pedcli  = {&TABLE-NAME}.nr-pedcli  NO-LOCK:
           
            find first embarque NO-LOCK
                 where embarque.cdd-embarq = it-pre-fat.cdd-embarq no-error.
            IF AVAIL embarque THEN DO:     
                
                ASSIGN cdd-embarq = embarque.cdd-embarq. //Guarda o embarque para eliminar    
            
                IF NOT l-cria-subprocesso THEN DO:    
                   FOR FIRST b-proc-ped-venda
                       WHERE b-proc-ped-venda.cod-estabel  = {&TABLE-NAME}.cod-estabel
                         AND b-proc-ped-venda.nr-proc-exp  = {&TABLE-NAME}.nr-proc-exp
                         AND b-proc-ped-venda.nome-abrev   = it-pre-fat.nome-abrev
                         AND b-proc-ped-venda.nr-pedcli   <> it-pre-fat.nr-pedcli NO-LOCK:
                   END.
                   IF  AVAIL b-proc-ped-venda  /*encontrado mais de um pedido deste processo no embarque*/
                   AND embarque.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp THEN DO: 
                       {utp/ut-liter.i Pedido_vinculado_ao_embarque: * }
                       ASSIGN c-msg = TRIM(RETURN-VALUE) + " " + STRING(embarque.cdd-embarq) + ". ".
                       {utp/ut-liter.i Para_que_seja_poss°vel_eliminar_o_Pedido_deste_Processo,_todos_os_Pedidos_alocados_a_este_Embarque_ser∆o_eliminados_deste_Processo_automaticamente *}
                           RUN utp/ut-msgs.p (INPUT "show":U,
                                              INPUT 34669,
                                              INPUT c-msg + "~~" + TRIM(RETURN-VALUE)).
                  
                     ASSIGN l-return-msg    = (RETURN-VALUE = "YES":U)
                            l-elimina-todos = YES.
                   END.
                   ELSE DO:
                      {utp/ut-liter.i "Pedido de venda possui relacionamento com embarque. Confirma exclus∆o?" *}
                      assign c-msg = TRIM(RETURN-VALUE).
                      run utp/ut-msgs.p (input "show",
                                         input 32699,
                                         input c-msg).
                      ASSIGN l-return-msg = (RETURN-VALUE = "yes":U).
                  END.
               END.
               ELSE
                   ASSIGN l-return-msg = YES.
              
               IF NOT l-return-msg THEN DO:                   
                   ASSIGN gl-possui-embarque = YES.
                   RETURN "NOK":U.
    
               END.
            END.
        END.   /*it-pre-fat*/
    
        IF l-return-msg THEN DO:
            IF l-elimina-todos THEN DO:
                FOR EACH b-proc-ped-venda NO-LOCK
                   WHERE b-proc-ped-venda.cod-estabel = {&TABLE-NAME}.cod-estabel
                     AND b-proc-ped-venda.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp:                        

                    /* Eliminar apenas do embarque selecionado */
                    FOR FIRST it-pre-fat 
                        WHERE it-pre-fat.nome-abrev = b-proc-ped-venda.nome-abrev 
                        AND   it-pre-fat.nr-pedcli  = b-proc-ped-venda.nr-pedcli 
                        AND   it-pre-fat.cdd-embarq = cdd-embarq NO-LOCK:             
    
                        RUN validateDeleteAux IN THIS-PROCEDURE (INPUT b-proc-ped-venda.cod-estabel,
                                                                 INPUT b-proc-ped-venda.nr-proc-exp,
                                                                 INPUT b-proc-ped-venda.nr-pedido,
                                                                 INPUT-OUTPUT r-chave).                      
                    END.                
                END.                
            END.
            ELSE
                RUN validateDeleteAux IN THIS-PROCEDURE (INPUT {&TABLE-NAME}.cod-estabel,
                                                         INPUT {&TABLE-NAME}.nr-proc-exp,
                                                         INPUT {&TABLE-NAME}.nr-pedido,
                                                         INPUT-OUTPUT r-chave).
        END.
        ELSE 
            RUN validateDeleteAux IN THIS-PROCEDURE (INPUT {&TABLE-NAME}.cod-estabel,
                                                     INPUT {&TABLE-NAME}.nr-proc-exp,
                                                     INPUT {&TABLE-NAME}.nr-pedido,
                                                     INPUT-OUTPUT r-chave).
    END.

    RETURN "":U.

END PROCEDURE.
        
/*******/  

PROCEDURE validateDeleteAux:
    DEFINE INPUT PARAMETER c-cod-estab-del  LIKE {&TABLE-NAME}.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER c-proc-exp-del   LIKE {&TABLE-NAME}.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER i-nr-pedido      LIKE {&TABLE-NAME}.nr-pedido   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER r-chave   AS   ROWID                     NO-UNDO.

    IF  NOT VALID-HANDLE(h-bocx195) THEN
        RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.
    
    FIND FIRST {&TABLE-NAME} 
         WHERE {&TABLE-NAME}.cod-estabel = c-cod-estab-del
           AND {&TABLE-NAME}.nr-proc-exp = c-proc-exp-del 
           AND {&TABLE-NAME}.nr-pedido   = i-nr-pedido EXCLUSIVE-LOCK NO-ERROR.
    
    IF AVAIL {&TABLE-NAME} THEN DO:
        ASSIGN r-chave = ROWID({&TABLE-NAME}).

        FOR EACH tt-epc WHERE tt-epc.cod-event = "VALIDA-ENTREGA": 
            DELETE tt-epc. 
        END.
            
        {include/i-epc200.i2 &CodEvent='"VALIDA-ENTREGA"'
                             &CodParameter='"ENTREGA-FATURADA"'
                             &ValueParameter='"NO"'}
                             
        {include/i-epc201.i "VALIDA-ENTREGA"}
    
        /* Chamada EPC inserida para os clientes que necessitam vincular/desvincular do processo de exportaá∆o entregas j† faturadas*/
        FIND FIRST tt-epc 
             WHERE tt-epc.cod-event     = "VALIDA-ENTREGA" 
               AND tt-epc.cod-parameter = "ENTREGA-FATURADA" 
               AND tt-epc.val-parameter = "YES" NO-ERROR.
        IF NOT AVAIL tt-epc THEN DO:
            /* pedido/entrega j† atendida */      
                ASSIGN de-qt-atendida = 0.
            
            FOR EACH proc-ped-ent NO-LOCK
               WHERE proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel
                 AND proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp
                 AND proc-ped-ent.nome-abrev  = {&TABLE-NAME}.nome-abrev
                 AND proc-ped-ent.nr-pedcli   = {&TABLE-NAME}.nr-pedcli:                 
                
                 run calculaQuantidadeAtendida IN h-bocx195 (INPUT  proc-ped-ent.cod-estabel,
                                                             INPUT  proc-ped-ent.nr-proc-exp,  
                                                             INPUT  proc-ped-ent.nome-abrev ,
                                                             INPUT  proc-ped-ent.nr-pedcli  ,
                                                             INPUT  proc-ped-ent.nr-sequencia ,
                                                             INPUT  proc-ped-ent.it-codigo    ,
                                                             INPUT  proc-ped-ent.cod-refer    ,
                                                             INPUT  proc-ped-ent.nr-entrega ,
                                                             OUTPUT de-qt-atendida). 
                 IF de-qt-atendida <> 0 THEN DO:
                
                     ASSIGN i-seq-erro = i-seq-erro + 1.
                     RUN utp/ut-msgs.p (INPUT "msg":U,
                                        INPUT 28383,
                                        INPUT "").
                     CREATE tt-bo-erro.
                     ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                            tt-bo-erro.cd-erro      = 28383
                            tt-bo-erro.mensagem     = RETURN-VALUE.
                     LEAVE.
                 END.
            END.
        END.
    
        ASSIGN c-lista-re = "".
        FOR EACH reg-export-item FIELDS(nr-re-ems) NO-LOCK
           WHERE reg-export-item.cod-estabel = {&TABLE-NAME}.cod-estabel
             AND reg-export-item.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp
             AND reg-export-item.nome-abrev  = {&TABLE-NAME}.nome-abrev
             AND reg-export-item.nr-pedcli   = {&TABLE-NAME}.nr-pedcli:
    
            IF  LOOKUP(STRING(reg-export-item.nr-re-ems),c-lista-re) = 0 THEN DO:
                IF  c-lista-re = "" THEN
                    ASSIGN c-lista-re = STRING(reg-export-item.nr-re-ems).
                ELSE
                    ASSIGN c-lista-re = c-lista-re + " ," + STRING(reg-export-item.nr-re-ems).
            END.
        END.
    
        IF  c-lista-re <> "" AND NOT l-cria-subprocesso THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            /* Inicio -- Projeto Internacional*/
            {utp/ut-liter.i "pedido" *}
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 30557,
                               INPUT RETURN-VALUE + "~~" + c-lista-re).
            CREATE tt-bo-erro.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-pedido AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "pedido" *}
            ASSIGN c-lbl-liter-pedido = TRIM(RETURN-VALUE).
            ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 30557
                   tt-bo-erro.mensagem     = c-lbl-liter
                   tt-bo-erro.parametros    = c-lbl-liter-pedido + "~~" + c-lista-re.
        END.      
                    
        IF NOT CAN-FIND(FIRST tt-bo-erro) THEN DO:
            ASSIGN de-tot-peso    = 0
                   de-tot-val     = 0
                   de-tot-qt      = 0
                   de-tot-cub-ped = 0
                   de-tot-cub-ent = 0.
                       
            FIND FIRST ped-venda EXCLUSIVE-LOCK
                 WHERE ped-venda.nome-abrev = {&TABLE-NAME}.nome-abrev
                   AND ped-venda.nr-pedcli  = {&TABLE-NAME}.nr-pedcli NO-ERROR.
            IF  AVAIL ped-venda THEN DO:
                ASSIGN ped-venda.nr-invoice  = "".
                          
                  &if defined(bf_dis_proc_ent) &then
                      ASSIGN ped-venda.nr-proc-exp = "".                              
                  &endif    
           END.
           FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nome-abrev = {&TABLE-NAME}.nome-abrev
                   AND ped-venda.nr-pedcli  = {&TABLE-NAME}.nr-pedcli NO-ERROR.
    
           RUN deleteTable IN h-bocx195 (INPUT {&TABLE-NAME}.cod-estabel,
                                         INPUT {&TABLE-NAME}.nr-proc-exp,
                                         INPUT {&TABLE-NAME}.nome-abrev,
                                         INPUT {&TABLE-NAME}.nr-pedcli). 
    
           RUN getTtBoErro IN h-bocx195 (OUTPUT TABLE tt-bo-erro).
    
           FIND FIRST tt-bo-erro WHERE tt-bo-erro.errorSubType <> "WARNING":U NO-ERROR.
           IF  NOT AVAIL tt-bo-erro THEN DO:
               &if defined(bf_dis_proc_ent) &then
                   run pi-chama-upc-ExcluiProcessoItiner.
               &endif
               RUN executeDelete.
    
               /*Desvincula o Embarque do Processo de exportaá∆o*/
               IF l-return-msg THEN DO:
                   IF l-elimina-todos THEN DO:
                      FIND CURRENT embarque EXCLUSIVE-LOCK.
                      IF  AVAIL embarque THEN DO:
                         IF embarque.nr-proc-exp = c-proc-exp-del THEN
                            assign embarque.nr-proc-exp     = ""
                                   embarque.cdn-tip-relacto = 1
                                   gl-possui-embarque       = NO.
                      END.
                   END.
                   ELSE DO:
                      IF NOT CAN-FIND(FIRST b-it-pre-fat 
                                      WHERE b-it-pre-fat.cdd-embarq = embarque.cdd-embarq 
                                        AND b-it-pre-fat.nr-pedcli <> it-pre-fat.nr-pedcli) THEN DO:
                         FIND CURRENT embarque EXCLUSIVE-LOCK.
                         IF  AVAIL embarque THEN DO:
                             IF embarque.nr-proc-exp = c-proc-exp-del THEN
                                assign embarque.nr-proc-exp     = ""
                                       embarque.cdn-tip-relacto = 1
                                       gl-possui-embarque       = NO.
                         END.
                      END.
                   END.
               END.
                 
               FIND FIRST processo-exp 
                    WHERE processo-exp.cod-estabel = c-cod-estab-del 
                      AND processo-exp.nr-proc-exp = c-proc-exp-del  EXCLUSIVE-LOCK NO-ERROR.
               IF  AVAIL processo-exp THEN
                   ASSIGN processo-exp.log-1 = NO.
           END.
        END.
    END.
	
	IF  VALID-HANDLE(h-bocx195) THEN DO:
		DELETE PROCEDURE h-bocx195.
		ASSIGN h-bocx195 = ?.
	END.	
    
    IF l-query THEN 
        GET NEXT {&query-name} NO-LOCK.
    ELSE
       FIND NEXT {&TABLE-NAME} NO-LOCK NO-ERROR.

    IF  NOT AVAIL {&TABLE-NAME} THEN
        IF  l-query THEN
            GET PREV {&query-name} NO-LOCK.
        ELSE
            FIND PREV {&TABLE-NAME} NO-LOCK NO-ERROR.
    
    ASSIGN r-chave = ROWID({&TABLE-NAME}).

    IF AVAIL {&TABLE-NAME} THEN DO:

        IF  NOT VALID-HANDLE(h-bocx185) THEN
            RUN cxbo/bocx185.p PERSISTENT SET h-bocx185.
        RUN AtualizaSituacaoProcesso IN h-bocx185 (INPUT {&TABLE-NAME}.cod-estabel,
                                                   INPUT {&TABLE-NAME}.nr-proc-exp).
		IF  VALID-HANDLE(h-bocx185) THEN DO:
			DELETE PROCEDURE h-bocx185.
			ASSIGN h-bocx185 = ?.
		END.									   
    END.
    
    IF  AVAIL {&TABLE-NAME} THEN DO:
        IF  NOT VALID-HANDLE(h-bocx362) THEN
            RUN cxbo/bocx362.p PERSISTENT SET h-bocx362.
            
        RUN VerificaLogPendente IN h-bocx362 (INPUT {&TABLE-NAME}.cod-estabel,
                                              INPUT {&TABLE-NAME}.nr-proc-exp).
        if  RETURN-VALUE = "NOK" THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Pedido_de_Venda" *}
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 31546,
                               INPUT RETURN-VALUE).
            CREATE tt-bo-erro.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-2 AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-liter-2 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-pedido-de-venda AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Pedido_de_Venda" *}
            ASSIGN c-lbl-liter-pedido-de-venda = TRIM(RETURN-VALUE).
            ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 31546
                   tt-bo-erro.mensagem     = c-lbl-liter-2
                   tt-bo-erro.parametros    = c-lbl-liter-pedido-de-venda.
        END.    
        IF VALID-HANDLE(h-bocx362) THEN DO:
            DELETE PROCEDURE h-bocx362.          
            ASSIGN h-bocx362 = ?.
        END.
    END.
        
    RETURN "".

END PROCEDURE.
 
procedure validateCreate:
    /*
    **  Valida criaá∆o da tabela/duplicidade de registro.
    */
    DEFINE INPUT  PARAMETER l-recebe AS  LOGICAL     NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE    FOR RowObject.
    DEFINE OUTPUT PARAMETER TABLE    FOR tt-bo-erro.
    DEFINE OUTPUT PARAMETER r-chave  AS  ROWID       NO-UNDO.
 
    RUN initializeValidate.
    RUN startMethod ("validateCREATE").
 
    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.
 
    FIND FIRST rowObject NO-LOCK NO-ERROR.
    
    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nome-abrev = rowObject.nome-abrev 
           AND ped-venda.nr-pedcli  = rowObject.nr-pedcli NO-ERROR.
    IF AVAIL ped-venda THEN DO:
        /* Pedido de Venda n∆o est† completo */
        IF  ped-venda.completo = NO THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 7900,
                               INPUT "").
            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 7900
                   tt-bo-erro.mensagem     = RETURN-VALUE.
        END.
        ELSE DO:
            FIND FIRST processo-exp NO-LOCK
                 WHERE processo-exp.cod-estabel = rowobject.cod-estabel
                   AND processo-exp.nr-proc-exp = rowobject.nr-proc-exp NO-ERROR.
            FOR EACH ped-venda-desp NO-LOCK
               WHERE ped-venda-desp.nome-abrev   = ped-venda.nome-abrev 
                 AND ped-venda-desp.nr-pedcli    = ped-venda.nr-pedcli,
               FIRST desp-imp NO-LOCK
               WHERE desp-imp.cod-desp = ped-venda-desp.cdn-despes
                 AND desp-imp.tipo     = 9:

                IF  processo-exp.volume-inf = 0 THEN DO:
                    ASSIGN i-seq-erro = i-seq-erro + 1.
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Volume_do_Processo_de_Exportaá∆o_n∆o_pode_estar_zerado" *}
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 25997,
                                       INPUT RETURN-VALUE).
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 25997
                           tt-bo-erro.mensagem     = RETURN-VALUE.
                    LEAVE.
                END.
            END.
        END.
        IF NOT CAN-FIND(FIRST tt-bo-erro NO-LOCK
                        WHERE tt-bo-erro.errorSubType <> "WARNING":U) THEN
            ASSIGN rowObject.nr-pedido = ped-venda.nr-pedido.
    END.
    
    IF NOT CAN-FIND(FIRST tt-bo-erro WHERE
                          tt-bo-erro.errorsubtype <> "warning":U) THEN DO:
        RUN ValidateCriaRelacao (INPUT l-recebe,
                                 INPUT  TABLE RowObject,
                                 OUTPUT TABLE tt-bo-erro,
                                 OUTPUT r-chave,
                                 INPUT  YES).
        RUN endMethod ("validateCREATE").
    
        /*
        FIND FIRST proc-ped-venda WHERE proc-ped-venda.nr-pedido = rowObject.nr-pedido NO-ERROR.
        */
        
        FIND FIRST proc-ped-venda 
             WHERE proc-ped-venda.cod-estabel = rowObject.cod-estabel
               AND proc-ped-venda.nr-proc-exp = rowObject.nr-proc-exp 
               AND proc-ped-venda.nr-pedido   = rowObject.nr-pedido NO-LOCK NO-ERROR.
    END.
END PROCEDURE.


PROCEDURE validarecebevariavelbodi317efm04:
DEFINE INPUT PARAMETER p-recebe-bodi317efm04 as logical NO-UNDO.

ASSIGN l-recebe-bodi317efm04 = p-recebe-bodi317efm04.

END PROCEDURE.

PROCEDURE validateCriaRelacao:
    DEFINE INPUT  PARAMETER l-recebe AS  LOGICAL.
    DEFINE INPUT  PARAMETER TABLE    FOR RowObject. 
    DEFINE OUTPUT PARAMETER TABLE    FOR tt-bo-erro.
    DEFINE OUTPUT PARAMETER r-chave  AS  ROWID.
    DEFINE INPUT  PARAMETER l-FIELDS AS  LOGICAL.
    
    DEFINE VARIABLE c-un-fatur       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE de-quantidade    AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE de-volume-inf    AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE i-idi-unid-fatur AS INTEGER   NO-UNDO.
    DEFINE VARIABLE l-prim-pedido    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE r-chave-aux      AS ROWID     NO-UNDO.

    FIND FIRST rowObject EXCLUSIVE-LOCK NO-ERROR.
    IF  l-FIELDS THEN DO:
        RUN validateFIELDS.
    END.
    
    &if defined(bf_dis_proc_ent) &then
        IF  NOT rowobject.log-1 THEN DO:
            FOR EACH tt-epc WHERE tt-epc.cod-event = "VALID-PEDIDO": 
               DELETE tt-epc. 
            END.
            {include/i-epc200.i2 &CodEvent='"VALID-PEDIDO"'
                                 &CodParameter='"TABLE-FIELDS"'
                                 &ValueParameter=STRING(RowObject.nr-pedido) }
            {include/i-epc201.i "VALID-PEDIDO"}
            
            FOR EACH tt-epc
               WHERE tt-epc.cod-event = "VALID-PARAMETER":

               ASSIGN i-seq-erro = i-seq-erro + 1.
               RUN utp/ut-msgs.p (INPUT "msg":U,
                                  INPUT INT(SUBSTRING(tt-epc.val-parameter,1,5)),
                                  INPUT SUBSTRING(tt-epc.val-parameter,6,11)).
               CREATE tt-bo-erro.
               ASSIGN tt-bo-erro.i-sequen  = i-seq-erro
                      tt-bo-erro.cd-erro   = INT(SUBSTRING(tt-epc.val-parameter,1,5))
                      tt-bo-erro.mensagem  = RETURN-VALUE.
            END.
        END.
    &endif
    
    
    &if defined(bf_dis_proc_ent) &then
        ASSIGN c-cod-estabel = rowobject.cod-estabel
               c-nr-proc-exp = rowobject.nr-proc-exp
               c-nr-pedido   = rowobject.nr-pedido.
        {cxbo/bocx190.i2}
        FIND FIRST tt-epc 
             WHERE tt-epc.cod-event = "VALID-PROCESS" 
               AND tt-epc.cod-parameter = "NOT-VALIDATE" NO-ERROR.
        IF NOT AVAIL tt-epc THEN DO:
    &endif
    

    FIND FIRST proc-ped-venda 
         WHERE proc-ped-venda.cod-estabel = rowObject.cod-estabel
           AND proc-ped-venda.nr-proc-exp = rowObject.nr-proc-exp 
           AND proc-ped-venda.nr-pedido   = rowObject.nr-pedido NO-LOCK NO-ERROR.
    IF  AVAIL proc-ped-venda THEN DO:
        IF  l-recebe-bodi317efm04 = NO THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex proc-ped-venda 1}
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 8,
                               INPUT RETURN-VALUE).
            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = RETURN-VALUE.
        END.
    END.
    ELSE
        ASSIGN l-not-achou-proc-ped-venda = YES.
    
    &if defined(bf_dis_proc_ent) &then
        END.
    &endif

    FIND FIRST processo-exp NO-LOCK
         WHERE processo-exp.cod-estabel = rowobject.cod-estabel
           AND processo-exp.nr-proc-exp = rowobject.nr-proc-exp NO-ERROR.

    ASSIGN l-prim-pedido = yes.
    
    FIND FIRST param-exp
         WHERE param-exp.cod-estabel = rowObject.cod-estabel NO-LOCK NO-ERROR.
    
    FIND FIRST proc-ped-venda NO-LOCK
         WHERE proc-ped-venda.cod-estabel = rowObject.cod-estabel
           and proc-ped-venda.nr-proc-exp = rowObject.nr-proc-exp NO-ERROR.
    IF  AVAIL proc-ped-venda THEN DO:
        ASSIGN l-prim-pedido = no.
        IF  NOT AVAIL ped-venda 
             OR ped-venda.nome-abrev <> rowObject.nome-abrev
             OR ped-venda.nr-pedcli  <> rowObject.nr-pedcli THEN
            FIND FIRST ped-venda NO-LOCK 
                 WHERE ped-venda.nome-abrev = rowObject.nome-abrev 
                 AND   ped-venda.nr-pedcli  = rowObject.nr-pedcli NO-ERROR.

        IF  AVAIL ped-venda THEN DO:         
            IF  AVAIL processo-exp 
            AND ped-venda.cod-cond-pag <> processo-exp.cod-cond-pagto THEN DO:
                ASSIGN i-seq-erro = i-seq-erro + 1.
                      
                IF  AVAIL param-exp
                AND (SUBSTRING(param-exp.char-1,22,1) = "1" OR SUBSTRING(param-exp.char-1,22,1) = "") THEN DO:
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 31611,
                                       INPUT "").
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 31611
                           tt-bo-erro.errorSubType = "WARNING":U
                           tt-bo-erro.mensagem     = RETURN-VALUE.
                END.
                ELSE DO:
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 30333,
                                       INPUT "").
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen = i-seq-erro                   
                           tt-bo-erro.cd-erro  = 30333
                           tt-bo-erro.mensagem = RETURN-VALUE.                                                                                       
                END.
            END.
            ELSE DO: 
                IF  ped-venda.cod-cond-pag      = 0 
                AND processo-exp.cod-cond-pagto = 0 THEN DO:
                    
                    IF  AVAIL param-exp 
                    AND SUBSTRING(param-exp.char-1,22,1) = "2" THEN DO: 
                        
                        ASSIGN i-seq-erro = i-seq-erro + 1.
                        RUN utp/ut-msgs.p (INPUT "msg":U,
                                           INPUT 30334,
                                           INPUT "").
                        CREATE tt-bo-erro.
                        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                               tt-bo-erro.cd-erro      = 30334
                               tt-bo-erro.mensagem     = RETURN-VALUE.
                    END.
                END.
            END.
        END.
    END.

    IF  l-prim-pedido THEN DO:
        if  not avail ped-venda 
            or  ped-venda.nome-abrev <> rowObject.nome-abrev
            or  ped-venda.nr-pedcli  <> rowObject.nr-pedcli then
            find FIRST ped-venda no-lock 
                 where ped-venda.nome-abrev = rowObject.nome-abrev 
                 AND   ped-venda.nr-pedcli  = rowObject.nr-pedcli no-error.

        IF  AVAIL processo-exp AND AVAIL(ped-venda)
        AND ped-venda.cod-cond-pag <> processo-exp.cod-cond-pagto THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            IF  AVAIL param-exp 
            AND (SUBSTRING(param-exp.char-1,22,1) = "1" or SUBSTRING(param-exp.char-1,22,1) = "") THEN DO: 
                RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 31611, INPUT "").
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 31611
                       tt-bo-erro.errorSubType = "WARNING":U
                       tt-bo-erro.mensagem     = RETURN-VALUE.
            END. /* IF  AVAIL param-exp ... */
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 30333,
                                   INPUT "").
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.i-sequen = i-seq-erro                   
                       tt-bo-erro.cd-erro  = 30333
                       tt-bo-erro.mensagem = RETURN-VALUE.                                                                                       
            END. /* ELSE DO: */
        END. /* IF  AVAIL processo-exp ... */
    END. /* IF  l-prim-pedido THEN DO: */

    FIND FIRST tt-bo-erro 
         WHERE tt-bo-erro.errorsubtype <> "warning":U NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-bo-erro THEN DO:
       RUN executeCreate (INPUT  l-recebe, 
                          OUTPUT TABLE tt-bo-erro-aux1,
                          OUTPUT r-proc-ped-venda).

        FOR EACH tt-bo-erro-aux1:
            CREATE tt-bo-erro.
            BUFFER-COPY tt-bo-erro-aux1 TO tt-bo-erro.
        END.
    
        FIND FIRST proc-ped-venda EXCLUSIVE-LOCK 
             WHERE ROWID(proc-ped-venda) = r-proc-ped-venda NO-ERROR.
        IF NOT AVAIL proc-ped-venda THEN RETURN.

        FIND FIRST processo-exp 
             WHERE processo-exp.cod-estabel = {&TABLE-NAME}.cod-estabel 
               AND processo-exp.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL processo-exp THEN
           ASSIGN processo-exp.log-1 = NO.
    
        ASSIGN r-chave = r-proc-ped-venda.
           
        IF  NOT CAN-FIND(FIRST tt-bo-erro 
                        WHERE tt-bo-erro.errorsubtype <> "warning":U) THEN DO:
     
            IF  l-recebe THEN DO:
                FIND FIRST ped-venda NO-LOCK 
                     WHERE ped-venda.nome-abrev = rowObject.nome-abrev 
                       AND ped-venda.nr-pedcli  = rowObject.nr-pedcli NO-ERROR.
                IF  AVAIL ped-venda THEN DO:
                    ASSIGN de-tot-peso    = 0
                           de-tot-val     = 0
                           de-tot-qt      = 0
                           de-tot-cub-ped = 0
                           de-tot-cub-ent = 0.
    
                    IF  NOT VALID-HANDLE(h-exapi) THEN
                        RUN exp/exapi010.p PERSISTENT SET h-exapi.
    
                    FOR EACH b-ped-ent 
                       WHERE b-ped-ent.nome-abrev  = rowObject.nome-abrev
                         AND b-ped-ent.nr-pedcli   = rowObject.nr-pedcli NO-LOCK:
                       
                       FOR EACH tt-ped-ent EXCLUSIVE-LOCK.
                           DELETE tt-ped-ent.
                       END.
    
                       CREATE tt-ped-ent.
                       BUFFER-COPY b-ped-ent TO tt-ped-ent.
    
                       FIND FIRST tt-ped-ent NO-ERROR.
                           
                       FOR FIRST proc-ped-ent  
                           WHERE proc-ped-ent.cod-estabel  = {&TABLE-NAME}.cod-estabel
                             AND proc-ped-ent.nr-proc-exp  = {&TABLE-NAME}.nr-proc-exp
                             AND proc-ped-ent.nome-abrev   = b-ped-ent.nome-abrev
                             AND proc-ped-ent.nr-pedcli    = b-ped-ent.nr-pedcli
                             AND proc-ped-ent.nr-sequencia = b-ped-ent.nr-sequencia
                             AND proc-ped-ent.it-codigo    = b-ped-ent.it-codigo
                             AND proc-ped-ent.cod-refer    = b-ped-ent.cod-refer
                             AND proc-ped-ent.nr-entrega   = b-ped-ent.nr-entrega NO-LOCK: 
                       END.
                           
                       IF  AVAIL proc-ped-ent THEN DO:
                           ASSIGN tt-ped-ent.qt-pedida = proc-ped-ent.quantidade[1].
                                
                            FOR FIRST ped-item  NO-LOCK
                                WHERE ped-item.nome-abrev    = proc-ped-ent.nome-abrev    
                                  AND ped-item.nr-pedcli     = proc-ped-ent.nr-pedcli     
                                  AND ped-item.nr-sequencia  = proc-ped-ent.nr-sequencia  
                                  AND ped-item.it-codigo     = proc-ped-ent.it-codigo     
                                  AND ped-item.cod-refer     = proc-ped-ent.cod-refer:
                            END.
                            IF AVAIL ped-item THEN DO:
                                IF ped-item.ind-fat-qtfam THEN DO:     

                                    IF  NOT VALID-HANDLE(h-bocx195) THEN
                                        RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.

                                    RUN converteQtdUnMedidaClienteFamilia IN h-bocx195 (INPUT  proc-ped-ent.it-codigo,
                                                                                        INPUT  proc-ped-ent.nome-abrev,
                                                                                        INPUT  proc-ped-ent.idi-unid-fatur,
                                                                                        INPUT  proc-ped-ent.quantidade[1],
                                                                                        INPUT  ped-item.des-un-medida,
                                                                                        OUTPUT de-quantidade,
                                                                                        OUTPUT c-un-fatur).  
                                    
                                    ASSIGN tt-ped-ent.vl-tot-it = (de-quantidade * ped-item.vl-preuni).
                                END.    
                                ELSE                                 
                                    ASSIGN tt-ped-ent.vl-tot-it = (proc-ped-ent.quantidade[1] * ped-item.vl-preuni).
                            END.                                    
                       END.
    
                       {exp/exapi010.i2 tt-ped-ent} 
    
                       ASSIGN de-volume-inf = de-volume-inf + de-tot-cub-ent.
    
                       RUN AdicionaProcdespItiner IN h-exapi (INPUT TABLE tt-ped-ent,
                                                              INPUT de-tot-peso,
                                                              INPUT de-tot-val,
                                                              INPUT de-tot-qt,
                                                              INPUT de-tot-cub-ped,
                                                              INPUT de-tot-cub-ent,
                                                              INPUT r-chave).
                                                              
                    END.
    
                    FOR FIRST processo-exp 
                        WHERE processo-exp.cod-estabel = {&TABLE-NAME}.cod-estabel 
                          AND processo-exp.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp EXCLUSIVE-LOCK:
                             
                        FIND FIRST ped-venda-cex 
                             WHERE ped-venda-cex.nome-abrev = ped-venda.nome-abrev 
                               AND ped-venda-cex.nr-pedcli  = ped-venda.nr-pedcli NO-LOCK NO-ERROR.
                                  
                        IF  AVAIL ped-venda-cex THEN DO:
                            IF  ped-venda-cex.volume = 0 THEN DO:
                                IF  processo-exp.volume-inf = 0 THEN
                                    /* NO CD0903 os campos Altura, largura e comprimento s„o informados em CM e no EX3001 È apresentado em M, por isso a divis„o por 1000000 para transformar de CM3 para M3*/
                                    ASSIGN processo-exp.volume-inf = de-volume-inf / 1000000. 
                            END.
                        END.
                    END.
                END.
            END.
    
            IF NOT VALID-HANDLE(h-bocx185) THEN
                RUN cxbo/bocx185.p PERSISTENT SET h-bocx185.
    
            RUN AtualizaSituacaoProcesso IN h-bocx185 (INPUT {&TABLE-NAME}.cod-estabel,
                                                       INPUT {&TABLE-NAME}.nr-proc-exp).
												   
			IF  VALID-HANDLE(h-bocx185) THEN DO:
				DELETE PROCEDURE h-bocx185.
				ASSIGN h-bocx185 = ?.
			END.
        END.
		
		IF  VALID-HANDLE(h-bocx195) THEN DO:
			DELETE PROCEDURE h-bocx195.
			ASSIGN h-bocx195 = ?.
		END.		
    END.
END PROCEDURE.

PROCEDURE validateFIELDS:
    /*
    **  Valida FIELDS
    */
    FIND FIRST rowObject NO-LOCK NO-ERROR.

    RUN startMethod ("validateFIELDS").

    IF  p-relaciona-nota-embarque-ex0190 = NO THEN DO:
        RUN exp/exapi005.p(INPUT TABLE rowObject, OUTPUT TABLE tt-bo-erro).
    END.
    ELSE DO:
        RUN exp/exapi019.p(INPUT TABLE rowObject, OUTPUT TABLE tt-bo-erro).
    END.
    
    IF  rowObject.cod-emitente = ? THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex {&table-name} cod-emitente 1}
        /******************************************/
        assign c-return-msg = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value
               tt-bo-erro.parametros   = c-return-msg.
    END.
 
    if rowObject.cod-estabel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex proc-ped-venda cod-estabel 1}
        /******************************************/
        assign c-return-msg = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value
               tt-bo-erro.parametros   = c-return-msg.
    end.
 
    if rowObject.nr-pedcli = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex proc-ped-venda nr-pedcli 1}
        /******************************************/
        assign c-return-msg = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value
               tt-bo-erro.parametros   = c-return-msg.
    end.
 
    if rowObject.nr-pedido = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex proc-ped-venda nr-pedido 1}
        /******************************************/
        assign c-return-msg = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value
               tt-bo-erro.parametros   = c-return-msg.
    end.
 
    if rowObject.nr-proc-exp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex proc-ped-venda nr-proc-exp 1}
        /******************************************/
        assign c-return-msg = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value
               tt-bo-erro.parametros   = c-return-msg.
    end.
    
    FIND FIRST tt-bo-erro NO-ERROR.
    IF  NOT AVAIL tt-bo-erro THEN DO:

        &if defined(bf_dis_proc_ent) &then
            ASSIGN c-cod-estabel = rowobject.cod-estabel
                   c-nr-proc-exp = rowobject.nr-proc-exp
                   c-nr-pedido   = rowobject.nr-pedido.
            {cxbo/bocx190.i2}
            FIND FIRST tt-epc NO-LOCK 
                 WHERE (tt-epc.cod-event = "VALID-PROCESS"
                    or  tt-epc.cod-event = "VALID-PEDIDO")
                    AND tt-epc.cod-parameter = "NOT-VALIDATE" NO-ERROR.
            IF NOT AVAIL tt-epc THEN DO: 
        &endif
        
        IF NOT l-recebe-bodi317efm04 THEN DO:

            FIND FIRST ped-venda NO-LOCK 
                 WHERE ped-venda.nome-abrev = RowObject.nome-abrev 
                   AND ped-venda.nr-pedcli  = RowObject.nr-pedcli NO-ERROR.
            IF AVAIL ped-venda THEN DO:
               FIND FIRST ped-ent NO-LOCK 
                    WHERE ped-ent.nr-pedcli = ped-venda.nr-pedcli 
                      AND ped-ent.nome-abrev  = ped-venda.nome-abrev 
                      &if defined(bf_dis_proc_ent) &then
                         and ped-ent.nr-proc-exp = ""   
                      &endif 
               NO-ERROR. 
               
               IF NOT AVAIL ped-ent THEN DO:
                  ASSIGN i-seq-erro = i-seq-erro + 1.
                  RUN utp/ut-msgs.p (INPUT "msg":U,
                                     INPUT 19073,
                                     INPUT string(rowObject.nr-pedido)).
                  CREATE tt-bo-erro.
                  ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                         tt-bo-erro.cd-erro  = 19073
                         tt-bo-erro.mensagem = RETURN-VALUE.
               END.
            END.
        END.
        &if defined(bf_dis_proc_ent) &then
            END.
        &endif
    END.
         
    RUN endMethod ("validateFIELDS").

END PROCEDURE.

PROCEDURE initializeFIELDS:

   /** Inicializa campos da tela **/
      
END PROCEDURE.

PROCEDURE executeCREATE:

    /**  Cria registro na tabela.*/
    DEFINE INPUT PARAMETER l-recebe as logical.          
    DEFINE OUTPUT PARAMETER table for tt-bo-erro-aux.     
    DEFINE OUTPUT PARAMETER pr-proc-ped-venda AS ROWID NO-UNDO.
    
    FIND FIRST ped-venda EXCLUSIVE-LOCK 
         WHERE ped-venda.nome-abrev  = rowObject.nome-abrev
           AND ped-venda.nr-pedcli   = rowObject.nr-pedcli NO-ERROR.
    IF AVAIL ped-venda THEN
       ASSIGN rowObject.nr-pedido = ped-venda.nr-pedido.               

    &if defined(bf_dis_proc_ent) &then
        ASSIGN c-cod-estabel = rowobject.cod-estabel
               c-nr-proc-exp = rowobject.nr-proc-exp
               c-nr-pedido   = rowobject.nr-pedido.
        {cxbo/bocx190.i2}
        FIND FIRST tt-epc NO-LOCK 
             WHERE  tt-epc.cod-event = "VALID-PEDIDO"
                AND tt-epc.cod-parameter = "NOT-VALIDATE" NO-ERROR.
        IF NOT AVAIL tt-epc THEN DO: 
    &endif 
    
       IF l-not-achou-proc-ped-venda THEN DO:
          CREATE {&TABLE-NAME}.
          BUFFER-COPY RowObject EXCEPT r-rowid TO {&TABLE-NAME}.
          ASSIGN pr-proc-ped-venda = ROWID({&TABLE-NAME}).
       END.

    &if defined(bf_dis_proc_ent) &then
        END.
    &endif
        
    &IF '{&ems_dbtype}' <> 'progress' &THEN 
        FIND FIRST proc-ped-venda 
             WHERE proc-ped-venda.cod-estabel = rowobject.cod-estabel 
               AND proc-ped-venda.nr-proc-exp = rowobject.nr-proc-exp  
               AND proc-ped-venda.nr-pedido = rowobject.nr-pedido NO-LOCK NO-ERROR.
        ASSIGN pr-proc-ped-venda = ROWID(proc-ped-venda).
    &endif
    
    IF l-recebe THEN DO:
       IF  NOT VALID-HANDLE(h-bocx195) THEN
           RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.

       RUN GenerateTable IN h-bocx195 (INPUT TABLE rowObject, OUTPUT TABLE tt-bo-erro-aux).
	   
	    IF  VALID-HANDLE(h-bocx195) THEN DO:
			DELETE PROCEDURE h-bocx195.
			ASSIGN h-bocx195 = ?.
		END.
    end.         
    
    IF  NOT l-recebe THEN
        EMPTY TEMP-TABLE tt-bo-erro-aux.

    /* Se ocorreu erros no procedimento anterior, devesse preservar a tt-bo-erro-aux */
    IF  NOT CAN-FIND(FIRST tt-bo-erro-aux) THEN
        RUN exp/exapi007.p (INPUT TABLE rowObject, OUTPUT TABLE tt-bo-erro-aux).
    
    &if defined(bf_dis_proc_ent) &then
        RUN pi-chama-upc-IncluiProcessoItiner.
    &endif

    RETURN STRING(ROWID({&TABLE-NAME})).
    
END PROCEDURE.

PROCEDURE generateTable.
    DEFINE INPUT  PARAMETER l-recebe AS  LOGICAL.
    DEFINE INPUT  PARAMETER TABLE    FOR RowObject.
    DEFINE OUTPUT PARAMETER TABLE    FOR tt-bo-erro.
    DEFINE OUTPUT PARAMETER r-chave  AS  ROWID.
 
    RUN initializeValidate.
 
    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.
    RUN ValidateCriaRelacao (INPUT  l-recebe,
                             INPUT  TABLE RowObject,
                             OUTPUT TABLE tt-bo-erro,
                             OUTPUT r-chave,
                             INPUT  NO).
      
    FIND FIRST proc-ped-venda NO-LOCK 
         WHERE proc-ped-venda.nr-proc-exp = rowObject.nr-proc-exp NO-ERROR.
    
END PROCEDURE.


PROCEDURE executeUpdate:
    /**  Executa Update*/
    BUFFER-COPY RowObject EXCEPT r-rowid nr-proc-exp TO {&TABLE-NAME}.

END PROCEDURE.
 

PROCEDURE initializeValidate:
    /*
    **  Inicializa Validate
    */
    RUN startMethod ("initializeValidade").

    RUN endMethod   ("initializeValidade").
END PROCEDURE.


PROCEDURE deleteTable:

     DEFINE INPUT PARAMETER p-cod-estabel like proc-ped-venda.cod-estabel. 
     DEFINE INPUT PARAMETER p-nr-proc-exp like proc-ped-venda.nr-proc-exp.
     
     DEFINE VARIABLE r-rowid  AS ROWID NO-UNDO.
     
     FOR EACH proc-ped-venda EXCLUSIVE-LOCK
        WHERE proc-ped-venda.cod-estabel = p-cod-estabel
          AND proc-ped-venda.nr-proc-exp = p-nr-proc-exp:

         ASSIGN r-rowid = ROWID(proc-ped-venda).

         RUN validateDelete (INPUT-OUTPUT r-rowid, OUTPUT TABLE tt-bo-erro) .
     END.

END PROCEDURE.

PROCEDURE findPk_proc_pedvenda:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    RUN startMethod ("find").
    DEFINE INPUT  PARAMETER c-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER c-nr-proc-exp AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER i-nr-pedido   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-return      AS CHARACTER NO-UNDO.
 
    FIND FIRST proc-ped-venda 
         WHERE proc-ped-venda.cod-estabel = c-cod-estabel
           AND proc-ped-venda.nr-proc-exp = c-nr-proc-exp
           AND proc-ped-venda.nr-pedido = i-nr-pedido NO-LOCK NO-ERROR.
    IF NOT AVAIL {&TABLE-NAME} THEN DO:
        {utp/ut-table.i mgcex proc-ped-venda 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).
        ASSIGN c-return = RETURN-VALUE.
    END.
    ELSE DO:
         RUN setCurrent.
    END.
    RUN endMethod ("find").

END PROCEDURE.
 
 
PROCEDURE getCharField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS CHARACTER NO-UNDO.
 
    CASE c-field:
        WHEN "char-1"       THEN c-value = RowObject.char-1.
        WHEN "char-2"       THEN c-value = RowObject.char-2.
        WHEN "check-sum"    THEN c-value = RowObject.check-sum.
        WHEN "cod-estabel"  THEN c-value = RowObject.cod-estabel.
        WHEN "nome-abrev"   THEN c-value = RowObject.nome-abrev.
        WHEN "nr-pedcli"    THEN c-value = RowObject.nr-pedcli.
        WHEN "nr-proc-exp"  THEN c-value = RowObject.nr-proc-exp.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.
 
PROCEDURE getDecField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS DECIMAL   NO-UNDO.
 
    CASE c-field:
        WHEN "dec-1" THEN c-value = RowObject.dec-1.
        WHEN "dec-2" THEN c-value = RowObject.dec-2.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.
 
PROCEDURE getIntField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS INTEGER   NO-UNDO.
 
    CASE c-field:
        WHEN "cod-emitente" THEN c-value = RowObject.cod-emitente.
        WHEN "int-1"        THEN c-value = RowObject.int-1.
        WHEN "int-2"        THEN c-value = RowObject.int-2.
        WHEN "nr-pedido"    THEN c-value = RowObject.nr-pedido.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.
 
PROCEDURE getDateField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS DATE      NO-UNDO.
 
    CASE c-field:
        WHEN "data-1" THEN c-value = RowObject.data-1.
        WHEN "data-2" THEN c-value = RowObject.data-2.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.
 
PROCEDURE getLogField:
    DEFINE INPUT  PARAMETER c-field AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-value AS LOGICAL   NO-UNDO.
 
    CASE c-field:
        WHEN "log-1" THEN c-value = RowObject.log-1.
        WHEN "log-2" THEN c-value = RowObject.log-2.
        OTHERWISE RETURN ERROR.
    END CASE.
END PROCEDURE.
 
PROCEDURE posicionaPedVenda.
/* procedimento criado para posicionar a tabela proc-ped-vend pelo rowid do processo 
   e atualizar  a tt-proc-ped-venda-aux usada no programa ex0190b */
  DEFINE INPUT  PARAMETER r-chave AS ROWID.
  DEFINE OUTPUT PARAMETER TABLE   FOR tt-proc-ped-venda-aux.

    FIND FIRST proc-ped-venda 
         WHERE ROWID(proc-ped-venda) = r-chave NO-LOCK NO-ERROR.
    IF  AVAIL proc-ped-venda THEN DO:
        FIND FIRST tt-proc-ped-venda-aux 
             WHERE tt-proc-ped-venda-aux.cod-estabel = proc-ped-venda.cod-estabel 
               AND tt-proc-ped-venda-aux.nr-proc-exp = proc-ped-venda.nr-proc-exp 
               AND tt-proc-ped-venda-aux.nr-pedido   = proc-ped-venda.nr-pedido NO-LOCK NO-ERROR.
       IF NOT AVAIL tt-proc-ped-venda-aux THEN
          CREATE tt-proc-ped-venda-aux.

       ASSIGN tt-proc-ped-venda-aux.cod-estabel = proc-ped-venda.cod-estabel
              tt-proc-ped-venda-aux.nr-proc-exp = proc-ped-venda.nr-proc-exp
              tt-proc-ped-venda-aux.nr-pedido   = proc-ped-venda.nr-pedido
              tt-proc-ped-venda-aux.r-rowid     = r-chave.
        
    END.        
END PROCEDURE.

PROCEDURE validaPedVendaCex:
   DEFINE INPUT  PARAMETER c-nome-abrev  AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER c-nr-pedcli   AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER c-nr-proc-exp AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER l-def         AS LOGICAL   NO-UNDO.
   DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.
   
   FOR EACH tt-bo-erro:
      DELETE tt-bo-erro.
   END.
   
   ASSIGN l-def = NO.
   FIND FIRST ped-venda-cex 
        WHERE ped-venda-cex.nome-abrev = c-nome-abrev 
          AND ped-venda-cex.nr-pedcli  = c-nr-pedcli NO-LOCK NO-ERROR.

   FIND FIRST ped-venda
        WHERE ped-venda.nr-pedido = ped-venda-cex.nr-pedido NO-LOCK NO-ERROR.

   FIND FIRST processo-exp 
        WHERE processo-exp.nr-proc-exp = c-nr-proc-exp 
          AND processo-exp.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

   IF  AVAIL processo-exp 
   AND AVAIL ped-venda-cex THEN DO:

      IF (processo-exp.cod-idioma   <> ped-venda-cex.cod-idioma) OR
         (processo-exp.cod-itiner   <> ped-venda-cex.cod-itiner) OR
         (processo-exp.cod-incoterm <> ped-venda-cex.cod-incoterm) THEN DO:

          ASSIGN l-def      =  YES
                 i-seq-erro =  i-seq-erro + 1.
          RUN utp/ut-msgs.p (INPUT "msg":U,
                             INPUT 26185,
                             INPUT RETURN-VALUE).
          CREATE tt-bo-erro.
          ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                 tt-bo-erro.cd-erro  = 26185
                 tt-bo-erro.mensagem = RETURN-VALUE.
      END.
   END.
   
END PROCEDURE.

PROCEDURE pi-chama-upc-IncluiProcessoItiner:
 &if defined(bf_dis_proc_ent) &then
        {include/i-epc200.i2 &CodEvent='"IncluiProcessoItiner"'
                             &CodParameter='"rowid-proc-ped-venda"'
                             &ValueParameter="string(rowid({&TABLE-NAME}))"}
        {include/i-epc201.i "IncluiProcessoItiner"}
 &endif    
END PROCEDURE.

procedure pi-chama-upc-ExcluiProcessoItiner:
  &if defined(bf_dis_proc_ent) &then
        {include/i-epc200.i2 &CodEvent='"ExcluiProcessoItiner"'
                             &CodParameter='"rowid-proc-ped-venda"'
                             &ValueParameter="string(rowid({&TABLE-NAME}))"}
        
        {include/i-epc201.i "ExcluiProcessoItiner"}
  &endif    
END PROCEDURE.

PROCEDURE verif-existe-proc-ped-venda:

    /* Verifica se j† existe Processo de Exportaá∆o para o Pedido de Venda
       Retornando a valor l¢gico e se existir e o N£mero do Processo */
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE proc-ped-venda.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pedido   LIKE proc-ped-venda.nr-pedido   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-nr-proc-exp LIKE proc-ped-venda.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER p-existe-proc AS   LOGICAL                    NO-UNDO.
 
    FIND FIRST proc-ped-venda 
         WHERE proc-ped-venda.nr-pedido   = p-nr-pedido  NO-LOCK NO-ERROR.
    IF NOT AVAIL {&TABLE-NAME} THEN DO:
        ASSIGN p-existe-proc = NO
               p-nr-proc-exp = "".
    END.
    ELSE DO:
        ASSIGN p-existe-proc = YES
               p-nr-proc-exp = proc-ped-venda.nr-proc-exp.
    END.
   
END PROCEDURE.

PROCEDURE verif-existe-proc-ped-ent:
    /* Verifica se j† existe Proc-ped-ent para o proc-ped-venda,
       Caso n∆o exista o Pedido de venda Ç desvinculado do processo */
    DEFINE INPUT PARAMETER r-chave   as rowid NO-UNDO.
 
    FIND FIRST {&TABLE-NAME} 
         WHERE ROWID({&TABLE-NAME}) = r-chave EXCLUSIVE-LOCK NO-ERROR.
    IF  AVAIL {&TABLE-NAME} THEN DO:
        IF NOT CAN-FIND(FIRST proc-ped-ent NO-LOCK
                        WHERE proc-ped-ent.cod-estabel = {&TABLE-NAME}.cod-estabel
                          AND proc-ped-ent.nr-proc-exp = {&TABLE-NAME}.nr-proc-exp
                          AND proc-ped-ent.nome-abrev  = {&TABLE-NAME}.nome-abrev
                          AND proc-ped-ent.nr-pedcli   = {&TABLE-NAME}.nr-pedcli) THEN DO:
            
            FIND FIRST ped-venda EXCLUSIVE-LOCK
                 WHERE ped-venda.nome-abrev = {&TABLE-NAME}.nome-abrev
                   AND ped-venda.nr-pedcli  = {&TABLE-NAME}.nr-pedcli NO-ERROR.
            IF  AVAIL ped-venda THEN
                ASSIGN ped-venda.nr-proc-exp = ""
                       ped-venda.nr-invoice  = "".          
            
        END.
    END.
    FIND FIRST {&TABLE-NAME} 
         WHERE ROWID({&TABLE-NAME}) = r-chave NO-LOCK NO-ERROR.
END PROCEDURE.


PROCEDURE destroy:

    IF  VALID-HANDLE(h-bocx195) THEN DO:
        DELETE PROCEDURE h-bocx195.
        ASSIGN h-bocx195 = ?.
    END.
    IF  VALID-HANDLE(h-exapi) THEN DO:
        DELETE PROCEDURE h-exapi.
        ASSIGN h-exapi = ?.
    END.
    IF  VALID-HANDLE(h-bocx185) THEN DO:
        DELETE PROCEDURE h-bocx185.
        ASSIGN h-bocx185 = ?.
    END.
    IF  VALID-HANDLE(h-bocx205) THEN DO:
        DELETE PROCEDURE h-bocx205.
        ASSIGN h-bocx205 = ?.
    END.

    DELETE PROCEDURE THIS-PROCEDURE.
    
END PROCEDURE.

PROCEDURE VerificaQtdeProcExp:
   DEFINE INPUT  PARAMETER p-c-nome-abrev      LIKE ped-ent.nome-abrev   NO-UNDO.
   DEFINE INPUT  PARAMETER p-c-nr-pedcli       LIKE ped-ent.nr-pedcli    NO-UNDO.
   DEFINE OUTPUT PARAMETER i-cont-proc-exp-aux AS   INTEGER              NO-UNDO.
   

   FOR EACH proc-ped-venda FIELDS(log-1)
      WHERE proc-ped-venda.nome-abrev = p-c-nome-abrev
        AND proc-ped-venda.nr-pedcli  = p-c-nr-pedcli NO-LOCK:
        
          ASSIGN i-cont-proc-exp-aux = i-cont-proc-exp-aux + 1.
   END.

END PROCEDURE.


PROCEDURE ValidaProcExp:
    /* Definiá∆o dos parÉmetros de Entrada/Sa°da */
    DEFINE INPUT  PARAMETER p-c-nome-abrev      LIKE ped-venda.nome-abrev NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-nr-pedcli       LIKE ped-venda.nr-pedcli  NO-UNDO.
    DEFINE OUTPUT PARAMETER p-l-procedimento-ok AS   LOGICAL              NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE for tt-bo-erro.
    
    DEFINE VARIABLE i-cont-proc-exp AS INTEGER NO-UNDO.

    ASSIGN i-cont-proc-exp = 0.
    IF p-c-nr-pedcli <> ? THEN DO:
        FOR FIRST ped-venda
            WHERE ped-venda.nome-abrev = p-c-nome-abrev
              AND ped-venda.nr-pedcli  = p-c-nr-pedcli NO-LOCK:
        END.

        IF  AVAIL ped-venda THEN DO:
            FOR EACH proc-ped-venda
               WHERE proc-ped-venda.nome-abrev = ped-venda.nome-abrev
                 and proc-ped-venda.nr-pedcli  = ped-venda.nr-pedcli NO-LOCK:
            
               FIND FIRST processo-exp
                    WHERE processo-exp.cod-estabel = proc-ped-venda.cod-estabel
                      and processo-exp.nr-proc-exp = proc-ped-venda.nr-proc-exp NO-LOCK NO-ERROR.

               IF  AVAIL processo-exp 
               AND processo-exp.cod-sit-proc <> 3 THEN /*considera somente os processos que nao estao faturados*/
                   ASSIGN i-cont-proc-exp = i-cont-proc-exp + 1.
            END.
        END.
            
        IF i-cont-proc-exp > 1 THEN DO:
            /* MENSAGEM: 31498 - H† mais de um processo de exportaá∆o no pedido a faturar */
            ASSIGN i-seq-erro = i-seq-erro + 1.
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 31498,
                               INPUT "").
            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 31498
                   tt-bo-erro.errorSubType = "WARNING":U
                   tt-bo-erro.mensagem     = RETURN-VALUE.
        end.
    end.

    ASSIGN p-l-procedimento-ok = YES. 
END PROCEDURE.


PROCEDURE retornaControleFaturamento:
    /*
    ** procedure utilizada nas bo's do faturamento
    ** para os registros da tabela proc-ped-venda
    */

    DEFINE INPUT  PARAMETER pc-cod-estabel    LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-rs-faturamento AS   INTEGER                  NO-UNDO.
    
    DEFINE VARIABLE h-bocx180 AS HANDLE                    NO-UNDO.
    DEFINE VARIABLE c-char-1  AS CHARACTER format "x(100)" NO-UNDO.
    DEFINE VARIABLE c-return  AS CHARACTER                 NO-UNDO. 
    
    IF NOT VALID-HANDLE(h-bocx180) 
    OR h-bocx180:TYPE      <> "PROCEDURE":U 
    OR h-bocx180:FILE-NAME <> "cxbo/bocx180.p":U THEN 
       RUN cxbo/bocx180.p PERSISTENT SET h-bocx180.
          
    RUN findPk_estabel IN h-bocx180 (INPUT  pc-cod-estabel,
                                     OUTPUT c-return).
    IF  c-return = "" THEN DO:
        RUN getcharfield in h-bocx180("char-1", OUTPUT c-char-1).
        ASSIGN pi-rs-faturamento = INT(SUBSTRING(c-char-1,20,1)).
    END.
    
    IF  VALID-HANDLE(h-bocx180) THEN DO:
        DELETE PROCEDURE h-bocx180.
        ASSIGN h-bocx180 = ?.
    END.

END PROCEDURE.

PROCEDURE piValidaRelacionamentos:

    DEFINE INPUT PARAMETER p-estab      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-serie      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-nota       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-embarque   AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAMETER p-origem     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-processo   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-estab-proc AS CHARACTER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-bo-erro.
  
    DEFINE VARIABLE c-mensagem AS CHARACTER FORMAT "X(100)" NO-UNDO.
    DEFINE VARIABLE c-help     AS CHARACTER FORMAT "X(100)" NO-UNDO.

    FIND FIRST processo-exp NO-LOCK
         WHERE processo-exp.cod-estabel = p-estab-proc
           and processo-exp.nr-proc-exp = p-processo NO-ERROR.
           
    
    FIND FIRST param-exp
         WHERE param-exp.cod-estabel = p-estab-proc NO-LOCK NO-ERROR.    
      
    IF p-origem = 1 THEN DO: /* Nota Fiscal */
    
       IF p-estab = "" THEN DO:
          ASSIGN i-seq-erro = i-seq-erro + 1.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Estabelecimento" *}
          RUN utp/ut-msgs.p (INPUT "msg":U,
                             INPUT 688,
                             INPUT RETURN-VALUE).
          CREATE tt-bo-erro.
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-3 AS CHARACTER NO-UNDO.
          ASSIGN c-lbl-liter-3 = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Estabelecimento" *}
          ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
          ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 688
                 tt-bo-erro.mensagem     = c-lbl-liter-3
                 tt-bo-erro.parametros   = c-lbl-liter-estabelecimento.
       END.
    
       IF p-nota = "" THEN DO:
          ASSIGN i-seq-erro = i-seq-erro + 1.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Nota_Fiscal" *}
          RUN utp/ut-msgs.p (INPUT "msg":U,
                             INPUT 688,
                             INPUT RETURN-VALUE).
          CREATE tt-bo-erro.
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-4 AS CHARACTER NO-UNDO.
          ASSIGN c-lbl-liter-4 = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-nota-fiscal AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Nota_Fiscal" *}
          ASSIGN c-lbl-liter-nota-fiscal = TRIM(RETURN-VALUE).
          ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 688
                 tt-bo-erro.mensagem     = c-lbl-liter-4
                 tt-bo-erro.parametros   = c-lbl-liter-nota-fiscal.  
       END.

       IF NOT CAN-FIND(FIRST nota-fiscal NO-LOCK
                       WHERE nota-fiscal.cod-estabel = p-estab
                         AND nota-fiscal.serie       = p-serie
                         AND nota-fiscal.nr-nota-fis = p-nota) THEN DO:
          ASSIGN i-seq-erro = i-seq-erro + 1.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Nota_Fiscal" *}
          RUN utp/ut-msgs.p (INPUT "msg":U,
                             INPUT 2,
                             INPUT RETURN-VALUE).
          CREATE tt-bo-erro.
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-5 AS CHARACTER NO-UNDO.
          ASSIGN c-lbl-liter-5 = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-nota-fiscal-2 AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Nota_Fiscal" *}
          ASSIGN c-lbl-liter-nota-fiscal-2 = TRIM(RETURN-VALUE).
          ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 2
                 tt-bo-erro.mensagem     = c-lbl-liter-5
                 tt-bo-erro.parametros   = c-lbl-liter-nota-fiscal-2.  
       END.

       FOR EACH tt-epc WHERE tt-epc.cod-event = "VALIDATE-ESTABEL": 
           DELETE tt-epc. 
       end.

       {include/i-epc200.i2 &CodEvent='"VALIDATE-ESTABEL"'
                            &CodParameter='"ROWID-NF"'
                            &ValueParameter='rowid(nota-fiscal)'}
                            
       {include/i-epc201.i "VALIDATE-ESTABEL"}

       FIND FIRST tt-epc 
            WHERE tt-epc.cod-event     = "VALIDATE-ESTABEL" 
              AND tt-epc.cod-parameter = "NOT-VALIDATE" NO-ERROR.

       IF NOT AVAIL tt-epc THEN DO:
           if p-estab <> p-estab-proc THEN DO:
              ASSIGN i-seq-erro = i-seq-erro + 1.
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-estabelecimento-da-nota-fiscal AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Estabelecimento_da_Nota_Fiscal" *}
              ASSIGN c-lbl-liter-estabelecimento-da-nota-fiscal = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-diferente-do-estabelecimento-d AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "diferente_do_estabelecimento_do_processo_de_exportaá∆o" *}
              ASSIGN c-lbl-liter-diferente-do-estabelecimento-d = TRIM(RETURN-VALUE).
              RUN utp/ut-msgs.p (INPUT "msg":U,
                                 INPUT 7972,
                                 INPUT c-lbl-liter-estabelecimento-da-nota-fiscal + "~~" + " " + c-lbl-liter-diferente-do-estabelecimento-d).
              CREATE tt-bo-erro.
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-6 AS CHARACTER NO-UNDO.
              ASSIGN c-lbl-liter-6 = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-estabelecimento-da-nota-fiscal-2 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Estabelecimento_da_Nota_Fiscal" *}
              ASSIGN c-lbl-liter-estabelecimento-da-nota-fiscal-2 = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-diferente-do-estabelecimento-d-2 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "diferente_do_estabelecimento_do_processo_de_exportaá∆o" *}
              ASSIGN c-lbl-liter-diferente-do-estabelecimento-d-2 = TRIM(RETURN-VALUE).
              ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                     tt-bo-erro.cd-erro      = 7972
                     tt-bo-erro.mensagem     = c-lbl-liter-6
                     tt-bo-erro.parametros   = c-lbl-liter-estabelecimento-da-nota-fiscal-2 + "~~" + " " + c-lbl-liter-diferente-do-estabelecimento-d-2.  
           END.
       end.
       
       FIND FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = p-estab
              and nota-fiscal.serie       = p-serie
              and nota-fiscal.nr-nota-fis = p-nota NO-ERROR.
       IF AVAIL nota-fiscal THEN DO:
         if avail param-exp and
         &IF '{&bf_dis_versao_ems}' >= '2.07' &then 
            NOT param-exp.log-atualiza-val-proces-export THEN DO:
         &ELSE
            SUBSTRING(param-exp.char-1,23,1) <> "1" THEN DO:
         &ENDIF
          /*verificar se o parametro "atualiza valores processo" no ex0180 est† como "no"*/
              FOR EACH it-nota-fisc 
                 WHERE it-nota-fisc.cod-estabel  = nota-fiscal.cod-estabel 
                   AND it-nota-fisc.serie        = nota-fiscal.serie 
                   AND it-nota-fisc.nr-nota-fis  = nota-fiscal.nr-nota-fis NO-LOCK:

                  FIND FIRST proc-ped-ent NO-LOCK
                       WHERE proc-ped-ent.cod-estabel        = p-estab-proc
                         AND proc-ped-ent.nr-proc-exp        = p-processo
                         AND proc-ped-ent.nome-abrev         = it-nota-fisc.nome-ab-cli
                         AND proc-ped-ent.nr-pedcli          = it-nota-fisc.nr-pedcli
                         AND proc-ped-ent.nr-sequencia       = it-nota-fisc.nr-seq-ped
                         AND proc-ped-ent.it-codigo          = it-nota-fisc.it-codigo
                         AND proc-ped-ent.cod-refer          = it-nota-fisc.cod-refer
                         AND proc-ped-ent.nr-entrega         = it-nota-fisc.nr-entrega NO-ERROR.
                  IF NOT AVAIL proc-ped-ent THEN DO:
                     ASSIGN c_mensagem_1 = "A entrega " + string(it-nota-fisc.nr-seq-ped) + " do pedido  " + it-nota-fisc.nr-pedcli + 
                                           " item " + it-nota-fisc.it-codigo  + " referància " + it-nota-fisc.cod-refer
                            c_mensagem_2 = "da nota fiscal".                
                     ASSIGN i-seq-erro = i-seq-erro + 1.
                     RUN utp/ut-msgs.p (INPUT "msg":U,
                                        INPUT 32698,
                                        INPUT c_mensagem_1 + "~~" + c_mensagem_2).
                     CREATE tt-bo-erro.
                     /* Inicio -- Projeto Internacional */
                     DEFINE VARIABLE c-lbl-liter-7 AS CHARACTER NO-UNDO.
                     ASSIGN c-lbl-liter-7 = TRIM(RETURN-VALUE).
                     DEFINE VARIABLE c-lbl-liter-condicao-de-pagamento-da-nota AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "Condiá∆o_de_Pagamento_da_Nota_Fiscal" *}
                     ASSIGN c-lbl-liter-condicao-de-pagamento-da-nota = TRIM(RETURN-VALUE).
                     DEFINE VARIABLE c-lbl-liter-diferente-da-condicao-de-pagam AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "diferente_da_condiá∆o_de_pagamento_do_Processo_de_Exportaá∆o" *}
                     ASSIGN c-lbl-liter-diferente-da-condicao-de-pagam = TRIM(RETURN-VALUE).
                     ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                            tt-bo-erro.cd-erro      = 32698
                            tt-bo-erro.mensagem     = c-lbl-liter-7
                            tt-bo-erro.parametros   = c-lbl-liter-condicao-de-pagamento-da-nota + "~~" +
                                                         c-lbl-liter-diferente-da-condicao-de-pagam
                                     c_mensagem_1   = ""
                                     c_mensagem_2   = "".              
                                                         
                  END.
              END. /* FOR EACH it-nota-fisc */
          END.
          
          IF  AVAIL param-exp 
          AND SUBSTRING(param-exp.char-1,22,1) = "2" /* YES */ THEN DO:
              IF nota-fiscal.cod-cond-pag <> processo-exp.cod-cond-pagto THEN DO:
                 ASSIGN i-seq-erro = i-seq-erro + 1.
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-condicao-de-pagamento-da-nota-2 AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Condiá∆o_de_Pagamento_da_Nota_Fiscal" *}
                 ASSIGN c-lbl-liter-condicao-de-pagamento-da-nota-2 = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-diferente-da-condicao-de-pagam-2 AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "diferente_da_condiá∆o_de_pagamento_do_Processo_de_Exportaá∆o" *}
                 ASSIGN c-lbl-liter-diferente-da-condicao-de-pagam-2 = TRIM(RETURN-VALUE).
                 RUN utp/ut-msgs.p (INPUT "msg":U,
                                    INPUT 7972,
                                    INPUT c-lbl-liter-condicao-de-pagamento-da-nota-2 + "~~" +
                                          c-lbl-liter-diferente-da-condicao-de-pagam-2).
                 CREATE tt-bo-erro.
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-8 AS CHARACTER NO-UNDO.
                 ASSIGN c-lbl-liter-8 = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-condicao-de-pagamento-da-nota-3 AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Condiá∆o_de_Pagamento_da_Nota_Fiscal" *}
                 ASSIGN c-lbl-liter-condicao-de-pagamento-da-nota-3 = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-diferente-da-condicao-de-pagam-3 AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "diferente_da_condiá∆o_de_pagamento_do_Processo_de_Exportaá∆o" *}
                 ASSIGN c-lbl-liter-diferente-da-condicao-de-pagam-3 = TRIM(RETURN-VALUE).
                 ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                        tt-bo-erro.cd-erro      = 7972
                        tt-bo-erro.mensagem     = c-lbl-liter-8
                        tt-bo-erro.parametros   = c-lbl-liter-condicao-de-pagamento-da-nota-3 + "~~" +
                                                  c-lbl-liter-diferente-da-condicao-de-pagam-3.       
              END.
          END.
          
          IF NOT CAN-FIND(FIRST ped-venda NO-LOCK
                          WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
                            and ped-venda.nome-abrev = nota-fiscal.nome-ab-cli) THEN DO:
             ASSIGN i-seq-erro = i-seq-erro + 1.
             RUN utp/ut-msgs.p (INPUT "msg":U,
                                INPUT 32629,
                                INPUT "").
             CREATE tt-bo-erro.
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-9 AS CHARACTER NO-UNDO.
             ASSIGN c-lbl-liter-9 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-nota-fiscal-3 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Nota_Fiscal" *}
             ASSIGN c-lbl-liter-nota-fiscal-3 = TRIM(RETURN-VALUE).
             ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                    tt-bo-erro.cd-erro      = 32629
                    tt-bo-erro.mensagem     = c-lbl-liter-9
                    tt-bo-erro.parametros   = c-lbl-liter-nota-fiscal-3.  
                    
          END.
         
          IF nota-fiscal.dt-atual-cr <> ? THEN DO:
             ASSIGN i-seq-erro = i-seq-erro + 1.
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "Nota_Fiscal" *}
             RUN utp/ut-msgs.p (INPUT "msg":U,
                                INPUT 32630,
                                INPUT RETURN-VALUE + "~~" +
                                       nota-fiscal.nr-nota-fis).
                  CREATE tt-bo-erro.
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-10 AS CHARACTER NO-UNDO.
                  ASSIGN c-lbl-liter-10 = TRIM(RETURN-VALUE).
                  DEFINE VARIABLE c-lbl-liter-nota-fiscal-4 AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Nota_Fiscal" *}
                  ASSIGN c-lbl-liter-nota-fiscal-4 = TRIM(RETURN-VALUE).
                  ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                         tt-bo-erro.cd-erro      = 32630
                         tt-bo-erro.mensagem     = c-lbl-liter-10
                         tt-bo-erro.errorsubtype = "warning":U
                         tt-bo-erro.parametros   = c-lbl-liter-nota-fiscal-4 + "~~" + nota-fiscal.nr-nota-fis. 
          END.

          IF nota-fiscal.cdd-embarq <> 0 AND NOT l-cria-subprocesso THEN DO:
             FIND FIRST embarque NO-LOCK
                  WHERE embarque.cdd-embarq = nota-fiscal.cdd-embarq NO-ERROR.
             IF AVAIL embarque THEN DO:
               &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
                    IF  embarque.nr-proc-exp  <> "" 
                    AND embarque.nr-proc-exp  <> p-processo THEN DO:
                        ASSIGN i-seq-erro = i-seq-erro + 1.
                        /* Inicio -- Projeto Internacional */
                        {utp/ut-liter.i "Embarque_relacionado_Ö_Nota_Fiscal" *}
                        RUN utp/ut-msgs.p (INPUT "msg":U,
                                           INPUT 32631,
                                           INPUT RETURN-VALUE + "~~" +
                                                 embarque.nr-proc-exp).
                        CREATE tt-bo-erro.
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-11 AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-liter-11 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-embarque-relacionado-a-nota-fi AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Embarque_relacionado_Ö_Nota_Fiscal" *}
                        ASSIGN c-lbl-liter-embarque-relacionado-a-nota-fi = TRIM(RETURN-VALUE).
                        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                               tt-bo-erro.cd-erro      = 32631
                               tt-bo-erro.mensagem     = c-lbl-liter-11
                               tt-bo-erro.parametros   = c-lbl-liter-embarque-relacionado-a-nota-fi + "~~" + embarque.nr-proc-exp. 
                    END.
               &ELSE 
                   IF  trim(SUBSTRING(embarque.char-1,2,12)) <> "" 
                   AND trim(SUBSTRING(embarque.char-1,2,12)) <> p-processo THEN DO:
                       ASSIGN i-seq-erro = i-seq-erro + 1.
                       /* Inicio -- Projeto Internacional */
                       {utp/ut-liter.i "Embarque_relacionado_Ö_Nota_Fiscal" *}
                       RUN utp/ut-msgs.p (INPUT "msg":U,
                                          INPUT 32631,
                                          INPUT RETURN-VALUE + "~~" +
                                                 substring(embarque.char-1,2,12)).
                       CREATE tt-bo-erro.
                       /* Inicio -- Projeto Internacional */
                       DEFINE VARIABLE c-lbl-liter-12 AS CHARACTER NO-UNDO.
                       ASSIGN c-lbl-liter-12 = TRIM(RETURN-VALUE).
                       DEFINE VARIABLE c-lbl-liter-embarque-relacionado-a-nota-fi-2 AS CHARACTER NO-UNDO.
                       {utp/ut-liter.i "Embarque_relacionado_Ö_Nota_Fiscal" *}
                       ASSIGN c-lbl-liter-embarque-relacionado-a-nota-fi-2 = TRIM(RETURN-VALUE).
                       ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                              tt-bo-erro.cd-erro      = 32631
                              tt-bo-erro.mensagem     = c-lbl-liter-12
                              tt-bo-erro.parametros   = c-lbl-liter-embarque-relacionado-a-nota-fi-2 + "~~" +
                                                         substring(embarque.char-1,2,12). 
                   END.
               &ENDIF  
            END. /* IF AVAIL embarque */
          END. /* if nota-fiscal.cdd-embarq */
       END. /* IF AVAIL nota-fiscal */ 
       
       /* sÇtima validaá∆o   */
       FIND FIRST proc-nota-fiscal NO-LOCK
            WHERE proc-nota-fiscal.cod-estab-faturam = p-estab
              AND proc-nota-fiscal.serie       = p-serie
              AND proc-nota-fiscal.nr-nota-fis = p-nota NO-ERROR.
       IF AVAIL proc-nota-fiscal THEN DO:
          ASSIGN i-seq-erro = i-seq-erro + 1.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Nota_Fiscal" *}
          RUN utp/ut-msgs.p (INPUT "msg":U,
                             INPUT 32631,
                             INPUT RETURN-VALUE + "~~" + proc-nota-fiscal.nr-proc-exp).
          CREATE tt-bo-erro.
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-13 AS CHARACTER NO-UNDO.
          ASSIGN c-lbl-liter-13 = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-nota-fiscal-5 AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Nota_Fiscal" *}
          ASSIGN c-lbl-liter-nota-fiscal-5 = TRIM(RETURN-VALUE).
          ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 32631
                 tt-bo-erro.mensagem     = c-lbl-liter-13
                 tt-bo-erro.parametros   = c-lbl-liter-nota-fiscal-5 + "~~" + proc-nota-fiscal.nr-proc-exp.  
       END.
    END.
    ELSE DO: /* Embarque */
    
       IF p-embarque = 0 THEN DO:
          ASSIGN i-seq-erro = i-seq-erro + 1.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Embarque" *}
          RUN utp/ut-msgs.p (INPUT "msg":U,
                             INPUT 688,
                             INPUT RETURN-VALUE).
          CREATE tt-bo-erro.
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-14 AS CHARACTER NO-UNDO.
          ASSIGN c-lbl-liter-14 = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-embarque AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Embarque" *}
          ASSIGN c-lbl-liter-embarque = TRIM(RETURN-VALUE).
          ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 688
                 tt-bo-erro.mensagem     = c-lbl-liter-14
                 tt-bo-erro.parametros   = c-lbl-liter-embarque.  
                 
           RETURN "NOK":U.
       END.

       IF NOT CAN-FIND(FIRST embarque NO-LOCK
                       WHERE embarque.cdd-embarq = p-embarque) THEN DO:
          ASSIGN i-seq-erro = i-seq-erro + 1.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Embarque" *}
          RUN utp/ut-msgs.p (INPUT "msg":U,
                             INPUT 2,
                             INPUT RETURN-VALUE).
          CREATE tt-bo-erro.
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-15 AS CHARACTER NO-UNDO.
          ASSIGN c-lbl-liter-15 = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-embarque-2 AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Embarque" *}
          ASSIGN c-lbl-liter-embarque-2 = TRIM(RETURN-VALUE).
          ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 2
                 tt-bo-erro.mensagem     = c-lbl-liter-15
                 tt-bo-erro.parametros   = c-lbl-liter-embarque-2.  
                 
          RETURN "NOK":U.             
       END.

       FOR EACH tt-epc WHERE tt-epc.cod-event = "VALIDATE-ESTABEL": 
           DELETE tt-epc. 
       end.

       {include/i-epc200.i2 &CodEvent='"VALIDATE-ESTABEL"'
                            &CodParameter='"ROWID-NF"'
                            &ValueParameter='rowid(nota-fiscal)'}
                            
       {include/i-epc201.i "VALIDATE-ESTABEL"}

       FIND FIRST tt-epc 
            WHERE tt-epc.cod-event     = "VALIDATE-ESTABEL" 
              AND tt-epc.cod-parameter = "NOT-VALIDATE" NO-ERROR.

       IF NOT AVAIL tt-epc THEN DO:
           IF CAN-FIND(FIRST embarque NO-LOCK
                       WHERE embarque.cdd-embarq   = p-embarque
                         AND embarque.cod-estabel     <> p-estab-proc ) THEN DO:
              ASSIGN i-seq-erro = i-seq-erro + 1.
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-estabelecimento-da-nota-fiscal-3 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Estabelecimento_da_Nota_Fiscal" *}
              ASSIGN c-lbl-liter-estabelecimento-da-nota-fiscal-3 = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-diferente-do-estabelecimento-d-3 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "diferente_do_estabelecimento_do_processo_de_exportaá∆o" *}
              ASSIGN c-lbl-liter-diferente-do-estabelecimento-d-3 = TRIM(RETURN-VALUE).
              RUN utp/ut-msgs.p (INPUT "msg":U,
                                INPUT 7972,
                                INPUT c-lbl-liter-estabelecimento-da-nota-fiscal-3 + "~~" + " " + c-lbl-liter-diferente-do-estabelecimento-d-3).
              CREATE tt-bo-erro.
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-16 AS CHARACTER NO-UNDO.
              ASSIGN c-lbl-liter-16 = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-estabelecimento-da-nota-fiscal-4 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Estabelecimento_da_Nota_Fiscal" *}
              ASSIGN c-lbl-liter-estabelecimento-da-nota-fiscal-4 = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-diferente-do-estabelecimento-d-4 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "diferente_do_estabelecimento_do_processo_de_exportaá∆o" *}
              ASSIGN c-lbl-liter-diferente-do-estabelecimento-d-4 = TRIM(RETURN-VALUE).
              ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                     tt-bo-erro.cd-erro      = 7972
                     tt-bo-erro.mensagem     = c-lbl-liter-16
                     tt-bo-erro.parametros   = c-lbl-liter-estabelecimento-da-nota-fiscal-4 + "~~" + " " + c-lbl-liter-diferente-do-estabelecimento-d-4.  
           END.
       end.

       IF  AVAIL param-exp 
       AND SUBSTRING(param-exp.char-1,22,1) = "2" /* YES */ THEN DO:
         
          FOR EACH res-cli NO-LOCK
             WHERE res-cli.cdd-embarq = p-embarque:
             
              IF res-cli.cod-cond-pag <> processo-exp.cod-cond-pagto THEN DO:
                 ASSIGN i-seq-erro = i-seq-erro + 1.
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-condioo-de-pagamento-da-nota-f AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Condiá∆o_de_Pagamento_da_Nota_Fiscal" *}
                 ASSIGN c-lbl-liter-condioo-de-pagamento-da-nota-f = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-diferente-da-condioo-de-pagame AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "diferente_da_condiá∆o_de_pagamento_do_Processo_de_Exportaá∆o" *}
                 ASSIGN c-lbl-liter-diferente-da-condioo-de-pagame = TRIM(RETURN-VALUE).
                 RUN utp/ut-msgs.p (INPUT "msg":U,
                                    INPUT 7972,
                                    INPUT c-lbl-liter-condioo-de-pagamento-da-nota-f + "~~" +
                                          c-lbl-liter-diferente-da-condioo-de-pagame).
                 CREATE tt-bo-erro.
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-17 AS CHARACTER NO-UNDO.
                 ASSIGN c-lbl-liter-17 = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-condioo-de-pagamento-da-nota-f-2 AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Condiá∆o_de_Pagamento_da_Nota_Fiscal" *}
                 ASSIGN c-lbl-liter-condioo-de-pagamento-da-nota-f-2 = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-diferente-da-condioo-de-pagame-2 AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "diferente_da_condiá∆o_de_pagamento_do_Processo_de_Exportaá∆o" *}
                 ASSIGN c-lbl-liter-diferente-da-condioo-de-pagame-2 = TRIM(RETURN-VALUE).
                 ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                        tt-bo-erro.cd-erro      = 7972
                        tt-bo-erro.mensagem     = c-lbl-liter-17
                        tt-bo-erro.parametros   = c-lbl-liter-condioo-de-pagamento-da-nota-f-2 + "~~" +
                                                 c-lbl-liter-diferente-da-condioo-de-pagame-2.       
                 LEAVE.
             END.
          END.
       END.
       
       IF NOT CAN-FIND(FIRST it-pre-fat NO-LOCK
                       WHERE it-pre-fat.cdd-embarq = p-embarque) THEN DO:
          ASSIGN i-seq-erro = i-seq-erro + 1.
          RUN utp/ut-msgs.p (INPUT "msg":U,
                             INPUT 32629,
                             INPUT "").
          CREATE tt-bo-erro.
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-18 AS CHARACTER NO-UNDO.
          ASSIGN c-lbl-liter-18 = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-embarque-3 AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Embarque" *}
          ASSIGN c-lbl-liter-embarque-3 = TRIM(RETURN-VALUE).
          ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 32629
                 tt-bo-erro.mensagem     = c-lbl-liter-18
                 tt-bo-erro.parametros   = c-lbl-liter-embarque-3.
                
       END.
    
       ASSIGN c-notas = "".
       FOR EACH nota-fiscal FIELDS(nr-nota-fis dt-atual-cr) NO-LOCK
          WHERE nota-fiscal.cdd-embarq  = p-embarque:
          IF nota-fiscal.dt-atual-cr <> ? THEN
              ASSIGN c-notas = c-notas + nota-fiscal.nr-nota-fis + ";".                          
       END.
       IF c-notas <> "" THEN DO:
          ASSIGN i-seq-erro = i-seq-erro + 1.
          /* Inicio -- Projeto Internacional */
          {utp/ut-liter.i "Nota(s)_Fiscai(s)_relacionada(s)_ao_embarque" *}
          RUN utp/ut-msgs.p (INPUT "msg":U,
                             INPUT 32630,
                             INPUT RETURN-VALUE + "~~" +
                                   c-notas).
          CREATE tt-bo-erro.
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-19 AS CHARACTER NO-UNDO.
          ASSIGN c-lbl-liter-19 = TRIM(RETURN-VALUE).
          DEFINE VARIABLE c-lbl-liter-notas-fiscais-relacionadas-ao AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Nota(s)_Fiscai(s)_relacionada(s)_ao_embarque" *}
          ASSIGN c-lbl-liter-notas-fiscais-relacionadas-ao = TRIM(RETURN-VALUE).
          ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 32630
                 tt-bo-erro.mensagem     = c-lbl-liter-19
                 tt-bo-erro.errorsubtype = "warning":U
                 tt-bo-erro.parametros   = c-lbl-liter-notas-fiscais-relacionadas-ao + "~~" + c-notas. 
       END.                                              

       FIND FIRST embarque NO-LOCK
            WHERE embarque.cdd-embarq = p-embarque NO-ERROR.
       IF AVAIL embarque THEN DO:
       
          &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
              IF embarque.nr-proc-exp <> "" THEN DO:
                 ASSIGN i-seq-erro = i-seq-erro + 1.
                 /* Inicio -- Projeto Internacional */
                 {utp/ut-liter.i "Embarque" *}
                 RUN utp/ut-msgs.p (INPUT "msg":U,
                                    INPUT 32631,
                                    INPUT RETURN-VALUE + "~~" + embarque.nr-proc-exp).
                 CREATE tt-bo-erro.
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-20 AS CHARACTER NO-UNDO.
                 ASSIGN c-lbl-liter-20 = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-embarque-4 AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Embarque" *}
                 ASSIGN c-lbl-liter-embarque-4 = TRIM(RETURN-VALUE).
                 ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                        tt-bo-erro.cd-erro      = 32631
                        tt-bo-erro.mensagem     = c-lbl-liter-20
                        tt-bo-erro.parametros   = c-lbl-liter-embarque-4 + "~~" + embarque.nr-proc-exp.  
              END.
          &ELSE 
              IF trim(SUBSTRING(embarque.char-1,2,12)) <> "" THEN DO:
                 ASSIGN i-seq-erro = i-seq-erro + 1.
                 /* Inicio -- Projeto Internacional */
                 {utp/ut-liter.i "Embarque" *}
                 RUN utp/ut-msgs.p (INPUT "msg":U,
                                    INPUT 32631,
                                    INPUT RETURN-VALUE + "~~" + SUBSTRING(embarque.char-1,2,12)).
                 CREATE tt-bo-erro.
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-21 AS CHARACTER NO-UNDO.
                 ASSIGN c-lbl-liter-21 = TRIM(RETURN-VALUE).
                 DEFINE VARIABLE c-lbl-liter-embarque-5 AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Embarque" *}
                 ASSIGN c-lbl-liter-embarque-5 = TRIM(RETURN-VALUE).
                 ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                        tt-bo-erro.cd-erro      = 32631
                        tt-bo-erro.mensagem     = c-lbl-liter-21
                        tt-bo-erro.parametros   = c-lbl-liter-embarque-5 + "~~" + SUBSTRING(embarque.char-1,2,12).  
              END.
          &ENDIF  
       END.
       /*Validaá∆o de cliente do pedido e processo exportaá∆o*/
       FOR EACH  pre-fatur NO-LOCK
           where pre-fatur.cdd-embarq =  p-embarque:
       
               FOR FIRST ped-venda NO-LOCK
                   WHERE ped-venda.nr-pedcli  = pre-fatur.nr-pedcli
                   AND   ped-venda.nome-abrev = pre-fatur.nome-abrev: END.
               FIND FIRST emitente NO-LOCK
                    WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.
               IF AVAIL emitente and avail processo-exp THEN 
                  IF processo-exp.cod-emitente <> emitente.cod-emitente THEN DO:
                     assign i-seq-erro = i-seq-erro + 1.
                     {utp/ut-liter.i "Embarque n∆o pode ser vinculado" * R}
                         ASSIGN c-mensagem = RETURN-VALUE.
                     {utp/ut-liter.i "Cliente do pedido diferente do c¢digo do importador Processo de Exportaá∆o" * R}
                         ASSIGN c-help = RETURN-VALUE.
                     run utp/ut-msgs.p (input "msg",
                                        input 15825,
                                        input c-mensagem + "~~" +
                                              c-help).
                     create tt-bo-erro.
                     assign tt-bo-erro.i-sequen     = i-seq-erro
                            tt-bo-erro.cd-erro      = 15825
                            tt-bo-erro.mensagem     = return-value
                            tt-bo-erro.parametros   = c-mensagem + "~~" +
                                                      c-help.       
                     leave.            
                  end.    
       END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piGeraRelacionamentos:

  DEFINE INPUT PARAMETER p-estab    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p-serie    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p-nota     AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p-embarque AS DECIMAL   NO-UNDO.
  DEFINE INPUT PARAMETER p-origem   AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER p-processo AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p-est-proc AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER TABLE for tt-bo-erro.

  FOR EACH tt-proc-nota-fiscal:  
      DELETE tt-proc-nota-fiscal.  
  END.
  FOR EACH tt-proc-ped-venda:    
      DELETE tt-proc-ped-venda.    
  END.
  FOR EACH tt-proc-ped-ent:      
      DELETE tt-proc-ped-ent.      
  END.
  FOR EACH tt-bo-erro:           
      DELETE tt-bo-erro.           
  END.
  
  def var de-qtd-devol like devol-cli.qt-devolvida no-undo.
  def var h-ex3051 as handle no-undo.

  DEFINE VARIABLE i-cdn-tip-export AS INTEGER INIT 0  NO-UNDO.
  DEFINE VARIABLE l-perm-embarque  AS LOGICAL INIT NO NO-UNDO.
  DEFINE VARIABLE h-boar2113       AS HANDLE          NO-UNDO.
  run exp/ex3051.p persistent set h-ex3051.
  IF p-origem = 1 THEN DO: /* Nota Fiscal */
  
     FIND FIRST nota-fiscal NO-LOCK
          WHERE nota-fiscal.cod-estabel = p-estab
            AND nota-fiscal.serie       = p-serie
            AND nota-fiscal.nr-nota-fis = p-nota NO-ERROR.
     IF NOT AVAIL nota-fiscal THEN NEXT.
     
     CREATE tt-proc-nota-fiscal.
     ASSIGN tt-proc-nota-fiscal.cod-estabel       = p-est-proc
            tt-proc-nota-fiscal.nr-proc-exp       = p-processo
            tt-proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel
            tt-proc-nota-fiscal.serie             = nota-fiscal.serie
            tt-proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis
            tt-proc-nota-fiscal.check-sum         = nota-fiscal.check-sum       
            tt-proc-nota-fiscal.log-nf-devolvid   = NO.
     
     FOR EACH it-nota-fisc NO-LOCK
        WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel 
          AND it-nota-fisc.serie       = nota-fiscal.serie       
          AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis :
          
          assign de-qtd-devol = 0.
          for each devol-cli fields(qt-devolvida) no-lock
             where devol-cli.cod-estabel  = it-nota-fisc.cod-estabel
               and devol-cli.serie        = it-nota-fisc.serie      
               and devol-cli.nr-nota-fis  = it-nota-fisc.nr-nota-fis
               and devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat 
               and devol-cli.it-codigo    = it-nota-fisc.it-codigo:
               assign de-qtd-devol        = de-qtd-devol + devol-cli.qt-devolvida.

               if valid-handle(h-ex3051) then
                  run CriaProcesDevolClienViaDevolCli in h-ex3051 (input nota-fiscal.cod-estabel, 
                                                                   input nota-fiscal.serie, 
                                                                   input nota-fiscal.nr-nota-fis, 
                                                                   buffer devol-cli).


          end.
          FOR FIRST ped-item FIELDS(ind-fat-qtfam ind-componen) NO-LOCK
              WHERE ped-item.nome-abrev    = it-nota-fisc.nome-ab-cli  
                AND ped-item.nr-pedcli     = it-nota-fisc.nr-pedcli    
                AND ped-item.nr-sequencia  = it-nota-fisc.nr-seq-ped   
                AND ped-item.it-codigo     = it-nota-fisc.it-codigo    
                AND ped-item.cod-refer     = it-nota-fisc.cod-refer: 
          END.  
          
          FOR FIRST ped-venda FIELDS(mo-codigo) NO-LOCK
               WHERE ped-venda.nr-pedido = it-nota-fisc.nr-pedido : 
          END.
  
          FIND FIRST tt-proc-ped-venda 
               WHERE tt-proc-ped-venda.cod-estabel  = p-est-proc
                 AND tt-proc-ped-venda.nr-proc-exp  = p-processo
                 AND tt-proc-ped-venda.nr-pedido    = it-nota-fisc.nr-pedido NO-ERROR.
          IF NOT AVAIL tt-proc-ped-venda THEN DO:
             CREATE tt-proc-ped-venda.
             ASSIGN tt-proc-ped-venda.cod-estabel  = p-est-proc
                    tt-proc-ped-venda.nr-proc-exp  = p-processo
                    tt-proc-ped-venda.nr-pedido    = it-nota-fisc.nr-pedido
                    tt-proc-ped-venda.check-sum    = it-nota-fisc.check-sum
                    tt-proc-ped-venda.cod-emitente = it-nota-fisc.cd-emitente
                    tt-proc-ped-venda.nome-abrev   = it-nota-fisc.nome-ab-cli
                    tt-proc-ped-venda.nr-pedcli    = it-nota-fisc.nr-pedcli.
          END.
                 
          FOR FIRST ITEM FIELDS(desc-item) NO-LOCK
               WHERE ITEM.it-codigo = it-nota-fisc.it-codigo : 
          END.
           
          FIND FIRST tt-proc-ped-ent
               WHERE tt-proc-ped-ent.cod-estabel        = p-est-proc
                 AND tt-proc-ped-ent.nr-proc-exp        = p-processo
                 AND tt-proc-ped-ent.nome-abrev         = it-nota-fisc.nome-ab-cli
                 AND tt-proc-ped-ent.nr-pedcli          = it-nota-fisc.nr-pedcli
                 AND tt-proc-ped-ent.nr-sequencia       = it-nota-fisc.nr-seq-ped
                 AND tt-proc-ped-ent.it-codigo          = it-nota-fisc.it-codigo
                 AND tt-proc-ped-ent.cod-refer          = it-nota-fisc.cod-refer
                 AND tt-proc-ped-ent.nr-entrega         = it-nota-fisc.nr-entrega NO-ERROR.
          IF NOT AVAIL tt-proc-ped-ent THEN DO:
             CREATE tt-proc-ped-ent.
             ASSIGN tt-proc-ped-ent.cod-estabel        = p-est-proc
                    tt-proc-ped-ent.nr-proc-exp        = p-processo
                    tt-proc-ped-ent.nome-abrev         = it-nota-fisc.nome-ab-cli
                    tt-proc-ped-ent.nr-pedcli          = it-nota-fisc.nr-pedcli
                    tt-proc-ped-ent.nr-sequencia       = it-nota-fisc.nr-seq-ped
                    tt-proc-ped-ent.it-codigo          = it-nota-fisc.it-codigo
                    tt-proc-ped-ent.cod-refer          = it-nota-fisc.cod-refer
                    tt-proc-ped-ent.nr-entrega         = it-nota-fisc.nr-entrega
                 
                    tt-proc-ped-ent.check-sum          = it-nota-fisc.check-sum
                    tt-proc-ped-ent.des-discrep-item   = IF AVAIL item THEN item.desc-item  ELSE ""
                    tt-proc-ped-ent.nr-pedido          = it-nota-fisc.nr-pedido   
                    tt-proc-ped-ent.peso-bruto         = it-nota-fisc.peso-bruto  
                    tt-proc-ped-ent.peso-liquido       = it-nota-fisc.peso-liq-fat 
                    tt-proc-ped-ent.quantidade[1]      = it-nota-fisc.qt-faturada[1] - de-qtd-devol
                    tt-proc-ped-ent.quantidade[2]      = it-nota-fisc.qt-faturada[2] - de-qtd-devol
                    tt-proc-ped-ent.un-fatur           = it-nota-fisc.un-fatur[1]    
                    tt-proc-ped-ent.vl-preori          = IF ped-venda.mo-codigo = 0 THEN it-nota-fisc.vl-preori ELSE it-nota-fisc.vl-preori-e[1]
                    tt-proc-ped-ent.vl-preuni          = IF ped-venda.mo-codigo = 0 THEN it-nota-fisc.vl-preuni ELSE it-nota-fisc.vl-preuni-e[1].
                 
                
             IF AVAIL ped-item THEN DO:
                 ASSIGN tt-proc-ped-ent.ind-componen  = ped-item.ind-componen.
                    
                 IF  ped-item.ind-fat-qtfam THEN
                     ASSIGN tt-proc-ped-ent.idi-unid-fatur = 2.
                 ELSE 
                     IF NOT ped-item.ind-fat-qtfam THEN
                        ASSIGN tt-proc-ped-ent.idi-unid-fatur = 1.
                     ELSE
                        ASSIGN tt-proc-ped-ent.idi-unid-fatur = 3.
             END.
          END.
          ELSE DO:
               ASSIGN  tt-proc-ped-ent.peso-bruto         = tt-proc-ped-ent.peso-bruto    + it-nota-fisc.peso-bruto        
                       tt-proc-ped-ent.peso-liquido       = tt-proc-ped-ent.peso-liquido  + it-nota-fisc.peso-liq-fat      
                       tt-proc-ped-ent.quantidade[1]      = tt-proc-ped-ent.quantidade[1] + it-nota-fisc.qt-faturada[1] - de-qtd-devol  
                       tt-proc-ped-ent.quantidade[2]      = tt-proc-ped-ent.quantidade[2] + it-nota-fisc.qt-faturada[2] - de-qtd-devol.  
          END.
          
          IF it-nota-fisc.ind-componen = 2 THEN DO:
          
             FOR EACH fat-ser-lote NO-LOCK
                WHERE fat-ser-lote.cod-estabel = p-est-proc 
                  AND fat-ser-lote.serie       = it-nota-fisc.serie       
                  AND fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis 
                  AND fat-ser-lote.nr-seq-fat  = it-nota-fisc.nr-seq-fat  
                  AND fat-ser-lote.cod-depos   = it-nota-fisc.cod-depos   
                  AND fat-ser-lote.cod-localiz = it-nota-fisc.cod-localiz 
                  AND fat-ser-lote.it-codigo   = it-nota-fisc.it-codigo   
                  AND fat-ser-lote.cod-refer   = it-nota-fisc.cod-refer:
                  
                  FOR FIRST ITEM FIELDS(desc-item) NO-LOCK
                       WHERE item.it-codigo = fat-ser-lote.it-codigo : 
                  END.
                   
                  CREATE tt-proc-ped-ent.
                  ASSIGN tt-proc-ped-ent.cod-estabel        = p-est-proc
                         tt-proc-ped-ent.nr-proc-exp        = p-processo
                         tt-proc-ped-ent.nome-abrev         = it-nota-fisc.nome-ab-cli
                         tt-proc-ped-ent.nr-pedcli          = it-nota-fisc.nr-pedcli
                         tt-proc-ped-ent.nr-sequencia       = it-nota-fisc.nr-seq-ped
                         tt-proc-ped-ent.it-codigo          = fat-ser-lote.it-codigo
                         tt-proc-ped-ent.cod-refer          = fat-ser-lote.cod-refer
                         tt-proc-ped-ent.nr-entrega         = it-nota-fisc.nr-entrega
                         tt-proc-ped-ent.check-sum          = fat-ser-lote.check-sum
                         tt-proc-ped-ent.des-discrep-item   = IF AVAIL item then item.desc-item  else ""
                         tt-proc-ped-ent.nr-pedido          = it-nota-fisc.nr-pedido   
                         tt-proc-ped-ent.peso-bruto         = it-nota-fisc.peso-bruto  
                         tt-proc-ped-ent.peso-liquido       = it-nota-fisc.peso-liq-fat 
                         tt-proc-ped-ent.quantidade[1]      = it-nota-fisc.qt-faturada[1] - de-qtd-devol
                         tt-proc-ped-ent.quantidade[2]      = it-nota-fisc.qt-faturada[2] - de-qtd-devol
                         tt-proc-ped-ent.un-fatur           = it-nota-fisc.un-fatur[1]    
                         tt-proc-ped-ent.vl-preori          = IF ped-venda.mo-codigo = 0 THEN it-nota-fisc.vl-preori ELSE it-nota-fisc.vl-preori-e[1]
                         tt-proc-ped-ent.vl-preuni          = IF ped-venda.mo-codigo = 0 THEN it-nota-fisc.vl-preuni ELSE it-nota-fisc.vl-preuni-e[1].
                       
                  IF AVAIL ped-item THEN DO:
                     ASSIGN tt-proc-ped-ent.ind-componen       = ped-item.ind-componen.
                     IF  ped-item.ind-fat-qtfam THEN
                          ASSIGN tt-proc-ped-ent.idi-unid-fatur = 2.
                     ELSE
                         IF  NOT ped-item.ind-fat-qtfam THEN
                             ASSIGN tt-proc-ped-ent.idi-unid-fatur = 1.
                         ELSE
                             ASSIGN tt-proc-ped-ent.idi-unid-fatur = 3.
                  END.
             END.
          END.
     END.
  END.
  ELSE DO: /* embarque */

       FOR EACH nota-fiscal FIELDS(cod-estabel nr-nota-fis nr-proc-exp serie check-sum) NO-LOCK
          WHERE nota-fiscal.cdd-embarq = p-embarque:
          
            IF NOT CAN-FIND(FIRST tt-proc-nota-fiscal NO-LOCK
                            WHERE tt-proc-nota-fiscal.cod-estabel       = p-est-proc
                              AND tt-proc-nota-fiscal.nr-proc-exp       = p-processo
                              and tt-proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel
                              AND tt-proc-nota-fiscal.serie             = nota-fiscal.serie
                              AND tt-proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis) THEN DO:
                
                CREATE tt-proc-nota-fiscal.
                ASSIGN tt-proc-nota-fiscal.cod-estabel       = p-est-proc
                       tt-proc-nota-fiscal.nr-proc-exp       = p-processo
                       tt-proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel
                       tt-proc-nota-fiscal.serie             = nota-fiscal.serie
                       tt-proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis
                       tt-proc-nota-fiscal.check-sum         = nota-fiscal.check-sum
                       tt-proc-nota-fiscal.log-nf-devolvid = NO.
            END.
       END.

       FOR EACH it-pre-fat NO-LOCK
          WHERE it-pre-fat.cdd-embarq = p-embarque:
          
          FOR FIRST ped-ent FIELDS(nome-abrev nr-pedcli nr-sequencia it-codigo cod-refer nr-entrega) NO-LOCK
              WHERE ped-ent.nome-abrev   = it-pre-fat.nome-abrev  
                AND ped-ent.nr-pedcli    = it-pre-fat.nr-pedcli   
                AND ped-ent.nr-sequencia = it-pre-fat.nr-sequencia
                AND ped-ent.it-codigo    = it-pre-fat.it-codigo   
                AND ped-ent.cod-refer    = it-pre-fat.cod-refer   
                AND ped-ent.nr-entrega   = it-pre-fat.nr-entrega  : 
          END.
          
          FIND FIRST ped-venda NO-LOCK
               WHERE ped-venda.nr-pedcli  = it-pre-fat.nr-pedcli
                 and ped-venda.nome-abrev = it-pre-fat.nome-abrev NO-ERROR.
          IF AVAIL ped-venda THEN DO:   
             IF NOT CAN-FIND (FIRST tt-proc-ped-venda NO-LOCK
                              WHERE tt-proc-ped-venda.cod-estabel = p-est-proc
                                AND tt-proc-ped-venda.nr-proc-exp = p-processo
                                AND tt-proc-ped-venda.nr-pedido   = ped-venda.nr-pedido) THEN DO:
            
                CREATE tt-proc-ped-venda.
                ASSIGN tt-proc-ped-venda.cod-estabel  = p-est-proc
                       tt-proc-ped-venda.nr-proc-exp  = p-processo
                       tt-proc-ped-venda.nr-pedido    = ped-venda.nr-pedido                      
                       tt-proc-ped-venda.check-sum    = ped-venda.check-sum
                       tt-proc-ped-venda.cod-emitente = ped-venda.cod-emitente
                       tt-proc-ped-venda.nome-abrev   = ped-venda.nome-abrev
                       tt-proc-ped-venda.nr-pedcli    = ped-venda.nr-pedcli.
             END.
          END.
  
          FOR FIRST ITEM FIELDS(desc-item peso-liquido peso-bruto) NO-LOCK
               WHERE item.it-codigo = it-pre-fat.it-codigo : 
          END.
           
          IF NOT CAN-FIND (FIRST tt-proc-ped-ent NO-LOCK
                           WHERE tt-proc-ped-ent.cod-estabel  = p-est-proc
                             AND tt-proc-ped-ent.nr-proc-exp  = p-processo
                             AND tt-proc-ped-ent.nome-abrev   = it-pre-fat.nome-abrev 
                             AND tt-proc-ped-ent.nr-pedcli    = it-pre-fat.nr-pedcli 
                             AND tt-proc-ped-ent.nr-sequencia = it-pre-fat.nr-sequencia
                             AND tt-proc-ped-ent.it-codigo    = it-pre-fat.it-codigo
                             AND tt-proc-ped-ent.cod-refer    = it-pre-fat.cod-refer
                             AND tt-proc-ped-ent.nr-entrega   = it-pre-fat.nr-entrega) THEN DO:
                             
              CREATE tt-proc-ped-ent.       
              ASSIGN tt-proc-ped-ent.cod-estabel        = p-est-proc
                     tt-proc-ped-ent.nr-proc-exp        = p-processo
                     tt-proc-ped-ent.nome-abrev         = it-pre-fat.nome-abrev 
                     tt-proc-ped-ent.nr-pedcli          = it-pre-fat.nr-pedcli 
                     tt-proc-ped-ent.nr-sequencia       = it-pre-fat.nr-sequencia
                     tt-proc-ped-ent.it-codigo          = it-pre-fat.it-codigo 
                     tt-proc-ped-ent.cod-refer          = it-pre-fat.cod-refer 
                     tt-proc-ped-ent.nr-entrega         = it-pre-fat.nr-entrega 
                     tt-proc-ped-ent.quantidade[1]      = it-pre-fat.qt-alocada
                     tt-proc-ped-ent.check-sum          = it-pre-fat.check-sum
                     tt-proc-ped-ent.des-discrep-item   = IF AVAIL item then item.desc-item  else ""
                     tt-proc-ped-ent.nr-pedido          = ped-venda.nr-pedido.
                 
                 
                 IF AVAIL ITEM THEN
                    ASSIGN tt-proc-ped-ent.peso-liquido   = TRUNCATE(it-pre-fat.qt-alocada * item.peso-liquido,3) 
                           tt-proc-ped-ent.peso-bruto     = TRUNCATE(it-pre-fat.qt-alocada * item.peso-bruto,3).
                           
                 FOR FIRST ped-item NO-LOCK
                     WHERE ped-item.nome-abrev    = it-pre-fat.nome-abrev    
                       AND ped-item.nr-pedcli     = it-pre-fat.nr-pedcli     
                       AND ped-item.nr-sequencia  = it-pre-fat.nr-sequencia  
                       AND ped-item.it-codigo     = it-pre-fat.it-codigo     
                       AND ped-item.cod-refer     = it-pre-fat.cod-refer :  
                 END.
                 IF AVAIL ped-item THEN DO:
                    ASSIGN tt-proc-ped-ent.ind-componen       = ped-item.ind-componen
                           tt-proc-ped-ent.vl-preori          = ped-item.vl-preori
                           tt-proc-ped-ent.vl-preuni          = ped-item.vl-preuni.  
                           
                      IF  ped-item.ind-fat-qtfam THEN
                          ASSIGN tt-proc-ped-ent.idi-unid-fatur = 2.
                      ELSE
                          IF  NOT ped-item.ind-fat-qtfam THEN
                              ASSIGN tt-proc-ped-ent.idi-unid-fatur = 1.
                          ELSE
                              ASSIGN tt-proc-ped-ent.idi-unid-fatur = 3.
                        
                      assign c-un-medida = ped-item.des-un-medida.
                   
                 END.
                 IF  VALID-HANDLE(h-bocx195) THEN
                    RUN converteQtdUnMedidaClienteFamilia IN h-bocx195 (INPUT  tt-proc-ped-ent.it-codigo,                                                     
                                                                        INPUT  tt-proc-ped-ent.nome-abrev,
                                                                        INPUT  tt-proc-ped-ent.idi-unid-fatur,
                                                                        INPUT  tt-proc-ped-ent.quantidade[1],
                                                                        INPUT  c-un-medida,
                                                                        OUTPUT de-qtd-conver,
                                                                        OUTPUT c-unid-conver).
                    ASSIGN tt-proc-ped-ent.quantidade[2] = de-qtd-conver
                           tt-proc-ped-ent.un-fatur      = c-unid-conver.
						   
				    IF  VALID-HANDLE(h-bocx195) THEN DO:
						DELETE PROCEDURE h-bocx195.
						ASSIGN h-bocx195 = ?.
					END.
	   
          END.
       END.

  END.

  if valid-handle(h-ex3051) THEN DO:
     delete procedure h-ex3051.
     ASSIGN h-ex3051 = ?.
  END.
  RUN piRelacionaProcPedVenda (INPUT TABLE tt-proc-ped-venda,
                               INPUT-OUTPUT TABLE tt-bo-erro).
  FIND FIRST tt-bo-erro NO-LOCK
       WHERE tt-bo-erro.errorsubtype <> "warning":U NO-ERROR.
  IF AVAIL tt-bo-erro THEN
     RETURN "NOK":U.
  
  RUN piCriaRelacionamentos(INPUT TABLE tt-proc-ped-venda,
                            INPUT TABLE tt-proc-ped-ent,
                            INPUT TABLE tt-proc-nota-fiscal,
                            INPUT-OUTPUT TABLE tt-bo-erro).
                            
  FIND FIRST tt-bo-erro 
       WHERE tt-bo-erro.errorsubtype <> "warning":U NO-ERROR.
  IF AVAIL tt-bo-erro THEN
     RETURN "NOK":U.
  IF p-origem = 1 THEN DO: /* Nota Fiscal */
     FIND FIRST proc-nota-fiscal EXCLUSIVE-LOCK
          WHERE proc-nota-fiscal.cod-estabel       = p-est-proc      
            and proc-nota-fiscal.nr-proc-exp       = p-processo   
            and proc-nota-fiscal.cod-estab-faturam = p-estab
            and proc-nota-fiscal.serie             = p-serie   
            and proc-nota-fiscal.nr-nota-fis       = p-nota NO-ERROR.
     IF AVAIL proc-nota-fiscal THEN DO:
        FOR FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel             = p-estab
              AND nota-fiscal.nr-nota-fis             = p-nota
              AND nota-fiscal.nr-proc-exp             = p-processo
              and nota-fiscal.cod-estab-proces-export = p-est-proc
              AND nota-fiscal.serie                   = p-serie:
        END.
        
        IF  AVAIL nota-fiscal 
        AND nota-fiscal.cdd-embarq <> 0 THEN DO:

			if l-cria-subprocesso then /*Se for subprocesso grava como Autom·tico*/
               ASSIGN proc-nota-fiscal.cdn-tip-relacto = 1. /* 1 - Automatico 2 - Manual */
			else
			   ASSIGN proc-nota-fiscal.cdn-tip-relacto = 2. /* 1 - Automatico 2 - Manual */
			   
           FIND FIRST embarque EXCLUSIVE-LOCK
                WHERE embarque.cdd-embarq = nota-fiscal.cdd-embarq NO-ERROR.
           IF AVAIL embarque THEN DO:
                ASSIGN embarque.nr-proc-exp     = p-processo.
				if l-cria-subprocesso then /*Se for subprocesso grava como Autom·tico*/
				   ASSIGN embarque.cdn-tip-relacto = 1. /* 1 - Automatico 2 - Manual */
				else
				   ASSIGN embarque.cdn-tip-relacto = 2. /* 1 - Automatico 2 - Manual */
           END.
           RELEASE embarque.
        END.
        ELSE DO:
            if l-cria-subprocesso then /*Se for subprocesso grava como Autom·tico*/
               ASSIGN proc-nota-fiscal.cdn-tip-relacto = 1. /* 1 - Automatico 2 - Manual */
			else
			   ASSIGN proc-nota-fiscal.cdn-tip-relacto = 2. /* 1 - Automatico 2 - Manual */
        END.

        /*Atualiza notas fiscais relacionadas Ö operaá∆o triangular 
          - Este tipo de documento sempre ir† armazenar a informaá∆o do Tipo de Relacionaemnto "Autom†tico",
          pois Ç uma NF Filha da nota fiscal de Fatura o qual foi vinculada ao Processo de Exportaá∆o*/
        FOR EACH tt-nota:
           FOR FIRST bf_nota_fiscal
               WHERE bf_nota_fiscal.cod-estabel = proc-nota-fiscal.cod-estab-faturam
                 AND bf_nota_fiscal.serie       = proc-nota-fiscal.serie
                 AND bf_nota_fiscal.nr-nota-fis = proc-nota-fiscal.nr-nota-fis NO-LOCK:
           END.

           FOR FIRST bf-proc-nota-fiscal
               WHERE bf-proc-nota-fiscal.cod-estab-faturam = tt-nota.cod-estabel
                 AND bf-proc-nota-fiscal.serie             = tt-nota.serie
                 AND bf-proc-nota-fiscal.nr-nota-fis       = tt-nota.nr-nota-fis EXCLUSIVE-LOCK:

                IF AVAIL bf_nota_fiscal
                AND bf_nota_fiscal.cdd-embarq <> 0 THEN DO:

                   ASSIGN bf-proc-nota-fiscal.cdn-tip-relacto = 1. /* 1 - Automatico 2 - Manual */
                       
                   FIND FIRST bf-embarque EXCLUSIVE-LOCK
                        WHERE bf-embarque.cdd-embarq = bf_nota_fiscal.cdd-embarq NO-ERROR.
                   IF AVAIL bf-embarque THEN DO:
                        ASSIGN bf-embarque.nr-proc-exp     = p-processo
                               bf-embarque.cdn-tip-relacto = 1. /* 1 - Automatico 2 - Manual */
                   END.
                   RELEASE bf-embarque.
                END.
                ELSE
                    ASSIGN bf-proc-nota-fiscal.cdn-tip-relacto = 1. /* 1 - Automatico 2 - Manual */
           END.
        END.
        
     END.
  END.
  ELSE DO: /* embarque */
       FIND FIRST embarque EXCLUSIVE-LOCK
            WHERE embarque.cdd-embarq = p-embarque NO-ERROR.
       IF AVAIL embarque THEN DO:
            ASSIGN embarque.nr-proc-exp     = p-processo.
			   
			if l-cria-subprocesso then /*Se for subprocesso grava como Autom·tico*/
			   ASSIGN embarque.cdn-tip-relacto = 1. /* 1 - Automatico 2 - Manual */
			else
			   ASSIGN embarque.cdn-tip-relacto = 2. /* 1 - Automatico 2 - Manual */
          
       end.
       RELEASE embarque.
       FOR EACH nota-fiscal FIELDS(cod-estabel nr-nota-fis nr-proc-exp serie check-sum) NO-LOCK
          WHERE nota-fiscal.cdd-embarq = p-embarque:
          FIND FIRST proc-nota-fiscal EXCLUSIVE-LOCK
               WHERE proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel      
                 and proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis       
                 and proc-nota-fiscal.serie             = nota-fiscal.serie
                 and proc-nota-fiscal.cod-estabel       = p-est-proc
                 and proc-nota-fiscal.nr-proc-exp       = p-processo NO-ERROR.
          IF AVAIL proc-nota-fiscal THEN DO:
             IF l-cria-subprocesso then /*Se for subprocesso grava como Autom·tico*/
                ASSIGN proc-nota-fiscal.cdn-tip-relacto = 1. /* 1 - Automatico 2 - Manual */
			 ELSE
			    ASSIGN proc-nota-fiscal.cdn-tip-relacto = 2. /* 1 - Automatico 2 - Manual */

            /*Atualiza notas fiscais relacionadas Ö operaá∆o triangular 
              - Este tipo de documento sempre ir† armazenar a informaá∆o do Tipo de Relacionaemnto "Autom†tico",
              pois Ç uma NF Filha da nota fiscal de Fatura o qual foi vinculada ao Processo de Exportaá∆o*/
              IF CAN-FIND(FIRST tt-nota
                          WHERE tt-nota.cod-estabel = proc-nota-fiscal.cod-estab-faturam
                            AND tt-nota.serie       = proc-nota-fiscal.serie 
                            AND tt-nota.nr-nota-fis = proc-nota-fiscal.nr-nota-fis) THEN
                  ASSIGN proc-nota-fiscal.cdn-tip-relacto = 1. /* 1 - Automatico 2 - Manual */
                  
          END.
       END.
  END.

  IF i-pais-impto-usuario = 2 THEN DO:   

      IF  NOT VALID-HANDLE(h-boar2113) THEN
          RUN local/arg/boar2113.p PERSISTENT SET h-boar2113.

      IF NOT AVAIL processo-exp THEN
          FOR FIRST processo-exp NO-LOCK
              WHERE processo-exp.cod-estabel = p-estab
              AND   processo-exp.nr-proc-exp = p-processo:
          END.

      RUN buscaRegistro IN h-boar2113 (INPUT processo-exp.cod-estabel,
                                       INPUT processo-exp.nr-proc-exp,
                                       OUTPUT i-cdn-tip-export,
                                       OUTPUT l-perm-embarque).

      RUN salvaRegistro IN h-boar2113 (INPUT processo-exp.cod-estabel,
                                       INPUT processo-exp.nr-proc-exp,
                                       INPUT processo-exp.cod-idioma,
                                       INPUT processo-exp.cod-pais,
                                       INPUT processo-exp.cod-incoterm,
                                       INPUT processo-exp.cdn-bco-cobr,
                                       INPUT i-cdn-tip-export,
                                       INPUT processo-exp.pto-chegada,
                                       INPUT processo-exp.pto-embarque,
                                       INPUT l-perm-embarque). 

      IF  VALID-HANDLE(h-boar2113) THEN DO:
          RUN destroy IN h-boar2113.
          ASSIGN h-boar2113 = ?.
      END.
  END.
  RETURN "OK":U.

END PROCEDURE.

PROCEDURE piRelacionaProcPedVenda:
        
    DEFINE INPUT PARAMETER TABLE FOR tt-proc-ped-venda.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-bo-erro.
    
    DEFINE VARIABLE r-rowid-ped-venda AS ROWID NO-UNDO.

    FOR EACH tt-bo-erro: 
        DELETE tt-bo-erro. 
    END.
    

 
        ASSIGN p-relaciona-nota-embarque-ex0190 = YES.
        FOR EACH tt-proc-ped-venda :

            RUN findPk_proc_pedvenda (INPUT tt-proc-ped-venda.cod-estabel,
                                      INPUT tt-proc-ped-venda.nr-proc-exp,
                                      INPUT tt-proc-ped-venda.nr-pedido,  
                                      OUTPUT c-return).

            IF c-return = "" THEN DO:
               RUN validarecebevariavelbodi317efm04(INPUT YES).
            END.
            ELSE DO:

               CREATE tt-proc-ped-venda-aux.
               BUFFER-COPY tt-proc-ped-venda TO tt-proc-ped-venda-aux.
               
               RUN validateCREATE (INPUT NO,
                                   INPUT  TABLE tt-proc-ped-venda-aux,
                                   OUTPUT TABLE tt-bo-erro,
                                   OUTPUT r-rowid-ped-venda).

               IF CAN-FIND(FIRST tt-bo-erro
                           WHERE tt-bo-erro.errorsubtype <> "warning":U ) THEN 
                  RETURN "NOK":U.

               FOR EACH tt-proc-ped-venda-aux: 
                   DELETE tt-proc-ped-venda-aux. 
               END.
              
               IF CAN-FIND(FIRST tt-bo-erro
                           WHERE tt-bo-erro.errorsubtype <> "warning":U) THEN 
                  RETURN "NOK":U. /* n∆o pode continuar deve retornar para o programa com os erros */

            END.

            RUN getRowid (OUTPUT r-rowid-ped-venda).
            ASSIGN tt-proc-ped-venda.r-rowid = r-rowid-ped-venda.  

        END.
    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE PiCriaRelacionamentos:

    DEFINE INPUT PARAMETER TABLE FOR tt-proc-ped-venda.
    DEFINE INPUT PARAMETER TABLE FOR tt-proc-ped-ent.
    DEFINE INPUT PARAMETER TABLE FOR tt-proc-nota-fiscal.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-bo-erro.
  
    DEF BUFFER bfproc-ped-ent FOR proc-ped-ent.  

    IF NOT VALID-HANDLE(h-bocx195) then
       RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.
     
    IF NOT VALID-HANDLE(h-bocx195a) then
       RUN cxbo/bocx195a.p PERSISTENT SET h-bocx195a.   
     
    IF NOT VALID-HANDLE(h-bocx260) then
       RUN cxbo/bocx260.p PERSISTENT SET h-bocx260.   

    RUN piSetaSubprocesso IN h-bocx195 (INPUT l-cria-subprocesso).
    IF l-cria-subprocesso THEN
          RUN setValidaNfEmbarque IN h-bocx195 (INPUT NO).

    FOR EACH tt-proc-ped-ent EXCLUSIVE-LOCK:
       
        CREATE tt-proc-ped-ent-aux.
        BUFFER-COPY tt-proc-ped-ent TO tt-proc-ped-ent-aux.
        
        FIND FIRST tt-proc-ped-venda NO-LOCK
             WHERE tt-proc-ped-venda.cod-estabel = tt-proc-ped-ent.cod-estabel
               AND tt-proc-ped-venda.nr-proc-exp = tt-proc-ped-ent.nr-proc-exp
               AND tt-proc-ped-venda.nr-pedido   = tt-proc-ped-ent.nr-pedido NO-ERROR.
        
         FOR FIRST proc-ped-ent NO-LOCK
             WHERE proc-ped-ent.cod-estabel  = tt-proc-ped-ent.cod-estabel 
               AND proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent.nr-proc-exp 
               AND proc-ped-ent.nome-abrev   = tt-proc-ped-ent.nome-abrev  
               AND proc-ped-ent.nr-pedcli    = tt-proc-ped-ent.nr-pedcli   
               AND proc-ped-ent.nr-sequencia = tt-proc-ped-ent.nr-sequencia
               AND proc-ped-ent.it-codigo    = tt-proc-ped-ent.it-codigo   
               AND proc-ped-ent.cod-refer    = tt-proc-ped-ent.cod-refer   
               AND proc-ped-ent.nr-entrega   = tt-proc-ped-ent.nr-entrega : 
         END.
         IF AVAIL proc-ped-ent THEN DO:
            ASSIGN tt-proc-ped-ent.quantidade[1] = tt-proc-ped-ent.quantidade[1] + proc-ped-ent.quantidade[1] 
                   tt-proc-ped-ent.quantidade[2] = tt-proc-ped-ent.quantidade[2] + proc-ped-ent.quantidade[2]
                   tt-proc-ped-ent.peso-bruto    = tt-proc-ped-ent.peso-bruto    + proc-ped-ent.peso-bruto   
                   tt-proc-ped-ent.peso-liquido  = tt-proc-ped-ent.peso-liquido  + proc-ped-ent.peso-liquido
                   tt-proc-ped-ent.r-rowid       = ROWID(proc-ped-ent).
         
            IF  VALID-HANDLE(h-bocx195) THEN DO:
                RUN ValidateUpdate IN h-bocx195 (INPUT TABLE tt-proc-ped-ent,
                                                 INPUT tt-proc-ped-ent.r-rowid,
                                                 OUTPUT TABLE tt-bo-erro).
                IF CAN-FIND(FIRST tt-bo-erro
                            WHERE tt-bo-erro.errorsubtype <> "warning":U) THEN 
                   RETURN "NOK":U.                                 
            END.
            FIND FIRST ped-item
                 WHERE ped-item.nome-abrev    = proc-ped-ent.nome-abrev  
                   AND ped-item.nr-pedcli     = proc-ped-ent.nr-pedcli    
                   AND ped-item.nr-sequencia  = proc-ped-ent.nr-sequencia   
                   AND ped-item.it-codigo     = proc-ped-ent.it-codigo    
                   AND ped-item.cod-refer     = proc-ped-ent.cod-refer NO-LOCK NO-ERROR.  
            IF  AVAIL ped-item THEN DO:
                IF ped-item.ind-componen = 2 THEN DO:
                    FOR EACH bfproc-ped-ent 
                       WHERE bfproc-ped-ent.cod-estabel  = proc-ped-ent.cod-estabel 
                         AND bfproc-ped-ent.nr-proc-exp  = proc-ped-ent.nr-proc-exp 
                         AND bfproc-ped-ent.nome-abrev   = ped-item.nome-abrev      
                         AND bfproc-ped-ent.nr-pedcli    = ped-item.nr-pedcli       
                         AND bfproc-ped-ent.nr-sequencia = ped-item.nr-sequencia NO-LOCK:

                        IF  proc-ped-ent.it-codigo <> bfproc-ped-ent.it-codigo THEN DO:
                            FIND FIRST ped-ent NO-LOCK 
                                 WHERE ped-ent.nome-abrev   = bfproc-ped-ent.nome-abrev
                                   AND ped-ent.nr-pedcli    = bfproc-ped-ent.nr-pedcli
                                   AND ped-ent.nr-sequencia = bfproc-ped-ent.nr-sequencia
                                   AND ped-ent.it-codigo    = bfproc-ped-ent.it-codigo
                                   AND ped-ent.cod-refer    = bfproc-ped-ent.cod-refer
                                   AND ped-ent.nr-entrega   = bfproc-ped-ent.nr-entrega NO-ERROR.

                            EMPTY TEMP-TABLE tt-proc-ped-ent-filho.
                   
                            CREATE tt-proc-ped-ent-filho.
                            BUFFER-COPY bfproc-ped-ent TO tt-proc-ped-ent-filho.
                            
                            ASSIGN tt-proc-ped-ent-filho.quantidade[1] = tt-proc-ped-ent.quantidade[1] / ped-item.qt-pedida * ped-ent.qt-pedida
                                   tt-proc-ped-ent-filho.r-rowid       = ROWID(bfproc-ped-ent).

                            IF  VALID-HANDLE(h-bocx195) THEN DO:
                            
                                RUN atualizaQuantidade in h-bocx195 (INPUT ROWID(ped-ent),
                                                                     INPUT-OUTPUT TABLE tt-proc-ped-ent-filho,
                                                                     INPUT tt-proc-ped-ent-filho.quantidade[1]).

                                FOR FIRST ITEM FIELDS(peso-liquido peso-bruto) NO-LOCK
                                    WHERE ITEM.it-codigo = tt-proc-ped-ent-filho.it-codigo : 
                                end.
                                IF  AVAIL ITEM THEN
                                    ASSIGN tt-proc-ped-ent-filho.peso-bruto   = TRUNCATE(tt-proc-ped-ent-filho.quantidade[1] * item.peso-bruto,3)
                                           tt-proc-ped-ent-filho.peso-liquido = TRUNCATE(tt-proc-ped-ent-filho.quantidade[1] * item.peso-liquido,3).

                                FIND FIRST tt-proc-ped-ent-filho NO-ERROR.

                                RUN ValidateUpdate IN h-bocx195 (INPUT TABLE tt-proc-ped-ent-filho,
                                                                 INPUT tt-proc-ped-ent-filho.r-rowid,
                                                                 OUTPUT TABLE tt-bo-erro).
                                IF CAN-FIND(FIRST tt-bo-erro
                                            WHERE tt-bo-erro.errorsubtype <> "warning":U) THEN 
                                    RETURN "NOK":U.                                 
                            END.
                        END.
                    END.
                END.
            END.
         END.
         ELSE DO:
             IF  VALID-HANDLE(h-bocx195a) THEN DO:
                 IF l-cria-subprocesso THEN
                      run setValidaNfEmbarque IN h-bocx195a (INPUT NO).
                 RUN carregaTempTablePedEnt IN h-bocx195a (INPUT TABLE tt-proc-ped-ent-aux,
                                                           INPUT 0,
                                                           INPUT tt-proc-ped-venda.r-rowid).
                                                          
                 RUN carregattprocpedentaux IN h-bocx195a (INPUT tt-proc-ped-ent.nr-sequencia,
                                                           INPUT tt-proc-ped-ent.nr-entrega,
                                                           INPUT tt-proc-ped-ent.quantidade[1] ,
                                                           OUTPUT TABLE tt-proc-ped-ent-aux). 
               
                 RUN carregaTempTablePedEnt IN h-bocx195a (INPUT TABLE tt-proc-ped-ent-aux,
                                                           INPUT 0,
                                                           INPUT tt-proc-ped-venda.r-rowid).                                          
             END.
         END.
         FOR EACH tt-proc-ped-ent-aux: 
             DELETE tt-proc-ped-ent-aux. 
         END.
         DELETE tt-proc-ped-ent.
    END.
   
  
    FOR EACH tt-proc-nota-fiscal:
        FOR FIRST nota-fiscal FIELDS(cod-estabel serie nr-nota-fis nr-proc-exp ind-tip-nota) EXCLUSIVE-LOCK
            WHERE nota-fiscal.cod-estabel = tt-proc-nota-fiscal.cod-estab-faturam
              AND nota-fiscal.serie       = tt-proc-nota-fiscal.serie      
              AND nota-fiscal.nr-nota-fis = tt-proc-nota-fiscal.nr-nota-fis: 
        END.
        IF AVAIL nota-fiscal THEN DO:
           ASSIGN nota-fiscal.nr-proc-exp             = tt-proc-nota-fiscal.nr-proc-exp
                  nota-fiscal.cod-estab-proces-export = tt-proc-nota-fiscal.cod-estabel.

            /*Busca notas fiscais relacionadas Ö operaá∆o triangular */
            FOR FIRST natur-oper
                WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao:
            END.
            IF NOT AVAIL natur-oper THEN NEXT.
        
            IF  natur-oper.log-oper-triang
            AND natur-oper.nat-vinculada   <> "":U
            AND natur-oper.nat-vinculada   <> ?
            AND nota-fiscal.nome-abrev-tri <> "":U
            AND nota-fiscal.nome-abrev-tri <> ? THEN DO:
        
                bloco_item:
                FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                    IF  it-nota-fisc.nr-docum <> "":U
                    AND it-nota-fisc.nr-docum <> ? THEN DO:
        
                        FOR FIRST bf_nota_fiscal 
                            WHERE bf_nota_fiscal.cod-estabel = it-nota-fisc.cod-estabel
                              AND bf_nota_fiscal.serie       = it-nota-fisc.serie-docum
                              AND bf_nota_fiscal.nr-nota-fis = it-nota-fisc.nr-docum    EXCLUSIVE-LOCK:
        
                            IF NOT CAN-FIND(FIRST tt-nota
                                            WHERE tt-nota.cod-estabel = bf_nota_fiscal.cod-estabel
                                              AND tt-nota.serie       = bf_nota_fiscal.serie      
                                              AND tt-nota.nr-nota-fis = bf_nota_fiscal.nr-nota-fis) THEN DO:
                                CREATE tt-nota.
                                ASSIGN tt-nota.cod-estabel                    = bf_nota_fiscal.cod-estabel
                                       tt-nota.serie                          = bf_nota_fiscal.serie      
                                       tt-nota.nr-nota-fis                    = bf_nota_fiscal.nr-nota-fis
                                       tt-nota.r-rowid                        = ROWID(bf_nota_fiscal)
                                       bf_nota_fiscal.nr-proc-exp             = nota-fiscal.nr-proc-exp
                                       bf_nota_fiscal.cod-estab-proces-export = nota-fiscal.cod-estab-proces-export.

                                LEAVE bloco_item.
                            END.
                        END.
                    END.
                END.
            END.
                     
            FOR EACH proc-it-nota-desp FIELDS(nr-proc-exp) EXCLUSIVE-LOCK
               WHERE proc-it-nota-desp.cod-estab-faturam = nota-fiscal.cod-estabel 
                 and proc-it-nota-desp.serie             = nota-fiscal.serie       
                 and proc-it-nota-desp.nr-nota-fis       = nota-fiscal.nr-nota-fis:
               ASSIGN proc-it-nota-desp.nr-proc-exp = tt-proc-nota-fiscal.nr-proc-exp
                      proc-it-nota-desp.cod-estabel = tt-proc-nota-fiscal.cod-estabel.
            END.
    
            FOR EACH it-nota-fisc NO-LOCK
               WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel 
                 AND it-nota-fisc.serie       = nota-fiscal.serie       
                 AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis :  
               
               IF  nota-fiscal.ind-tip-nota = 3 THEN DO:
                   RUN exp/ex3105a.p(INPUT ROWID(it-nota-fisc),
                                     INPUT proc-nota-fiscal.nr-proc-exp).                       
               END.
            END.
    
            IF  nota-fiscal.ind-tip-nota <> 3 THEN DO:
               RUN criaProcNota IN h-bocx260(INPUT ROWID(nota-fiscal)).
               FOR EACH tt-nota:
                   RUN criaProcNota IN h-bocx260(INPUT tt-nota.r-rowid).
               END.
            END.
         END.
     END.
    
     IF  VALID-HANDLE(h-bocx195) THEN DO:
         DELETE PROCEDURE h-bocx195.
         ASSIGN h-bocx195 = ?.
     END.
     IF  VALID-HANDLE(h-bocx195a) THEN DO:
         DELETE PROCEDURE h-bocx195a.
         ASSIGN h-bocx195a = ?.
     END.
     IF  VALID-HANDLE(h-bocx260) THEN DO:
         DELETE PROCEDURE h-bocx260.
         ASSIGN h-bocx260 = ?.
     END.
      
     RETURN "OK":U.
END PROCEDURE.


PROCEDURE EmbarquesRelacionados:

    DEFINE INPUT  PARAMETER p-processo  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estab AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-embarque.
    
    FOR EACH tt-embarque: 
        DELETE tt-embarque. 
    END.
    
    FOR EACH proc-ped-ent FIELDS(nome-abrev nr-pedcli nr-sequencia it-codigo cod-refer nr-entrega) NO-LOCK
       WHERE proc-ped-ent.cod-estabel = p-cod-estab 
         and proc-ped-ent.nr-proc-exp = p-processo:
       
       FOR EACH it-pre-fat NO-LOCK
          WHERE it-pre-fat.nome-abrev   = proc-ped-ent.nome-abrev
            AND it-pre-fat.nr-pedcli    = proc-ped-ent.nr-pedcli
            AND it-pre-fat.nr-sequencia = proc-ped-ent.nr-sequencia
            AND it-pre-fat.it-codigo    = proc-ped-ent.it-codigo
            AND it-pre-fat.cod-refer    = proc-ped-ent.cod-refer
            AND it-pre-fat.nr-entrega   = proc-ped-ent.nr-entrega:
          
            FIND FIRST embarque NO-LOCK
                 WHERE embarque.cdd-embarq = it-pre-fat.cdd-embarq NO-ERROR.
            IF NOT AVAIL embarque THEN NEXT.
            
            &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
                IF embarque.nr-proc-exp <> p-processo THEN NEXT.
            &ELSE 
                IF trim(SUBSTRING(embarque.char-1,2,12)) <> p-processo THEN NEXT.
            &ENDIF  
      
             FIND FIRST tt-embarque NO-LOCK
                  WHERE tt-embarque.cdd-embarq = embarque.cdd-embarq NO-ERROR.
             IF NOT AVAIL tt-embarque THEN
                CREATE tt-embarque.
                
             ASSIGN tt-embarque.cdd-embarq   = embarque.cdd-embarq
                    tt-embarque.dt-embarque  = embarque.dt-embarque
                    tt-embarque.identific    = embarque.identific
                    tt-embarque.situacao     = {diinc/i01di162.i 04 embarque.situacao}
                    tt-embarque.r-rowid      = ROWID(embarque). 
                    
             &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
                 ASSIGN tt-embarque.tipo = STRING(embarque.cdn-tip-relacto). /*pendente include*/
             &ELSE
                 ASSIGN tt-embarque.tipo = STRING(embarque.int-1). /*pendente include*/
             &ENDIF
          
       END.       
    END.   

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piSetaSubprocesso:
/*--------------------------------------------------------------------------------------------------
  Purpose:     Indica se trata de uma criaá∆o de subprocesso
  Parameters:  INPUT pl-subprocesso - Est† sendo criado um subprocesso? - L¢gico
               
--------------------------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-subprocesso AS LOGICAL NO-UNDO.

    ASSIGN l-cria-subprocesso = pl-subprocesso.

END PROCEDURE.

PROCEDURE EliminaRelacionamentosNota:
/*--------------------------------------------------------------------------------------------------
  Purpose:     Elimina os relacionamentos da nota fiscal
  Parameters:  INPUT p-estabel - Estabelecimento da Nota Fiscal - Character
               INPUT p-serie   - SÇrie da Nota Fiscal   - Character
               INPUT p-nota    - N£mero da Nota Fiscal  - Character
               INPUT p-processo   - C¢digo do Processo de Exportaá∆o de Origem          - Character
               INPUT p-estab-proc - C¢digo do Estab do Processo de Exportaá∆o de Origem - Character
--------------------------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-estabel    LIKE proc-nota-fiscal.nr-nota-fis NO-UNDO.
    DEFINE INPUT PARAMETER p-serie      LIKE proc-nota-fiscal.serie       NO-UNDO.
    DEFINE INPUT PARAMETER p-nota       LIKE proc-nota-fiscal.nr-nota-fis NO-UNDO.
    DEFINE INPUT PARAMETER p-processo   AS   CHARACTER                    NO-UNDO.
    DEFINE INPUT PARAMETER p-estab-proc AS   CHARACTER                    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.
    
    DEFINE VARIABLE h-bocx195      AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-bocx265      AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-bocx260      AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-bocx185      AS HANDLE  NO-UNDO.
    DEFINE VARIABLE r-rowid        AS ROWID   NO-UNDO.
    DEFINE VARIABLE l-achou-nf-emb AS LOGICAL NO-UNDO.
    DEFINE VARIABLE de-qtd-pai     AS DECIMAL NO-UNDO.

    DEFINE BUFFER bfproc-ped-ent FOR proc-ped-ent.
    DEFINE BUFFER b-nota-fiscal  FOR nota-fiscal.
    
    
    IF NOT VALID-HANDLE(h-bocx195) THEN 
       RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.
    
    IF NOT VALID-HANDLE(h-bocx265) THEN 
       RUN cxbo/bocx265.p PERSISTENT SET h-bocx265.   
    
    IF NOT VALID-HANDLE(h-bocx260) THEN 
       RUN cxbo/bocx260.p PERSISTENT SET h-bocx260.   
    
    IF NOT VALID-HANDLE(h-bocx185) THEN 
       RUN cxbo/bocx185.p PERSISTENT SET h-bocx185.      
    
    RUN piSetaSubprocesso   IN h-bocx195 (INPUT l-cria-subprocesso).
    IF l-cria-subprocesso THEN
        RUN setValidaNfEmbarque IN h-bocx195 (INPUT NO).

    FIND FIRST proc-nota-fiscal NO-LOCK
         WHERE proc-nota-fiscal.cod-estabel       = p-estab-proc
           and proc-nota-fiscal.nr-proc-exp       = p-processo
           and proc-nota-fiscal.cod-estab-faturam = p-estabel
           and proc-nota-fiscal.serie             = p-serie
           and proc-nota-fiscal.nr-nota-fis       = p-nota NO-ERROR.
    IF AVAIL proc-nota-fiscal THEN DO:
         IF  i-pais-impto-usuario <> 1 AND
         &if '{&bf_dis_versao_ems}' >= '2.08' &then
             proc-nota-fiscal.log-gerou-provis
         &else
             proc-nota-fiscal.log-2
         &endif THEN DO:
             ASSIGN i-seq-erro = i-seq-erro + 1.
             RUN utp/ut-msgs.p (INPUT "msg":U,
                                INPUT 34464,
                                INPUT "").
             CREATE tt-bo-erro.
             ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                    tt-bo-erro.cd-erro      = 34464
                    tt-bo-erro.mensagem     = RETURN-VALUE.
             RETURN "NOK":U.
         END.
    
         FOR EACH proc-it-nota-fisc NO-LOCK
            WHERE proc-it-nota-fisc.cod-estabel       = proc-nota-fiscal.cod-estabel
              AND proc-it-nota-fisc.nr-proc-exp       = proc-nota-fiscal.nr-proc-exp
              and proc-it-nota-fisc.cod-estab-faturam = proc-nota-fiscal.cod-estab-faturam
              AND proc-it-nota-fisc.serie             = proc-nota-fiscal.serie
              AND proc-it-nota-fisc.nr-nota-fis       = proc-nota-fiscal.nr-nota-fis,
         FIRST it-nota-fisc FIELDS (cod-estabel nome-ab-cli nr-pedcli      nr-seq-ped   it-codigo 
                                    cod-refer   nr-entrega  qt-faturada[1] peso-liq-fat peso-bruto)    
            WHERE it-nota-fisc.cod-estabel   = proc-it-nota-fisc.cod-estab-faturam
              AND it-nota-fisc.serie       = proc-it-nota-fisc.serie       
              AND it-nota-fisc.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis 
              AND it-nota-fisc.nr-seq-fat  = proc-it-nota-fisc.nr-seq-fat 
              AND it-nota-fisc.it-codigo   = proc-it-nota-fisc.it-codigo NO-LOCK:
    
            FOR FIRST proc-ped-ent            
                WHERE proc-ped-ent.cod-estabel  = proc-it-nota-fisc.cod-estabel 
                  AND proc-ped-ent.nr-proc-exp  = proc-it-nota-fisc.nr-proc-exp
                  AND proc-ped-ent.nome-abrev   = it-nota-fisc.nome-ab-cli  
                  AND proc-ped-ent.nr-pedcli    = it-nota-fisc.nr-pedcli   
                  AND proc-ped-ent.nr-sequencia = it-nota-fisc.nr-seq-ped
                  AND proc-ped-ent.it-codigo    = it-nota-fisc.it-codigo   
                  AND proc-ped-ent.cod-refer    = it-nota-fisc.cod-refer   
                  AND proc-ped-ent.nr-entrega   = it-nota-fisc.nr-entrega NO-LOCK : 
            END.
            IF NOT AVAIL proc-ped-ent THEN NEXT.
            
            FOR FIRST proc-ped-venda FIELDS(cod-estabel nr-proc-exp nr-pedido) NO-LOCK
                WHERE proc-ped-venda.cod-estabel = proc-ped-ent.cod-estabel
                  AND proc-ped-venda.nr-proc-exp = proc-ped-ent.nr-proc-exp
                  AND proc-ped-venda.nr-pedcli   = proc-ped-ent.nr-pedcli
                  AND proc-ped-venda.nome-abrev  = proc-ped-ent.nome-abrev:
            END.
            IF NOT AVAIL proc-ped-venda THEN NEXT.
            
            /* Verifica se a quantidade desta nota Ç a mesma do item do pedido de 
               exportaá∆o, caso seja, ent∆o este item dever† ser eliminado do processo */ 
            IF it-nota-fisc.qt-faturada[1] >= proc-ped-ent.quantidade[1] THEN DO:
            
               FIND FIRST ped-item
                    WHERE ped-item.nome-abrev    = proc-ped-ent.nome-abrev  
                      AND ped-item.nr-pedcli     = proc-ped-ent.nr-pedcli    
                      AND ped-item.nr-sequencia  = proc-ped-ent.nr-sequencia   
                      AND ped-item.it-codigo     = proc-ped-ent.it-codigo    
                      AND ped-item.cod-refer     = proc-ped-ent.cod-refer NO-LOCK NO-ERROR.  
               IF AVAIL ped-item THEN DO:

                  IF ped-item.ind-componen = 2 THEN DO:
                       /*eliminaá∆o do itens filhos*/
                       FOR EACH bfproc-ped-ent 
                          WHERE bfproc-ped-ent.cod-estabel  = proc-ped-ent.cod-estabel 
                            AND bfproc-ped-ent.nr-proc-exp  = proc-ped-ent.nr-proc-exp 
                            AND bfproc-ped-ent.nome-abrev   = ped-item.nome-abrev      
                            AND bfproc-ped-ent.nr-pedcli    = ped-item.nr-pedcli       
                            AND bfproc-ped-ent.nr-sequencia = ped-item.nr-sequencia NO-LOCK:

                           IF  proc-ped-ent.it-codigo <> bfproc-ped-ent.it-codigo THEN DO:
                               ASSIGN r-rowid = ROWID(bfproc-ped-ent).
                               RUN validateDelete IN h-bocx195 (INPUT-OUTPUT r-rowid,
                                                                OUTPUT TABLE tt-bo-erro).
                               IF CAN-FIND(FIRST tt-bo-erro) THEN
                                  RETURN "NOK":U.
                           END.
                       END.
                  END.
               END.

               ASSIGN r-rowid = ROWID(proc-ped-ent).

               FOR EACH tt-bo-erro: 
                   DELETE tt-bo-erro. 
               END.
               RUN validateDelete IN h-bocx195 (INPUT-OUTPUT r-rowid,
                                                OUTPUT TABLE tt-bo-erro).
               IF CAN-FIND(FIRST tt-bo-erro) THEN
                  RETURN "NOK":U.  
                  
               FIND FIRST bfproc-ped-ent NO-LOCK
                    WHERE bfproc-ped-ent.cod-estabel = proc-ped-venda.cod-estabel  
                      and bfproc-ped-ent.nr-proc-exp = proc-ped-venda.nr-proc-exp  
                      and bfproc-ped-ent.nr-pedido   = proc-ped-venda.nr-pedido   NO-ERROR.
               IF NOT AVAIL bfproc-ped-ent THEN DO:

                  FOR EACH tt-bo-erro: 
                      DELETE tt-bo-erro. 
                  END.

                  ASSIGN r-rowid = ROWID(proc-ped-venda).

                  RUN validateDelete (INPUT-OUTPUT r-rowid, 
                                      OUTPUT TABLE tt-bo-erro) .
                  IF CAN-FIND(FIRST tt-bo-erro) THEN 
                     RETURN "NOK":U.    
               END.
            END.
            ELSE DO: 
               /* Caso contr†rio, significa que este item do pedido foi faturado parcial e a sua 
                  quantidade dever† ser diminuida, pois tem outras notas referente a este item */
               FOR EACH tt-proc-ped-ent: 
                   DELETE tt-proc-ped-ent. 
               END.

               CREATE tt-proc-ped-ent.
               BUFFER-COPY proc-ped-ent TO tt-proc-ped-ent NO-ERROR.
               ASSIGN tt-proc-ped-ent.quantidade[1]   = tt-proc-ped-ent.quantidade[1]   -  it-nota-fisc.qt-faturada[1]   
                      tt-proc-ped-ent.quantidade[2]   = tt-proc-ped-ent.quantidade[2]   -  it-nota-fisc.qt-faturada[2]
                      tt-proc-ped-ent.peso-liquido    = tt-proc-ped-ent.peso-liquido    -  it-nota-fisc.peso-liq-fat 
                      tt-proc-ped-ent.peso-bruto      = tt-proc-ped-ent.peso-bruto      -  it-nota-fisc.peso-bruto
                      tt-proc-ped-ent.r-rowid         = ROWID(proc-ped-ent).
               FOR EACH tt-bo-erro: 
                   DELETE tt-bo-erro. 
               END.
               
               RUN piEnviaQuantidadeTotal IN h-bocx195 (INPUT tt-proc-ped-ent.quantidade[1] + it-nota-fisc.qt-faturada[1]).
               RUN ValidateUpdate         IN h-bocx195 (INPUT TABLE tt-proc-ped-ent,
                                                        INPUT tt-proc-ped-ent.r-rowid,
                                                        OUTPUT TABLE tt-bo-erro).
                                                
               IF CAN-FIND(FIRST tt-bo-erro) THEN   
                  RETURN "NOK":U.
                  
               /* Diminuir as quantidades dos itens filhos */
               FIND FIRST ped-item
                    WHERE ped-item.nome-abrev    = proc-ped-ent.nome-abrev  
                      AND ped-item.nr-pedcli     = proc-ped-ent.nr-pedcli    
                      AND ped-item.nr-sequencia  = proc-ped-ent.nr-sequencia   
                      AND ped-item.it-codigo     = proc-ped-ent.it-codigo    
                      AND ped-item.cod-refer     = proc-ped-ent.cod-refer NO-LOCK NO-ERROR.  
               IF AVAIL ped-item THEN DO:
                    IF ped-item.ind-componen = 2 THEN DO:
                                                      
                        ASSIGN de-qtd-pai = tt-proc-ped-ent.quantidade[1].                  
                        
                        FOR EACH bfproc-ped-ent 
                           WHERE bfproc-ped-ent.cod-estabel  = proc-ped-ent.cod-estabel 
                             AND bfproc-ped-ent.nr-proc-exp  = proc-ped-ent.nr-proc-exp 
                             AND bfproc-ped-ent.nome-abrev   = ped-item.nome-abrev      
                             AND bfproc-ped-ent.nr-pedcli    = ped-item.nr-pedcli       
                             AND bfproc-ped-ent.nr-sequencia = ped-item.nr-sequencia NO-LOCK:

                            IF  proc-ped-ent.it-codigo <> bfproc-ped-ent.it-codigo THEN DO:
                                                                                        
                                FIND FIRST ped-ent NO-LOCK 
                                     WHERE ped-ent.nome-abrev   = bfproc-ped-ent.nome-abrev
                                       AND ped-ent.nr-pedcli    = bfproc-ped-ent.nr-pedcli
                                       AND ped-ent.nr-sequencia = bfproc-ped-ent.nr-sequencia
                                       AND ped-ent.it-codigo    = bfproc-ped-ent.it-codigo
                                       AND ped-ent.cod-refer    = bfproc-ped-ent.cod-refer
                                       AND ped-ent.nr-entrega   = bfproc-ped-ent.nr-entrega NO-ERROR.
                                
                                EMPTY TEMP-TABLE tt-proc-ped-ent.
        
                                CREATE tt-proc-ped-ent.
                                BUFFER-COPY bfproc-ped-ent TO tt-proc-ped-ent NO-ERROR.
                                
                                ASSIGN tt-proc-ped-ent.quantidade[1] = tt-proc-ped-ent.quantidade[1] - (de-qtd-pai / ped-item.qt-pedida * ped-ent.qt-pedida)
                                       tt-proc-ped-ent.r-rowid       = ROWID(bfproc-ped-ent).
                                 
                                IF  VALID-HANDLE (h-bocx195) THEN DO:
                                    RUN atualizaQuantidade in h-bocx195 (INPUT ROWID(ped-ent),
                                                                         INPUT-OUTPUT TABLE tt-proc-ped-ent,
                                                                         INPUT tt-proc-ped-ent.quantidade[1]).
                                                                    
                                    FIND FIRST tt-proc-ped-ent NO-LOCK NO-ERROR.
                                    
                                    FOR FIRST ITEM FIELDS(peso-liquido peso-bruto) NO-LOCK
                                        WHERE ITEM.it-codigo = tt-proc-ped-ent.it-codigo: 
                                    END.
                                    IF AVAIL ITEM THEN
                                        ASSIGN tt-proc-ped-ent.peso-bruto   = TRUNCATE(tt-proc-ped-ent.quantidade[1] * item.peso-bruto,3)
                                               tt-proc-ped-ent.peso-liquido = TRUNCATE(tt-proc-ped-ent.quantidade[1] * item.peso-liquido,3).
    
                                    RUN ValidateUpdate IN h-bocx195 (INPUT TABLE tt-proc-ped-ent,
                                                                     INPUT tt-proc-ped-ent.r-rowid,
                                                                     OUTPUT TABLE tt-bo-erro).
                                END.
                                                                
                                IF CAN-FIND(FIRST tt-bo-erro) THEN 
                                    RETURN "NOK":U.                                   
                            END.
                        END.
                    END.
               END.
            END.
            
            /* Elimina o proc-it-nota-fisc */
            ASSIGN r-rowid = ROWID(proc-it-nota-fisc).
            RUN validateDelete IN h-bocx265 (INPUT-OUTPUT r-rowid,
                                             OUTPUT TABLE tt-bo-erro).
            IF  CAN-FIND(FIRST tt-bo-erro) THEN
                RETURN "NOK":U.                                  
            
         END. /* FOR EACH proc-it-nota-fisc */
         
         /* Desvincula o processo da nota fiscal e do embarque */
         ASSIGN l-achou-nf-emb = NO.
         FOR FIRST nota-fiscal FIELDS(cdd-embarq nr-nota-fis nr-proc-exp) EXCLUSIVE-LOCK
             WHERE nota-fiscal.cod-estabel  = proc-nota-fiscal.cod-estab-faturam
               AND nota-fiscal.serie        = proc-nota-fiscal.serie         
               AND nota-fiscal.nr-nota-fis  = proc-nota-fiscal.nr-nota-fis:
         END.
         IF AVAIL nota-fiscal THEN DO:
            IF nota-fiscal.cdd-embarq <> 0 THEN DO:
                ASSIGN l-achou-nf-emb = NO.
                 FOR EACH b-nota-fiscal FIELDS(nr-nota-fis cdd-embarq nr-proc-exp) 
                    WHERE b-nota-fiscal.cdd-embarq = nota-fiscal.cdd-embarq NO-LOCK: 

                     /*Verifica se existem mais notas fiscais do Embarque vinculados a outros processos de exportaá∆o*/
                     IF  b-nota-fiscal.nr-nota-fis <> nota-fiscal.nr-nota-fis 
                     AND b-nota-fiscal.nr-proc-exp <> "":U THEN
                        ASSIGN l-achou-nf-emb = YES.
                 END.
                 IF NOT l-achou-nf-emb THEN DO:
                    FIND FIRST embarque EXCLUSIVE-LOCK 
                         WHERE embarque.cdd-embarq = nota-fiscal.cdd-embarq NO-ERROR.
                    IF AVAIL embarque THEN
                       ASSIGN embarque.nr-proc-exp     = "":U.
                    RELEASE embarque.
                 END.
            END.
            ASSIGN nota-fiscal.nr-proc-exp             = "":U 
                   nota-fiscal.cod-estab-proces-export = "":U.

            /*Busca notas fiscais relacionadas Ö operaá∆o triangular */
            FOR FIRST natur-oper
                WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao:
            END.
            IF NOT AVAIL natur-oper THEN NEXT.
        
            IF  natur-oper.log-oper-triang
            AND natur-oper.nat-vinculada   <> "":U
            AND natur-oper.nat-vinculada   <> ?
            AND nota-fiscal.nome-abrev-tri <> "":U
            AND nota-fiscal.nome-abrev-tri <> ? THEN DO:
        
                bloco_item:
                FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                    IF  it-nota-fisc.nr-docum <> "":U
                    AND it-nota-fisc.nr-docum <> ? THEN DO:
        
                        FOR FIRST bf_nota_fiscal 
                            WHERE bf_nota_fiscal.cod-estabel = it-nota-fisc.cod-estabel
                              AND bf_nota_fiscal.serie       = it-nota-fisc.serie-docum
                              AND bf_nota_fiscal.nr-nota-fis = it-nota-fisc.nr-docum    EXCLUSIVE-LOCK:
        
                            IF NOT CAN-FIND(FIRST tt-nota
                                            WHERE tt-nota.cod-estabel = bf_nota_fiscal.cod-estabel
                                              AND tt-nota.serie       = bf_nota_fiscal.serie      
                                              AND tt-nota.nr-nota-fis = bf_nota_fiscal.nr-nota-fis) THEN DO:
                                CREATE tt-nota.
                                ASSIGN tt-nota.cod-estabel = bf_nota_fiscal.cod-estabel
                                       tt-nota.serie       = bf_nota_fiscal.serie      
                                       tt-nota.nr-nota-fis = bf_nota_fiscal.nr-nota-fis
                                       tt-nota.r-rowid     = ROWID(bf_nota_fiscal).
                                LEAVE bloco_item.
                            END.
                        END.
                    END.
                END.
            END.
         END.

         /*Eliminaá∆o com o relacionamento da DU-E*/
         RUN piEliminaRelacionamentoDUE (INPUT proc-nota-fiscal.cod-estab-faturam,
                                         INPUT proc-nota-fiscal.serie,
                                         INPUT proc-nota-fiscal.nr-nota-fis).
         
         /*Busca notas fiscais filhas correspondentes Ös Operaá‰es Triangulares para tambÇm desvincular do Processo*/
         FOR EACH tt-nota:
             FOR FIRST bf_nota_fiscal
                 WHERE bf_nota_fiscal.cod-estabel = tt-nota.cod-estabel
                   AND bf_nota_fiscal.serie       = tt-nota.serie
                   AND bf_nota_fiscal.nr-nota-fis = tt-nota.nr-nota-fis EXCLUSIVE-LOCK:
    
                 ASSIGN bf_nota_fiscal.nr-proc-exp             = "":U
                        bf_nota_fiscal.cod-estab-proces-export = "":U.
             END.
             FOR FIRST bf-proc-nota-fiscal
                 WHERE bf-proc-nota-fiscal.cod-estabel = tt-nota.cod-estabel
                   AND bf-proc-nota-fiscal.serie       = tt-nota.serie
                   AND bf-proc-nota-fiscal.nr-nota-fis = tt-nota.nr-nota-fis NO-LOCK:
                 ASSIGN r-rowid = ROWID(bf-proc-nota-fiscal).

                 RUN validateDelete IN h-bocx260 (INPUT-OUTPUT r-rowid,
                                                  OUTPUT TABLE tt-bo-erro).
                 IF CAN-FIND(FIRST tt-bo-erro) THEN
                    RETURN "NOK":U.   
             END.
         END.

         /* Elimina a nota do processo - proc-nota-fiscal */
         ASSIGN r-rowid = ROWID(proc-nota-fiscal).
         RUN validateDelete IN h-bocx260 (INPUT-OUTPUT r-rowid,
                                          OUTPUT TABLE tt-bo-erro).
         IF  CAN-FIND(FIRST tt-bo-erro) THEN
             RETURN "NOK":U.   

    END. /* IF AVAIL proc-nota-fiscal */
       
    RUN atualizaSituacaoProcesso IN h-bocx185(INPUT p-estab-proc,
                                              INPUT p-processo).
                      
    FOR EACH tt-bo-erro: 
        DELETE tt-bo-erro. 
    END.
    IF  VALID-HANDLE(h-bocx195) THEN DO:
        DELETE PROCEDURE h-bocx195.
        ASSIGN h-bocx195 = ?.
    END.
    IF  VALID-HANDLE(h-bocx265) THEN DO:
        DELETE PROCEDURE h-bocx265.
        ASSIGN h-bocx265 = ?.
    END.
    IF  VALID-HANDLE(h-bocx260) THEN DO:
        DELETE PROCEDURE h-bocx260.
        ASSIGN h-bocx260 = ?.
    END.
    IF  VALID-HANDLE(h-bocx185) THEN DO:
        DELETE PROCEDURE h-bocx185.
        ASSIGN h-bocx185 = ?.
    END.              
      
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE EliminaRelacionamentosEmbarque:

  DEFINE INPUT  PARAMETER p-embarque   AS DECIMAL   NO-UNDO.
  DEFINE INPUT  PARAMETER p-processo   AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p-estab-proc AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

  DEFINE VARIABLE h-bocx195  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE h-bocx265  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE h-bocx260  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE h-bocx185  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE r-rowid    AS ROWID   NO-UNDO.
  DEFINE VARIABLE de-qtd-pai AS DECIMAL NO-UNDO.

  DEFINE BUFFER bfproc-ped-ent FOR proc-ped-ent.
  DEFINE BUFFER b-proc-ped-ent FOR proc-ped-ent.

  IF NOT VALID-HANDLE(h-bocx195) THEN 
     RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.
   
  IF NOT VALID-HANDLE(h-bocx265) THEN 
     RUN cxbo/bocx265.p PERSISTENT SET h-bocx265. 

  IF NOT VALID-HANDLE(h-bocx260) THEN 
     RUN cxbo/bocx260.p PERSISTENT SET h-bocx260.

  IF NOT VALID-HANDLE(h-bocx185) THEN 
     RUN cxbo/bocx185.p PERSISTENT SET h-bocx185.
      
  FOR FIRST embarque FIELDS(cdd-embarq) NO-LOCK
      WHERE embarque.cdd-embarq = p-embarque: 
  END.
  RUN piSetaSubprocesso IN h-bocx195 (INPUT l-cria-subprocesso).
  IF l-cria-subprocesso THEN
        RUN setValidaNfEmbarque IN h-bocx195 (INPUT NO).

  IF AVAIL embarque THEN DO:
     
     IF  i-pais-impto-usuario <> 1 THEN DO:
         FOR EACH nota-fiscal
             FIELDS(cod-estabel nr-nota-fis serie) NO-LOCK
             WHERE nota-fiscal.cdd-embarq = p-embarque:
             
             FIND FIRST proc-nota-fiscal NO-LOCK
                  WHERE proc-nota-fiscal.cod-estabel       = p-estab-proc
                    AND proc-nota-fiscal.nr-proc-exp       = p-processo
                    AND proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel
                    AND proc-nota-fiscal.serie             = nota-fiscal.serie
                    AND proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis NO-ERROR.
             IF  AVAIL proc-nota-fiscal AND
                &if '{&bf_dis_versao_ems}' >= '2.08' &then
                 proc-nota-fiscal.log-gerou-provis
                &else
                 proc-nota-fiscal.log-2
                &endif THEN DO:
                 ASSIGN i-seq-erro = i-seq-erro + 1.
                 RUN utp/ut-msgs.p (INPUT "msg":U,
                                    INPUT 34464,
                                    INPUT "").
                 CREATE tt-bo-erro.
                 ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                        tt-bo-erro.cd-erro      = 34464
                        tt-bo-erro.mensagem     = RETURN-VALUE.
                 RETURN "NOK":U.
             END.
         END.
     END.
     
     FOR EACH it-pre-fat NO-LOCK
        WHERE it-pre-fat.cdd-embarq = embarque.cdd-embarq:
      
        FOR FIRST proc-ped-ent NO-LOCK
            WHERE proc-ped-ent.cod-estabel  = p-estab-proc
              AND proc-ped-ent.nr-proc-exp  = p-processo
              AND proc-ped-ent.nome-abrev   = it-pre-fat.nome-abrev
              AND proc-ped-ent.nr-pedcli    = it-pre-fat.nr-pedcli
              AND proc-ped-ent.nr-sequencia = it-pre-fat.nr-sequencia
              AND proc-ped-ent.it-codigo    = it-pre-fat.it-codigo
              AND proc-ped-ent.cod-refer    = it-pre-fat.cod-refer
              AND proc-ped-ent.nr-entrega   = it-pre-fat.nr-entrega:
        END.
        IF NOT AVAIL proc-ped-ent THEN NEXT.
      
        FOR FIRST ITEM FIELDS (desc-item peso-liquido peso-bruto) NO-LOCK
            WHERE ITEM.it-codigo = it-pre-fat.it-codigo : 
        END.

        FOR FIRST proc-ped-venda FIELDS(cod-estabel nr-proc-exp nr-proc-exp nr-pedido) NO-LOCK
            WHERE proc-ped-venda.cod-estabel = proc-ped-ent.cod-estabel
              AND proc-ped-venda.nr-proc-exp = proc-ped-ent.nr-proc-exp
              AND proc-ped-venda.nr-pedido   = proc-ped-ent.nr-pedido:
        END.
        IF NOT AVAIL proc-ped-venda THEN NEXT.
      
        IF it-pre-fat.qt-alocada >= proc-ped-ent.quantidade[1] THEN DO:
           FIND FIRST ped-item
                WHERE ped-item.nome-abrev    = proc-ped-ent.nome-abrev  
                  AND ped-item.nr-pedcli     = proc-ped-ent.nr-pedcli    
                  AND ped-item.nr-sequencia  = proc-ped-ent.nr-sequencia   
                  AND ped-item.it-codigo     = proc-ped-ent.it-codigo    
                  AND ped-item.cod-refer     = proc-ped-ent.cod-refer NO-LOCK NO-ERROR.  
           IF AVAIL ped-item THEN DO:
              IF ped-item.ind-componen = 2 THEN DO:
                   /*eliminaá∆o do itens filhos*/
                   FOR EACH b-proc-ped-ent 
                      WHERE b-proc-ped-ent.cod-estabel  = proc-ped-ent.cod-estabel 
                        AND b-proc-ped-ent.nr-proc-exp  = proc-ped-ent.nr-proc-exp 
                        AND b-proc-ped-ent.nome-abrev   = ped-item.nome-abrev      
                        AND b-proc-ped-ent.nr-pedcli    = ped-item.nr-pedcli       
                        AND b-proc-ped-ent.nr-sequencia = ped-item.nr-sequencia NO-LOCK:

                       IF  proc-ped-ent.it-codigo <> b-proc-ped-ent.it-codigo THEN DO:
                           ASSIGN r-rowid = ROWID(b-proc-ped-ent).
                           RUN validateDelete IN h-bocx195 (INPUT-OUTPUT r-rowid,
                                                            OUTPUT TABLE tt-bo-erro).
                           IF CAN-FIND(FIRST tt-bo-erro) THEN RETURN "NOK":U.
                        END.
                   END.
              END.
           END.
           
           ASSIGN r-rowid = ROWID(proc-ped-ent).
           RUN validateDelete IN h-bocx195 (INPUT-OUTPUT r-rowid,
                                            OUTPUT TABLE tt-bo-erro).
           IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
              RETURN "NOK":U.                    
           END.
        END.
        ELSE DO:
           FOR EACH tt-proc-ped-ent:
               delete tt-proc-ped-ent.
           END.
           CREATE tt-proc-ped-ent.
           BUFFER-COPY proc-ped-ent TO tt-proc-ped-ent NO-ERROR.

           ASSIGN tt-proc-ped-ent.quantidade[1] = tt-proc-ped-ent.quantidade[1] - it-pre-fat.qt-alocada
                  tt-proc-ped-ent.quantidade[2] = tt-proc-ped-ent.quantidade[2] - it-pre-fat.qt-faturada
                  tt-proc-ped-ent.r-rowid       = ROWID(proc-ped-ent).
           
           IF AVAIL ITEM THEN
              ASSIGN tt-proc-ped-ent.peso-liquido = tt-proc-ped-ent.peso-liquido -  TRUNCATE(it-pre-fat.qt-alocada * item.peso-liquido,3) 
                     tt-proc-ped-ent.peso-bruto   = tt-proc-ped-ent.peso-bruto   -  TRUNCATE(it-pre-fat.qt-alocada * item.peso-bruto,3).  
                  
           RUN ValidateUpdate IN h-bocx195 (INPUT TABLE tt-proc-ped-ent,
                                            INPUT tt-proc-ped-ent.r-rowid,
                                            OUTPUT TABLE tt-bo-erro).

           IF CAN-FIND(FIRST tt-bo-erro) THEN RETURN "NOK":U.                                   

           /* Diminuir as quantidades dos itens filhos */
           FIND FIRST ped-item
                WHERE ped-item.nome-abrev    = proc-ped-ent.nome-abrev  
                  AND ped-item.nr-pedcli     = proc-ped-ent.nr-pedcli    
                  AND ped-item.nr-sequencia  = proc-ped-ent.nr-sequencia   
                  AND ped-item.it-codigo     = proc-ped-ent.it-codigo    
                  AND ped-item.cod-refer     = proc-ped-ent.cod-refer NO-LOCK NO-ERROR.  
           IF AVAIL ped-item THEN DO:
              IF ped-item.ind-componen = 2 THEN DO:
                                                
                  ASSIGN de-qtd-pai = tt-proc-ped-ent.quantidade[1].                  
                  
                  FOR EACH b-proc-ped-ent 
                     WHERE b-proc-ped-ent.cod-estabel  = proc-ped-ent.cod-estabel 
                       AND b-proc-ped-ent.nr-proc-exp  = proc-ped-ent.nr-proc-exp 
                       AND b-proc-ped-ent.nome-abrev   = ped-item.nome-abrev      
                       AND b-proc-ped-ent.nr-pedcli    = ped-item.nr-pedcli       
                       AND b-proc-ped-ent.nr-sequencia = ped-item.nr-sequencia NO-LOCK:

                      IF proc-ped-ent.it-codigo <> b-proc-ped-ent.it-codigo THEN DO:
                                                                                  
                          FIND FIRST ped-ent NO-LOCK 
                               WHERE ped-ent.nome-abrev   = b-proc-ped-ent.nome-abrev
                                 AND ped-ent.nr-pedcli    = b-proc-ped-ent.nr-pedcli
                                 AND ped-ent.nr-sequencia = b-proc-ped-ent.nr-sequencia
                                 AND ped-ent.it-codigo    = b-proc-ped-ent.it-codigo
                                 AND ped-ent.cod-refer    = b-proc-ped-ent.cod-refer
                                 AND ped-ent.nr-entrega   = b-proc-ped-ent.nr-entrega NO-ERROR.
                          
                          EMPTY TEMP-TABLE tt-proc-ped-ent.
    
                          CREATE tt-proc-ped-ent.
                          BUFFER-COPY b-proc-ped-ent TO tt-proc-ped-ent NO-ERROR.
                          
                          ASSIGN tt-proc-ped-ent.quantidade[1] = tt-proc-ped-ent.quantidade[1] - (de-qtd-pai / ped-item.qt-pedida * ped-ent.qt-pedida)
                                 tt-proc-ped-ent.r-rowid       = ROWID(b-proc-ped-ent).
                           
                          IF  VALID-HANDLE (h-bocx195) THEN DO:
                              RUN atualizaQuantidade IN h-bocx195 (INPUT ROWID(ped-ent),
                                                                   INPUT-OUTPUT TABLE tt-proc-ped-ent,
                                                                   INPUT tt-proc-ped-ent.quantidade[1]).
                                                              
                              FIND FIRST tt-proc-ped-ent NO-LOCK NO-ERROR.
                              
                              FOR FIRST ITEM FIELDS(peso-liquido peso-bruto) NO-LOCK
                                  WHERE item.it-codigo = tt-proc-ped-ent.it-codigo: 
                              END.
                              IF AVAIL ITEM THEN
                                  ASSIGN tt-proc-ped-ent.peso-bruto   = TRUNCATE(tt-proc-ped-ent.quantidade[1] * item.peso-bruto,3)
                                         tt-proc-ped-ent.peso-liquido = TRUNCATE(tt-proc-ped-ent.quantidade[1] * item.peso-liquido,3).
                              
                              RUN ValidateUpdate IN h-bocx195 (INPUT TABLE tt-proc-ped-ent,
                                                               INPUT tt-proc-ped-ent.r-rowid,
                                                               OUTPUT TABLE tt-bo-erro).
                          END.
                                                          
                          IF CAN-FIND(FIRST tt-bo-erro) THEN RETURN "NOK":U.                                   
                      END.
                  END.     
              END.                    
           END.
        END.
      
        FIND FIRST bfproc-ped-ent NO-LOCK
             WHERE bfproc-ped-ent.cod-estabel = proc-ped-venda.cod-estabel  
               AND bfproc-ped-ent.nr-proc-exp = proc-ped-venda.nr-proc-exp  
               AND bfproc-ped-ent.nr-pedido   = proc-ped-venda.nr-pedido NO-ERROR.
        IF NOT AVAIL bfproc-ped-ent THEN DO:
           ASSIGN r-rowid = ROWID(proc-ped-venda).
           RUN validateDelete (INPUT-OUTPUT r-rowid, OUTPUT TABLE tt-bo-erro) .
           IF CAN-FIND(FIRST tt-bo-erro) THEN RETURN "NOK":U.                      
        END.
     END.
   
     FOR EACH nota-fiscal FIELDS(cod-estabel serie nr-nota-fis) NO-LOCK 
         WHERE nota-fiscal.cdd-embarq = p-embarque:

         FOR EACH it-nota-fisc FIELDS(cod-estabel serie nr-nota-fis nr-seq-fat it-codigo) NO-LOCK
            WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
              AND it-nota-fisc.serie       = nota-fiscal.serie
              AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis: 
        
            FOR FIRST proc-it-nota-fisc FIELDS(cod-estabel nr-proc-exp serie nr-nota-fis) NO-LOCK 
                WHERE proc-it-nota-fisc.cod-estabel       = p-estab-proc
                  AND proc-it-nota-fisc.nr-proc-exp       = p-processo
                  AND proc-it-nota-fisc.cod-estab-faturam = it-nota-fisc.cod-estabel
                  AND proc-it-nota-fisc.serie             = it-nota-fisc.serie
                  AND proc-it-nota-fisc.nr-nota-fis       = it-nota-fisc.nr-nota-fis
                  AND proc-it-nota-fisc.nr-seq-fat        = it-nota-fisc.nr-seq-fat
                  AND proc-it-nota-fisc.it-codigo         = it-nota-fisc.it-codigo : 
            END.
            IF AVAIL proc-it-nota-fisc THEN DO:
               ASSIGN r-rowid = ROWID(proc-it-nota-fisc).
               RUN validateDelete IN h-bocx265 (INPUT-OUTPUT r-rowid, OUTPUT TABLE tt-bo-erro).
               IF CAN-FIND(FIRST tt-bo-erro) THEN RETURN "NOK":U.                               
            END.                                                                
         END.
       
         FIND FIRST proc-nota-fiscal NO-LOCK
              WHERE proc-nota-fiscal.cod-estabel       = p-estab-proc
                AND proc-nota-fiscal.nr-proc-exp       = p-processo   
                AND proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel   
                AND proc-nota-fiscal.serie             = nota-fiscal.serie         
                AND proc-nota-fiscal.nr-nota-fis       = nota-fiscal.nr-nota-fis NO-ERROR.
         IF AVAIL proc-nota-fiscal THEN DO:   
            /*Eliminaá∆o com o relacionamento da DU-E*/
            RUN piEliminaRelacionamentoDUE (INPUT proc-nota-fiscal.cod-estab-faturam,
                                            INPUT proc-nota-fiscal.serie,
                                            INPUT proc-nota-fiscal.nr-nota-fis).

            ASSIGN r-rowid = ROWID(proc-nota-fiscal).
            RUN validateDelete IN h-bocx260 (INPUT-OUTPUT r-rowid,
                                             OUTPUT TABLE tt-bo-erro).
            IF CAN-FIND(FIRST tt-bo-erro) THEN 
               RETURN "NOK":U.   

         END.

         FIND FIRST bf_nota_fiscal EXCLUSIVE-LOCK
              WHERE ROWID(bf_nota_fiscal) = ROWID(nota-fiscal) NO-ERROR.
         IF AVAIL bf_nota_fiscal THEN
            ASSIGN bf_nota_fiscal.nr-proc-exp             = "":U
                   bf_nota_fiscal.cod-estab-proces-export = "":U.
     END.
     FOR FIRST embarque FIELDS(cdd-embarq) EXCLUSIVE-LOCK
         WHERE embarque.cdd-embarq = p-embarque: 
     END.
     IF AVAIL embarque THEN DO:

        &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
             ASSIGN embarque.nr-proc-exp     = "".
        &ELSE 
             ASSIGN OVERLAY(embarque.char-1,2,12) = "".
        &ENDIF  
     END.
     RUN atualizaSituacaoProcesso IN h-bocx185(INPUT p-estab-proc, INPUT p-processo).
  END.

  IF  VALID-HANDLE(h-bocx195) THEN DO:
      DELETE PROCEDURE h-bocx195.
      ASSIGN h-bocx195 = ?.
  END.
  IF  VALID-HANDLE(h-bocx265) THEN DO:
      DELETE PROCEDURE h-bocx265.
      ASSIGN h-bocx265 = ?.
  END.
  IF  VALID-HANDLE(h-bocx260) THEN DO:
      DELETE PROCEDURE h-bocx260.
      ASSIGN h-bocx260 = ?.
  END.
  IF  VALID-HANDLE(h-bocx185) THEN DO:
      DELETE PROCEDURE h-bocx185.
      ASSIGN h-bocx185 = ?.
  END.  
   
   RETURN "OK":U.
END PROCEDURE.


PROCEDURE PiAtualizaValoresProcesso:

  DEFINE INPUT  PARAMETER p-processo   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER p-estab-proc AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.  
  
  DEFINE VARIABLE h-bocx185  AS HANDLE NO-UNDO.
  DEFINE VARIABLE h-bocx195  AS HANDLE NO-UNDO.
  DEFINE VARIABLE h-bocx195a AS HANDLE NO-UNDO.
        
  DEFINE BUFFER bfproc-ped-ent FOR proc-ped-ent.

  IF NOT VALID-HANDLE(h-bocx185) THEN 
     RUN cxbo/bocx185.p PERSISTENT SET h-bocx185.
   
  IF NOT VALID-HANDLE(h-bocx195) THEN 
     RUN cxbo/bocx195.p PERSISTENT SET h-bocx195.
   
  IF NOT VALID-HANDLE(h-bocx195a) THEN 
     RUN cxbo/bocx195a.p PERSISTENT SET h-bocx195a.
      
  &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
       IF  AVAIL param-exp 
       AND param-exp.log-atualiza-val-proces-export = YES THEN DO:
  &ELSE     
       IF  AVAIL param-exp 
       AND SUBSTRING(param-exp.char-1,23,1) = "1" THEN DO:
  &ENDIF
            FOR EACH tt-proc-ped-ent: 
                DELETE tt-proc-ped-ent. 
            END.
           
            FOR FIRST processo-exp FIELDS(cod-sit-proc) NO-LOCK 
                WHERE processo-exp.cod-estabel = p-estab-proc 
                  AND processo-exp.nr-proc-exp = p-processo:
            END.

            IF  AVAIL processo-exp 
            AND CAN-FIND(FIRST proc-nota-fiscal NO-LOCK 
                         WHERE proc-nota-fiscal.cod-estabel = p-estab-proc 
                           AND proc-nota-fiscal.nr-proc-exp = p-processo) THEN DO:                                           
                 RUN AtualizaProcPedEnt IN h-bocx185 (INPUT p-estab-proc,
                                                      INPUT p-processo,
                                                      OUTPUT TABLE tt-bo-erro).
                 IF CAN-FIND(FIRST tt-bo-erro
                             WHERE tt-bo-erro.errorsubtype <> "warning":U) THEN 
                     RETURN "NOK":U.    
            END.   
                                               
            FOR EACH  proc-ped-ent FIELDS(nome-abrev nr-pedcli  nr-sequencia it-codigo 
                                          cod-refer  nr-entrega nr-proc-exp  quantidade[1]) NO-LOCK
                WHERE proc-ped-ent.cod-estabel = p-estab-proc
                  AND proc-ped-ent.nr-proc-exp = p-processo:
                
                FOR EACH it-pre-fat NO-LOCK
                     WHERE it-pre-fat.nome-abrev   = proc-ped-ent.nome-abrev
                       AND it-pre-fat.nr-pedcli    = proc-ped-ent.nr-pedcli
                       AND it-pre-fat.nr-sequencia = proc-ped-ent.nr-sequencia
                       AND it-pre-fat.it-codigo    = proc-ped-ent.it-codigo
                       AND it-pre-fat.cod-refer    = proc-ped-ent.cod-refer
                       AND it-pre-fat.nr-entrega   = proc-ped-ent.nr-entrega:

                   FOR FIRST embarque FIELDS(cdd-embarq char-1 &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN nr-proc-exp &ENDIF ) NO-LOCK 
                        WHERE embarque.cdd-embarq = it-pre-fat.cdd-embarq:
                   END.
                   IF AVAIL embarque THEN DO:

                      &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
                          IF embarque.nr-proc-exp <> proc-ped-ent.nr-proc-exp THEN NEXT.
                      &ELSE
                          IF trim(SUBSTRING(embarque.char-1,2,12)) <> proc-ped-ent.nr-proc-exp THEN NEXT.
                      &ENDIF
                      
                      FOR EACH res-cli FIELDS(cdd-embarq nr-resumo nome-abrev) NO-LOCK
                         WHERE res-cli.cdd-embarq = embarque.cdd-embarq
                           AND res-cli.nr-resumo    = it-pre-fat.nr-resumo
                     &IF '{&bf_dis_versao_ems}' >= '2.07' &THEN
                           and res-cli.situacao   <> 4:
                     &ELSE
                           and res-cli.situacao   <> 2:
                     &ENDIF

                          FOR FIRST ped-venda FIELDS (nr-pedido) NO-LOCK
                              WHERE ped-venda.nr-pedcli  = it-pre-fat.nr-pedcli
                                AND ped-venda.nome-abrev = it-pre-fat.nome-abrev:
                          END.
                          IF NOT AVAIL ped-venda THEN NEXT.
            
                          FOR FIRST ITEM FIELDS(desc-item peso-liquido peso-bruto) NO-LOCK
                              WHERE item.it-codigo = it-pre-fat.it-codigo:
                          END.
                                   
                          FIND FIRST tt-proc-ped-ent EXCLUSIVE-LOCK
                               WHERE tt-proc-ped-ent.cod-estabel    = p-estab-proc              
                                 AND tt-proc-ped-ent.nr-proc-exp    = p-processo                 
                                 AND tt-proc-ped-ent.nome-abrev     = it-pre-fat.nome-abrev      
                                 AND tt-proc-ped-ent.nr-pedcli      = it-pre-fat.nr-pedcli       
                                 AND tt-proc-ped-ent.nr-sequencia   = it-pre-fat.nr-sequencia    
                                 AND tt-proc-ped-ent.it-codigo      = it-pre-fat.it-codigo       
                                 AND tt-proc-ped-ent.cod-refer      = it-pre-fat.cod-refer       
                                 AND tt-proc-ped-ent.nr-entrega     = it-pre-fat.nr-entrega  NO-ERROR.
                          IF NOT AVAIL tt-proc-ped-ent THEN DO:           
                             CREATE tt-proc-ped-ent.       
                             ASSIGN tt-proc-ped-ent.cod-estabel        = p-estab-proc
                                    tt-proc-ped-ent.nr-proc-exp        = p-processo
                                    tt-proc-ped-ent.nome-abrev         = it-pre-fat.nome-abrev 
                                    tt-proc-ped-ent.nr-pedcli          = it-pre-fat.nr-pedcli 
                                    tt-proc-ped-ent.nr-sequencia       = it-pre-fat.nr-sequencia
                                    tt-proc-ped-ent.it-codigo          = it-pre-fat.it-codigo 
                                    tt-proc-ped-ent.cod-refer          = it-pre-fat.cod-refer 
                                    tt-proc-ped-ent.nr-entrega         = it-pre-fat.nr-entrega 
                                    tt-proc-ped-ent.check-sum          = it-pre-fat.check-sum
                                    tt-proc-ped-ent.des-discrep-item   = IF AVAIL ITEM THEN ITEM.desc-item ELSE ""
                                    tt-proc-ped-ent.quantidade[1]      = it-pre-fat.qt-alocada
                                    tt-proc-ped-ent.nr-pedido          = IF AVAIL ped-venda THEN ped-venda.nr-pedido ELSE 0 
                                    tt-proc-ped-ent.r-rowid            = ROWID(proc-ped-ent).
                                      
                             FOR FIRST ped-item NO-LOCK
                                 WHERE ped-item.nome-abrev    = it-pre-fat.nome-abrev    
                                   AND ped-item.nr-pedcli     = it-pre-fat.nr-pedcli     
                                   AND ped-item.nr-sequencia  = it-pre-fat.nr-sequencia  
                                   AND ped-item.it-codigo     = it-pre-fat.it-codigo     
                                   AND ped-item.cod-refer     = it-pre-fat.cod-refer:
                              END.  
                              IF AVAIL ped-item THEN DO:
                                 IF  ped-item.ind-fat-qtfam THEN
                                     ASSIGN tt-proc-ped-ent.idi-unid-fatur = 2.
                                 ELSE
                                     IF  NOT ped-item.ind-fat-qtfam THEN
                                         ASSIGN tt-proc-ped-ent.idi-unid-fatur = 1.
                                     ELSE
                                         ASSIGN tt-proc-ped-ent.idi-unid-fatur = 3.
                                     
                                 ASSIGN tt-proc-ped-ent.ind-componen       = ped-item.ind-componen
                                        tt-proc-ped-ent.vl-preori          = ped-item.vl-preori
                                        tt-proc-ped-ent.vl-preuni          = ped-item.vl-preuni.  
                                   
                                 assign c-un-medida = ped-item.des-un-medida.
                              END.
                              
                              IF AVAIL ITEM THEN
                                 ASSIGN tt-proc-ped-ent.peso-liquido   = TRUNCATE(it-pre-fat.qt-alocada * item.peso-liquido,3) 
                                        tt-proc-ped-ent.peso-bruto     = TRUNCATE(it-pre-fat.qt-alocada * item.peso-bruto,3).
                                               
                               IF  VALID-HANDLE(h-bocx195) THEN
                                   RUN converteQtdUnMedidaClienteFamilia in h-bocx195 (INPUT  tt-proc-ped-ent.it-codigo,                                                     
                                                                                       INPUT  tt-proc-ped-ent.nome-abrev,
                                                                                       INPUT  tt-proc-ped-ent.idi-unid-fatur,
                                                                                       INPUT  tt-proc-ped-ent.quantidade[1],
                                                                                       INPUT  c-un-medida,
                                                                                       OUTPUT de-qtd-conver,
                                                                                       OUTPUT c-unid-conver).
                               ASSIGN tt-proc-ped-ent.quantidade[2] = de-qtd-conver
                                      tt-proc-ped-ent.un-fatur      = c-unid-conver.
                          END.
                          ELSE DO:
                               IF AVAIL ITEM THEN
                                  ASSIGN  tt-proc-ped-ent.peso-bruto     =  tt-proc-ped-ent.peso-bruto    
                                                                         + TRUNCATE(it-pre-fat.qt-alocada * item.peso-bruto,3)      
                                          tt-proc-ped-ent.peso-liquido   =  tt-proc-ped-ent.peso-liquido  
                                                                         + TRUNCATE(it-pre-fat.qt-alocada * item.peso-liquido,3).
                                          
                               ASSIGN  tt-proc-ped-ent.quantidade[1]  =  tt-proc-ped-ent.quantidade[1] + it-pre-fat.qt-alocada
                                       tt-proc-ped-ent.quantidade[2]  =  tt-proc-ped-ent.quantidade[2] + it-pre-fat.qt-faturada. 
                          END.            
                      END. /* FOR EACH res-cli */
                   END. /*FIND FIRST embarque*/
                END. /*FIND FIRST it-pre-fat*/
            END. /* proc-ped-ent */
         
            FOR EACH tt-proc-ped-ent EXCLUSIVE-LOCK:
                CREATE tt-proc-ped-ent-aux.
                BUFFER-COPY tt-proc-ped-ent TO tt-proc-ped-ent-aux.
                        
                FIND FIRST tt-proc-ped-venda NO-LOCK
                     WHERE tt-proc-ped-venda.cod-estabel = tt-proc-ped-ent.cod-estabel
                       AND tt-proc-ped-venda.nr-proc-exp = tt-proc-ped-ent.nr-proc-exp
                       AND tt-proc-ped-venda.nr-pedido   = tt-proc-ped-ent.nr-pedido NO-ERROR.
                       
                FOR FIRST proc-ped-ent FIELDS(quantidade[1] quantidade[2] peso-bruto peso-liquido nr-proc-exp) NO-LOCK
                     WHERE proc-ped-ent.cod-estabel  = tt-proc-ped-ent.cod-estabel 
                       AND proc-ped-ent.nr-proc-exp  = tt-proc-ped-ent.nr-proc-exp 
                       AND proc-ped-ent.nome-abrev   = tt-proc-ped-ent.nome-abrev  
                       AND proc-ped-ent.nr-pedcli    = tt-proc-ped-ent.nr-pedcli   
                       AND proc-ped-ent.nr-sequencia = tt-proc-ped-ent.nr-sequencia
                       AND proc-ped-ent.it-codigo    = tt-proc-ped-ent.it-codigo   
                       AND proc-ped-ent.cod-refer    = tt-proc-ped-ent.cod-refer   
                       AND proc-ped-ent.nr-entrega   = tt-proc-ped-ent.nr-entrega:
                END.
                IF AVAIL proc-ped-ent THEN DO:
                   IF  VALID-HANDLE(h-bocx195) THEN DO:
                       RUN ValidateUpdate IN h-bocx195 (INPUT TABLE tt-proc-ped-ent,
                                                        INPUT tt-proc-ped-ent.r-rowid,
                                                        OUTPUT TABLE tt-bo-erro).
                      IF CAN-FIND(FIRST tt-bo-erro
                                  WHERE tt-bo-erro.errorsubtype <> "warning":U) THEN 
                         RETURN "NOK":U.                                   
                   END.
                   FIND FIRST ped-item
                        WHERE ped-item.nome-abrev    = proc-ped-ent.nome-abrev  
                          AND ped-item.nr-pedcli     = proc-ped-ent.nr-pedcli    
                          AND ped-item.nr-sequencia  = proc-ped-ent.nr-sequencia   
                          AND ped-item.it-codigo     = proc-ped-ent.it-codigo    
                          AND ped-item.cod-refer     = proc-ped-ent.cod-refer NO-LOCK NO-ERROR.  
                   IF AVAIL ped-item THEN DO:
                       IF  ped-item.ind-componen = 2 THEN DO:
                           FOR EACH bfproc-ped-ent 
                              WHERE bfproc-ped-ent.cod-estabel  = proc-ped-ent.cod-estabel 
                                AND bfproc-ped-ent.nr-proc-exp  = proc-ped-ent.nr-proc-exp 
                                AND bfproc-ped-ent.nome-abrev   = ped-item.nome-abrev      
                                AND bfproc-ped-ent.nr-pedcli    = ped-item.nr-pedcli       
                                AND bfproc-ped-ent.nr-sequencia = ped-item.nr-sequencia NO-LOCK:

                               IF  proc-ped-ent.it-codigo <> bfproc-ped-ent.it-codigo THEN DO:
                              
                                   FIND FIRST ped-ent NO-LOCK 
                                        WHERE ped-ent.nome-abrev   = bfproc-ped-ent.nome-abrev
                                          AND ped-ent.nr-pedcli    = bfproc-ped-ent.nr-pedcli
                                          AND ped-ent.nr-sequencia = bfproc-ped-ent.nr-sequencia
                                          AND ped-ent.it-codigo    = bfproc-ped-ent.it-codigo
                                          AND ped-ent.cod-refer    = bfproc-ped-ent.cod-refer
                                          AND ped-ent.nr-entrega   = bfproc-ped-ent.nr-entrega NO-ERROR.
           
                                   EMPTY TEMP-TABLE tt-proc-ped-ent-filho.
                         
                                   CREATE tt-proc-ped-ent-filho.
                                   BUFFER-COPY bfproc-ped-ent TO tt-proc-ped-ent-filho.
                                  
                                   ASSIGN tt-proc-ped-ent-filho.quantidade[1] = tt-proc-ped-ent.quantidade[1] / ped-item.qt-pedida 
                                                                              * ped-ent.qt-pedida
                                          tt-proc-ped-ent-filho.r-rowid       = ROWID(bfproc-ped-ent).
           
                                   IF  VALID-HANDLE(h-bocx195) THEN DO:
                                       RUN atualizaQuantidade in h-bocx195 (INPUT ROWID(ped-ent),
                                                                            INPUT-OUTPUT TABLE tt-proc-ped-ent-filho,
                                                                            INPUT tt-proc-ped-ent-filho.quantidade[1]).
           
                                      FIND FIRST tt-proc-ped-ent-filho NO-LOCK NO-ERROR.
           
                                      FOR FIRST ITEM FIELDS(peso-liquido peso-bruto) NO-LOCK
                                          WHERE ITEM.it-codigo = tt-proc-ped-ent-filho.it-codigo:
                                      END.
                                      IF AVAIL ITEM THEN
                                          ASSIGN tt-proc-ped-ent-filho.peso-bruto   = TRUNCATE(tt-proc-ped-ent-filho.quantidade[1] * item.peso-bruto,3)
                                                 tt-proc-ped-ent-filho.peso-liquido = TRUNCATE(tt-proc-ped-ent-filho.quantidade[1] * item.peso-liquido,3).
                                      
                                      RUN ValidateUpdate IN h-bocx195 (INPUT TABLE tt-proc-ped-ent-filho,
                                                                       INPUT tt-proc-ped-ent-filho.r-rowid,
                                                                       OUTPUT TABLE tt-bo-erro).
                                      IF CAN-FIND(FIRST tt-bo-erro
                                                  WHERE tt-bo-erro.errorsubtype <> "warning":U) THEN 
                                         RETURN "NOK":U.                                 
                                   END.   
                               END.
                           END.
                       END.
                   END.
                END.
                ELSE DO:
                     IF  VALID-HANDLE(h-bocx195a) THEN DO:
                         RUN carregaTempTablePedEnt IN h-bocx195a (INPUT TABLE tt-proc-ped-ent-aux,
                                                                   INPUT 0,
                                                                   INPUT tt-proc-ped-venda.r-rowid).
                                                           
                         RUN carregattprocpedentaux IN h-bocx195a (INPUT tt-proc-ped-ent.nr-sequencia,
                                                                   INPUT tt-proc-ped-ent.nr-entrega,
                                                                   INPUT tt-proc-ped-ent.quantidade[1],
                                                                   OUTPUT TABLE tt-proc-ped-ent-aux).
                                                                  
                         FIND FIRST tt-proc-ped-ent-aux NO-LOCK NO-ERROR.
                         IF  AVAIL tt-proc-ped-ent-aux THEN
                             RUN carregaTempTablePedEnt IN h-bocx195a (INPUT TABLE tt-proc-ped-ent-aux,
                                                                       INPUT 0,
                                                                       INPUT tt-proc-ped-venda.r-rowid).                                          
                                                                   
                     END.
                     FOR EACH tt-proc-ped-ent-aux: 
                         DELETE tt-proc-ped-ent-aux. 
                     END.
                END. 
                DELETE tt-proc-ped-ent.
            END.    
       END.       

   RUN atualizaSituacaoProcesso IN h-bocx185(INPUT p-estab-proc, INPUT p-processo).

   IF  VALID-HANDLE(h-bocx185) THEN DO:
       DELETE PROCEDURE h-bocx185.
       ASSIGN h-bocx185 = ?.
   END.
        
   IF  VALID-HANDLE(h-bocx195) THEN DO:
       DELETE PROCEDURE h-bocx195.
       ASSIGN h-bocx195 = ?.
   END.
        
   IF  VALID-HANDLE(h-bocx195a) THEN DO:
       DELETE PROCEDURE h-bocx195a.
       ASSIGN h-bocx195a = ?.
   END.

   RETURN "OK":U.
END PROCEDURE.


PROCEDURE PiValidaCR:

   DEFINE INPUT  PARAMETER p-estab    AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER p-serie    AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER p-nota     AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER p-embarque AS DECIMAL   NO-UNDO.
   DEFINE OUTPUT PARAMETER c-notas    AS CHARACTER NO-UNDO.
  
   ASSIGN c-notas = "".

   IF p-embarque = 0 THEN DO:
      FIND FIRST nota-fiscal NO-LOCK
           WHERE nota-fiscal.cod-estabel = p-estab
             AND nota-fiscal.serie       = p-serie
             AND nota-fiscal.nr-nota-fis = p-nota NO-ERROR.
      IF AVAIL nota-fiscal THEN DO:
         IF nota-fiscal.dt-atual-cr <> ? THEN
            ASSIGN c-notas = STRING(nota-fiscal.nr-nota-fis).
      END. 
   END. 
   ELSE DO:
        FOR EACH nota-fiscal NO-LOCK
           WHERE nota-fiscal.cdd-embarq  = p-embarque:

            IF nota-fiscal.dt-atual-cr <> ? THEN
               ASSIGN c-notas = c-notas + string(nota-fiscal.nr-nota-fis) + ";".
        END. 
   END.                      
   
   RETURN "OK":U.
END PROCEDURE.

PROCEDURE EliminaDespesas:

   DEFINE INPUT PARAMETER c-cod-estabel LIKE processo-exp.cod-estabel NO-UNDO.
   DEFINE INPUT PARAMETER c-nr-proc-exp LIKE processo-exp.nr-proc-exp NO-UNDO.

   FOR EACH proc-desp-itiner EXCLUSIVE-LOCK
      WHERE proc-desp-itiner.cod-estabel = c-cod-estabel
        AND proc-desp-itiner.nr-proc-exp = c-nr-proc-exp:
       DELETE proc-desp-itiner.
   END.
     
   RETURN "OK":U.
END PROCEDURE.


PROCEDURE piEliminaRelacionamentoDUE:
    /* Procedure respons†vel pela eliminaá∆o do relacionamento da 
    ** Nota Fiscal vinculada ao Processo de Exportaá∆o com a DU-E
    ParÉmetros: Entrada: pc-cod-estab-faturam (character): Estabelecimento da Nota Fiscal vinculada ao Processo de Exportaá∆o
                Entrada: pc-serie             (character): SÇrie da Nota Fiscal vinculada ao Processo de Exportaá∆o
                Entrada: pc-nr-nota-fis       (character): N£mero da Nota Fiscal vinculada ao Processo de Exportaá∆o
    */
    DEFINE INPUT PARAMETER pc-cod-estab-faturam LIKE proc-nota-fiscal.cod-estab-faturam NO-UNDO.
    DEFINE INPUT PARAMETER pc-serie             LIKE proc-nota-fiscal.serie             NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-nota-fis       LIKE proc-nota-fiscal.nr-nota-fis       NO-UNDO.

    FOR FIRST due-nf FIELDS(cod-estabel-nf cod-serie-nf cod-nota-fisc cod-estab-proces-export cod-proces-export)
        WHERE due-nf.cod-estabel-nf = pc-cod-estab-faturam
          AND due-nf.cod-serie-nf   = pc-serie
          AND due-nf.cod-nota-fisc  = pc-nr-nota-fis EXCLUSIVE-LOCK:

        FOR EACH due-item FIELDS(cod-estabel-nf cod-serie-nf cod-nota-fisc cod-estab-proces-export cod-proces-export)
           WHERE due-item.cod-estabel-nf = due-nf.cod-estabel-nf
             AND due-item.cod-serie-nf   = due-nf.cod-serie-nf
             AND due-item.cod-nota-fisc  = due-nf.cod-nota-fisc EXCLUSIVE-LOCK:

            FOR EACH due-item-nf-refer FIELDS(cod-estab-proces-exp-due cod-proces-exp-due)
               WHERE due-item-nf-refer.cod-estab-nf-due  = due-item.cod-estabel-nf
                 AND due-item-nf-refer.cod-serie-nf-due  = due-item.cod-serie-nf
                 AND due-item-nf-refer.cod-nota-fisc-due = due-item.cod-nota-fisc EXCLUSIVE-LOCK:
                ASSIGN due-item-nf-refer.cod-estab-proces-exp-due = "":U
                       due-item-nf-refer.cod-proces-exp-due       = "":U.

            END.
            ASSIGN due-item.cod-estab-proces-export = "":U
                   due-item.cod-proces-export       = "":U.
        END.
        ASSIGN due-nf.cod-estab-proces-export = "":U
               due-nf.cod-proces-export       = "":U.
     END.
     RELEASE due-nf.
     RELEASE due-item.
     RELEASE due-item-nf-refer.

     RETURN "OK":U.
END PROCEDURE.

