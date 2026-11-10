/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*********************************************************************************/
{include/i-prgvrs.i ABAPI016 2.00.00.001 } /*** "010001" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i abapi016 ABP}
&ENDIF

/*********************************************************************************
**
**   ABAPI016 - Manutencao Tabela Abastecimento/Lubrificacao/Materiais Aplicados
**
*********************************************************************************/
{cdp/cdcfgmat.i}
{cdp/cdcfgmnt.i}
{utp/ut-glob.i}

/* Temp-Table and Buffer definitions */
DEFINE TEMP-TABLE tt-mab-abastec-lubrific NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-mab-item-abastec NO-UNDO LIKE mab-item-abastec
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-mab-item-lubrific NO-UNDO LIKE mab-item-lubrific
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-mmv-movto-mater NO-UNDO LIKE mmv-movto-mater
       field r-rowid as rowid.

{method/dbotterr.i} /* Definicao RowErrors */
{abp/abapi016.i}
{cdp/cd9911.i}
{abp/abapi001.i}  /** Temp-Tables da API de Atualizacao (ABAPI001) **/
{pnp/pnapi002.i tt-param-aux} /**Definicao da Temp-Table tt-param-aux para integrar com a pnapi002**/

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

/** Vari†veis Handles **/
define variable h-ficha    as handle no-undo.
define variable h-abastec  as handle no-undo.
define variable h-lubrific as handle no-undo.
define variable h-material as handle no-undo.

/** Vari†veis **/
DEFINE VARIABLE v-serie-docto   LIKE item-doc-est.serie-docto NO-UNDO.
DEFINE VARIABLE v-nro-docto     LIKE item-doc-est.nro-docto NO-UNDO.
DEFINE VARIABLE v-cod-emitente  LIKE item-doc-est.cod-emitente NO-UNDO.
DEFINE VARIABLE v-nat-operacao  LIKE item-doc-est.nat-operacao NO-UNDO.
DEFINE VARIABLE v-sequencia     LIKE item-doc-est.sequencia NO-UNDO.
DEFINE VARIABLE lEqptoComAcesso AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE c-aux           AS CHARACTER NO-UNDO.
/*Parametros para atualizaªío durablidade/apontamento dos pneus*/
DEFINE VARIABLE param25         LIKE mab-param.des-valor NO-UNDO.
DEFINE VARIABLE param26         LIKE mab-param.des-valor NO-UNDO.
DEFINE VARIABLE param49         LIKE mab-param.des-valor NO-UNDO.
DEFINE VARIABLE iErro           AS INTEGER NO-UNDO.

/* ---------------------------------- PROCEDURES --------------------------------- */
{abp/ab9000.i}         /** converteParaHoraInvertida  **/
{abp/ab9001.i}         /** piConverteMoeda            **/
{abp/abapi001.i2}      /** piCriaErro                 **/

PROCEDURE pi-execute:

    DEFINE INPUT PARAMETER TABLE FOR tt-mab-item-abastec-lubrific.
    DEFINE INPUT PARAMETER p-operacao AS INT.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.

    /** Inicia Handles **/
    run pi-handle in this-procedure (input 1).

    FIND FIRST tt-mab-item-abastec-lubrific NO-LOCK NO-ERROR.

    CASE p-operacao:
        WHEN 1 THEN /* Inclus∆o */
            RUN pi-incluir-abastec-lubrif.
        WHEN 2 THEN /* Alteraá∆o */
            RUN pi-alterar-abastec-lubrif.
        OTHERWISE  
            RETURN.
    END CASE.

    /** Finaliza Handles **/
    run pi-handle in this-procedure (input 2).
    
    return "OK":U.
END PROCEDURE.

PROCEDURE pi-dadosItemDocEst:
    DEFINE INPUT PARAMETER pi-emitente  LIKE item-doc-est.cod-emitente.
    DEFINE INPUT PARAMETER pc-nota      LIKE item-doc-est.nro-docto.
    DEFINE INPUT PARAMETER pc-serie     LIKE item-doc-est.serie-docto.
    DEFINE INPUT PARAMETER pc-natureza  LIKE item-doc-est.nat-operacao.
    DEFINE INPUT PARAMETER pi-sequencia LIKE item-doc-est.sequencia.

    ASSIGN v-cod-emitente = pi-emitente 
           v-nro-docto    = pc-nota     
           v-serie-docto  = pc-serie    
           v-nat-operacao = pc-natureza 
           v-sequencia    = pi-sequencia.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-getTTdadosAbastLubrif:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-mab-item-abastec-lubrific.

    EMPTY TEMP-TABLE tt-mab-item-abastec-lubrific.

    /** Busca a Ficha referente ao Documento Manutenido **/
    if can-find(first mab-abastec-lubrific no-lock
                where mab-abastec-lubrific.serie        = v-serie-docto 
                and   mab-abastec-lubrific.nr-nota-fis  = v-nro-docto   
                and   mab-abastec-lubrific.cod-emitente = v-cod-emitente
                and   mab-abastec-lubrific.nat-operacao = v-nat-operacao
                and   mab-abastec-lubrific.sequencia    = v-sequencia) then do:
        for first mab-abastec-lubrific no-lock
            where mab-abastec-lubrific.serie        = v-serie-docto
            and   mab-abastec-lubrific.nr-nota-fis  = v-nro-docto
            and   mab-abastec-lubrific.cod-emitente = v-cod-emitente
            and   mab-abastec-lubrific.nat-operacao = v-nat-operacao
            and   mab-abastec-lubrific.sequencia    = v-sequencia:

            CREATE tt-mab-item-abastec-lubrific.
            ASSIGN tt-mab-item-abastec-lubrific.dt-movimento    = mab-abastec-lubrific.dat-movto
                   tt-mab-item-abastec-lubrific.hr-inicial      = mab-abastec-lubrific.hra-inicial
                   tt-mab-item-abastec-lubrific.hr-final        = mab-abastec-lubrific.hra-final
                   tt-mab-item-abastec-lubrific.ep-codigo       = mab-abastec-lubrific.ep-codigo
                   tt-mab-item-abastec-lubrific.cod-eqpto       = mab-abastec-lubrific.cod-eqpto
                   tt-mab-item-abastec-lubrific.contador        = mab-abastec-lubrific.val-hodom-horim
                   tt-mab-item-abastec-lubrific.contador-sec    = mab-abastec-lubrific.val-hodom-horim-sec
                   tt-mab-item-abastec-lubrific.posto           = mab-abastec-lubrific.cod-posto
                   tt-mab-item-abastec-lubrific.empresa-matr    = mab-abastec-lubrific.ep-codigo-matr
                   tt-mab-item-abastec-lubrific.estabel-matr    = mab-abastec-lubrific.cod-estabel-matr
                   tt-mab-item-abastec-lubrific.cod-matr        = mab-abastec-lubrific.cod-matr
                   tt-mab-item-abastec-lubrific.cod-rota        = mab-abastec-lubrific.cod-rota
                   tt-mab-item-abastec-lubrific.cod-ativid      = mab-abastec-lubrific.cod-ativid
                   tt-mab-item-abastec-lubrific.cod-cta-ctbl    = mab-abastec-lubrific.ct-codigo
                   tt-mab-item-abastec-lubrific.cod-ccusto      = mab-abastec-lubrific.cc-codigo.

            /**********************************************
            **             Abastecimento 
            **********************************************/
            IF  can-find(first mab-item-abastec no-lock
                        where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto) then do:
                for first mab-item-abastec no-lock
                    where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto:   
                    ASSIGN tt-mab-item-abastec-lubrific.i-tipo = 1. // Abastecimento

                    /* Quando paramentro 55 = sim Alimenta os campo de conta e centro de custo com base no item de abastecimento */
                    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
                        IF  mab-param.des-valor = "1" THEN DO:
                            /* Alimenta os campo de conta e centro de custo com base no item abastecimento */
                            ASSIGN tt-mab-item-abastec-lubrific.cod-cta-ctbl = mab-item-abastec.cod-cta-ctbl
                                   tt-mab-item-abastec-lubrific.cod-ccusto   = mab-item-abastec.cod-ccusto.
                        END.
                    END.                
                END.
            END.
            ELSE
            /**********************************************
            **             Lubrificaá∆o
            **********************************************/
            IF  can-find(first mab-item-lubrific no-lock
                         where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto) then do:
                for each  mab-item-lubrific no-lock
                    where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto:
                    ASSIGN tt-mab-item-abastec-lubrific.cod-evento   = mab-item-lubrific.cod-evento    
                           tt-mab-item-abastec-lubrific.cod-compart  = mab-item-lubrific.cod-comptmento
                           tt-mab-item-abastec-lubrific.cod-cta-ctbl = mab-item-lubrific.cod-cta-ctbl
                           tt-mab-item-abastec-lubrific.cod-ccusto   = mab-item-lubrific.cod-ccusto
                           tt-mab-item-abastec-lubrific.i-tipo       = 2. // Lubrificaá∆o
                END.
            END.
        end.
    end.
    ELSE
    /**********************************************
    **             Outros
    **********************************************/
    if can-find(first mmv-movto-mater no-lock
                where mmv-movto-mater.serie-docto  = v-serie-docto 
                and   mmv-movto-mater.nro-docto    = v-nro-docto   
                and   mmv-movto-mater.cod-emitente = v-cod-emitente
                and   mmv-movto-mater.nat-operacao = v-nat-operacao
                and   mmv-movto-mater.sequencia    = v-sequencia) then do:
        for first mmv-movto-mater no-lock
            where mmv-movto-mater.serie-docto  = v-serie-docto 
            and   mmv-movto-mater.nro-docto    = v-nro-docto   
            and   mmv-movto-mater.cod-emitente = v-cod-emitente
            and   mmv-movto-mater.nat-operacao = v-nat-operacao
            and   mmv-movto-mater.sequencia    = v-sequencia:

            CREATE tt-mab-item-abastec-lubrific.
            ASSIGN tt-mab-item-abastec-lubrific.dt-movimento    = mmv-movto-mater.dat-movto
                   tt-mab-item-abastec-lubrific.ep-codigo       = mmv-movto-mater.ep-codigo
                   tt-mab-item-abastec-lubrific.cod-eqpto       = mmv-movto-mater.cod-eqpto
                   tt-mab-item-abastec-lubrific.cod-evento      = mmv-movto-mater.cod-evento
                   tt-mab-item-abastec-lubrific.i-tipo          = 3. // Movimento Material
        end.
    end.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-handle :
