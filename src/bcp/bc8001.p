/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC8001 2.00.00.030 } /*** "010030" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bc8001 MBC}
&ENDIF

/**********************************************************************************
** Programa............: BC8001.p
**
** Objetivo............: Mudar o Código do Item
**
** Parametros Recebidos: <input> Código do Item Atual
**                       <input> Código do Item Novo
**                       <input> Tipo Movimentação do Item (Alteração/Eliminação)
**
**********************************************************************************/
/* BEG - Definição Parametros */
def input param c-it-codigo-atual as char format "x(16)".
def input param c-it-codigo-novo  as char format "x(16)".
def input param c-tipo-movto      as char format "x".
/* END - Definição Parametros */

/** Parametros Adapters REST **/
{adapters/rest/rfid/arestrfidprodutos.i}
DEFINE VARIABLE h-rfid-api AS HANDLE NO-UNDO.


DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.


{include/i_dbtype.i}
{include/i_dbvers.i}
{cdp/cdcfgmnt.i}
{bcp/bc9001.i}   /*Definição tt-Contagem-bc       */
{bcp/bc9002.i}   /*Definição tt-transfere-bc      */
{bcp/bc9003.i}   /*Definição tt-reporte-ordem-bc  */
{bcp/bc9004.i}   /*Definição tt-requis-mat-bc     */
{bcp/bc9006.i}   /*Definição tt-reporte-repet-bc  */
{bcp/bc9008.i}   /*Definição tt-embarque-bc       */
{bcp/bcapi002.i} /*Definição tt-etiqueta          */
{cdp/cd0666.i}   /* Definição tt-erros */
{bcp/bcapi001.i} /* tt-trans */
&IF DEFINED (bf_mnt_ems203) &THEN
{bcp/bc9011.i }  /*Definição tt-requis-manut-bc   */
&ENDIF

Define Variable hAcomp          As Handle       No-Undo.
Define Variable iCont           As Integer      No-Undo.
Define Variable rw-Transacao    As Raw          No-Undo.
Define Variable cTransacao      As CHARACTER    No-Undo.
Define Variable lProcessa       As Logical      No-undo.
def new global shared var v_cod_usuar_corren 
    as character 
    format "x(12)" 
    label "Usuario Corrente" 
    column-label "Usuario Corrente" 
    no-undo. 
DEFINE VARIABLE cDetalhe           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLiter_transacao   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLiter_novo        as CHARACTER   no-undo.
DEFINE VARIABLE cLiter_antigo      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLiter_nrtransacao AS CHARACTER   NO-UNDO.
Define Buffer bBc-Trans     For bc-trans.
Define Buffer b1_Bc-Trans   For bc-trans.

DEFINE TEMP-TABLE tt-trans-02 NO-UNDO LIKE tt-trans.

Assign  cTransacao = "Contagem,Rep-item,Reporte,Req-MCP,Transf,TransfMa,Embarque,Req-OM,Etiq-avu,Etiq-rec,Etiq-fat,Etq-PrdL,Etq-PrdS,Codigo2D".

run utp/ut-acomp.p persistent set hAcomp.

