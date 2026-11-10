/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172LOG 2.00.00.011 } /*** 010011 ***/
/*****************************************************************************/

/****************************** 
Validaá‰es de Criaá∆o, Alteraá∆o e Exclus∆o da tabela item no que se refere
as informaá‰es de Log°stica 
 ******************************/

{cdp/cdcfgman.i}
{cdp/cdcfgman.i1}
 {utp/ut-glob.i}

{inbo/boin172.i tt-item}             

{dibo/bodi259.i tt-item-cota}        /* Logistica */ 
{dibo/bodi300.i tt-item-dist}        /* Logistica */ 
{inbo/boin667.i tt-item-mat-aux}     /* Logistica */ 
{inbo/boin684.i tt-item-uni-estab}   /* Logistica */ 

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.


PROCEDURE pi-seta-defaut:

    DEF INPUT-OUTPUT PARAM TABLE FOR tt-item.

    FIND FIRST tt-item EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL tt-item THEN DO:

        /* Busca defaults da familia, caso nao tenham sido enviados no xml */
        FIND FIRST familia WHERE familia.fm-codigo = tt-item.fm-codigo NO-LOCK NO-ERROR.        
        IF AVAIL familia THEN DO:
           IF tt-item.tipo-contr = ? THEN
              ASSIGN tt-item.tipo-contr     = IF familia.tipo-contr   = 0 OR familia.tipo-contr = 5 THEN 2 ELSE familia.tipo-contr.
           IF tt-item.tipo-con-est = ? THEN
              ASSIGN tt-item.tipo-con-est   = IF familia.tipo-con-est = 0 THEN 1 ELSE familia.tipo-con-est.
           IF tt-item.tempo-segur = ? THEN
              ASSIGN tt-item.tempo-segur    = familia.tempo-segur.
           IF tt-item.quant-segur = ? THEN
               ASSIGN tt-item.quant-segur   = familia.quant-segur.
           IF tt-item.perm-saldo-neg = ? THEN
              ASSIGN tt-item.perm-saldo-neg = familia.perm-saldo-neg.
           IF tt-item.quant-perda = ? THEN
               ASSIGN tt-item.quant-perda   = familia.quant-perda.
           IF tt-item.tipo-est-seg = ? THEN
              ASSIGN tt-item.tipo-est-seg   = familia.tipo-est-seg.
           /*IF tt-item.lote-per-max = ? THEN
              ASSIGN tt-item.lote-per-max   = familia.lote-per-max.*/
           IF tt-item.ciclo-contag = ? THEN
              ASSIGN tt-item.ciclo-contag   = familia.ciclo-contag.
           IF tt-item.contr-qualid = ? THEN
              ASSIGN tt-item.contr-qualid   = familia.contr-qualid. 
           IF tt-item.criticidade = ? THEN
              ASSIGN tt-item.criticidade    = familia.criticidade.
           IF tt-item.nivel = ? THEN 
              ASSIGN tt-item.nivel          = familia.nivel.
           IF tt-item.perc-nqa = ? THEN
              ASSIGN tt-item.perc-nqa       = familia.perc-nqa.
           IF tt-item.baixa-estoq = ? THEN
              ASSIGN tt-item.baixa-estoq    = familia.baixa-estoq.
           IF tt-item.class-fiscal = ?  THEN 
              ASSIGN tt-item.class-fiscal   = familia.class-fiscal. 
           IF tt-item.cd-trib-icm = ? THEN
              ASSIGN tt-item.cd-trib-icm    = familia.cd-trib-icm.
           IF tt-item.cod-servico = ? THEN
              ASSIGN tt-item.cod-servico    = familia.cod-servico.
           IF tt-item.cd-trib-iss = ? THEN
              ASSIGN tt-item.cd-trib-iss    = familia.cd-trib-iss.
           IF tt-item.cd-trib-ipi = ? THEN
              ASSIGN tt-item.cd-trib-ipi    = familia.cd-trib-ipi.
           /*IF tt-item.ft-conv-fm = ? THEN
              ASSIGN tt-item.ft-conv-fm     = familia.ft-conv-fm.*/
           IF tt-item.fator-conver = ? THEN
              ASSIGN tt-item.fator-conver   = familia.fator-conver.
           IF tt-item.fraciona = ? THEN
              ASSIGN tt-item.fraciona       = familia.fraciona.
           IF tt-item.lote-multipl = ? THEN
              ASSIGN tt-item.lote-multipl   = familia.lote-multipl.
           /*IF tt-item.lote-mulven = ? THEN
              ASSIGN tt-item.lote-mulven    = familia.lote-mulven.*/
           IF tt-item.codigo-orig = ? THEN
              ASSIGN tt-item.codigo-orig    = familia.codigo-orig.
           IF tt-item.deposito-pad = ? THEN
              ASSIGN tt-item.deposito-pad   = familia.deposito-pad.
           IF tt-item.cod-localiz = ? THEN
              ASSIGN tt-item.cod-localiz    = familia.cod-localiz.
           IF tt-item.demanda = ? THEN
              ASSIGN tt-item.demanda        = familia.demanda.
           IF tt-item.res-cq-fabri = ? THEN
              ASSIGN tt-item.res-cq-fabri   = familia.res-cq-fabri.
           IF tt-item.res-for-comp = ? THEN
              ASSIGN tt-item.res-for-comp   = familia.res-for-comp.
           IF tt-item.res-int-comp = ? THEN
              ASSIGN tt-item.res-int-comp   = familia.res-int-comp.
           IF tt-item.curva-abc = ? THEN
              ASSIGN tt-item.curva-abc      = familia.curva-abc.
    
           /*ASSIGN tt-item.fator-ponder[1]    = familia.fator-ponder[1]
                  tt-item.fator-ponder[2]    = familia.fator-ponder[2]
                  tt-item.fator-ponder[3]    = familia.fator-ponder[3]
                  tt-item.fator-ponder[4]    = familia.fator-ponder[4]
                  tt-item.fator-ponder[5]    = familia.fator-ponder[5]
                  tt-item.fator-ponder[6]    = familia.fator-ponder[6]
                  tt-item.fator-ponder[7]    = familia.fator-ponder[7]
                  tt-item.fator-ponder[8]    = familia.fator-ponder[8]
                  tt-item.fator-ponder[9]    = familia.fator-ponder[9]
                  tt-item.fator-ponder[10]   = familia.fator-ponder[10]
                  tt-item.fator-ponder[11]   = familia.fator-ponder[11]
                  tt-item.fator-ponder[12]   = familia.fator-ponder[12].*/
    
        END.
        
        IF tt-item.conta-aplicacao = ? THEN
           ASSIGN tt-item.conta-aplicacao = "".
        
        IF tt-item.tipo-contr = 2 OR
           tt-item.tipo-contr = 3 THEN 
           ASSIGN tt-item.conta-aplicacao = "".
              
        IF tt-item.ind-item-fat = ? THEN
           ASSIGN tt-item.ind-item-fat = NO.
        IF tt-item.ind-inf-qtf = ? THEN 
           ASSIGN tt-item.ind-inf-qtf  = NO.
        IF tt-item.ind-serv-mat = ? THEN
           ASSIGN tt-item.ind-serv-mat = 2.
        IF tt-item.res-cq-comp = ? THEN
           ASSIGN tt-item.res-cq-comp = 0.
        IF tt-item.ressup-fabri = ? THEN
           ASSIGN tt-item.ressup-fabri = 0.
        IF tt-item.variac-acum = ? THEN
           ASSIGN tt-item.variac-acum  = 0.
        IF tt-item.data-ult-con = ? THEN
           ASSIGN tt-item.data-ult-con = (&IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF).
        IF tt-item.preco-repos = ? THEN
           ASSIGN tt-item.preco-repos  = 0.
        IF tt-item.aliquota-iss = ? THEN
           ASSIGN tt-item.aliquota-iss = 0.
        IF tt-item.aliquota-ipi = ? THEN
           ASSIGN tt-item.aliquota-ipi = 0.
        IF tt-item.fator-reaj-icms  = ? THEN
           ASSIGN tt-item.fator-reaj-icms  = 0.
        IF tt-item.nr-item-dcr  = ? THEN
           ASSIGN tt-item.nr-item-dcr  = 0.
        IF tt-item.valor-ipi-beb  = ? THEN
           ASSIGN tt-item.valor-ipi-beb  = 0.
        IF tt-item.esp-beb  = ? THEN
           ASSIGN tt-item.esp-beb  = 0.
        IF tt-item.enquad-beb  = ? THEN
           ASSIGN tt-item.enquad-beb  = 0.
        IF tt-item.tipo-recip-beb  = ? THEN
           ASSIGN tt-item.tipo-recip-beb  = 0.
        IF tt-item.peso-liquido = ? THEN
           ASSIGN tt-item.peso-liquido = 0.
        IF tt-item.cod-tax = ? THEN
           ASSIGN tt-item.cod-tax = 0.
        IF tt-item.codigo-refer = ? THEN
           ASSIGN tt-item.codigo-refer = "".
        IF tt-item.inform-compl = ? THEN
           ASSIGN inform-compl = ''.
        IF tt-item.data-ult-rep = ? THEN
           ASSIGN tt-item.data-ult-rep = ?.
        IF tt-item.ft-conv-fmcoml = ? OR 
           tt-item.ft-conv-fmcoml = 0 THEN
           ASSIGN tt-item.ft-conv-fmcoml = 1.
        IF tt-item.ft-conversao = ? OR 
           tt-item.ft-conversao = 0 THEN
           ASSIGN tt-item.ft-conversao = 1.
        IF tt-item.codigo-orig = ? THEN
           ASSIGN tt-item.codigo-orig = 0.
        IF tt-item.altura = ? THEN
           ASSIGN tt-item.altura = 0.
        IF tt-item.comprim = ? THEN
           ASSIGN tt-item.comprim = 0.
        IF tt-item.largura = ? THEN
           ASSIGN tt-item.largura = 0.
        IF tt-item.div-ordem = ? THEN
           ASSIGN tt-item.div-ordem = 0.
        IF tt-item.fator-refugo = ? THEN
           ASSIGN tt-item.fator-refugo = 0.
        IF tt-item.ind-imp-desc = ? THEN
           ASSIGN tt-item.ind-imp-desc = 0.
        IF tt-item.ind-refugo = ? THEN
           ASSIGN tt-item.ind-refugo = 0.
        IF tt-item.lote-economi = ? THEN
           ASSIGN tt-item.lote-economi = 0.
        IF tt-item.lote-minimo = ? THEN
           ASSIGN tt-item.lote-minimo = 0.
        IF tt-item.peso-bruto = ? THEN
           ASSIGN tt-item.peso-bruto = 0.
        IF tt-item.qtd-batch-padrao = ? THEN
           ASSIGN tt-item.qtd-batch-padrao = 0.
        IF tt-item.tipo-requis  = ? THEN
           ASSIGN tt-item.tipo-requis  = 0.

        
        /* por solicitacao do Muller */
        IF tt-item.cod-estabel = ? OR 
           tt-item.cod-estabel = ""  THEN DO:
           FIND FIRST param-estoq NO-LOCK NO-ERROR.
        
           IF AVAIL param-estoq THEN
              ASSIGN tt-item.cod-estabel = param-estoq.estabel-pad.
        END.
                                         

    END.
    RETURN "OK":u.