/*------------------------------------------------------------------------------
  Purpose:     pi-handle
  Parameters:  entrada pAction = (1 = Inicia / 2 = Finaliza)
  Notes:       Manutená∆o dos handles
------------------------------------------------------------------------------*/
    define input parameter pAction as integer no-undo.
    
    case pAction:
       /** Inicializa **/
        when 1 then do:
            /*:T--- BO de Movimento Material ---*/
            IF NOT VALID-HANDLE(h-material) OR
               h-material:TYPE <> "PROCEDURE":U OR
               h-material:FILE-NAME <> "frbo/bofr076.p":U THEN DO:
                run frbo/bofr076.p persistent set h-material.
            END.
            
            RUN openQueryStatic IN h-material (INPUT "Main":U) NO-ERROR.
    
            /*:T--- BO de Ficha Abatestecimento ---*/
            IF NOT VALID-HANDLE(h-ficha) OR
               h-ficha:TYPE <> "PROCEDURE":U OR
               h-ficha:FILE-NAME <> "frbo/bofr055.p":U THEN DO:
                run frbo/bofr055.p persistent set h-ficha.
            END.
            
            RUN openQueryStatic IN h-ficha (INPUT "Main":U) NO-ERROR.
            
            /*:T--- BO de Ficha Abatestecimento ---*/
            IF NOT VALID-HANDLE(h-abastec) OR
               h-abastec:TYPE <> "PROCEDURE":U OR
               h-abastec:FILE-NAME <> "frbo/bofr057.p":U THEN DO:
                run frbo/bofr057.p persistent set h-abastec.
            END.
            
            RUN openQueryStatic IN h-abastec (INPUT "Main":U) NO-ERROR.
    
            /*:T--- BO de Ficha Abatestecimento ---*/
            IF NOT VALID-HANDLE(h-lubrific) OR
               h-lubrific:TYPE <> "PROCEDURE":U OR
               h-lubrific:FILE-NAME <> "frbo/bofr058.p":U THEN DO:
                run frbo/bofr058.p persistent set h-lubrific.
            END.
            
            RUN openQueryStatic IN h-lubrific (INPUT "Main":U) NO-ERROR.
    
            /** Verifica se Consiste Ficha **/
            for first mab-param
                where mab-param.cdn-param = 11 no-lock:
                /** 1 = On-Line / 2 = Batch **/
                if mab-param.des-valor = "1":U then do:
                    run setaExecutaAPI in h-abastec  (input yes).
                    run setaExecutaAPI in h-lubrific (input yes).
                end.
                else do:
                    run setaExecutaAPI in h-abastec  (input no).
                    run setaExecutaAPI in h-lubrific (input no).
                end.
            end.
    
        end.
        /** Finaliza **/
        when 2 then do:
            if valid-handle(h-material) then
                run Destroy in h-material.
            if valid-handle(h-ficha) then
                run Destroy in h-ficha.
            if valid-handle(h-abastec) then
                run Destroy in h-abastec.
            if valid-handle(h-lubrific) then
                run Destroy in h-lubrific.
        end.
    end case.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-incluir-abastec-lubrif:
    define variable deTanque as decimal no-undo.   

    for first item-doc-est
        where item-doc-est.serie-docto  = v-serie-docto 
        and   item-doc-est.nro-docto    = v-nro-docto   
        and   item-doc-est.cod-emitente = v-cod-emitente
        and   item-doc-est.nat-operacao = v-nat-operacao
        and   item-doc-est.sequencia    = v-sequencia no-lock:
        case tt-mab-item-abastec-lubrific.i-tipo:
            /**********************************************
            **             Abastecimento 
            **********************************************/
            when 1 then do:
                /** Cria Ficha Abastec/Lubrific **/
                run pi-cria-ficha in this-procedure.
                if return-value = "OK":U then do:
    
                    /** Limpa Temp-Table **/
                    empty temp-table tt-mab-item-abastec.
                    /** Cria temp-table de comunicaá∆o **/
                    create tt-mab-item-abastec.
                    assign tt-mab-item-abastec.num-docto            = tt-mab-abastec-lubrific.num-docto
                           tt-mab-item-abastec.ep-codigo            = tt-mab-abastec-lubrific.ep-codigo
                           tt-mab-item-abastec.cod-eqpto            = tt-mab-abastec-lubrific.cod-eqpto
                           tt-mab-item-abastec.val-dat-hora-invrtda = tt-mab-abastec-lubrific.val-dat-hora-invrtda
                           tt-mab-item-abastec.cod-bomba            = "":U
                           tt-mab-item-abastec.it-codigo            = item-doc-est.it-codigo
                           tt-mab-item-abastec.cod-refer            = item-doc-est.cod-refer
                           tt-mab-item-abastec.cod-localiz          = item-doc-est.cod-localiz
                           tt-mab-item-abastec.lote                 = item-doc-est.lote
                           tt-mab-item-abastec.r-rowid              = ?
                           tt-mab-item-abastec.val-mater-1          = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
                           tt-mab-item-abastec.val-quant            = item-doc-est.quantidade
                           /** Dados de Tela **/
                           tt-mab-item-abastec.cod-posto            = tt-mab-item-abastec-lubrific.posto.
    
                    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
                        IF  mab-param.des-valor = "1":U THEN DO:
                            ASSIGN tt-mab-item-abastec.cod-cta-ctbl = tt-mab-item-abastec-lubrific.cod-cta-ctbl
                                   tt-mab-item-abastec.cod-ccusto   = tt-mab-item-abastec-lubrific.cod-ccusto.
                        END.
                    END.
    
                    /** Atualiza data invertida do Apontamento **/
                    run converteParaHoraInvertida (input string(tt-mab-item-abastec-lubrific.dt-movimento,"99/99/9999"),
                                                   input tt-mab-item-abastec-lubrific.hr-inicial,
                                                   output tt-mab-item-abastec.val-dat-hora-invrtda).
    
                    /** Busca Tipo Material e Flag de Abastecimento Prim†rio **/
                    run buscaTipoMaterial in h-abastec (input  tt-mab-item-abastec.ep-codigo,
                                                        input  tt-mab-item-abastec.cod-eqpto,
                                                        input  tt-mab-item-abastec.it-codigo,
                                                        input  tt-mab-item-abastec-lubrific.dt-movimento,
                                                        output tt-mab-item-abastec.cod-tip-mater,
                                                        output tt-mab-item-abastec.log-abastec-prim,
                                                        output deTanque).
                    /** Busca Valores para Moedas Alternativas **/
                    run piConverteMoeda in this-procedure (input  tt-mab-item-abastec.val-mater-1,
                                                           output tt-mab-item-abastec.val-mater-2,
                                                           output tt-mab-item-abastec.val-mater-3,
                                                           input  tt-mab-abastec-lubrific.dat-movto).
                    /*--- Limpa temp-table RowErrors no DBO ---*/
                    RUN emptyRowErrors IN h-abastec.
                    /*--- Transfere temp-table ttTarefa para o DBO ---*/
                    RUN setRecord IN h-abastec (INPUT TABLE tt-mab-item-abastec).
                    /*--- Cria registro ---*/
                    
                    RUN createRecord IN h-abastec.
                    if return-value = "NOK":U then do:
                        run getRowErrors in h-abastec (output table RowErrors).
                        return "NOK":U.
                    end.
                    ELSE DO:    
                        /* inserida mensagem de aviso para Nota Fiscal que a quantidade informada Ç maior que a capacidade do compartimento */
                        IF item-doc-est.quantidade > deTanque THEN DO:
                            run piCriaErro (30075, 'EMS':U, '').
                        END.
                    END.
                end.
                else do:
                    return "NOK":U.
                end.
            end.
            /**********************************************
            **             Lubrificaá∆o
            **********************************************/
            when 2 then do:
                /** Cria Ficha Abastec/Lubrific **/
                run pi-cria-ficha in this-procedure.
                if return-value = "OK":U then do:
                    /** Limpa Temp-Table **/
                    empty temp-table tt-mab-item-lubrific.
                    /** Cria temp-table de comunicaá∆o **/
                    create tt-mab-item-lubrific.
                    assign tt-mab-item-lubrific.num-docto            = tt-mab-abastec-lubrific.num-docto
                           tt-mab-item-lubrific.ep-codigo            = tt-mab-abastec-lubrific.ep-codigo
                           tt-mab-item-lubrific.cod-eqpto            = tt-mab-abastec-lubrific.cod-eqpto
                           tt-mab-item-lubrific.val-dat-hora-invrtda = tt-mab-abastec-lubrific.val-dat-hora-invrtda
                           tt-mab-item-lubrific.it-codigo            = item-doc-est.it-codigo
                           tt-mab-item-lubrific.cod-refer            = item-doc-est.cod-refer
                           tt-mab-item-lubrific.cod-localiz          = item-doc-est.cod-localiz
                           tt-mab-item-lubrific.lote                 = item-doc-est.lote
                           tt-mab-item-lubrific.val-mater-1          = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
                           tt-mab-item-lubrific.val-quant            = item-doc-est.quantidade
                           tt-mab-item-lubrific.r-rowid              = ?
                           /** Dados de Tela **/
                           tt-mab-item-lubrific.cod-evento           = tt-mab-item-abastec-lubrific.cod-evento
                           tt-mab-item-lubrific.cod-comptmento       = tt-mab-item-abastec-lubrific.cod-compart.
    
                    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
                        IF mab-param.des-valor = "1":U THEN DO:
                            ASSIGN tt-mab-item-lubrific.cod-cta-ctbl = tt-mab-item-abastec-lubrific.cod-cta-ctbl
                                   tt-mab-item-lubrific.cod-ccusto   = tt-mab-item-abastec-lubrific.cod-ccusto.
                        END.
                    END.
    
                    /** Atualiza data invertida do Apontamento **/
                    run converteParaHoraInvertida (input string(tt-mab-item-abastec-lubrific.dt-movimento,"99/99/9999"),
                                                   input tt-mab-item-abastec-lubrific.hr-inicial,
                                                   output tt-mab-item-lubrific.val-dat-hora-invrtda).
                    
                    /** Tipo de Manutená∆o Preventiva Padr∆o **/
                    for first mab-param fields(des-valor)
                        where mab-param.cdn-param = 27 no-lock:
                        assign tt-mab-item-lubrific.cd-tipo = integer(mab-param.des-valor).
                    end.

                   /** Grava Tipo de Material **/
                   run buscaTipoMaterial in h-lubrific (input  tt-mab-item-lubrific.ep-codigo,
                                                        input  tt-mab-item-lubrific.cod-eqpto,
                                                        input  tt-mab-item-lubrific.cod-comptmento,
                                                        input  tt-mab-item-lubrific.it-codigo,
                                                        output tt-mab-item-lubrific.cod-tip-mater,
                                                        output deTanque).

                    /** Busca Valores para Moedas Alternativas **/
                    run piConverteMoeda in this-procedure (input  tt-mab-item-lubrific.val-mater-1,
                                                           output tt-mab-item-lubrific.val-mater-2,
                                                           output tt-mab-item-lubrific.val-mater-3,
                                                           input  tt-mab-abastec-lubrific.dat-movto). 
                
                    /*--- Limpa temp-table RowErrors no DBO ---*/
                    RUN emptyRowErrors IN h-lubrific.
                    /*--- Transfere temp-table ttTarefa para o DBO ---*/
                    RUN setRecord IN h-lubrific (INPUT TABLE tt-mab-item-lubrific).
                    /*--- Cria registro ---*/
                    RUN createRecord IN h-lubrific.
                    if return-value = "NOK":U then do:
                        run getRowErrors in h-lubrific (output table RowErrors).
                        return "NOK":U.
                    end.
                    ELSE DO:
                        /* inserida mensagem de aviso para Nota Fiscal que a quantidade informada Ç maior que a capacidade do compartimento */
                        IF item-doc-est.quantidade > deTanque THEN DO:
                            run piCriaErro (30075, 'EMS':U, '').
                        END.
                    END.
                end.
                else do:
                    return "NOK":U.
                end.
            end.
            /**********************************************
            **         Outros (Pneus / Serviáos)
            **********************************************/
            when 3 then do:
                /** Limpa Temp-Table **/
                empty temp-table tt-mmv-movto-mater.
    
                for first item fields(ge-codigo)
                    where item.it-codigo = item-doc-est.it-codigo no-lock:
                end.
                create tt-mmv-movto-mater.
                assign /** Chave da Nota Fiscal **/
                       tt-mmv-movto-mater.cod-emitente    = v-cod-emitente
                       tt-mmv-movto-mater.nat-operacao    = v-nat-operacao
                       tt-mmv-movto-mater.nro-docto       = v-nro-docto
                       tt-mmv-movto-mater.sequencia       = v-sequencia
                       tt-mmv-movto-mater.serie-docto     = v-serie-docto
                       /** Dados de Tela **/
                       tt-mmv-movto-mater.ep-codigo       = tt-mab-item-abastec-lubrific.ep-codigo
                       tt-mmv-movto-mater.cod-eqpto       = tt-mab-item-abastec-lubrific.cod-eqpto
                       tt-mmv-movto-mater.cod-evento      = tt-mab-item-abastec-lubrific.cod-evento
                       tt-mmv-movto-mater.dat-movto       = tt-mab-item-abastec-lubrific.dt-movimento 
                       /** Dados do item da Nota **/
                       tt-mmv-movto-mater.it-codigo       = item-doc-est.it-codigo
                       tt-mmv-movto-mater.dsl-obs         = item-doc-est.narrativa
                       tt-mmv-movto-mater.qtd-item        = item-doc-est.quantidade
                       tt-mmv-movto-mater.val-mater-1     = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
                       /** Demais Dados **/
                       tt-mmv-movto-mater.ge-codigo       = item.ge-codigo
                       tt-mmv-movto-mater.esp-docto       = 21            /** NFE -  Nota Fiscal Entrada **/
                       tt-mmv-movto-mater.idi-espec-docto = 1             /** 1 = Nota Fiscal / 2 = Requisiá∆o **/
                       tt-mmv-movto-mater.log-saida       = yes           /** Sa°da do Estoque **/
                       /** Dados n∆o atualizados, pois n∆o existe Ordem Manutená∆o associada **/
                       tt-mmv-movto-mater.nr-ord-produ    = 0
                       tt-mmv-movto-mater.nr-trans        = 0
                       tt-mmv-movto-mater.num-seq         = 0
                       tt-mmv-movto-mater.num-seqcial     = 0.
                /** Busca Valores para Moedas Alternativas **/
                run piConverteMoeda in this-procedure (input  tt-mmv-movto-mater.val-mater-1,
                                                       output tt-mmv-movto-mater.val-mater-2,
                                                       output tt-mmv-movto-mater.val-mater-3,
                                                       input  tt-mmv-movto-mater.dat-movto). 
                /*--- Limpa temp-table RowErrors no DBO ---*/
                RUN emptyRowErrors IN h-material.
                /*--- Transfere temp-table ttTarefa para o DBO ---*/
                RUN setRecord IN h-material (INPUT TABLE tt-mmv-movto-mater).
                /*--- Cria registro ---*/
                RUN createRecord IN h-material.
                if return-value = "NOK":U then do:
                    run getRowErrors in h-material (output table RowErrors).
                    return "NOK":U.
                end.
            end.
        end case.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-cria-ficha :