/* Alteração de código de itens informados, das tabelas do DC */
if c-tipo-movto = "A" then do:
    on write of bc-ext-item            override do: end.
    on write of bc-ext-saldo-estoq     override do: end.
    on write of bc-ext-item-emit       override do: end.

    EMPTY TEMP-TABLE tt-erro.

    EMPTY TEMP-TABLE tt-trans.

    {utp/ut-liter.i _Nr.Transa‡Æo:_ *}
    ASSIGN cLiter_nrtransacao = trim(RETURN-VALUE).

    {utp/ut-liter.i Alterando_Codigo_Item_M¢dulo_Coleta_de_Dados. *}
    run pi-inicializar in hAcomp (input  Return-value ).

    /*INI - Integra‡Æo RFID*/
    /*Find necess rio para posicionamento do buffer quando atualiza‡Æo ambiente SQL*/
    FIND FIRST ITEM
         WHERE ITEM.it-codigo = c-it-codigo-atual
        NO-LOCK NO-ERROR.

    for   each bc-ext-item fields(it-codigo) use-index ch-codigo
         where bc-ext-item.it-codigo = c-it-codigo-atual exclusive-lock:

        assign bc-ext-item.it-codigo = c-it-codigo-novo.
    end.

    FOR   EACH rfid-epc FIELDS(it-codigo) USE-INDEX epc_ix3
         WHERE rfid-epc.it-codigo = c-it-codigo-atual EXCLUSIVE-LOCK:

        ASSIGN rfid-epc.it-codigo = c-it-codigo-novo.
    END.

    FOR   EACH rfid-rastro FIELDS(cod-produto)
         WHERE rfid-rastro.cod-produto = c-it-codigo-atual EXCLUSIVE-LOCK:

        ASSIGN rfid-rastro.cod-produto = c-it-codigo-novo.
    END.

    FOR   EACH rfid-invent-itens FIELDS(cod-produto) USE-INDEX rfdnvntt_ix2
         WHERE rfid-invent-itens.cod-produto = c-it-codigo-atual EXCLUSIVE-LOCK:

        ASSIGN rfid-invent-itens.cod-produto = c-it-codigo-novo.
    END.

    FOR   EACH rfid-conferen-itens FIELDS(cod-produto) USE-INDEX rfdcnfra_ix2
         WHERE rfid-conferen-itens.cod-produto = c-it-codigo-atual EXCLUSIVE-LOCK:
                                                                                
        ASSIGN rfid-conferen-itens.cod-produto = c-it-codigo-novo.                
    END.    

    FOR   EACH rfid-transf-itens FIELDS(cod-produto) USE-INDEX rfdtrnsa_ix2
         WHERE rfid-transf-itens.cod-produto = c-it-codigo-atual EXCLUSIVE-LOCK:
                                                                                
        ASSIGN rfid-transf-itens.cod-produto = c-it-codigo-novo.                
    END.            

    FOR   EACH rfid-separa-itens FIELDS(cod-produto) USE-INDEX rfdsprtn_ix2
         WHERE rfid-separa-itens.cod-produto = c-it-codigo-atual EXCLUSIVE-LOCK:
                                                                                
        ASSIGN rfid-separa-itens.cod-produto = c-it-codigo-novo.                
    END.      

    for   each bc-ext-saldo-estoq fields(cod-estabel cod-depos cod-localiz lote it-codigo) use-index ch-saldo-estoq
         where bc-ext-saldo-estoq.it-codigo = c-it-codigo-atual exclusive-lock:
        assign bc-ext-saldo-estoq.it-codigo = c-it-codigo-novo.
    end.

    for   each bc-ext-item-emit fields(cod-emitente it-codigo) use-index Item-Emit
         where bc-ext-item-emit.it-codigo = c-it-codigo-atual exclusive-lock:
        assign bc-ext-item-emit.it-codigo = c-it-codigo-novo.
    end.

    &IF "{&mgcld_version}" >= "2.02" &THEN
        for   each bc-etiqueta fields(it-codigo) USE-INDEX ch-it-codigo
             where bc-etiqueta.it-codigo = c-it-codigo-atual EXCLUSIVE-LOCK:
            assign bc-etiqueta.it-codigo = c-it-codigo-novo.
        end.
    &ENDIF
    
    &IF "{&mgcld_version}" >= "2.02" &THEN
       
        FOR EACH bc-param-ext FIELDS(cod-entidade-param-ext cod-chave-param-ext cod-param-ext) WHERE
            bc-param-ext.cod-entidade-param-ext = "bc-ext-item":U AND   
            bc-param-ext.cod-chave-param-ext    = c-it-codigo-atual EXCLUSIVE-LOCK:
            ASSIGN bc-param-ext.cod-chave-param-ext = c-it-codigo-novo.
        END.

        FOR EACH bc-param-ext fields(cod-entidade-param-ext cod-chave-param-ext cod-param-ext) WHERE
            bc-param-ext.cod-entidade-param-ext = "bc-ext-item-emit" EXCLUSIVE-LOCK:
            IF entry(2,bc-param-ext.cod-chave-param-ext,'#':U)  = c-it-codigo-atual THEN DO:
                 ASSIGN entry(2,bc-param-ext.cod-chave-param-ext,'#':U) = c-it-codigo-novo.
            END.
        END.

    &ENDIF

    /*Altera Item na tabela bc-trans*/
    DO iCont = 1 TO NUM-ENTRIES(cTransacao).
        Case Entry(iCont,cTransacao):
            When "Contagem":U     THEN IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Contagem" NO-LOCK) THEN Run Pi_Acerta_Item_Contagem    (Input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
            When "Rep-item":U     Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Rep-item" NO-LOCK) THEN Run Pi_Acerta_Item_Rep_Item    (Input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
            When "Reporte":U      Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Reporte" NO-LOCK) THEN Run Pi_Acerta_Item_Reporte     (input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
            When "Req-MCP":U      Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Req-MCP" NO-LOCK) THEN Run Pi_Acerta_Item_Req-MCP     (input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
            When "Transf":U       Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Transf" NO-LOCK) THEN Run Pi_Acerta_Item_Transf      (input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
            When "TransfMa":U     Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "TransfMa" NO-LOCK) THEN Run Pi_Acerta_Item_Transf      (input Entry(iCont,cTransacao)). /*ok*/    
                                       ELSE NEXT.
            When "Embarque":U     Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Embarque" NO-LOCK) THEN Run Pi_Acerta_Item_Embarque    (input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
            When "Req-OM":U       Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Req-OM" NO-LOCK) THEN Run Pi_Acerta_Item_Req-OM      (input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
            When "Etiq-avu":U     Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Etiq-avu" NO-LOCK) THEN Run Pi_Acerta_Etiqueta         (input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
            When "Etiq-rec":U     Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Etiq-rec" NO-LOCK) THEN Run Pi_Acerta_Etiqueta         (input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
            When "Etiq-fat":U     Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Etiq-fat" NO-LOCK) THEN Run Pi_Acerta_Etiqueta         (input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
            When "Etq-PrdL":U     Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Etq-PrdL" NO-LOCK) THEN Run Pi_Acerta_Etiqueta         (input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
            When "Etq-PrdS":U     Then IF CAN-FIND (FIRST bc-trans
                                               WHERE bc-trans.cd-trans = "Etq-PrdS" NO-LOCK) THEN Run Pi_Acerta_Etiqueta         (input Entry(iCont,cTransacao)). /*ok*/
                                       ELSE NEXT.
        End.
    End.
    
   {utp/ut-liter.i Criando_Log_Transa‡Æo_M¢dulo_Coleta_de_Dados. *}
       Run pi-acompanhar In hAcomp (Input RETURN-VALUE ).
  
   {utp/ut-liter.i Transa‡Æo: *}
   ASSIGN cLiter_transacao = RETURN-VALUE.

   {utp/ut-liter.i Item_Novo: *} 
   ASSIGN cLiter_novo = RETURN-VALUE.

   {utp/ut-liter.i Item_Antigo: * }
   ASSIGN cLiter_antigo = RETURN-VALUE.

   ASSIGN cDetalhe =  trim(cLiter_transacao)  + "BCREN001":U + "  " + 
                      TRIM(cLiter_antigo)     + TRIM(c-it-codigo-atual) + "  " + 
                      TRIM(cLiter_novo)       + TRIM(c-it-codigo-novo). 

    create tt-trans.
    assign tt-trans.cod-versao-integracao = 1
           tt-trans.i-sequen              = 1
           tt-trans.cd-trans              = "BCREN001":U
           tt-trans.usuario               = v_cod_usuar_corren
           tt-trans.atualizada            = YES
           tt-trans.etiqueta              = NO
           tt-trans.detalhe               = TRIM(cdetalhe).

    BUFFER-COPY tt-trans  TO tt-trans-02 NO-ERROR. /* progress não permite raw-transfer de uma tabela para ela própria */
    raw-transfer tt-trans-02 to tt-trans.conteudo-trans.

    bcapi001: /* colocado bloc de tratamento para que não exista impacto na área de negócio decorrente de algo erro */
    do on error  undo bcapi001, leave bcapi001
       on quit   undo bcapi001, leave bcapi001
       on stop   undo bcapi001, leave bcapi001
       on endkey undo bcapi001, leave bcapi001:
       run bcp/bcapi001.p (input-output table tt-trans,
                           input-output table tt-erro).
    END.
    
    run pi-finalizar in hAcomp.

    /* Inicio -- Projeto Internacional */
       
    IF c-arquivo-log <> "" THEN DO: /* extrato de versao */
        output to value(c-arquivo-log) convert target "iso8859-1":U APPEND .
        DEF VAR c-lbl-liter-termino AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Termino" *}
        ASSIGN c-lbl-liter-termino = TRIM(RETURN-VALUE).
        put UNFORMATTED "      (BC8001)" + c-lbl-liter-termino + "BCAPI001(BCREN001). Return-value:":U RETURN-VALUE SKIP.
        FOR EACH tt-erro NO-LOCK:
             put UNFORMATTED "      (BC8001) ":U string(tt-erro.cd-erro) + " - " + tt-erro.mensagem SKIP.  
        END.
        output close.   
    end.          
        
    EMPTY TEMP-TABLE tt-erro. /* eliminar registros para que não exista impacto na área de negócio */
    
    RETURN RETURN-VALUE.
    