END PROCEDURE.


PROCEDURE pi-trata-erro.

    DEFINE INPUT PARAM p-errornumber      LIKE rowErrors.errornumber      NO-UNDO.
    DEFINE INPUT PARAM p-errordescription LIKE RowErrors.errordescription NO-UNDO.
    DEFINE INPUT PARAM p-errorhelp        LIKE RowErrors.errorhelp        NO-UNDO.

    CREATE RowErrors.
    ASSIGN RowErrors.errornumber      = p-errornumber   
           RowErrors.errortype        = "ERROR":U       
           RowErrors.errordescription = p-errordescription 
           RowErrors.errorhelp        = p-errorhelp.       

END.


PROCEDURE pi-valida-item:
    def input  param table for tt-item.
    def input  param iInvestmentAccountId                 as int    no-undo.
    def input  param iExpenseNatureId                     as int    no-undo.
    def input  param iExpenseTypeId                       as int    no-undo.
    def input  param iQualityControlInformationId         as int    no-undo.
    def input  param iPurchaseControlInformationId        as int    no-undo.
    def input  param iBuyerId                             as int    no-undo.
    def input  param iFiscalInformationId                 as int    no-undo.
    def input  param iFiscalClassificationId              as int    no-undo.
    def input  param iBrazilianTaxesId                    as int    no-undo.
    def input  param iServiceTypeId                       as int    no-undo.
    DEF OUTPUT PARAMETER TABLE FOR RowErrors.

    DEF VAR c-msg AS CHAR NO-UNDO.
    DEF VAR c-help AS CHAR NO-UNDO.


    find first tt-item          no-lock no-error.

    FOR EACH rowErrors.
        DELETE rowErrors.
    END.

    /*run getSonVal in hGenXml (input iInvestmentAccountId, "Account":U, output tt-item.conta-aplicacao).*/
    if iInvestmentAccountId <> ? then do:
        if tt-item.conta-aplicacao = "" then do: 
           run utp/ut-msgs.p (input "msg":u,
                              input 2261,  
                              input "").
           ASSIGN c-msg = RETURN-VALUE
                  c-help = c-msg.
           RUN pi-trata-erro (INPUT 2261,
                              INPUT c-msg,
                              INPUT c-help).
        end. 
    end. 
    /* run getSonDec in hGenXml (input iExpenseNatureId, "ExpenseNatureID":U, output tt-item.nat-despesa). */
    if iExpenseNatureId <> ? then do:
        if tt-item.nat-despesa = 0 then do: 
           run utp/ut-msgs.p (input "msg":u,
                              input 26216,  
                              input "").
           ASSIGN c-msg = RETURN-VALUE.
           run utp/ut-msgs.p (input "help":u,
                              input 26216,  
                              input "").
           ASSIGN c-help = RETURN-VALUE.
           RUN pi-trata-erro (INPUT 26216,
                              INPUT c-msg,
                              INPUT c-help).
        end. 
    end.
    /* run getSonDec in hGenXml (input iExpenseTypeId, "ExpenseID":U, output tt-item.tp-desp-padrao). */
    if iExpenseTypeId <> ? then do:
        if tt-item.tp-desp-padrao = 0 then do: 
           RUN utp/ut-msgs.p (INPUT "msg":u,
                              INPUT 4268,  
                              INPUT "").
           ASSIGN c-msg = RETURN-VALUE
                  c-help = c-msg.
           RUN pi-trata-erro (INPUT 4268,
                              INPUT c-msg,
                              INPUT c-help).
        end. 
    end. 
    /* run searchTag  in hGenXml ("QualityControlInformation":U, iLogisticsId, output iQualityControlInformationId). */
    if iQualityControlInformationId <> ? then do:
            /* run getSonLog in hGenXml (input iQualityControlInformationId, "IsItemQualityControlled":U, output tt-item.contr-qualid). */
            if tt-item.contr-qualid = ? then do: 
               RUN utp/ut-msgs.p (INPUT "msg":u,
                                  INPUT 8843,  
                                  INPUT "").
               ASSIGN c-msg = RETURN-VALUE
                      c-help = c-msg.
               RUN pi-trata-erro (INPUT 8843,
                                  INPUT c-msg,
                                  INPUT c-help).
            end. 
            /* run getSonDec in hGenXml (input iQualityControlInformationId, "CriticCode":U, output tt-item.criticidade). */
            if tt-item.criticidade = 0 then do: 
               RUN utp/ut-msgs.p (INPUT "msg":u,
                                  INPUT 8438,  
                                  INPUT "").
               ASSIGN c-msg = RETURN-VALUE
                      c-help = c-msg.
               RUN pi-trata-erro (INPUT 8438,
                                  INPUT c-msg,
                                  INPUT c-help).
            end. 
            /* run getSonDec in hGenXml (input iQualityControlInformationId, "QualityControlLevel":U, output tt-item.nivel). */
            IF tt-item.nivel = 0 THEN DO: 
               RUN utp/ut-msgs.p (INPUT "msg":u,
                                  INPUT 32094,  
                                  INPUT "").
               ASSIGN c-msg = RETURN-VALUE.
               RUN utp/ut-msgs.p (INPUT "help":u,
                                  INPUT 32094,  
                                  INPUT "").
               ASSIGN c-help = RETURN-VALUE.
               RUN pi-trata-erro (INPUT 32094,
                                  INPUT c-msg,
                                  INPUT c-help).
            END. 
    end. 
    /* run searchTag  in hGenXml ("PurchaseControlInformation":U, iLogisticsId, output iPurchaseControlInformationId). */
    if iPurchaseControlInformationId <> ? then do:
                    /*run searchTag  in hGenXml ("Buyer":U, iPurchaseControlInformationId, output iBuyerId).*/
       if iBuyerId <> ? then do:
          if tt-item.cod-comprado = "" then do: 
             RUN utp/ut-msgs.p (INPUT "msg":u,
                                INPUT 15712,  
                                INPUT "").
             ASSIGN c-msg = RETURN-VALUE.
             RUN utp/ut-msgs.p (INPUT "help":u,
                                INPUT 15712,  
                                INPUT "").
             ASSIGN c-help = RETURN-VALUE.
             RUN pi-trata-erro (INPUT 15712,
                                INPUT c-msg,
                                INPUT c-help).
          end.
       end.
    end.

    /* - Distribuiá∆o - */
    /* run searchTag  in hGenXml ("FiscalInformation":U, iLogisticsId, output iFiscalInformationId). */
    if iFiscalInformationId <> ? then do:

       /* run searchTag  in hGenXml ("FiscalClassification":U, iFiscalInformationId, output iFiscalClassificationId). */
       if iFiscalClassificationId <> ? then do:
          if tt-item.class-fiscal = "" then do: 
             RUN utp/ut-msgs.p (INPUT "msg":u,
                                INPUT 5398,  
                                INPUT "").
             ASSIGN c-msg = RETURN-VALUE.
             RUN utp/ut-msgs.p (INPUT "help":u,
                                INPUT 5398,  
                                INPUT "").
             ASSIGN c-help = RETURN-VALUE.
             RUN pi-trata-erro (INPUT 5398,
                                INPUT c-msg,
                                INPUT c-help).
          end. 
       end.

       /* run searchTag  in hGenXml ("BrazilianTaxes":U, iFiscalInformationId, output iBrazilianTaxesId). */
       if iBrazilianTaxesId <> ? then do:
           /* run searchTag  in hGenXml ("ServiceType":U, iBrazilianTaxesId, output iServiceTypeId). */
           if iServiceTypeId <> ? then do:
              if tt-item.cod-servico = 0 then do: 
                 RUN utp/ut-msgs.p (INPUT "msg":u,
                                    INPUT 7494,  
                                    INPUT "").
                 ASSIGN c-msg = RETURN-VALUE.
                 RUN utp/ut-msgs.p (INPUT "help":u,
                                    INPUT 7494,  
                                    INPUT "").
                 ASSIGN c-help = RETURN-VALUE.
                 RUN pi-trata-erro (INPUT 7494,
                                    INPUT c-msg,
                                    INPUT c-help).
              end. 
           end.
       end.
    end.
    

    if i-pais-impto-usuario = 1         
    and  AVAIL tt-ITEM AND tt-item.fraciona = no
    and (tt-item.lote-mulven - INT(tt-item.lote-mulven)) <> 0  
    then do:
       run utp/ut-msgs.p (input "msg":u,
                          input 847,  /* Quantidade fracionada */
                          input "").
       ASSIGN c-msg = RETURN-VALUE
              c-help = c-msg.
       RUN pi-trata-erro (INPUT 847,
                          INPUT c-msg,
                          INPUT c-help).
    end.
    
    if  i-pais-impto-usuario = 1 
    and  AVAIL tt-ITEM AND tt-item.fraciona = no
    and (tt-item.lote-multipl - int(tt-item.lote-multipl) <> 0) 
    then do:
       run utp/ut-msgs.p (input "msg":u,
                          input 26120, 
                          input "").
       ASSIGN c-msg = RETURN-VALUE.
       
       run utp/ut-msgs.p (input "help":u,
                          input 26120, 
                          input "").
       ASSIGN c-help = RETURN-VALUE.
    
       RUN pi-trata-erro (INPUT 26120,
                          INPUT c-msg,
                          INPUT c-help).
    end.
    
    
    if  AVAIL tt-ITEM AND (tt-item.peso-liquido > tt-item.peso-bruto) then do:
       run utp/ut-msgs.p (input "msg",
                          input 3912,
                          input "").
       ASSIGN c-msg = RETURN-VALUE
              c-help = c-msg.
    
       RUN pi-trata-erro (INPUT 3912,
                          INPUT c-msg,
                          INPUT c-help).
    end.
                          /*
    /*** Validaá∆o da Origem do Item************/
    if  AVAIL tt-ITEM AND 
       tt-item.codigo-orig <> 0 and 
       tt-item.codigo-orig <> 1 and
       tt-item.codigo-orig <> 2 then do:
       run utp/ut-msgs.p (input "msg",
                          input 26703,
                          input "").
       ASSIGN c-msg = RETURN-VALUE.
       run utp/ut-msgs.p (input "help",
                       input 26703,
                       input "").
       ASSIGN c-help = RETURN-VALUE.
       RUN pi-trata-erro (INPUT 26703,
                          INPUT c-msg,
                          INPUT c-help).
    end.
                            */
    IF AVAIL tt-ITEM AND tt-item.deposito-pad <> "" THEN DO:
       if not can-find (deposito where 
                        deposito.cod-depos = tt-item.deposito-pad) then do:
          {utp/ut-field.i mgind item deposito-pad 1}
          run utp/ut-msgs.p (input "msg",
                             input 47,
                             input return-value).
          ASSIGN c-msg = RETURN-VALUE.
          {utp/ut-field.i mgind item deposito-pad 1}
          run utp/ut-msgs.p (input "help",
                             input 47,
                             input return-value).
          ASSIGN c-help = RETURN-VALUE.
          RUN pi-trata-erro (INPUT 47,
                             INPUT c-msg,
                             INPUT c-help).
       end.
    END.
    if AVAIL tt-ITEM AND tt-item.cod-localiz <> "" then do:
       if not can-find(first localizacao where 
                             localizacao.cod-localiz = tt-item.cod-localiz) then do:
          {utp/ut-field.i mgind item cod-localiz 1}
          run utp/ut-msgs.p (input "msg",
                             input 47,
                             input return-value).
          ASSIGN c-msg = RETURN-VALUE.
          {utp/ut-field.i mgind item cod-localiz 1}
          run utp/ut-msgs.p (input "help",
                            input 47,
                            input return-value).
          ASSIGN c-help = RETURN-VALUE.
          RUN pi-trata-erro (INPUT 47,
                             INPUT c-msg,
                             INPUT c-help).
       END.                   
    end.
    IF AVAIL tt-item AND 
       tt-item.cod-tax <> 0 THEN DO:
    
       FIND tipo-tax WHERE tipo-tax.cod-tax = tt-item.cod-tax NO-LOCK NO-ERROR.
       IF NOT AVAIL tipo-tax THEN DO:
          RUN utp/ut-msgs.p(INPUT "msg",
                            INPUT 8512,
                            INPUT "").
          ASSIGN c-msg = RETURN-VALUE
                 c-help = c-msg.
          RUN pi-trata-erro (INPUT 8512,
                             INPUT c-msg,
                             INPUT c-help).
       END.
    END.

    IF CAN-FIND (FIRST rowErrors) THEN
       RETURN 'ADM-ERROR':U.
    ELSE
       RETURN "ok":u.