/*------------------------------------------------------------------------------
  Purpose:     pi-cria-ficha
  Parameters:  <none>
  Notes:       Cria a ficha de Abastecimento / Lubrificaá∆o
------------------------------------------------------------------------------*/
    define buffer bfParam for mab-param.
    define buffer bfApont for mab-abastec-lubrific.
    DEFINE BUFFER bfEqpto FOR mab-eqpto.
    DEFINE VARIABLE dValDatHora AS DECIMAL.
    DEFINE VARIABLE cHistEstab LIKE mab-eqpto.cod-estabel NO-UNDO.
    
    DEFINE VARIABLE cConta     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cSub       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cContLub   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCCustoLub AS CHARACTER NO-UNDO.
    
    /** Limpa Temp-Table **/
    empty temp-table tt-mab-abastec-lubrific.
    /** Cria temp-table de comunicaá∆o **/
    create tt-mab-abastec-lubrific.
    /** Busca a numeraá∆o do Apontamento **/
    run buscaDocumento in h-ficha (output tt-mab-abastec-lubrific.num-docto).
    /** Busca Atividade e Conta Cont†bil do Hist¢rico Atividade Equipamento **/    
    run buscaAtividade in h-ficha (input  tt-mab-item-abastec-lubrific.ep-codigo,
                                   input  tt-mab-item-abastec-lubrific.cod-eqpto,
                                   input  tt-mab-item-abastec-lubrific.dt-movimento,
                                   output tt-mab-abastec-lubrific.cod-ativid,
                                   output cConta,
                                   output cSub,
                               &IF DEFINED(bf_mnt_ems206b) &THEN
                                   output tt-mab-abastec-lubrific.cod-unid-negoc,
                               &ELSE
                                   output tt-mab-abastec-lubrific.cod_unid_negoc,
                               &ENDIF
                                   OUTPUT cContLub,
                                   OUTPUT cCCustoLub,
                                   OUTPUT cHistEstab).
    
    assign /** Dados da Tela **/
           tt-mab-abastec-lubrific.ep-codigo           = tt-mab-item-abastec-lubrific.ep-codigo
           tt-mab-abastec-lubrific.cod-eqpto           = tt-mab-item-abastec-lubrific.cod-eqpto
           tt-mab-abastec-lubrific.val-hodom-horim     = tt-mab-item-abastec-lubrific.contador
           tt-mab-abastec-lubrific.val-hodom-horim-sec = tt-mab-item-abastec-lubrific.contador-sec
           tt-mab-abastec-lubrific.dat-movto           = tt-mab-item-abastec-lubrific.dt-movimento
           tt-mab-abastec-lubrific.hra-inicial         = tt-mab-item-abastec-lubrific.hr-inicial
           tt-mab-abastec-lubrific.hra-final           = tt-mab-item-abastec-lubrific.hr-inicial
           tt-mab-abastec-lubrific.cod-posto           = tt-mab-item-abastec-lubrific.posto
           tt-mab-abastec-lubrific.cod-usuar           = c-seg-usuario
           tt-mab-abastec-lubrific.cod-ativid          = tt-mab-item-abastec-lubrific.cod-ativid
           /** Dados da Nota Fiscal **/
           tt-mab-abastec-lubrific.serie               = v-serie-docto
           tt-mab-abastec-lubrific.sequencia           = v-sequencia
           tt-mab-abastec-lubrific.nr-nota-fis         = v-nro-docto
           tt-mab-abastec-lubrific.nat-operacao        = v-nat-operacao
           tt-mab-abastec-lubrific.cod-emitente        = v-cod-emitente
           tt-mab-abastec-lubrific.ct-codigo           = tt-mab-item-abastec-lubrific.cod-cta-ctbl
           tt-mab-abastec-lubrific.cc-codigo           = tt-mab-item-abastec-lubrific.cod-ccusto
           /** Dados Iniciais **/
           tt-mab-abastec-lubrific.log-consist         = no
           tt-mab-abastec-lubrific.idi-integr          = 2
           tt-mab-abastec-lubrific.idi-consist         = 1
           tt-mab-abastec-lubrific.r-rowid             = ?.

    /*  quando o parametro 55 estiver como sim, as informaá‰es de contas da ficha ser† igual a do historico de estabelecimento do equipamento.
        A conta informada no recebimento ser† a nivel de item, que Ç gravado na procedure pi-inclui deste programa */
    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
        IF mab-param.des-valor = "1":U THEN DO:
            ASSIGN tt-mab-abastec-lubrific.ct-codigo             = cConta
                   tt-mab-abastec-lubrific.cc-codigo             = cSub
                   tt-mab-abastec-lubrific.cod-cta-ctbl-lubrific = cContLub
                   tt-mab-abastec-lubrific.cod-ccusto-lubrific   = cCCustoLub.
        END.
    END.
    
    
    for each  mab-param fields(des-valor cdn-param)
        where mab-param.cdn-param = 7
        or    mab-param.cdn-param = 9 no-lock:
        case mab-param.cdn-param:
            /** Motorista **/
            when 7 then do:
                if mab-param.des-valor = "1":U then do:
                    assign tt-mab-abastec-lubrific.ep-codigo-matr   = tt-mab-item-abastec-lubrific.empresa-matr
                           tt-mab-abastec-lubrific.cod-estabel-matr = tt-mab-item-abastec-lubrific.estabel-matr
                           tt-mab-abastec-lubrific.cod-matr         = tt-mab-item-abastec-lubrific.cod-matr.
                end.
                else do:
                    assign &IF "{&mguni_version}" >= "2.071" &THEN
                               tt-mab-abastec-lubrific.ep-codigo-matr   = ""
                           &ELSE
                               tt-mab-abastec-lubrific.ep-codigo-matr   = 0
                           &ENDIF
                           tt-mab-abastec-lubrific.cod-estabel-matr = "":U
                           tt-mab-abastec-lubrific.cod-matr         = "":U.
                end.
            end.
            /** Trajeto **/
            when 9 then do:
                if mab-param.des-valor = "1":U then do:
                    assign tt-mab-abastec-lubrific.cod-rota = tt-mab-item-abastec-lubrific.cod-rota.
                end.
                else do:
                    assign tt-mab-abastec-lubrific.cod-rota = "":U.
                end.
            end.
        end case.
    end.
    
    /*--- Limpa temp-table RowErrors no DBO ---*/
    RUN emptyRowErrors IN h-ficha.
    /*--- Transfere temp-table ttTarefa para o DBO ---*/
    RUN setRecord IN h-ficha (INPUT TABLE tt-mab-abastec-lubrific).
    /*--- Cria registro ---*/
    RUN createRecord IN h-ficha.

    if return-value = "NOK":U then do:
        run getRowErrors in h-ficha (output table RowErrors).
        return "NOK":U.
    end.    
    ELSE DO:
        /** Atualiza o campo hora invertida. Ser† gravado no 
        formato "AAAAMMDDHHMM" (Ano+Màs+Dia+Hora+Minuto) **/
        run converteParaHoraInvertida  (input  string(tt-mab-item-abastec-lubrific.dt-movimento,"99/99/9999"),
                                        input  tt-mab-item-abastec-lubrific.hr-inicial,
                                        output dValDatHora).
    
        /* Verifica se contador informado Ç maior que contador anterior */
        for last  bfApont fields(val-hodom-horim ep-codigo cod-eqpto val-hodom-horim-sec)
            where bfApont.ep-codigo            =  tt-mab-item-abastec-lubrific.ep-codigo
            and   bfApont.cod-eqpto            =  tt-mab-item-abastec-lubrific.cod-eqpto        
            and   bfApont.val-dat-hora-invrtda <  dValDatHora NO-LOCK:
            IF bfApont.val-hodom-horim > tt-mab-item-abastec-lubrific.contador AND tt-mab-item-abastec-lubrific.contador <> 0 THEN DO:
                run piCriaErro (5545, 'EMS':U, '').
            END.
            FIND FIRST bfEqpto
                 WHERE bfEqpto.ep-codigo = bfApont.ep-codigo
                   AND bfEqpto.cod-eqpto = bfApont.cod-eqpto NO-LOCK NO-ERROR.
            IF  AVAIL bfEqpto AND bfEqpto.log-cont-sec THEN DO:
                IF  bfApont.val-hodom-horim-sec > tt-mab-item-abastec-lubrific.contador-sec AND tt-mab-item-abastec-lubrific.contador-sec <> 0 THEN DO:
                    RUN piCriaErro (5545, 'EMS':U, '').
                END.
            END.
        END.
    
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-alterar-abastec-lubrif:

    /** Busca a Ficha referente ao Documento Manutenido **/
    if can-find(first mab-abastec-lubrific
                where mab-abastec-lubrific.serie        = v-serie-docto      
                and   mab-abastec-lubrific.nr-nota-fis  = v-nro-docto        
                and   mab-abastec-lubrific.cod-emitente = v-cod-emitente     
                and   mab-abastec-lubrific.nat-operacao = v-nat-operacao     
                and   mab-abastec-lubrific.sequencia    = v-sequencia no-lock) then do:
        for first mab-abastec-lubrific
            where mab-abastec-lubrific.serie        = v-serie-docto      
            and   mab-abastec-lubrific.nr-nota-fis  = v-nro-docto        
            and   mab-abastec-lubrific.cod-emitente = v-cod-emitente     
            and   mab-abastec-lubrific.nat-operacao = v-nat-operacao     
            and   mab-abastec-lubrific.sequencia    = v-sequencia no-lock:
            /** Alteraá∆o **/
            run pi-altera-ficha in this-procedure.
        end.
    end.
    else do:
        if can-find(first mmv-movto-mater
                    where mmv-movto-mater.serie-docto  = v-serie-docto      
                    and   mmv-movto-mater.nro-docto    = v-nro-docto        
                    and   mmv-movto-mater.cod-emitente = v-cod-emitente     
                    and   mmv-movto-mater.nat-operacao = v-nat-operacao     
                    and   mmv-movto-mater.sequencia    = v-sequencia no-lock) then do:
            for first mmv-movto-mater
                where mmv-movto-mater.serie-docto  = v-serie-docto      
                and   mmv-movto-mater.nro-docto    = v-nro-docto        
                and   mmv-movto-mater.cod-emitente = v-cod-emitente     
                and   mmv-movto-mater.nat-operacao = v-nat-operacao     
                and   mmv-movto-mater.sequencia    = v-sequencia no-lock:
                /** Alteraá∆o dos Movimentos de Materiais **/
                run pi-altera-material in this-procedure.
            end.
        end.
    end.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-altera-ficha :