END.

/* Eliminação de registros das tabelas do DC dos código de itens informados */
if c-tipo-movto = "E" then do: 
    {utp/ut-liter.i Eliminando_Codigo_Item_M¢dulo_Coleta_de_Dados. *}
    run pi-inicializar in hAcomp (input  Return-value ).


    //Caso tenha algum registro na tabela rfid-rastro, retornar "NOK" para desfazer a transa‡Æo.
    IF CAN-FIND(FIRST rfid-rastro NO-LOCK
                WHERE rfid-rastro.cod-produto = c-it-codigo-atual)
    THEN DO:
        run pi-finalizar in hAcomp.
        RETURN "NOK".
    END.

    for   each bc-etiqueta fields(it-codigo) USE-INDEX ch-it-codigo
         where bc-etiqueta.it-codigo = c-it-codigo-atual EXCLUSIVE-LOCK:
        DELETE bc-etiqueta.
    end.

    for   each bc-ext-item fields(it-codigo)  use-index ch-codigo
         where bc-ext-item.it-codigo = c-it-codigo-atual exclusive-lock:
        delete bc-ext-item.
    end.

    for   each bc-ext-saldo-estoq fields(cod-estabel cod-depos cod-localiz lote it-codigo) use-index ch-saldo-estoq
         where bc-ext-saldo-estoq.it-codigo = c-it-codigo-atual exclusive-lock:
        delete bc-ext-saldo-estoq.
    end.

    for   each bc-ext-item-emit fields(cod-emitente it-codigo) use-index Item-Emit
         where bc-ext-item-emit.it-codigo = c-it-codigo-atual exclusive-lock:
        delete bc-ext-item-emit.
    end.
     
    FOR EACH bc-param-ext FIELDS(cod-entidade-param-ext cod-chave-param-ext cod-param-ext) WHERE
        bc-param-ext.cod-entidade-param-ext = "bc-ext-item":U AND   
        bc-param-ext.cod-chave-param-ext    = c-it-codigo-atual EXCLUSIVE-LOCK:
        delete bc-param-ext.
    END.

    FOR EACH bc-param-ext FIELDS(cod-entidade-param-ext cod-chave-param-ext cod-param-ext) WHERE
        bc-param-ext.cod-entidade-param-ext = "bc-ext-item-emit" EXCLUSIVE-LOCK:
        IF entry(2,bc-param-ext.cod-chave-param-ext,'#':U)  = c-it-codigo-atual THEN DO:
             delete bc-param-ext.
        END.
    END.

    run pi-finalizar in hAcomp.