END PROCEDURE.

PROCEDURE pi-valida-item-mat-aux:

    def input  param table for tt-item-mat-aux.
    def input  param iPurchaseControlInformationId        as int    no-undo.
    def input  param iManagerSiteId                       as int    no-undo.
    def input  param iPurchaseGroupId                     as int    no-undo.
    def input  param iInventoryInformationId              as int    no-undo.
    def input  param iReplenishmentId                     as int    no-undo.
    def input  param iSupplyFrequencyId                   as int    no-undo.
    def input  param iWeightingFormulasId                 as int    no-undo.
    def input  param iInventoryCountingId                 as int    no-undo.
    def input  param iListOfWeightFactorsId               as int    no-undo.
    def input  param iWeightFactorId                      as int    no-undo.
    def input  param iFiscalInformationId                 as int    no-undo.
    def input  param iTaxId                               as int    no-undo.
    DEF OUTPUT PARAMETER TABLE FOR RowErrors.

    DEF VAR c-msg AS CHAR NO-UNDO.
    DEF VAR c-help AS CHAR NO-UNDO.

    FOR EACH rowErrors.
        DELETE rowErrors.
    END.

    find first tt-item-mat-aux  no-lock no-error.
    
    /* run searchTag  in hGenXml ("PurchaseControlInformation":U, iLogisticsId, output iPurchaseControlInformationId). */
    if iPurchaseControlInformationId <> ? then do:
        /* run searchTag  in hGenXml ("ManagerSite":U, iPurchaseControlInformationId, output iManagerSiteId). */
        if iManagerSiteId <> ? then do:
            if tt-item-mat-aux.cod-estab-gestor = "" then do: 
               run utp/ut-msgs.p (input "msg":u,
                                  input 3645,  
                                  input "").
               ASSIGN c-msg = RETURN-VALUE.
               run utp/ut-msgs.p (input "help":u,
                                  input 3645,  
                                  input "").
               ASSIGN c-help = RETURN-VALUE.
               RUN pi-trata-erro (INPUT 3645,
                                  INPUT c-msg,
                                  INPUT c-help).
            end.
        end.
        /* run searchTag  in hGenXml ("PurchaseGroup":U, iPurchaseControlInformationId, output iPurchaseGroupId). */
        if iPurchaseGroupId <> ? then do:
            IF tt-item-mat-aux.cod-grp-compra = "" OR 
               NOT CAN-FIND(FIRST grupo-compra WHERE 
                                  grupo-compra.cod-grp-compra = tt-item-mat-aux.cod-grp-compra) THEN DO:
               RUN utp/ut-msgs.p (INPUT "msg":u,
                                  INPUT 16419,  
                                  INPUT "").
               ASSIGN c-msg = RETURN-VALUE    
                      c-help = c-msg.
               RUN pi-trata-erro (INPUT 16419,
                                  INPUT c-msg,
                                  INPUT c-help).
            end.
        end.
    end.

    /* run searchTag  in hGenXml ("InventoryInformation":U, iLogisticsId, output iInventoryInformationId). */
    if iInventoryInformationId <> ? then do:    
        /*run searchTag in hGenXml ("Replenishment":U, iInventoryInformationId, output iReplenishmentId). */
        if iReplenishmentId <> ? then do:
            /*run searchTag in hGenXml ("SupplyFrequency":U, iReplenishmentId, output iSupplyFrequencyId). */
            if iSupplyFrequencyId <> ? then do:
                if tt-item-mat-aux.cd-freq = 0 then do: 
                   run utp/ut-msgs.p (input "msg":u,
                                      input 6070,  
                                      input "").
                   ASSIGN c-msg = RETURN-VALUE.
                   run utp/ut-msgs.p (input "help":u,
                                      input 6070,  
                                      input "").
                   ASSIGN c-help = RETURN-VALUE.
                   RUN pi-trata-erro (INPUT 6070,
                                      INPUT c-msg,
                                      INPUT c-help).
                end. 
            end.
            /*run searchTag  in hGenXml ("WeightingFormulas":U, iReplenishmentId, output iWeightingFormulasId). */
            if iWeightingFormulasId <> ? then do:
                if tt-item-mat-aux.cod-fat-ponder = 0 then do: 
                   run utp/ut-msgs.p (input "msg":u,
                                      input 5057,  
                                      input "").
                   ASSIGN c-msg = RETURN-VALUE    
                          c-help = c-msg.
                   RUN pi-trata-erro (INPUT 5057,
                                      INPUT c-msg,
                                      INPUT c-help).
                end. 
            end.
        end. 
        /*run searchTag  in hGenXml ("InventoryCounting":U, iInventoryInformationId, output iInventoryCountingId).
        if iInventoryCountingId <> ? then do:

            run getSonDec  in hGenXml (input iInventoryCountingId, "CountingCicle":U,             output tt-item.ciclo-contag).
            run getSonDec  in hGenXml (input iInventoryCountingId, "AccumulatedVariation":U,      output tt-item.variac-acum).
            run getSonDate in hGenXml (input iInventoryCountingId, "LastInventoryCountingDate":U, output tt-item.data-ult-rep).

            run searchTag  in hGenXml ("ListOfWeightFactors":U, iInventoryCountingId, output iListOfWeightFactorsId).
            if iListOfWeightFactorsId <> ? then do:
            /*
                run searchTag  in hGenXml ("WeightFactor":U, iListOfWeightFactorsId, output iWeightFactorId).
                if iWeightFactorId <> ? then do:
                    run getSonDec in hGenXml (input iWeightFactorId, "WeightFactorIndex":U, output ??????????????????????????????????????).
                    run getSonDec in hGenXml (input iWeightFactorId, "WeightFactorValue":U, output tt-item.fator-ponder[1..12]).
                end.*/
            end.
        end.*/
    end.

    /* run searchTag  in hGenXml ("FiscalInformation":U, iLogisticsId, output iFiscalInformationId). */
    if iFiscalInformationId <> ? then do:
        /* run searchTag  in hGenXml ("Tax":U, iFiscalInformationId, output iTaxId). */
       if iTaxId <> ? then do:
          if tt-item-mat-aux.cod-tax = 0 OR
             NOT CAN-FIND(FIRST tipo-tax WHERE 
                                tipo-tax.cod-tax = tt-item-mat-aux.cod-tax) THEN DO:
             RUN utp/ut-msgs.p(INPUT "msg",
                               INPUT 8512,
                               INPUT "").
             ASSIGN c-msg = RETURN-VALUE
                    c-help = c-msg.
             RUN pi-trata-erro (INPUT 8512,
                                INPUT c-msg,
                                INPUT c-help).

          END.
       end.
    end.

    IF CAN-FIND (FIRST rowErrors) THEN
       RETURN 'ADM-ERROR':U.
    ELSE
       RETURN "ok":u.

END PROCEDURE.