/*------------------------------------------------------------------------------
  Purpose:     pi-altera-ficha
  Parameters:  <none>
  Notes:       Alteraá∆o das Tabelas
------------------------------------------------------------------------------*/
    DEFINE VARIABLE deTanque AS DECIMAL NO-UNDO.   
    DEFINE VARIABLE dValDatHora AS DECIMAL.
    DEFINE VARIABLE cHistEstab LIKE mab-eqpto.cod-estabel NO-UNDO.

    DEFINE BUFFER bfApont FOR mab-abastec-lubrific.
    DEFINE BUFFER bfEqpto FOR mab-eqpto.

    for first item-doc-est
        where item-doc-est.serie-docto  = v-serie-docto      
        and   item-doc-est.nro-docto    = v-nro-docto        
        and   item-doc-est.cod-emitente = v-cod-emitente     
        and   item-doc-est.nat-operacao = v-nat-operacao     
        and   item-doc-est.sequencia    = v-sequencia no-lock:
        /**************************************************
        **                 ABASTECIMENTO                 **
        **************************************************/
        if can-find(first mab-item-abastec
                    where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
            for first mab-item-abastec
                where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock:
                /** Limpa Temp-Table **/
                empty temp-table tt-mab-item-abastec.
                /** Cria temp-table de comunicaá∆o **/
                create tt-mab-item-abastec.
                buffer-copy mab-item-abastec to tt-mab-item-abastec
                    assign tt-mab-item-abastec.r-rowid               = rowid(mab-item-abastec)
                           tt-mab-item-abastec.val-mater-1           = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
                           tt-mab-item-abastec.val-quant             = item-doc-est.quantidade.
                /** Dados de Tela **/
                ASSIGN tt-mab-item-abastec.ep-codigo    = tt-mab-item-abastec-lubrific.ep-codigo
                       tt-mab-item-abastec.cod-eqpto    = tt-mab-item-abastec-lubrific.cod-eqpto
                       tt-mab-item-abastec.cod-posto    = tt-mab-item-abastec-lubrific.posto
                       tt-mab-item-abastec.cod-cta-ctbl = tt-mab-item-abastec-lubrific.cod-cta-ctbl
                       tt-mab-item-abastec.cod-ccusto   = tt-mab-item-abastec-lubrific.cod-ccusto.
    
                /** Atualiza data invertida do Apontamento **/
                run converteParaHoraInvertida (input string(tt-mab-item-abastec-lubrific.dt-movimento,"99/99/9999"),
                                               input tt-mab-item-abastec-lubrific.hr-inicial,
                                               output tt-mab-item-abastec.val-dat-hora-invrtda).

                /** Busca Tipo Material e Flag de Abastecimento Prim†rio **/
                run buscaTipoMaterial in h-abastec (input  tt-mab-item-abastec.ep-codigo,
                                                    input  tt-mab-item-abastec.cod-eqpto,
                                                    input  tt-mab-item-abastec.it-codigo,
                                                    input  tt-mab-item-abastec-lubrific.dt-movimento,
                                                    output tt-mab-item-abastec.cod-tip-mater,
                                                    output tt-mab-item-abastec.log-abastec-prim,
                                                    output deTanque).

                /** Busca Valores para Moedas Alternativas **/
                run piConverteMoeda in this-procedure (input  tt-mab-item-abastec.val-mater-1,
                                                       output tt-mab-item-abastec.val-mater-2,
                                                       output tt-mab-item-abastec.val-mater-3,
                                                       input  mab-abastec-lubrific.dat-movto).        
                /*--- Limpa temp-table RowErrors no DBO ---*/
                RUN emptyRowErrors IN h-abastec.
                /*-- Posiciona registro a ser alterado na DBO --*/
                run repositionRecord in h-abastec (input tt-mab-item-abastec.r-rowid).
                /*--- Transfere temp-table ttTarefa para o DBO ---*/
                RUN setRecord IN h-abastec (INPUT TABLE tt-mab-item-abastec).
                /*--- Altera registro ---*/
                RUN updateRecord IN h-abastec.
                /*--- Busca temp-table RowErrors no DBO ---*/
                run getRowErrors in h-abastec (output table RowErrors).
                IF  CAN-FIND(FIRST RowErrors) THEN
                    RETURN "NOK":U.
                ELSE DO:
                    /* inserida mensagem de aviso para Nota Fiscal que a quantidade informada Ç maior que a capacidade do compartimento */
                    IF item-doc-est.quantidade > deTanque THEN DO:
                        run piCriaErro (30075, 'EMS':U, '').
                    END.
                END.
            end.
        end.
        /**************************************************
        **                 LUBRIFICAÄ«O                  **
        **************************************************/
        else do:
            if can-find(first mab-item-lubrific
                        where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
                for each  mab-item-lubrific
                    where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock:
                    /** Limpa Temp-Table **/
                    empty temp-table tt-mab-item-lubrific.
                    /** Cria temp-table de comunicaá∆o **/
                    create tt-mab-item-lubrific.
                    buffer-copy mab-item-lubrific to tt-mab-item-lubrific
                        assign tt-mab-item-lubrific.r-rowid              = rowid(mab-item-lubrific)
                               tt-mab-item-lubrific.val-mater-1          = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
                               tt-mab-item-lubrific.val-quant            = item-doc-est.quantidade.
                    /** Dados de Tela **/
                    ASSIGN tt-mab-item-lubrific.ep-codigo                = tt-mab-item-abastec-lubrific.ep-codigo
                           tt-mab-item-lubrific.cod-eqpto                = tt-mab-item-abastec-lubrific.cod-eqpto
                           tt-mab-item-lubrific.cod-evento               = tt-mab-item-abastec-lubrific.cod-evento
                           tt-mab-item-lubrific.cod-comptmento           = tt-mab-item-abastec-lubrific.cod-compart.

                    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
                        IF mab-param.des-valor = "1":U THEN DO:
                            ASSIGN tt-mab-item-lubrific.cod-cta-ctbl     = tt-mab-item-abastec-lubrific.cod-cta-ctbl
                                   tt-mab-item-lubrific.cod-ccusto       = tt-mab-item-abastec-lubrific.cod-ccusto.
                        END.
                    END.
                    
                    /** Atualiza data invertida do Apontamento **/
                    run converteParaHoraInvertida (input string(tt-mab-item-abastec-lubrific.dt-movimento,"99/99/9999"),
                                                   input tt-mab-item-abastec-lubrific.hr-inicial,
                                                   output tt-mab-item-lubrific.val-dat-hora-invrtda).

                   /** Grava Tipo de Material **/
                   run buscaTipoMaterial in h-lubrific (input  tt-mab-item-lubrific.ep-codigo,
                                                        input  tt-mab-item-lubrific.cod-eqpto,
                                                        input  tt-mab-item-lubrific.cod-comptmento,
                                                        input  tt-mab-item-lubrific.it-codigo,
                                                        output tt-mab-item-lubrific.cod-tip-mater,
                                                        output deTanque).

                    /** Busca Valores para Moedas Alternativas **/
                    run piConverteMoeda in this-procedure (input  tt-mab-item-lubrific.val-mater-1,
                                                           output tt-mab-item-lubrific.val-mater-2,
                                                           output tt-mab-item-lubrific.val-mater-3,
                                                           input  tt-mab-item-abastec-lubrific.dt-movimento). 
                
                    /*--- Limpa temp-table RowErrors no DBO ---*/
                    RUN emptyRowErrors IN h-lubrific.
                    /*-- Posiciona registro a ser alterado na DBO --*/
                    run repositionRecord in h-lubrific (input tt-mab-item-lubrific.r-rowid).
                    /*--- Transfere temp-table ttTarefa para o DBO ---*/
                    RUN setRecord IN h-lubrific (INPUT TABLE tt-mab-item-lubrific).
                    /*--- Altera registro ---*/
                    RUN updateRecord IN h-lubrific.
                    /*--- Busca temp-table RowErrors no DBO ---*/
                    run getRowErrors in h-lubrific (output table RowErrors).
                    IF  CAN-FIND(FIRST RowErrors) THEN
                        RETURN "NOK":U.
                    ELSE DO:
                        /* inserida mensagem de aviso para Nota Fiscal que a quantidade informada Ç maior que a capacidade do compartimento */
                        IF item-doc-est.quantidade > deTanque THEN DO:
                            run piCriaErro (30075, 'EMS':U, '').
                        END.
                    END.
                end.
            end.
        end.
        /**************************************************
        **                     FICHA                     **
        **************************************************/
        /** Limpa Temp-Table **/
        empty temp-table tt-mab-abastec-lubrific.
        /** Cria temp-table de comunicaá∆o **/
        create tt-mab-abastec-lubrific.
        buffer-copy mab-abastec-lubrific to tt-mab-abastec-lubrific
            assign tt-mab-abastec-lubrific.r-rowid         = rowid(mab-abastec-lubrific).

        assign /** Dados da Tela **/
               tt-mab-abastec-lubrific.ep-codigo           = tt-mab-item-abastec-lubrific.ep-codigo
               tt-mab-abastec-lubrific.cod-eqpto           = tt-mab-item-abastec-lubrific.cod-eqpto
               tt-mab-abastec-lubrific.val-hodom-horim     = tt-mab-item-abastec-lubrific.contador
               tt-mab-abastec-lubrific.val-hodom-horim-sec = tt-mab-item-abastec-lubrific.contador-sec
               tt-mab-abastec-lubrific.dat-movto           = tt-mab-item-abastec-lubrific.dt-movimento
               tt-mab-abastec-lubrific.hra-inicial         = tt-mab-item-abastec-lubrific.hr-inicial
               tt-mab-abastec-lubrific.hra-final           = tt-mab-item-abastec-lubrific.hr-inicial
               tt-mab-abastec-lubrific.cod-posto           = tt-mab-item-abastec-lubrific.posto
               tt-mab-abastec-lubrific.cod-ativid          = tt-mab-item-abastec-lubrific.cod-ativid
               tt-mab-abastec-lubrific.cod-usuar           = c-seg-usuario.

        /* Abastecimento */
        if  can-find(first mab-item-abastec
                    where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:               
            FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
                IF  mab-param.des-valor = "2":U THEN DO: /* N∆o */
                    ASSIGN tt-mab-abastec-lubrific.ct-codigo = tt-mab-item-abastec-lubrific.cod-cta-ctbl
                           tt-mab-abastec-lubrific.cc-codigo = tt-mab-item-abastec-lubrific.cod-ccusto.
                END.
            END.
        END.

        for each  mab-param fields(des-valor cdn-param)
            where mab-param.cdn-param = 7
            or    mab-param.cdn-param = 9 no-lock:
            case mab-param.cdn-param:
                /** Motorista **/
                when 7 then do:
                    if mab-param.des-valor = "1":U then do:
                        assign tt-mab-abastec-lubrific.ep-codigo-matr   = tt-mab-item-abastec-lubrific.empresa-matr
                               tt-mab-abastec-lubrific.cod-estabel-matr = tt-mab-item-abastec-lubrific.estabel-matr
                               tt-mab-abastec-lubrific.cod-matr         = tt-mab-item-abastec-lubrific.cod-matr.
                    end.
                    else do:
                        assign &IF "{&mguni_version}" >= "2.071" &THEN
                                   tt-mab-abastec-lubrific.ep-codigo-matr   = ""
                               &ELSE
                                   tt-mab-abastec-lubrific.ep-codigo-matr   = 0
                               &ENDIF
                               tt-mab-abastec-lubrific.cod-estabel-matr = "":U
                               tt-mab-abastec-lubrific.cod-matr         = "":U.
                    end.
                end.
                /** Trajeto **/
                when 9 then do:
                    if mab-param.des-valor = "1":U then do:
                        assign tt-mab-abastec-lubrific.cod-rota = tt-mab-item-abastec-lubrific.cod-rota.
                    end.
                    else do:
                        assign tt-mab-abastec-lubrific.cod-rota = "":U.
                    end.
                end.
            end case.
        end.

        /*--- Limpa temp-table RowErrors no DBO ---*/
        RUN emptyRowErrors IN h-ficha.
        /*-- Posiciona registro a ser alterado na DBO --*/
        run repositionRecord in h-ficha (input tt-mab-abastec-lubrific.r-rowid).
        /*--- Transfere temp-table ttTarefa para o DBO ---*/
        RUN setRecord IN h-ficha (INPUT TABLE tt-mab-abastec-lubrific).
        /*--- Altera registro ---*/
        RUN updateRecord IN h-ficha.
        /*--- Busca temp-table RowErrors no DBO ---*/
        run getRowErrors in h-ficha (output table RowErrors).
        IF  CAN-FIND(FIRST RowErrors) THEN
            RETURN "NOK":U.
        ELSE DO:
            /** Atualiza o campo hora invertida. Serˇ gravado no 
            formato "AAAAMMDDHHMM" (Ano+Mºs+Dia+Hora+Minuto) **/
            run converteParaHoraInvertida  (input  string(tt-mab-abastec-lubrific.dat-movto,"99/99/9999"),
                                            input  tt-mab-abastec-lubrific.hra-inicial,
                                            output dValDatHora).
        
            /* Verifica se contador informado ≤ maior que contador anterior */
            for last  bfApont fields(val-hodom-horim ep-codigo cod-eqpto val-hodom-horim-sec)
                where bfApont.ep-codigo            =  tt-mab-abastec-lubrific.ep-codigo
                and   bfApont.cod-eqpto            =  tt-mab-abastec-lubrific.cod-eqpto        
                and   bfApont.val-dat-hora-invrtda <  dValDatHora NO-LOCK:
                IF bfApont.val-hodom-horim > tt-mab-abastec-lubrific.val-hodom-horim AND tt-mab-abastec-lubrific.val-hodom-horim <> 0 THEN DO:
                    run piCriaErro (5545, 'EMS':U, '').
                END.
                FIND FIRST bfEqpto
                     WHERE bfEqpto.ep-codigo = bfApont.ep-codigo
                       AND bfEqpto.cod-eqpto = bfApont.cod-eqpto NO-LOCK NO-ERROR.
                IF  AVAIL bfEqpto AND bfEqpto.log-cont-sec THEN DO:
                    IF  bfApont.val-hodom-horim-sec > tt-mab-abastec-lubrific.val-hodom-horim-sec AND tt-mab-abastec-lubrific.val-hodom-horim-sec <> 0 THEN DO:
                        RUN piCriaErro (5545, 'EMS':U, '').
                    END.
                END.
            END.        
        END.
        
        if can-find(first mab-item-abastec
                    where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
            for first mab-item-abastec
                where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock:
                /* Chamada API Atualizaá∆o */
                run piParametroAPI in this-procedure (input tt-mab-item-abastec-lubrific.dt-movimento,
                                                      input tt-mab-item-abastec-lubrific.ep-codigo,
                                                      input tt-mab-item-abastec-lubrific.cod-eqpto,
                                                      INPUT tt-mab-abastec-lubrific.num-docto,
                                                      INPUT tt-mab-item-abastec-lubrific.posto).

                run piAtualizacao in THIS-PROCEDURE (INPUT 2). /* Alteraá∆o */
                IF  RETURN-VALUE = "NOK":U THEN
                    return "NOK":U.        
            END.
        END.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-altera-material :
/*------------------------------------------------------------------------------
  Purpose:     pi-altera-material
  Parameters:  <none>
  Notes:       Altera movimento de material
------------------------------------------------------------------------------*/
    for first item-doc-est
        where item-doc-est.serie-docto  = v-serie-docto      
        and   item-doc-est.nro-docto    = v-nro-docto        
        and   item-doc-est.cod-emitente = v-cod-emitente     
        and   item-doc-est.nat-operacao = v-nat-operacao     
        and   item-doc-est.sequencia    = v-sequencia no-lock:
        /** Limpa Temp-Table **/
        empty temp-table tt-mmv-movto-mater.
        /** Cria temp-table de comunicaá∆o **/
        create tt-mmv-movto-mater.
        buffer-copy mmv-movto-mater to tt-mmv-movto-mater
            assign tt-mmv-movto-mater.r-rowid     = rowid(mmv-movto-mater)
                   tt-mmv-movto-mater.dsl-obs     = item-doc-est.narrativa
                   tt-mmv-movto-mater.qtd-item    = item-doc-est.quantidade
                   tt-mmv-movto-mater.val-mater-1 = item-doc-est.preco-total[1] - item-doc-est.desconto[1].

        /** Dados de Tela **/
        assign tt-mmv-movto-mater.ep-codigo       = tt-mab-item-abastec-lubrific.ep-codigo
               tt-mmv-movto-mater.cod-eqpto       = tt-mab-item-abastec-lubrific.cod-eqpto
               tt-mmv-movto-mater.cod-evento      = tt-mab-item-abastec-lubrific.cod-evento
               tt-mmv-movto-mater.dat-movto       = tt-mab-item-abastec-lubrific.dt-movimento.

        /** Busca Valores para Moedas Alternativas **/
        run piConverteMoeda in this-procedure (input  tt-mmv-movto-mater.val-mater-1,
                                               output tt-mmv-movto-mater.val-mater-2,
                                               output tt-mmv-movto-mater.val-mater-3,
                                               input  tt-mmv-movto-mater.dat-movto).
        /*--- Limpa temp-table RowErrors no DBO ---*/
        RUN emptyRowErrors IN h-material.
        /*-- Posiciona registro a ser alterado na DBO --*/
        run repositionRecord in h-material (input tt-mmv-movto-mater.r-rowid).
        /*--- Transfere temp-table ttTarefa para o DBO ---*/
        RUN setRecord IN h-material (INPUT TABLE tt-mmv-movto-mater).
        /*--- Altera registro ---*/
        RUN updateRecord IN h-material.
        /*--- Busca temp-table RowErrors no DBO ---*/
        run getRowErrors in h-material (output table RowErrors).
        IF  CAN-FIND(FIRST RowErrors) THEN
            RETURN "NOK":U.
    end.
    
    return "OK":U.
END PROCEDURE.

PROCEDURE piParametroAPI :
/*------------------------------------------------------------------------------
  Purpose:     piParametroAPI
  Parameters:  entrada pData    = Data do Movimento
               entrada pEmpresa = Codigo da Empresa
               entrada pEqpto   = Codigo do Equipamento
               entrada pDocto   = Numero do Documento
  Notes:       Cria a temp-table de parametros para a atualizacao on-line
               (tt-param)
------------------------------------------------------------------------------*/
    define input parameter pData    as date format "99/99/9999" no-undo.
    define input parameter pEmpresa LIKE mab-item-abastec.ep-codigo no-undo.
    define input parameter pEqpto   as character                no-undo.
    define input parameter pDocto   as integer                  no-undo.
    define input parameter pPosto   as character                no-undo.
    
    DEFINE VARIABLE c-valor-param53 LIKE mab-param.des-valor NO-UNDO.
    DEFINE VARIABLE deDataInvertida AS DECIMAL               NO-UNDO.
    
    DEFINE BUFFER bf-mab-abastec-lubrific FOR mab-abastec-lubrific.
    
    empty temp-table tt-param.
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = 1
           tt-param.arquivo         = ""
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.iConsiste       = 2 /** Todas as Fichas **/
           tt-param.descConsiste    = "Todos":U
           tt-param.iEmpIni         = pEmpresa
           tt-param.iEmpFim         = pEmpresa
           tt-param.cEqptoIni       = pEqpto
           tt-param.cEqptoFim       = pEqpto
           tt-param.num-docto       = pDocto
           tt-param.lFicha          = yes
           tt-param.tipo-liberacao  = 1 /** Normal **/
           tt-param.cCCini          = ""
           tt-param.cCCfim          = "ZZZZZZZZ"
           tt-param.cPostoIni       = pPosto
           tt-param.cPostoFim       = pPosto
           tt-param.cEstabIni       = ""
           tt-param.cEstabFim       = "ZZZZZ"
           tt-param.cTagIni         = ""
           tt-param.cTagFim         = "ZZZZZZZZZZZZZZZZ".
    
    FOR FIRST bf-mab-abastec-lubrific
        WHERE bf-mab-abastec-lubrific.num-docto = pDocto NO-LOCK:
        ASSIGN deDataInvertida = bf-mab-abastec-lubrific.val-dat-hora-invrtda.
    
        &IF DEFINED(bf_mnt_ems206b) &THEN
            ASSIGN tt-param.cUnidNegocIni = bf-mab-abastec-lubrific.cod-unid-negoc
                   tt-param.cUnidNegocFim = bf-mab-abastec-lubrific.cod-unid-negoc.
        &ENDIF
    END.
    
    FOR FIRST mab-param
        WHERE mab-param.cdn-param = 53 NO-LOCK:
        ASSIGN c-valor-param53 = mab-param.des-valor.
    END.
    
    /** Se parametrizado para consistir todas as fichas posteriores a validada, 
        retira chamada somente para o documento e coloca data final como atual **/
    IF c-valor-param53 = "1":U THEN DO:
        ASSIGN tt-param.dataIni   = pData
               tt-param.dataFim   = TODAY
               tt-param.num-docto = ?.
    END.
    ELSE DO:
        ASSIGN tt-param.dataIni   = pData
               tt-param.dataFim   = pData
               tt-param.num-docto = pDocto.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piAtualizacao :
/*------------------------------------------------------------------------------
  Purpose:     piAtualizacao
  Parameters:  entrada pAcao = Acao (1 = Inclusao/2 = Alteracao)
  Notes:       Chama a API de Atualizacao das fichas de abastecimento/lubrificacao
------------------------------------------------------------------------------*/
    define input parameter pAcao as integer no-undo.

    /*Quando exclu≠da a ficha, prepara para a atualizacao dos pneus*/
    IF  pAcao = 2 THEN DO:
        FOR EACH mab-param FIELDS (des-valor cdn-param)
           WHERE mab-param.cdn-param = 25 
              OR mab-param.cdn-param = 26  
              OR mab-param.cdn-param = 49  NO-LOCK:
            CASE mab-param.cdn-param:
                WHEN 25 THEN
                    ASSIGN param25 = mab-param.des-valor. 
                WHEN 26 THEN
                    ASSIGN param26 = mab-param.des-valor. 
                WHEN 49 THEN
                    ASSIGN param49 = mab-param.des-valor. 
            END CASE.
        END.
             
        IF param25 = "1" AND param26 = "1" AND param49 = "1" THEN 
            RUN piAtualizaPneu IN THIS-PROCEDURE.
    END.    
    
    if  can-find(first mab-param /*Parametro 11 - Consiste Ficha*/
                 where mab-param.cdn-param = 11 no-lock) then do:

        for first mab-param fields(des-valor)
            where mab-param.cdn-param = 11 no-lock:

            if mab-param.des-valor = '1':U then do: /*1 - Online, 2 - Batch*/
                run abp/abapi001.p (input  table tt-param,
                                    output table RowErrors,
                                    output table ttDocLib).                                    
                if  can-find(first RowErrors) then do:
                    RETURN "NOK":U.
                end.
            end.
        end.
    end.
    
    return "OK":U.
END PROCEDURE.

PROCEDURE piAtualizaPneu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*Para exclusao nao ≤ necessario validar se a ficha esta integrada ou nao*/
    FIND FIRST tt-param NO-LOCK NO-ERROR.

    /*Verifica os pneus no equipamento*/
    FOR EACH mpn-pneu FIELDS(cod-eqpto-inicial cod-eqpto-atual ep-codigo-atual cod-pneu)
       WHERE mpn-pneu.ep-codigo-atual   >= tt-param.iEmpIni
         AND mpn-pneu.ep-codigo-atual   <= tt-param.iEmpFim
         AND mpn-pneu.cod-eqpto-atual   >= tt-param.cEqptoIni
         AND mpn-pneu.cod-eqpto-atual   <= tt-param.cEqptoFim
         AND mpn-pneu.cod-estabel-atual >= tt-param.cEstabIni
         AND mpn-pneu.cod-estabel-atual <= tt-param.cEstabFim NO-LOCK:

        EMPTY TEMP-TABLE tt-param-aux.
        /*Criacao da tt-param que serˇ enviada para a pnapi002. Esta temp-table serˇ criada para cada */    
        /*pneu atual do equipamento                                                                   */
        CREATE tt-param-aux.
        ASSIGN tt-param-aux.destino   = tt-param.destino
               tt-param-aux.arquivo   = tt-param.arquivo 
               tt-param-aux.usuario   = tt-param.usuario    
               tt-param-aux.data-exec = tt-param.data-exec  
               tt-param-aux.hora-exec = tt-param.hora-exec  
               tt-param-aux.empIni    = tt-param.iEmpIni  
               tt-param-aux.empFim    = tt-param.iEmpFim  
               tt-param-aux.eqptoIni  = tt-param.cEqptoIni
               tt-param-aux.eqptoFim  = tt-param.cEqptoFim
               tt-param-aux.estabIni  = tt-param.cEstabIni
               tt-param-aux.estabFim  = tt-param.cEstabFim
               tt-param-aux.pneuIni   = mpn-pneu.cod-pneu 
               tt-param-aux.pneuFim   = mpn-pneu.cod-pneu 
               tt-param-aux.tag-ini   = tt-param.cTagIni 
               tt-param-aux.tag-fim   = tt-param.cTagFim 
               tt-param-aux.cc-ini    = tt-param.cCCini 
               tt-param-aux.cc-fim    = tt-param.cCCfim 
               tt-param-aux.dataIni   = (TODAY - 30)
               tt-param-aux.numDias   = 30 
               tt-param-aux.rRowid    = ?.
        /** Roda API geracao KM **/
        RUN pnp/pnapi002.p (INPUT  TABLE tt-param-aux,
                            OUTPUT TABLE RowErrorsAux).

        /** Verifica se ocorreram erros **/
        IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
            FOR LAST RowErrors NO-LOCK:
                ASSIGN iErro = RowErrors.ErrorSequence.
            END.
        END.
        ELSE 
            ASSIGN iErro = 0.
        FOR EACH RowErrorsAux NO-LOCK:
            ASSIGN iErro = iErro + 1.
            CREATE RowErrors.
            BUFFER-COPY RowErrorsAux EXCEPT ErrorSequence TO RowErrors
                ASSIGN RowErrors.ErrorSequence = iErro.
        END.
    END.

    RETURN "OK":U.              
END PROCEDURE.