end.

/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
PROCEDURE Pi_Acerta_Item_Contagem:
    DEFINE INPUT PARAM cCodTrans       AS CHARACTER   NO-UNDO.
        {utp/ut-liter.i Processando *}
        Run pi-acompanhar In hAcomp (Input cCodTrans +  " : " + RETURN-VALUE).
        FOR EACH bc-trans FIELDS(cd-trans estado-trans Nr-Trans conteudo-trans ind-tipo-trans log-1) NO-LOCK
            WHERE bc-trans.cd-trans = cCodTrans:

            IF  bc-trans.estado-trans = 2 /* atualizada */ OR 
                bc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                NEXT. /* não alterar em logs já concluídos */
            END.

            &IF "{&mgcld_version}" >= "2.04" &THEN
                If bc-trans.ind-tipo-trans = 1 Then do: 
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                END.
            &ELSE 
                If bc-trans.log-1 Then DO:
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                    END.
                &ENDIF            

            EMPTY TEMP-TABLE tt-contagem-bc.

            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                Assign rw-Transacao = bc-trans.conteudo-trans.
            &Else
                Run btb/btb928za.p ( Input bc-trans.conteudo-trans,
                                    Output rw-Transacao) No-Error.
                If Error-Status:Error Then Next.
            &EndIf

            Create  tt-contagem-bc.
            Raw-Transfer rw-Transacao To tt-contagem-bc No-Error.

            If Not Avail tt-contagem-bc Then Next.
            IF  tt-contagem-bc.cod-item = c-it-codigo-atual
            THEN DO:
                ASSIGN  tt-contagem-bc.cod-item = c-it-codigo-novo.

                Raw-Transfer tt-contagem-bc To rw-Transacao.

                Find First b1_bc-trans Of bc-trans Exclusive-lock No-error.
                &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                    Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                &Else
                    Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                &EndIf
            END.
        END.
END PROCEDURE.

/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
PROCEDURE Pi_Acerta_Item_Rep_Item.
    DEFINE INPUT PARAM cCodTrans  AS CHARACTER NO-UNDO.
        {utp/ut-liter.i Processando *}
        Run pi-acompanhar In hAcomp (Input cCodTrans +  " : " + RETURN-VALUE).
        For Each bc-trans FIELDS (cd-trans Nr-Trans estado-trans ind-tipo-trans log-1 conteudo-trans)No-lock
            WHERE bc-trans.cd-trans = cCodTrans:

            IF  bc-trans.estado-trans = 2 /* atualizada */ OR 
                bc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                NEXT. /* não alterar em logs já concluídos */
            END.

            &IF "{&mgcld_version}" >= "2.04" &THEN
                If bc-trans.ind-tipo-trans = 1 Then do:
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                END.
            &ELSE 
                If bc-trans.log-1 Then DO:
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                    END.
                &ENDIF

            EMPTY TEMP-TABLE tt-reporte-repet-bc.

            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                Assign rw-Transacao = bc-trans.conteudo-trans.
            &Else
                Run btb/btb928za.p ( Input bc-trans.conteudo-trans,
                                     Output rw-Transacao) No-Error.
                If Error-Status:Error Then Next.
            &EndIf

            Create  tt-reporte-repet-bc.
            Raw-Transfer rw-Transacao To tt-reporte-repet-bc No-Error.

            If Not Avail tt-reporte-repet-bc Then Next.
            IF  tt-reporte-repet-bc.it-codigo = c-it-codigo-atual
            THEN DO:
                ASSIGN  tt-reporte-repet-bc.it-codigo = c-it-codigo-novo.

                Raw-Transfer tt-reporte-repet-bc To rw-Transacao.

                Find First b1_bc-trans Of bc-trans Exclusive-lock No-error.
                &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                    Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                &Else
                    Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                &EndIf
            END.
        END.
END PROCEDURE.

/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
PROCEDURE Pi_Acerta_Item_Reporte.
    DEFINE INPUT PARAM cCodTrans  AS CHARACTER NO-UNDO.
        {utp/ut-liter.i Processando *}
        Run pi-acompanhar In hAcomp (Input cCodTrans +  " : " + RETURN-VALUE).
        FOR EACH bc-trans FIELDS(cd-trans Nr-Trans estado-trans ind-tipo-trans log-1 conteudo-trans) NO-LOCK
            WHERE bc-trans.cd-trans = cCodTrans:

            IF  bc-trans.estado-trans = 2 /* atualizada */ OR 
                bc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                NEXT. /* não alterar em logs já concluídos */
            END.

            &IF "{&mgcld_version}" >= "2.04" &THEN
                If bc-trans.ind-tipo-trans = 1 Then do:
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                END.
            &ELSE 
                If bc-trans.log-1 Then DO:
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* nÆo alterar em logs j  conclu¡dos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                    END.
                &ENDIF
            
            EMPTY TEMP-TABLE tt-reporte-ordem-bc.

            Assign  lProcessa = No.

            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                Assign rw-Transacao = bc-trans.conteudo-trans.
            &Else
                Run btb/btb928za.p ( Input bc-trans.conteudo-trans,
                                    Output rw-Transacao) No-Error.
                If Error-Status:Error Then Next.
            &EndIf

            Create  tt-reporte-ordem-bc.
            Raw-Transfer rw-Transacao To tt-reporte-ordem-bc No-Error.

            If Not Avail tt-reporte-ordem-bc Then Next.
            IF  tt-reporte-ordem-bc.it-codigo = c-it-codigo-atual
            Then
                ASSIGN  tt-reporte-ordem-bc.it-codigo = c-it-codigo-novo
                        lProcessa = Yes.
            IF  tt-reporte-ordem-bc.it-oper = c-it-codigo-atual
            Then
                ASSIGN  tt-reporte-ordem-bc.it-oper = c-it-codigo-novo
                        lProcessa = Yes.

            If  lProcessa
            Then Do:
                Raw-Transfer tt-reporte-ordem-bc To rw-Transacao.

                Find First b1_bc-trans Of bc-trans Exclusive-lock No-error.
                &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                    Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                &Else
                    Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                &EndIf
            End.
        END.
END PROCEDURE.

/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
PROCEDURE Pi_Acerta_Item_Req-MCP.
    DEFINE INPUT PARAM cCodTrans  AS CHARACTER NO-UNDO.
        {utp/ut-liter.i Processando *}
        Run pi-acompanhar In hAcomp (Input cCodTrans +  " : " + RETURN-VALUE).
        FOR EACH bc-trans FIELDS(cd-trans Nr-Trans estado-trans ind-tipo-trans conteudo-trans ind-tipo-trans log-1)  NO-LOCK
            WHERE bc-trans.cd-trans = cCodTrans:

            IF  bc-trans.estado-trans = 2 /* atualizada */ OR
                bc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                NEXT. /* não alterar em logs já concluídos */
            END.

            &IF "{&mgcld_version}" >= "2.04" &THEN
                If bc-trans.ind-tipo-trans = 1 Then do: 
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                END.
            &ELSE 
                If bc-trans.log-1 Then DO:
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                    END.
                &ENDIF

            EMPTY TEMP-TABLE tt-requis-mat-bc.

            Assign  lProcessa = No.

            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                Assign rw-Transacao = bc-trans.conteudo-trans.
            &Else
                Run btb/btb928za.p ( Input bc-trans.conteudo-trans,
                                    Output rw-Transacao) No-Error.
                If Error-Status:Error Then Next.
            &EndIf

            Create  tt-requis-mat-bc.
            Raw-Transfer rw-Transacao To tt-requis-mat-bc No-Error.

            If Not Avail tt-requis-mat-bc Then Next.
            IF  tt-requis-mat-bc.it-codigo = c-it-codigo-atual
            Then
                ASSIGN  tt-requis-mat-bc.it-codigo = c-it-codigo-novo
                        lProcessa = Yes.
            IF  tt-requis-mat-bc.item-pai = c-it-codigo-atual
            Then
                ASSIGN  tt-requis-mat-bc.item-pai = c-it-codigo-novo
                        lProcessa = Yes.

            If  lProcessa
            Then Do:
                Raw-Transfer tt-requis-mat-bc To rw-Transacao.

                Find First b1_bc-trans Of bc-trans Exclusive-lock No-error.
                &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                    Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                &Else
                    Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                &EndIf
            End.
        END.
END PROCEDURE.

/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
PROCEDURE Pi_Acerta_Item_Transf.
    DEFINE INPUT PARAM cCodTrans  AS CHARACTER NO-UNDO.
        {utp/ut-liter.i Processando *}
        Run pi-acompanhar In hAcomp (Input cCodTrans +  " : " + RETURN-VALUE).
        FOR EACH bc-trans FIELDS(cd-trans Nr-Trans ind-tipo-trans log-1 estado-trans conteudo-trans)  NO-LOCK
            WHERE bc-trans.cd-trans = cCodTrans:

            IF  bc-trans.estado-trans = 2 /* atualizada */ OR 
                bc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                NEXT. /* nÆo alterar em logs j  conclu¡dos */
            END.

            &IF "{&mgcld_version}" >= "2.04" &THEN
                If bc-trans.ind-tipo-trans = 1 Then do: 
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                END.
            &ELSE 
                If bc-trans.log-1 Then DO:
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                    END.
                &ENDIF

            EMPTY TEMP-TABLE tt-transfere-bc.

            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                Assign rw-Transacao = bc-trans.conteudo-trans.
            &Else
                Run btb/btb928za.p ( Input bc-trans.conteudo-trans,
                                    Output rw-Transacao) No-Error.
                If Error-Status:Error Then Next.
            &EndIf

            Create  tt-transfere-bc.
            Raw-Transfer rw-Transacao To tt-transfere-bc No-Error.

            If Not Avail tt-transfere-bc Then Next.
            IF  tt-transfere-bc.cod-item = c-it-codigo-atual
            THEN DO:
                ASSIGN  tt-transfere-bc.cod-item = c-it-codigo-novo.

                Raw-Transfer tt-transfere-bc To rw-Transacao.

                Find First b1_bc-trans Of bc-trans Exclusive-lock No-error.
                &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                    Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                &Else
                    Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                &EndIf
            END.
        END.
END PROCEDURE.

/**********************************************************************************************************************************/
PROCEDURE Pi_Acerta_Item_TransfMa.
    DEFINE INPUT PARAM cCodTrans  AS CHARACTER NO-UNDO.
        {utp/ut-liter.i Processando *}
        Run pi-acompanhar In hAcomp (Input cCodTrans +  " : " + RETURN-VALUE).
        FOR EACH bc-trans FIELDS ( cd-trans nr-Trans ind-tipo-trans log-1 estado-trans conteudo-trans) NO-LOCK
            WHERE bc-trans.cd-trans = cCodTrans:

            IF  bc-trans.estado-trans = 2 /* atualizada */ OR 
                bc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                NEXT. /* não alterar em logs já concluídos */
            END.

            &IF "{&mgcld_version}" >= "2.04" &THEN
                If bc-trans.ind-tipo-trans = 1 Then do: 
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                END.
            &ELSE 
                If bc-trans.log-1 Then DO:
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.

                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                    END.
                &ENDIF

            EMPTY TEMP-TABLE tt-transfere-bc.

            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                Assign rw-Transacao = bc-trans.conteudo-trans.
            &Else
                Run btb/btb928za.p ( Input bc-trans.conteudo-trans,
                                    Output rw-Transacao) No-Error.
                If Error-Status:Error Then Next.
            &EndIf

            Create  tt-transfere-bc.
            Raw-Transfer rw-Transacao To tt-transfere-bc No-Error.

            If Not Avail tt-transfere-bc Then Next.
            IF  tt-transfere-bc.cod-item = c-it-codigo-atual
            THEN DO:
                ASSIGN  tt-transfere-bc.cod-item = c-it-codigo-novo.

                Raw-Transfer tt-transfere-bc To rw-Transacao.

                Find First b1_bc-trans Of bc-trans Exclusive-lock No-error.
                &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                    Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                &Else
                    Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                &EndIf
            END.
        END.
END PROCEDURE.
/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
PROCEDURE Pi_Acerta_Item_Embarque.
    DEFINE INPUT PARAM cCodTrans  AS CHARACTER NO-UNDO.
        {utp/ut-liter.i Processando *}
        Run pi-acompanhar In hAcomp (Input cCodTrans +  " : " + RETURN-VALUE).
        FOR EACH bc-trans FIELDS (cd-trans nr-Trans estado-trans ind-tipo-trans log-1 conteudo-trans) NO-LOCK
            WHERE bc-trans.cd-trans = cCodTrans:

            IF  bc-trans.estado-trans = 2 /* atualizada */ OR 
                bc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                NEXT. /* não alterar em logs já concluídos */
            END.

            &IF "{&mgcld_version}" >= "2.04" &THEN
                If bc-trans.ind-tipo-trans = 1 Then do:
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                END.
            &ELSE 
                If bc-trans.log-1 Then DO:
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                    END.
                &ENDIF

            EMPTY TEMP-TABLE tt-embarque-bc.

            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                Assign rw-Transacao = bc-trans.conteudo-trans.
            &Else
                Run btb/btb928za.p ( Input bc-trans.conteudo-trans,
                                    Output rw-Transacao) No-Error.
                If Error-Status:Error Then Next.
            &EndIf

            Create  tt-embarque-bc.
            Raw-Transfer rw-Transacao To tt-embarque-bc No-Error.

            If Not Avail tt-embarque-bc Then Next.
            IF  tt-embarque-bc.cod-item = c-it-codigo-atual
            THEN DO:
                ASSIGN  tt-embarque-bc.cod-item = c-it-codigo-novo.

                Raw-Transfer tt-embarque-bc To rw-Transacao.

                Find First b1_bc-trans Of bc-trans Exclusive-lock No-error.
                &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                    Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                &Else
                    Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                &EndIf
            END.
        END.
END PROCEDURE.

/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
PROCEDURE Pi_Acerta_Item_Req-OM.
    DEFINE INPUT PARAM cCodTrans  AS CHARACTER NO-UNDO.
    {utp/ut-liter.i Processando *}
    Run pi-acompanhar In hAcomp (Input cCodTrans +  " : " + RETURN-VALUE).
&IF DEFINED (bf_mnt_ems203) &THEN
        FOR EACH bc-trans FIELDS (cd-trans Nr-Trans ind-tipo-trans log-1 estado-trans conteudo-trans) NO-LOCK
            WHERE bc-trans.cd-trans = cCodTrans:

            IF  bc-trans.estado-trans = 2 /* atualizada */ OR 
                bc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                NEXT. /* não alterar em logs já concluídos */
            END.

            &IF "{&mgcld_version}" >= "2.04" &THEN
                If bc-trans.ind-tipo-trans = 1 Then do: 
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                END.
            &ELSE 
                If bc-trans.log-1 Then DO:
                    FOR FIRST bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
                        WHERE bBc-Trans.Nr-Trans = bc-trans.nr-trans:
            
                        IF  bbc-trans.estado-trans = 2 /* atualizada */ OR 
                            bbc-trans.estado-trans = 5 /* cancelado */ THEN DO:
                            NEXT. /* não alterar em logs já concluídos */
                        END.
            
                        &IF "{&mgcld_version}" >= "2.04" &THEN
                            If bBc-Trans.ind-tipo-trans = 2 Then Next .
                        &ELSE 
                            If Not bBc-Trans.log-1 Then Next.
                        &ENDIF
            
                        EMPTY TEMP-TABLE tt-etiqueta.
            
                        &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                            Assign rw-Transacao = bBc-Trans.conteudo-trans.
                        &Else
                            Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                                Output rw-Transacao) No-Error.
                            If Error-Status:Error Then Next.
                        &EndIf
            
                        Create  tt-etiqueta.
                        Raw-Transfer rw-Transacao To tt-etiqueta No-Error.
            
                        If Not Avail tt-etiqueta Then Next.
                        IF  tt-etiqueta.it-codigo = c-it-codigo-atual
                        THEN DO:
                            ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.
            
                            Raw-Transfer tt-etiqueta To rw-Transacao.
            
                            Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                                Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                            &Else
                                Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                            &EndIf
                        END.
                    END.
                END.
                &ENDIF
                
            EMPTY TEMP-TABLE tt-requis-manut-bc.

            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                Assign rw-Transacao = bc-trans.conteudo-trans.
            &Else
                Run btb/btb928za.p ( Input bc-trans.conteudo-trans,
                                    Output rw-Transacao) No-Error.
                If Error-Status:Error Then Next.
            &EndIf

            Create  tt-requis-manut-bc.
            Raw-Transfer rw-Transacao To tt-requis-manut-bc No-Error.

            If Not Avail tt-requis-manut-bc Then Next.
            IF  tt-requis-manut-bc.it-codigo = c-it-codigo-atual
            Then Do:
                Assign  tt-requis-manut-bc.it-codigo = c-it-codigo-novo.

                Raw-Transfer tt-requis-manut-bc To rw-Transacao.

                Find First b1_bc-trans Of bc-trans Exclusive-lock No-error.
                &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                    Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                &Else
                    Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                &EndIf
            END.
        END.
&ENDIF
END PROCEDURE.

/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
PROCEDURE Pi_Acerta_Etiqueta.

    DEFINE INPUT PARAM cCodTrans AS CHAR NO-UNDO.

        {utp/ut-liter.i Processando *}
        Run pi-acompanhar In hAcomp (Input cCodTrans +  " : " + RETURN-VALUE).

        FOR EACH bBc-Trans fields(cd-trans Nr-Trans conteudo-trans ind-tipo-trans log-1 estado-trans) NO-LOCK
           WHERE bBc-Trans.cd-trans        = cCodTrans
		     AND bbc-trans.estado-trans   <> 2 //Atualizada
			 AND bbc-trans.estado-trans   <> 5 //Cancelada
			 AND bBc-Trans.ind-tipo-trans <> 2:

            EMPTY TEMP-TABLE tt-etiqueta.
            
            &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                Assign rw-Transacao = bBc-Trans.conteudo-trans.
            &Else
                Run btb/btb928za.p ( Input bBc-Trans.conteudo-trans,
                                    Output rw-Transacao) No-Error.
                If Error-Status:Error Then Next.
            &EndIf

            Create  tt-etiqueta.
            Raw-Transfer rw-Transacao To tt-etiqueta No-Error.

            If Not Avail tt-etiqueta Then Next.
            IF  tt-etiqueta.it-codigo = c-it-codigo-atual
            THEN DO:
                ASSIGN  tt-etiqueta.it-codigo = c-it-codigo-novo.

                Raw-Transfer tt-etiqueta To rw-Transacao.

                Find First b1_bc-trans Of bBc-trans Exclusive-lock No-error.
                &If "{&mgcld_dbtype}" = "PROGRESS" &Then
                    Assign b1_bc-trans.conteudo-trans = rw-Transacao.
                &Else
                    Assign b1_bc-trans.conteudo-trans = String(rw-Transacao).
                &EndIf
            END.
        END.
END PROCEDURE.

/**********************************************************************************************************************************/
/**********************************************************************************************************************************/
