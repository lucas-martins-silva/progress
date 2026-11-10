&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : api-ab0708f.i
    
    Notes       : api de importaá∆o da p†gina 5 do AB0708
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* temp-tables*/
DEFINE TEMP-TABLE tt-mab-comptmento-eqpto     LIKE mab-comptmento-eqpto   FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-eqpto-caract         LIKE mab-eqpto-caract       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-configur-eixo        LIKE mab-configur-eixo      FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-histor-combust       LIKE mab-histor-combust     FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-histor-ativid        LIKE mab-histor-ativid      FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-period-manut         LIKE mab-period-manut       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-eqpto                LIKE mab-eqpto              FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mmv-eqpto-plano          LIKE mmv-eqpto-plano        FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-histor-layout-eixo   LIKE mpn-histor-layout-eixo FIELD r-Rowid AS ROWID.
define temp-table tt-mpn-histor-vida          like mpn-histor-vida        field r-Rowid as Rowid.
define temp-table tt-mab-relac-eqpto-sub-sist like mab-relac-eqpto-sub-sist field r-Rowid as rowid.
define temp-table tt-mab-eqpto-sub-sist       like mab-eqpto-sub-sist     field r-Rowid as rowid.


DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.

define temp-table tt-dados no-undo
            FIELD i-chave        AS INT
            field linha          as int
            field erro           as int
            field descricao      as char format "x(70)":U
            field tabela         as char format "x(30)":U
            field modulo         as char format "x(50)":U
            field cod-tabela     as char format "x(5)":U
            field des-tabela     as char format "x(40)":U
            field des-tab        as char format "x(30)":U
    index id is primary unique i-chave tabela ASCENDING.

{abp/ab0708.i1}

/* variaveis */
DEFINE VARIABLE h-tabela  AS HANDLE         NO-UNDO.
DEFINE VARIABLE c-cont    AS INTEGER INIT 1 NO-UNDO.
DEFINE VARIABLE c-cont2   AS INTEGER INIT 1 NO-UNDO.
DEFINE VARIABLE c-caminho AS CHARACTER      NO-UNDO.

define input parameter table for tt-param.
DEFINE VARIABLE h-cabecalho AS HANDLE     NO-UNDO.

DEFINE VARIABLE l-primeiro AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 12.38
         WIDTH              = 33.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
run abp/api-ab0708h.i persistent set h-cabecalho (input table tt-param).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-mab-comptmento-eqpto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-comptmento-eqpto Procedure 
PROCEDURE pi-mab-comptmento-eqpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE de-km-ult-troca    AS INTEGER    NO-UNDO.
DEFINE VARIABLE de-km-atual        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE c-cod-evento-troca AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-period-troca    AS DECIMAL    NO-UNDO.

/** Valida Se parÉmetros est∆o OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens Ç Iniciado **/
assign c-cont2 = 1.
/******************************************
** Validaá∆o do Destino da Importaá∆o
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr004.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr004").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Compartimentos do Equipamento","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Compartimentos do Equipamento","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr004.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** Là os Compartimentos de ‡leo **/
FOR EACH mb.mbpadracomp NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-comptmento-eqpto.
    CREATE tt-mab-comptmento-eqpto.

    ASSIGN tt-mab-comptmento-eqpto.ep-codigo      = mb.mbpadracomp.codiempr
           tt-mab-comptmento-eqpto.cod-eqpto      = STRING(mb.mbpadracomp.numeequi)
           tt-mab-comptmento-eqpto.cod-comptmento = string(mb.mbpadracomp.codicomp,"9999")
           tt-mab-comptmento-eqpto.cod-tip-mater  = string(mb.mbpadracomp.codicolu,"999")
           tt-mab-comptmento-eqpto.idi-remonta    = mb.mbpadracomp.trocremo
           tt-mab-comptmento-eqpto.qtd-capac      = mb.mbpadracomp.quant
           tt-mab-comptmento-eqpto.val-km-inicial = 0
           tt-mab-comptmento-eqpto.val-perc-remon = 0
           tt-mab-comptmento-eqpto.cod-sub-sist   = tt-param.c-sub-sist-oleo.

    /** Busca a Data de Inclus∆o **/
    for first mb.equipamento
        where mb.equipamento.codiempr  = mb.mbpadracomp.codiempr
        and   mb.equipamento.numeequi  = mb.mbpadracomp.numeequi no-lock:
        /** Busca Modelo X Compartiemnto de ‡leo **/
        for FIRST mb.modelcompa 
            where mb.modelcompa.codimode = mb.equipamento.codimode 
            AND   mb.modelcompa.codicomp = mb.mbpadracomp.codicomp no-lock:
            ASSIGN de-km-ult-troca = 0
                   de-period-troca = mb.modelcompa.peritroc.
            /** Busca £ltima vida do equipamento para atualizar os KM **/
            FOR LAST  mb.equipvida USE-INDEX i-equipvida2
                WHERE mb.equipvida.codiempr = mb.equipamento.codiempr
                AND   mb.equipvida.numeequi = mb.equipamento.numeequi NO-LOCK:
                ASSIGN de-km-atual = mb.equipvida.vida.
            END.
            /** Busca a £ltima troca de ¢leo para o equipamento **/
            for last  mb.diarilubri
                where mb.diarilubri.codiempr = mb.equipamento.codiempr
                and   mb.diarilubri.numeequi = mb.equipamento.numeequi
                and   mb.diarilubri.codicomp = mb.prevlubrifilt.codigo
                and   mb.diarilubri.trocremo = 1 use-index i-diarilubri4 no-lock:
                /** AtravÇs da data da troca, busca a vida do equipamento nesta data **/
                for first mb.equipvida
                    where mb.equipvida.codiempr = mb.diarilubri.codiempr
                    and   mb.equipvida.numeequi = mb.diarilubri.numeequi
                    and   mb.equipvida.data     = mb.diarilubri.data
                    and   mb.equipvida.numedocu = mb.diarilubri.numedocu use-index i-equipvida2 no-lock:
                    assign de-km-ult-troca = mb.equipvida.vida.
                END.
            END.
        END.
        assign tt-mab-comptmento-eqpto.dat-inicial    = if mb.equipamento.datainic = ? then today else mb.equipamento.datainic
               tt-mab-comptmento-eqpto.val-km-inicial = IF  (de-km-atual - de-km-ult-troca >= 0) 
                                                        THEN de-km-atual - de-km-ult-troca 
                                                        ELSE 0.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-comptmento-eqpto except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-comptmento-eqpto).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Compartimento do Equipamento","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-comptmento-eqpto"
                       tt-dados.cod-tabela = tt-mab-comptmento-eqpto.cod-comptmento
                       tt-dados.des-tabela = ""
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Compartimento do Equipamento","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-comptmento-eqpto.cod-comptmento
                   tt-dados.des-tabela = ""
                   tt-dados.tabela     = "mab-comptmento-eqpto"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

/** Là os Compartimentos de Filtro **/
FOR EACH mb.mbpadrafilt NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-comptmento-eqpto.
    CREATE tt-mab-comptmento-eqpto.
    
    ASSIGN tt-mab-comptmento-eqpto.ep-codigo      = mb.mbpadrafilt.codiempr
           tt-mab-comptmento-eqpto.cod-eqpto      = STRING(mb.mbpadrafilt.numeequi)
           tt-mab-comptmento-eqpto.cod-comptmento = STRING(mb.mbpadrafilt.codifilt,"9999")
           tt-mab-comptmento-eqpto.cod-tip-mater  = string(mb.mbpadrafilt.codifilt,"999")  /** Verificar posteriormente, para saber de onde busca este tipo de material (em tela ou de tabela)**/
           tt-mab-comptmento-eqpto.idi-remonta    = 1
           tt-mab-comptmento-eqpto.qtd-capac      = 1  /** Sempre 1 ser† a qtd **/
           tt-mab-comptmento-eqpto.val-km-inicial = 0
           tt-mab-comptmento-eqpto.val-perc-remon = 0
           tt-mab-comptmento-eqpto.cod-sub-sist   = tt-param.c-sub-sist-filtro.
    /** Busca a Data de Inclus∆o **/
    for first mb.equipamento
        where mb.equipamento.codiempr  = mb.mbpadrafilt.codiempr
        and   mb.equipamento.numeequi  = mb.mbpadrafilt.numeequi no-lock:
        /** Busca Modelo X Filtro **/
        for FIRST mb.modelfiltr 
            where mb.modelfiltr.codimode = mb.equipamento.codimode 
            AND   mb.modelfiltr.codicomp = mb.mbpadrafilt.codifilt no-lock:
            EMPTY TEMP-TABLE  tt-mab-period-manut.
            CREATE tt-mab-period-manut.
            ASSIGN de-km-ult-troca = 0
                   de-period-troca = mb.modelfiltr.peritroc.
            /** Busca £ltima vida do equipamento para atualizar os KM **/
            FOR LAST  mb.equipvida USE-INDEX i-equipvida2
                WHERE mb.equipvida.codiempr = mb.equipamento.codiempr
                AND   mb.equipvida.numeequi = mb.equipamento.numeequi NO-LOCK:
                ASSIGN de-km-atual = mb.equipvida.vida.
            END.
            /** Busca a £ltima troca de ¢leo para o equipamento **/
            for last  mb.diarifiltr
                where mb.diarifiltr.codiempr = mb.equipamento.codiempr
                and   mb.diarifiltr.numeequi = mb.equipamento.numeequi
                and   mb.diarifiltr.codifilt = mb.prevlubrifilt.codigo use-index i-diarifiltr4 no-lock:
                /** AtravÇs da data da troca, busca a vida do equipamento nesta data **/
                for first mb.equipvida
                    where mb.equipvida.codiempr = mb.diarifiltr.codiempr
                    and   mb.equipvida.numeequi = mb.diarifiltr.numeequi
                    and   mb.equipvida.data     = mb.diarifiltr.data
                    and   mb.equipvida.numedocu = mb.diarifiltr.numedocu use-index i-equipvida2 no-lock:
                    assign de-km-ult-troca = mb.equipvida.vida.
                END.
            END.
        END.
        assign tt-mab-comptmento-eqpto.dat-inicial    = if mb.equipamento.datainic = ? then today else mb.equipamento.datainic
               tt-mab-comptmento-eqpto.val-km-inicial = IF  (de-km-atual - de-km-ult-troca >= 0) 
                                                        THEN de-km-atual - de-km-ult-troca 
                                                        ELSE 0.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-comptmento-eqpto except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-comptmento-eqpto).
        RUN createRecord in h-tabela.

        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Filtro do Equipamento","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-comptmento-eqpto"
                       tt-dados.cod-tabela = tt-mab-comptmento-eqpto.cod-comptmento
                       tt-dados.des-tabela = ""
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Filtro do Equipamento","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-comptmento-eqpto.cod-comptmento
                   tt-dados.des-tabela = ""
                   tt-dados.tabela     = "mab-comptmento-eqpto"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-configur-eixo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-configur-eixo Procedure 
PROCEDURE pi-mab-configur-eixo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa cofiguraá∆o do eixo*/
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parÉmetros est∆o OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens Ç Iniciado **/
assign c-cont2 = 1.
/******************************************
** Validaá∆o do Destino da Importaá∆o
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr005.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr005").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Configuraá∆o Eixos Equipamento","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Configuraá∆o Eixos Equipamento","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
if NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr005.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.equiptracao NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-configur-eixo. 
    CREATE tt-mab-configur-eixo.
    
    ASSIGN tt-mab-configur-eixo.ep-codigo          = mb.equiptracao.codiempr
           tt-mab-configur-eixo.cod-eqpto          = STRING (mb.equiptracao.numeequi)
           tt-mab-configur-eixo.num-eixo           = mb.equiptracao.eixo
           tt-mab-configur-eixo.val-percent-suspen = mb.equiptracao.porcsusp
           tt-mab-configur-eixo.log-eixo-tracao    = mb.equiptracao.coditrac
           tt-mab-configur-eixo.log-eixo-dpl       = mb.equiptracao.codidupli.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-configur-eixo except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-configur-eixo).
        RUN createRecord in h-tabela.
    
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Configuraá∆o Eixo","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-configur-eixo":U
                       tt-dados.cod-tabela = STRING (tt-mab-configur-eixo.num-eixo)
                       tt-dados.des-tabela = tt-mab-configur-eixo.cod-eqpto
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Configuraá∆o Eixo","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = STRING (tt-mab-configur-eixo.num-eixo)
                   tt-dados.des-tabela = tt-mab-configur-eixo.cod-eqpto
                   tt-dados.tabela     = "mab-configur-eixo":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

if valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-eqpto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-eqpto Procedure 
PROCEDURE pi-mab-eqpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parÉmetros est∆o OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens Ç Iniciado **/
assign c-cont2 = 1.
/******************************************
** Validaá∆o do Destino da Importaá∆o
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 AND tt-param.i-km-eqpto = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr007.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr007").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Equipamento","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    /** Processo Normal (Inclus∆o) **/
    IF tt-param.i-km-eqpto = 1 THEN
        run utp/ut-liter.p (input "Atualizando tabela Equipamento","*","").
    ELSE 
        run utp/ut-liter.p (input "Atualizando KM Inicial Equipamento","*","").

/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) OR
   h-tabela:TYPE <> "PROCEDURE":U OR
   h-tabela:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
    RUN  frbo/bofr007.p PERSISTENT SET  h-tabela.
end.

RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** Là os Equipamentos Motorizados **/
FOR EACH mb.equipamento NO-LOCK:

    empty temp-table tt-mab-eqpto.

    /** Processo Normal **/
    IF tt-param.i-km-eqpto = 1 THEN DO:
        create tt-mab-eqpto.

        ASSIGN tt-mab-eqpto.ep-codigo               = mb.equipamento.codiempr
               tt-mab-eqpto.cod-eqpto               = STRING(mb.equipamento.numeequi)
               tt-mab-eqpto.cod-model               = STRING(mb.equipamento.codimode + 1000,"99999")
               tt-mab-eqpto.idi-tip-eqpto           = 1   /** Motorizado **/
               /** Dados Terceiros **/              
               tt-mab-eqpto.idi-tip-propriet        = 1   /** Pr¢prio **/
               tt-mab-eqpto.cod-emitente            = 0
               /** Datas **/                        
               tt-mab-eqpto.dat-inicial             = if mb.equipamento.datainic = ? then today else mb.equipamento.datainic
               tt-mab-eqpto.vli-ano-fabric          = mb.equipamento.anofabri 
               tt-mab-eqpto.vli-ano-model           = mb.equipamento.anomodel 
               /** Dados Compra **/                 
               tt-mab-eqpto.dat-compra              = if mb.equipamento.datacomp = ? then tt-mab-eqpto.dat-inicial else mb.equipamento.datacomp
               tt-mab-eqpto.cdn-fornecedor          = 0
               tt-mab-eqpto.val-compra              = 0
               /** Situaá∆o **/                     
               tt-mab-eqpto.cod-sit-eqpto           = string(mb.equipamento.codisitu + 100,"999")
               tt-mab-eqpto.dat-situacao            = ?
               /** Dados do Hist¢rico, ser∆o atualizados pelo Hist¢rico **/           
               tt-mab-eqpto.ct-codigo               = "":U /**  **/
               tt-mab-eqpto.cc-codigo               = STRING(mb.equipamento.centcusto)
               tt-mab-eqpto.cod-ccusto-alter        = STRING(mb.equipamento.centcusto)
               tt-mab-eqpto.cod-grp-eqpto           = string(mb.equipamento.codiclop,"999")
               tt-mab-eqpto.cd-tag                  = "":U
               tt-mab-eqpto.cod-pais                = "":U
               tt-mab-eqpto.cod-estado              = "":U
               tt-mab-eqpto.cod-cidade              = "":U
               tt-mab-eqpto.cod-estabel             = string(mb.equipamento.codiseto)
               tt-mab-eqpto.cod_unid_negoc          = "":U
               /** Dados Adicionais **/             
               tt-mab-eqpto.cod-chassi              = string(mb.equipamento.numechas)
               tt-mab-eqpto.cod-placa               = string(mb.equipamento.placa-atual)
               tt-mab-eqpto.cod-renavam             = "":U /** N∆o Encontrado **/
               /** Bem Patrimonial n∆o informa **/
               tt-mab-eqpto.bm-codigo               = 0
               tt-mab-eqpto.bm-indice               = 0
               tt-mab-eqpto.cod-cta-pat             = "":U.
        /** Atualizaá∆o da parte documentacional **/
        for first mb.veiculos
            where mb.veiculos.codiespe = 1
            and   mb.veiculos.codiempr = mb.equipamento.codiempr
            and   mb.veiculos.numeequi = mb.equipamento.numeequi no-lock:
            assign tt-mab-eqpto.cod-chassi  = mb.veiculos.num-chassi
                   tt-mab-eqpto.cod-placa   = mb.veiculos.placa-atual
                   tt-mab-eqpto.cod-renavam = string(mb.veiculos.cod-renavam).
        end.
        /** Busca Situaá∆o do Equipamento para colcoar data de inatividade **/
        for first mab-sit-eqpto
            where mab-sit-eqpto.cod-sit-eqpto = tt-mab-eqpto.cod-sit-eqpto no-lock:
            if mab-sit-eqpto.idi-tip = 2 then
                assign tt-mab-eqpto.dat-situacao = mb.equipamento.datadesa.
        end.
        /** Busca a Estrutura MecÉnica do Modelo do Equipamento **/
        for first mb.modelo
            where mb.modelo.codimode = mb.equipamento.codimode no-lock:
            assign tt-mab-eqpto.cod-estrut-mec = string(mb.modelo.codiclme,"999").
        end.
        /** De-Para de Estabelecimento **/
        for first tt-estabelec
            where tt-estabelec.cod-nop = string(mb.equipamento.codiseto) no-lock:
            assign tt-mab-eqpto.cod-estabel = tt-estabelec.cod-estabel.
        end.
    END.
    ELSE DO:
        /** Busca o Registro **/
        RUN goToKey IN h-tabela (INPUT mb.equipamento.codiempr,
                                 INPUT STRING(mb.equipamento.numeequi)).
        IF RETURN-VALUE = "OK":U THEN DO:
            /** Busca o registro da BO **/
            RUN getRecord IN h-tabela (OUTPUT TABLE tt-mab-eqpto).
            FOR FIRST tt-mab-eqpto EXCLUSIVE-LOCK: END.
        END.
        ELSE DO:
            CREATE tt-mab-eqpto.
            ASSIGN tt-mab-eqpto.ep-codigo               = mb.equipamento.codiempr
                   tt-mab-eqpto.cod-eqpto               = STRING (mb.equipamento.numeequi).
        END.
    END.

    /** KM e Hodìmetro atual do equipamento no SISMA ser∆o os iniciais no Frotas **/
    ASSIGN tt-mab-eqpto.val-hodom-horim-inicial = mb.equipamento.vidainic
           tt-mab-eqpto.val-km-inicial          = mb.equipamento.vidainic.
    /** Busca £ltima vida do equipamento para atualizar os KM **/
    FOR LAST  mb.equipvida USE-INDEX i-equipvida2
        WHERE mb.equipvida.codiempr = mb.equipamento.codiempr
        AND   mb.equipvida.numeequi = mb.equipamento.numeequi NO-LOCK:
        ASSIGN tt-mab-eqpto.val-km-inicial          = mb.equipvida.vida
               tt-mab-eqpto.val-hodom-horim-inicial = mb.equipvida.vida.
        /** Busca o Contador na Ficha de Abastecimento **/
        FOR FIRST mb.diarigeral
            WHERE mb.diarigeral.numedocu = mb.equipvida.numedocu NO-LOCK:
            ASSIGN tt-mab-eqpto.val-hodom-horim-inicial = mb.diarigeral.medicao.
        END.
    END.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 AND tt-param.i-km-eqpto = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-eqpto except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables RowErrors no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-eqpto).
        /** Processo Normal (Inclus∆o) **/
        IF tt-param.i-km-eqpto = 1 THEN
            RUN createRecord in h-tabela.
        /** Atualizaá∆o dos KMs **/
        ELSE 
            RUN updateRecord IN h-tabela.

        IF RETURN-VALUE = "NOK" THEN DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Equipamento","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-eqpto":U
                       tt-dados.cod-tabela = tt-mab-eqpto.cod-eqpto
                       tt-dados.des-tabela = tt-mab-eqpto.cod-model
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Equipamento","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-eqpto.cod-eqpto
                   tt-dados.des-tabela = tt-mab-eqpto.cod-model
                   tt-dados.tabela     = "mab-eqpto"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.
/******************************************
** Importaá∆o dos Implementos 
******************************************/
RUN pi-mab-eqpto-2 IN THIS-PROCEDURE.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-eqpto-2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-eqpto-2 Procedure 
PROCEDURE pi-mab-eqpto-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Là os Equipamentos N∆o Motorizados **/
FOR EACH mb.implemento NO-LOCK:
    empty temp-table tt-mab-eqpto.

    /** Processo Normal **/
    IF tt-param.i-km-eqpto = 1 THEN DO:
        create tt-mab-eqpto.
        ASSIGN tt-mab-eqpto.ep-codigo               = mb.implemento.codiempr
               tt-mab-eqpto.cod-eqpto               = STRING(mb.implemento.codiimpl)
               tt-mab-eqpto.cod-model               = STRING(mb.implemento.codimode + 10000,"99999")
               tt-mab-eqpto.idi-tip-eqpto           = 2   /** N∆o Motorizado **/
               /** Dados Terceiros **/              
               tt-mab-eqpto.idi-tip-propriet        = 1   /** Pr¢prio **/
               tt-mab-eqpto.cod-emitente            = 0
               /** Datas **/
               tt-mab-eqpto.dat-inicial             = if mb.implemento.datainic = ? then today else mb.implemento.datainic
               tt-mab-eqpto.vli-ano-fabric          = mb.implemento.anofabr
               tt-mab-eqpto.vli-ano-model           = mb.implemento.anomodel 
               /** Dados Compra **/                 
               tt-mab-eqpto.dat-compra              = if mb.implemento.datainic = ? then today else mb.implemento.datainic 
               tt-mab-eqpto.cdn-fornecedor          = 0
               tt-mab-eqpto.val-compra              = 0
               /** Situaá∆o **/                     
               tt-mab-eqpto.cod-sit-eqpto           = string(mb.implemento.codisitu + 100,"999")
               tt-mab-eqpto.dat-situacao            = ?
               /** Dados do Hist¢rico, ser∆o atualizados pelo Hist¢rico **/           
               tt-mab-eqpto.ct-codigo               = "":U /**  **/
               tt-mab-eqpto.cc-codigo               = STRING(mb.implemento.centcusto)
               tt-mab-eqpto.cod-ccusto-alter        = STRING(mb.implemento.centcusto)
               tt-mab-eqpto.cod-grp-eqpto           = "":U
               tt-mab-eqpto.cd-tag                  = "":U
               tt-mab-eqpto.cod-pais                = "":U
               tt-mab-eqpto.cod-estado              = "":U
               tt-mab-eqpto.cod-cidade              = "":U
               tt-mab-eqpto.cod-estabel             = "":U
               tt-mab-eqpto.cod_unid_negoc          = "":U
               /** Dados Adicionais **/             
               tt-mab-eqpto.cod-chassi              = mb.implemento.chassis
               tt-mab-eqpto.cod-placa               = mb.implemento.placa-atual
               tt-mab-eqpto.cod-renavam             = "":U
               /** Bem Patrimonial n∆o informa **/
               tt-mab-eqpto.bm-codigo               = 0
               tt-mab-eqpto.bm-indice               = 0
               tt-mab-eqpto.cod-cta-pat             = "":U.
        /** Atualizaá∆o da parte documentacional **/
        for first mb.veiculos
            where mb.veiculos.codiespe = 2
            and   mb.veiculos.codiempr = mb.implemento.codiempr
            and   mb.veiculos.numeequi = mb.implemento.codiimpl no-lock:
            assign tt-mab-eqpto.cod-chassi  = mb.veiculos.num-chassi
                   tt-mab-eqpto.cod-placa   = mb.veiculos.placa-atual
                   tt-mab-eqpto.cod-renavam = string(mb.veiculos.cod-renavam).
        end.
        /** Busca Situaá∆o do Equipamento para colcoar data de inatividade **/
        for first mab-sit-eqpto
            where mab-sit-eqpto.cod-sit-eqpto = tt-mab-eqpto.cod-sit-eqpto no-lock:
            if mab-sit-eqpto.idi-tip = 2 then
                assign tt-mab-eqpto.dat-situacao = mb.implemento.datdesat.
        end.
        /** Busca a Estrutura MecÉnica do Modelo do Implemento **/
        for first mb.ipmodelo
            where mb.ipmodelo.codimode = mb.implemento.codimode no-lock:
            assign tt-mab-eqpto.cod-estrut-mec = string(mb.modelo.codiclme,"999").
        end.
    END.
    ELSE DO:
        /** Busca o Registro **/
        RUN goToKey IN h-tabela (INPUT mb.implemento.codiempr,
                                 INPUT STRING (mb.implemento.codiimpl)).
        IF RETURN-VALUE = "OK":U THEN DO:
            /** Busca o registro da BO **/
            RUN getRecord IN h-tabela (OUTPUT TABLE tt-mab-eqpto).
            FOR FIRST tt-mab-eqpto EXCLUSIVE-LOCK: END.
        END.
        ELSE DO:
            CREATE tt-mab-eqpto.
            ASSIGN tt-mab-eqpto.ep-codigo               = mb.implemento.codiempr
                   tt-mab-eqpto.cod-eqpto               = STRING (mb.implemento.codiimpl).
        END.
    END.
    /** KM e Hodìmetro atual do equipamento no SISMA ser∆o os iniciais no Frotas **/
    ASSIGN tt-mab-eqpto.val-hodom-horim-inicial = mb.implemento.vidabase
           tt-mab-eqpto.val-km-inicial          = mb.implemento.vidabase.
    /** Busca £ltima vida do equipamento para atualizar os KM **/
    FOR LAST  mb.implevida USE-INDEX i-implevida
        WHERE mb.implevida.codiempr = mb.implemento.codiempr
        AND   mb.implevida.codiimpl = mb.implemento.codiimpl NO-LOCK:
        ASSIGN tt-mab-eqpto.val-km-inicial          = mb.implevida.vida
               tt-mab-eqpto.val-hodom-horim-inicial = mb.implevida.vida.
    END.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 AND tt-param.i-km-eqpto = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-eqpto except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables RowErrors no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-eqpto).
        /** Processo Normal (Inclus∆o) **/
        IF tt-param.i-km-eqpto = 1 THEN
            RUN createRecord in h-tabela.
        /** Atualizaá∆o dos KMs **/
        ELSE 
            RUN updateRecord IN h-tabela.

        IF RETURN-VALUE = "NOK" THEN DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Equipamento","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-eqpto":U
                       tt-dados.cod-tabela = string(tt-mab-eqpto.ep-codigo) + "-" + tt-mab-eqpto.cod-eqpto
                       tt-dados.des-tabela = tt-mab-eqpto.cod-model
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Equipamento","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = string(tt-mab-eqpto.ep-codigo) + "-" + tt-mab-eqpto.cod-eqpto
                   tt-dados.des-tabela = tt-mab-eqpto.cod-model
                   tt-dados.tabela     = "mab-eqpto"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-eqpto-sub-sist) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-eqpto-sub-sist Procedure 
PROCEDURE pi-mab-eqpto-sub-sist :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:                 tt-mab-eqpto-sub-sist
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parÉmetros est∆o OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens Ç Iniciado **/
assign c-cont2 = 1.
/******************************************
** Validaá∆o do Destino da Importaá∆o
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr008.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr008").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Grupo Equipamento x Sub-Sistema","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Grupo Equipamento x Sub-Sistema","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr008.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** Relacionamento Equipamento x Sub-Sistema deve estar importado antes **/
FOR EACH mab-relac-eqpto-sub-sist NO-LOCK:
    /** Equipamento deve estar importado antes, para buscar grupo **/
    for first mab-eqpto
        where mab-eqpto.ep-codigo = mab-relac-eqpto-sub-sist.ep-codigo
        and   mab-eqpto.cod-eqpto = mab-relac-eqpto-sub-sist.cod-eqpto no-lock:
        /** Caso ainda n∆o exista o relacionamento, faz l¢gica para criar **/
        if not can-find (first mab-eqpto-sub-sist
                         where mab-eqpto-sub-sist.cod-grp-eqpto = mab-eqpto.cod-grp-eqpto
                         and   mab-eqpto-sub-sist.cod-sub-sist  = mab-relac-eqpto-sub-sist.cod-sub-sist no-lock) then do:

            EMPTY TEMP-TABLE tt-mab-eqpto-sub-sist.
            CREATE tt-mab-eqpto-sub-sist.
            ASSIGN tt-mab-eqpto-sub-sist.cod-grp-eqpto = mab-eqpto.cod-grp-eqpto
                   tt-mab-eqpto-sub-sist.cod-sub-sist  = mab-relac-eqpto-sub-sist.cod-sub-sist
                   tt-mab-eqpto-sub-sist.qti-max       = mab-relac-eqpto-sub-sist.qti-max.

            /** Exporta para Excel **/
            if tt-param.dest-exportacao = 1 then do:
                OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
                    export delimiter ";" tt-mab-eqpto-sub-sist except r-rowid.
                output close.
            end.
            else do:
                CREATE tt-dados.
                RUN emptyRowErrors IN h-tabela.
                RUN setRecord IN h-tabela (INPUT TABLE tt-mab-eqpto-sub-sist).
                RUN createRecord in h-tabela.
                IF RETURN-VALUE = "NOK":U then DO:
                    RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
                    run utp/ut-liter.p (input "Grupo Eqpto X Sub-Sistema","*","").
                    FOR EACH RowErrors NO-LOCK:
                        ASSIGN tt-dados.i-chave    = c-cont2
                               tt-dados.erro       = RowErrors.ErrorNumber
                               tt-dados.descricao  = RowErrors.ErrorDescription 
                               tt-dados.tabela     = "mab-eqpto-sub-sist":U
                               tt-dados.cod-tabela = tt-mab-eqpto-sub-sist.cod-sub-sist
                               tt-dados.des-tabela = ""
                               tt-dados.des-tab    = return-value     
                               c-cont2             = c-cont2 + 1.
                    end.
                end.
                ELSE DO:
                    run utp/ut-liter.p (input "Grupo Eqpto X Sub-Sistema","*","").
                    ASSIGN tt-dados.i-chave    = c-cont2
                           tt-dados.cod-tabela = tt-mab-eqpto-sub-sist.cod-grp-eqpto + tt-mab-eqpto-sub-sist.cod-sub-sis
                           tt-dados.des-tabela = ""
                           tt-dados.tabela     = "mab-eqpto-sub-sist":U
                           tt-dados.des-tab    = return-value
                           c-cont2 = c-cont2 + 1.
                end.
            end.
        end. /** if not can-find **/
    end.  /** mab-eqpto **/
end.

IF valid-handle(h-tabela) THEN   
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-histor-ativid) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-histor-ativid Procedure 
PROCEDURE pi-mab-histor-ativid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa historico atividades*/
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parÉmetros est∆o OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens Ç Iniciado **/
assign c-cont2 = 1.
/******************************************
** Validaá∆o do Destino da Importaá∆o
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr013.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr013").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Hist¢rico Estabelecimento Atividade","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Hist¢rico Estabelecimento Atividade","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela)   THEN
    RUN  frbo/bofr013.p PERSISTENT SET h-tabela.
run openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** Là os movimentos de vida do equipamento **/
for EACH mb.equipmovim no-lock:
    /** Là o equipamento **/
    FOR first mb.equipamento
        where mb.equipamento.codiempr = mb.equipmovim.codiempr
        AND   mb.equipamento.numeequi = mb.equipmovim.numeequi NO-LOCK:
        EMPTY TEMP-TABLE tt-mab-histor-ativid.
        CREATE tt-mab-histor-ativid.
        ASSIGN tt-mab-histor-ativid.ep-codigo        = mb.equipmovim.codiempr
               tt-mab-histor-ativid.cod-eqpto        = string (mb.equipmovim.numeequi)
               tt-mab-histor-ativid.dat-cadastro     = mb.equipmovim.uldatrab
               /** Dados **/
               tt-mab-histor-ativid.cod-ativid       = string (equipmovim.codioper,"999")
               tt-mab-histor-ativid.cod-cidade       = ""
               tt-mab-histor-ativid.cod-estado       = ""
               tt-mab-histor-ativid.cod-pais         = ""
               tt-mab-histor-ativid.cc-codigo        = string(mb.equipamento.centcusto)
               tt-mab-histor-ativid.ct-codigo        = string(mb.equipamento.ccontabil)
               tt-mab-histor-ativid.cod-ccusto-alter = string(mb.equipamento.centcusto)
               tt-mab-histor-ativid.cod-estabel      = string(mb.equipamento.codiseto)
               tt-mab-histor-ativid.cod-grp-eqpto    = string(mb.equipamento.codiclop,"999")
               tt-mab-histor-ativid.cd-tag           = "":U  /** TAG Branco Padr∆o **/
               tt-mab-histor-ativid.cod_unid_negoc   = "":U.
        /** Busca a Data de Inclus∆o **/
        if tt-mab-histor-ativid.dat-cadastro < mb.equipamento.datainic or mb.equipamento.datainic = ? then
            assign tt-mab-histor-ativid.dat-cadastro = if mb.equipamento.datainic = ? then today else mb.equipamento.datainic.
        /** Busca o c¢digo do Grupo do Equipamento do Modelo **/
        for first mb.modelo
            where mb.modelo.codimode = mb.equipamento.codimode no-lock:
            assign tt-mab-histor-ativid.cod-grp-eqpto = string(mb.modelo.codiclop,"999").
        end.
        /** Atualizaá∆o da parte documentacional **/
        for first mb.veiculos
            where mb.veiculos.codiespe = 1
            and   mb.veiculos.codiempr = mb.equipamento.codiempr
            and   mb.veiculos.numeequi = mb.equipamento.numeequi no-lock:
            for first mb.cidade
                where mb.cidade.codicid = mb.veiculos.codicid no-lock:
                assign tt-mab-histor-ativid.cod-cidade = mb.cidade.nome.
            end.
            assign tt-mab-histor-ativid.cod-estado = mb.veiculos.estplacaatual
                   tt-mab-histor-ativid.cod-pais   = "Brasil":U.    /*tt-param.c-cod-pais*/
        end.
        /** De-Para de Estabelecimento **/
        for first tt-estabelec
            where tt-estabelec.cod-nop = string(mb.equipamento.codiseto) no-lock:
            assign tt-mab-histor-ativid.cod-estabel = tt-estabelec.cod-estabel.
        end.
        /** Exporta para Excel **/
        if tt-param.dest-exportacao = 1 then do:
            OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
                export delimiter ";" tt-mab-histor-ativid except r-rowid.
            output close.
        end.
        else do:
            CREATE tt-dados.
            RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
            RUN setRecord IN h-tabela (INPUT TABLE tt-mab-histor-ativid).
            RUN createRecord in h-tabela.
            IF RETURN-VALUE = "NOK" then DO:
                RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
                run utp/ut-liter.p (input "Hist¢rico Estabelecimento Atividade","*","").
                FOR EACH RowErrors NO-LOCK:
                    ASSIGN tt-dados.i-chave    = c-cont2
                           tt-dados.erro       = RowErrors.ErrorNumber
                           tt-dados.descricao  = RowErrors.ErrorDescription 
                           tt-dados.tabela     = "mab-histor-ativid"
                           tt-dados.cod-tabela = tt-mab-histor-ativid.cod-eqpto
                           tt-dados.des-tabela = STRING (tt-mab-histor-ativid.cod-grp-eqpto)
                           tt-dados.des-tab    = return-value
                           c-cont2             = c-cont2 + 1.
                end.
            end.
            ELSE DO:
                run utp/ut-liter.p (input "Hist¢rico Estabelecimento Atividade","*","").
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.cod-tabela = tt-mab-histor-ativid.cod-eqpto
                       tt-dados.des-tabela = STRING (tt-mab-histor-ativid.cod-grp-eqpto)
                       tt-dados.tabela     = "mab-histor-ativid"
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
    end.
end.

/** Verificar Movimentos de implementos **/

if valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-histor-combust) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-histor-combust Procedure 
PROCEDURE pi-mab-histor-combust :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parÉmetros est∆o OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens Ç Iniciado **/
assign c-cont2 = 1.
/******************************************
** Validaá∆o do Destino da Importaá∆o
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr014.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr014").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Hist¢rico Combust°veis","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Hist¢rico Combust°veis","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela)   THEN
    RUN  frbo/bofr014.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.equipcombu NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-histor-combust.
    CREATE tt-mab-histor-combust.
    ASSIGN tt-mab-histor-combust.ep-codigo        = mb.equipcombu.codiempr
           tt-mab-histor-combust.cod-eqpto        = STRING (mb.equipcombu.numeequi)
           tt-mab-histor-combust.val-consu-padr   = if mb.equipcombu.conscomb = 0 then 1 else mb.equipcombu.conscomb
           tt-mab-histor-combust.cod-tip-mater    = STRING (mb.equipcombu.codicolu,"999")
           tt-mab-histor-combust.val-capac-tanque = mb.equipcombu.capatanq
           tt-mab-histor-combust.dat-inicial      = mb.equipcombu.datauso
           tt-mab-histor-combust.idi-tip-consu    = 2.  /** Percurso/Qtd **/

    /** Busca a Data de Inclus∆o **/
    for first mb.equipamento
        where mb.equipamento.codiempr  = mb.equipcombu.codiempr
        and   mb.equipamento.numeequi  = mb.equipcombu.numeequi no-lock:
        if tt-mab-histor-combust.dat-inicial = ? or tt-mab-histor-combust.dat-inicial < mb.equipamento.datainic then do:
            assign tt-mab-histor-combust.dat-inicial = if mb.equipamento.datainic = ? then today else mb.equipamento.datainic.
        end.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-histor-combust except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-histor-combust).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Hist¢rico Combust°veis","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-histor-combust"
                       tt-dados.cod-tabela = tt-mab-histor-combust.cod-eqpto
                       tt-dados.des-tabela = STRING (tt-mab-histor-combust.val-consu-padr)
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Hist¢rico Combust°veis","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-histor-combust.cod-eqpto
                   tt-dados.des-tabela = STRING (tt-mab-histor-combust.val-consu-padr)
                   tt-dados.tabela     = "mab-histor-combust":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-period-manut) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-period-manut Procedure 
PROCEDURE pi-mab-period-manut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE de-km-ult-troca    AS INTEGER    NO-UNDO.
DEFINE VARIABLE de-km-atual        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE c-cod-evento-troca AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-period-troca    AS DECIMAL    NO-UNDO.

/** Valida Se parÉmetros est∆o OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens Ç Iniciado **/
assign c-cont2 = 1.
/******************************************
** Validaá∆o do Destino da Importaá∆o
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 AND tt-param.i-km-eqpto = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr020.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr020").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Per°odo Manutená∆o Compartimentos","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    /** Processo Normal (Inclus∆o) **/
    IF tt-param.i-km-eqpto = 1 THEN
        run utp/ut-liter.p (input "Atualizando tabela Per°odo Manutená∆o Compartimentos","*","").
    ELSE 
        run utp/ut-liter.p (input "Atualizando KM Per°odo Manutená∆o Compartimentos","*","").

/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
/** Busca o Evento de Troca dos ParÉmetros do Frotas **/
FOR FIRST mab-param
    WHERE mab-param.cdn-param = 17 NO-LOCK:
    ASSIGN c-cod-evento-troca = trim(mab-param.des-valor).
END.

IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr020.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.equipamento NO-LOCK:
    FOR EACH  mb.equipcompa
        WHERE mb.equipcompa.codiempr = mb.equipamento.codiempr
        AND   mb.equipcompa.numeequi = mb.equipamento.numeequi NO-LOCK:
        /** Identifica o tipo de compartimento **/
        /*****************************************
        ** mb.equipcompa.classe = 1 = ‡leo 
        *****************************************/
        IF mb.equipcompa.classe = 1 THEN DO:
            /** Busca Modelo X Compartiemnto de ‡leo **/
            for FIRST mb.modelcompa 
                where mb.modelcompa.codimode = mb.equipamento.codimode 
                AND   mb.modelcompa.codicomp = mb.equipcompa.codigo no-lock:
                ASSIGN de-km-ult-troca = 0
                       de-period-troca = mb.modelcompa.peritroc.
                /** Busca £ltima vida do equipamento para atualizar os KM **/
                FOR LAST  mb.equipvida USE-INDEX i-equipvida2
                    WHERE mb.equipvida.codiempr = mb.equipamento.codiempr
                    AND   mb.equipvida.numeequi = mb.equipamento.numeequi NO-LOCK:
                    ASSIGN de-km-atual = mb.equipvida.vida.
                END.
                /** Busca a £ltima troca de ¢leo para o equipamento **/
                for last  mb.diarilubri
                    where mb.diarilubri.codiempr = mb.equipamento.codiempr
                    and   mb.diarilubri.numeequi = mb.equipamento.numeequi
                    and   mb.diarilubri.codicomp = mb.prevlubrifilt.codigo
                    and   mb.diarilubri.trocremo = 1 use-index i-diarilubri4 no-lock:
                    /** AtravÇs da data da troca, busca a vida do equipamento nesta data **/
                    for first mb.equipvida
                        where mb.equipvida.codiempr = mb.diarilubri.codiempr
                        and   mb.equipvida.numeequi = mb.diarilubri.numeequi
                        and   mb.equipvida.data     = mb.diarilubri.data
                        and   mb.equipvida.numedocu = mb.diarilubri.numedocu use-index i-equipvida2 no-lock:
                        assign de-km-ult-troca = mb.equipvida.vida.
                    END.
                END.
            END.
        END.
        ELSE DO:
            /** Busca Modelo X Filtro **/
            for FIRST mb.modelfiltr 
                where mb.modelfiltr.codimode = mb.equipamento.codimode 
                AND   mb.modelfiltr.codicomp = mb.equipcompa.codigo no-lock:
                EMPTY TEMP-TABLE  tt-mab-period-manut.
                CREATE tt-mab-period-manut.
                ASSIGN de-km-ult-troca = 0
                       de-period-troca = mb.modelfiltr.peritroc.
                /** Busca £ltima vida do equipamento para atualizar os KM **/
                FOR LAST  mb.equipvida USE-INDEX i-equipvida2
                    WHERE mb.equipvida.codiempr = mb.equipamento.codiempr
                    AND   mb.equipvida.numeequi = mb.equipamento.numeequi NO-LOCK:
                    ASSIGN de-km-atual = mb.equipvida.vida.
                END.
                /** Busca a £ltima troca de ¢leo para o equipamento **/
                for last  mb.diarifiltr
                    where mb.diarifiltr.codiempr = mb.equipamento.codiempr
                    and   mb.diarifiltr.numeequi = mb.equipamento.numeequi
                    and   mb.diarifiltr.codifilt = mb.prevlubrifilt.codigo use-index i-diarifiltr4 no-lock:
                    /** AtravÇs da data da troca, busca a vida do equipamento nesta data **/
                    for first mb.equipvida
                        where mb.equipvida.codiempr = mb.diarifiltr.codiempr
                        and   mb.equipvida.numeequi = mb.diarifiltr.numeequi
                        and   mb.equipvida.data     = mb.diarifiltr.data
                        and   mb.equipvida.numedocu = mb.diarifiltr.numedocu use-index i-equipvida2 no-lock:
                        assign de-km-ult-troca = mb.equipvida.vida.
                    END.
                END.
            END.
        END.
        EMPTY TEMP-TABLE  tt-mab-period-manut.
        /** Processo Normal **/
        IF tt-param.i-km-eqpto = 1 THEN DO:
            /** Criaá∆o do Registro **/
            CREATE tt-mab-period-manut.
            ASSIGN tt-mab-period-manut.ep-codigo      = mb.equipamento.codiempr
                   tt-mab-period-manut.cod-eqpto      = STRING (mb.equipamento.numeequi)
                   tt-mab-period-manut.cod-comptmento = STRING (mb.equipcompa.codigo,"9999")
                   tt-mab-period-manut.cod-evento     = c-cod-evento-troca
                   tt-mab-period-manut.val-km-padr    = de-period-troca
                   /** Atualiza o KM real percorrido do compartimento (Atual - Èltima Troca) **/
                   tt-mab-period-manut.val-km-real    = IF  (de-km-atual - de-km-ult-troca >= 0) 
                                                        THEN de-km-atual - de-km-ult-troca 
                                                        ELSE 0.
        END.
        ELSE DO:
            /** Busca o Registro **/
            RUN goToKey IN h-tabela (INPUT mb.equipamento.codiempr,
                                        INPUT STRING (mb.equipamento.numeequi),
                                        INPUT STRING (mb.equipcompa.codigo,"9999"),
                                        INPUT c-cod-evento-troca).
            IF RETURN-VALUE = "OK":U THEN DO:
                /** Busca o registro da BO **/
                RUN getRecord IN h-tabela (OUTPUT TABLE tt-mab-period-manut).
                FOR FIRST tt-mab-period-manut EXCLUSIVE-LOCK:
                    ASSIGN tt-mab-period-manut.val-km-padr = de-period-troca
                           tt-mab-period-manut.val-km-real = IF  (de-km-atual - de-km-ult-troca >= 0) 
                                                             THEN de-km-atual - de-km-ult-troca 
                                                             ELSE 0.
                END.
            END.
            ELSE DO:
                CREATE tt-mab-period-manut.
                ASSIGN tt-mab-period-manut.ep-codigo      = mb.equipamento.codiempr
                       tt-mab-period-manut.cod-eqpto      = STRING (mb.equipamento.numeequi)
                       tt-mab-period-manut.cod-comptmento = STRING (mb.equipcompa.codigo,"9999")
                       tt-mab-period-manut.cod-evento     = c-cod-evento-troca
                       tt-mab-period-manut.val-km-padr    = de-period-troca
                       /** Atualiza o KM real percorrido do compartimento (Atual - Èltima Troca) **/
                       tt-mab-period-manut.val-km-real    = IF  (de-km-atual - de-km-ult-troca >= 0) 
                                                            THEN de-km-atual - de-km-ult-troca 
                                                            ELSE 0.
            END.
        END.
        /** Exporta para Excel **/
        if tt-param.dest-exportacao = 1 AND tt-param.i-km-eqpto = 1 then do:
            OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
                export delimiter ";" tt-mab-period-manut except r-rowid.
            output close.
        end.
        else do:
            CREATE tt-dados.
            RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
            RUN setRecord IN h-tabela (INPUT TABLE tt-mab-period-manut).
            /** Processo Normal (Inclus∆o) **/
            IF tt-param.i-km-eqpto = 1 THEN
                RUN createRecord in h-tabela.
            /** Atualizaá∆o dos KMs **/
            ELSE 
                RUN updateRecord IN h-tabela.
        
            IF RETURN-VALUE = "NOK" then DO:
                RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
                run utp/ut-liter.p (input "Per°odo Manutená∆o Compartimentos","*","").
                FOR EACH RowErrors NO-LOCK:
                    ASSIGN tt-dados.i-chave    = c-cont2
                           tt-dados.erro       = RowErrors.ErrorNumber
                           tt-dados.descricao  = RowErrors.ErrorDescription 
                           tt-dados.tabela     = "mab-period-manut"
                           tt-dados.cod-tabela = tt-mab-period-manut.cod-eqpto
                           tt-dados.des-tabela = STRING (tt-mab-period-manut.val-km-padr)
                           tt-dados.des-tab    = return-value
                           c-cont2             = c-cont2 + 1.
                end.
            end.
            ELSE DO:
                run utp/ut-liter.p (input "Per°odo Manutená∆o Compartimentos","*","").
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.cod-tabela = tt-mab-period-manut.cod-eqpto
                       tt-dados.des-tabela = STRING (tt-mab-period-manut.val-km-padr)
                       tt-dados.tabela     = "mab-period-manut"
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
    END.  /** EquipCompa **/
END.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-relac-eqpto-sub-sist) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-relac-eqpto-sub-sist Procedure 
PROCEDURE pi-mab-relac-eqpto-sub-sist :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Vari†veis de Controle do KM dos planos **/
DEFINE VARIABLE de-km-atual    AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-km-anterior AS DECIMAL NO-UNDO.
DEFINE VARIABLE dt-km-anterior AS DATE    NO-UNDO.

/** Valida Se parÉmetros est∆o OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens Ç Iniciado **/
assign c-cont2 = 1.
/******************************************
** Validaá∆o do Destino da Importaá∆o
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 AND tt-param.i-km-eqpto = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr128.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr128").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Equipamento x Sub-Sistema","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    /** Processo Normal (Inclus∆o) **/
    IF tt-param.i-km-eqpto = 1 THEN
        run utp/ut-liter.p (input "Atualizando tabela Equipamento x Sub-Sistema","*","").
    ELSE 
        run utp/ut-liter.p (input "Atualizando KM Inicial Equipamento x Sub-Sistema","*","").

/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN frbo/bofr128.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.agreequip NO-LOCK:
    /** Busca a Data de Inclus∆o **/
    FOR FIRST mb.equipamento
        WHERE mb.equipamento.codiempr = mb.agreequip.codiempr
        AND   mb.equipamento.numeequi = mb.agreequip.numeequi NO-LOCK:

        /** Processo Normal **/
        IF tt-param.i-km-eqpto = 1 THEN DO:

            EMPTY TEMP-TABLE tt-mab-relac-eqpto-sub-sist.
            CREATE tt-mab-relac-eqpto-sub-sist.
            ASSIGN tt-mab-relac-eqpto-sub-sist.ep-codigo    = mb.agreequip.codiempr
                   tt-mab-relac-eqpto-sub-sist.cod-eqpto    = string(mb.agreequip.numeequi)
                   tt-mab-relac-eqpto-sub-sist.cod-sub-sist = string(mb.agreequip.codilocal,"9999")
                   tt-mab-relac-eqpto-sub-sist.qti-max      = mb.agreequip.quantidade
                   tt-mab-relac-eqpto-sub-sist.dat-cadastro = if mb.equipamento.datainic = ? then today else mb.equipamento.datainic
                   dt-km-anterior                           = tt-mab-relac-eqpto-sub-sist.dat-cadastro
                   de-km-atual                              = 0
                   de-km-anterior                           = 0.
            /** Busca £ltima vida do equipamento para atualizar os KM **/
            FOR LAST  mb.equipvida USE-INDEX i-equipvida2
                WHERE mb.equipvida.codiempr = mb.equipamento.codiempr
                AND   mb.equipvida.numeequi = mb.equipamento.numeequi NO-LOCK:
                ASSIGN de-km-atual = mb.equipvida.vida.
            END.
            /** Busca £ltima manutená∆o para o sub-sistema no equipamento **/
            FOR LAST  mb.itemordem
                WHERE mb.itemordem.codiespe  = 1
                AND   mb.itemordem.codiempr  = mb.equipamento.codiempr
                AND   mb.itemordem.numeequi  = mb.equipamento.numeequi
                AND   mb.itemordem.codilocal = mb.agreequip.codilocal NO-LOCK
                BY    mb.itemordem.codiempr 
                BY    mb.itemordem.numeequi 
                BY    mb.itemordem.codilocal
                BY    mb.itemordem.datasaida:
                ASSIGN dt-km-anterior = mb.itemordem.datasaida.
                /** Busca £ltima vida do equipamento para atualizar os KM **/
                FOR LAST  mb.equipvida USE-INDEX i-equipvida2
                    WHERE mb.equipvida.codiempr = mb.equipamento.codiempr
                    AND   mb.equipvida.numeequi = mb.equipamento.numeequi 
                    AND   mb.equipvida.data    <= dt-km-anterior NO-LOCK:
                    ASSIGN de-km-anterior = mb.equipvida.vida.
                END.
            END.
            /** Atualiza os KMs percorrridos dos planos **/
            ASSIGN tt-mab-relac-eqpto-sub-sist.dat-ult-troca      = dt-km-anterior
                   tt-mab-relac-eqpto-sub-sist.val-km-inicial     = de-km-atual - de-km-anterior
                   /** Troca em KM **/
                   tt-mab-relac-eqpto-sub-sist.val-uso-estimad    = 0
                   tt-mab-relac-eqpto-sub-sist.val-km-aviso       = 0
                   /** Troca em Dias **/
                   tt-mab-relac-eqpto-sub-sist.num-dias-estimad   = 0
                   tt-mab-relac-eqpto-sub-sist.num-dias-antecip   = 0
                   /** Garantia **/
                   tt-mab-relac-eqpto-sub-sist.val-km-hora-gartia = 0
                   tt-mab-relac-eqpto-sub-sist.num-dias-gartia    = 0.
    
            /** Valida KM errado do SISMA **/
            IF tt-mab-relac-eqpto-sub-sist.val-km-inicial < 0 THEN
                ASSIGN tt-mab-relac-eqpto-sub-sist.val-km-inicial = 0.
        END.
        ELSE DO:
            /** Busca o Registro **/
            RUN goToKey IN h-tabela (INPUT mb.agreequip.codiempr,
                                        INPUT STRING(mb.agreequip.numeequi),
                                        INPUT string(mb.agreequip.codilocal,"9999")).
            IF RETURN-VALUE = "OK":U THEN DO:
                /** Busca o registro da BO **/
                RUN getRecord IN h-tabela (OUTPUT TABLE tt-mab-relac-eqpto-sub-sist).
                FOR FIRST tt-mab-relac-eqpto-sub-sist EXCLUSIVE-LOCK:
                    ASSIGN dt-km-anterior = tt-mab-relac-eqpto-sub-sist.dat-cadastro
                           de-km-atual    = 0
                           de-km-anterior = 0.
                    /** Busca £ltima vida do equipamento para atualizar os KM **/
                    FOR LAST  mb.equipvida USE-INDEX i-equipvida2
                        WHERE mb.equipvida.codiempr = mb.equipamento.codiempr
                        AND   mb.equipvida.numeequi = mb.equipamento.numeequi NO-LOCK:
                        ASSIGN de-km-atual = mb.equipvida.vida.
                    END.
                    /** Busca £ltima manutená∆o para o sub-sistema no equipamento **/
                    FOR LAST  mb.itemordem
                        WHERE mb.itemordem.codiespe  = 1
                        AND   mb.itemordem.codiempr  = mb.equipamento.codiempr
                        AND   mb.itemordem.numeequi  = mb.equipamento.numeequi
                        AND   mb.itemordem.codilocal = mb.agreequip.codilocal NO-LOCK
                        BY    mb.itemordem.codiempr 
                        BY    mb.itemordem.numeequi 
                        BY    mb.itemordem.codilocal
                        BY    mb.itemordem.datasaida:
                        ASSIGN dt-km-anterior = mb.itemordem.datasaida.
                        /** Busca £ltima vida do equipamento para atualizar os KM **/
                        FOR LAST  mb.equipvida USE-INDEX i-equipvida2
                            WHERE mb.equipvida.codiempr = mb.equipamento.codiempr
                            AND   mb.equipvida.numeequi = mb.equipamento.numeequi 
                            AND   mb.equipvida.data    <= dt-km-anterior NO-LOCK:
                            ASSIGN de-km-anterior = mb.equipvida.vida.
                        END.
                    END.
                    /** Atualiza os KMs percorrridos dos planos **/
                    ASSIGN tt-mab-relac-eqpto-sub-sist.dat-ult-troca      = dt-km-anterior
                           tt-mab-relac-eqpto-sub-sist.val-km-inicial     = de-km-atual - de-km-anterior.
                    /** Valida KM errado do SISMA **/
                    IF tt-mab-relac-eqpto-sub-sist.val-km-inicial < 0 THEN
                        ASSIGN tt-mab-relac-eqpto-sub-sist.val-km-inicial = 0.
                END.
            END.
            ELSE DO:
                CREATE tt-mab-relac-eqpto-sub-sist.
                ASSIGN tt-mab-relac-eqpto-sub-sist.ep-codigo    = mb.agreequip.codiempr
                       tt-mab-relac-eqpto-sub-sist.cod-eqpto    = string(mb.agreequip.numeequi)
                       tt-mab-relac-eqpto-sub-sist.cod-sub-sist = string(mb.agreequip.codilocal,"9999").
            END.
        END.

        /** Exporta para Excel **/
        if tt-param.dest-exportacao = 1 AND tt-param.i-km-eqpto = 1 then do:
            OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
                export delimiter ";" tt-mab-relac-eqpto-sub-sist except r-rowid.
            output close.
        end.
        else do:
            CREATE tt-dados.
            RUN emptyRowErrors IN h-tabela.
            RUN setRecord IN h-tabela (INPUT TABLE tt-mab-relac-eqpto-sub-sist).
            IF tt-param.i-km-eqpto = 1 THEN
                RUN createRecord in h-tabela.
            ELSE 
                RUN updateRecord in h-tabela.
        
            IF RETURN-VALUE = "NOK":U then DO:
                RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
                run utp/ut-liter.p (input "Equipamento x Sub-Sistema","*","").
                FOR EACH RowErrors NO-LOCK:
                    ASSIGN tt-dados.i-chave    = c-cont2
                           tt-dados.erro       = RowErrors.ErrorNumber
                           tt-dados.descricao  = RowErrors.ErrorDescription 
                           tt-dados.tabela     = "mab-relac-eqpto-sub-sist"
                           tt-dados.cod-tabela = tt-mab-relac-eqpto-sub-sist.cod-sub-sist
                           tt-dados.des-tabela = ""
                           tt-dados.des-tab    = return-value     
                           c-cont2             = c-cont2 + 1.
                end.
            end.
            ELSE DO:
                run utp/ut-liter.p (input "Equipamento x Sub-Sistema","*","").
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.cod-tabela = tt-mab-relac-eqpto-sub-sist.cod-sub-sis
                       tt-dados.des-tabela = ""
                       tt-dados.tabela     = "mab-relac-eqpto-sub-sist":U
                       tt-dados.des-tab    = return-value
                       c-cont2 = c-cont2 + 1.
            end.
        end.
    end. /** Equipamento **/
end.

IF valid-handle(h-tabela) THEN   
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mmv-eqpto-plano) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mmv-eqpto-plano Procedure 
PROCEDURE pi-mmv-eqpto-plano :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Vari†veis de Controle do KM dos planos **/
DEFINE VARIABLE de-km-atual    AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-km-anterior AS DECIMAL NO-UNDO.
DEFINE VARIABLE dt-km-anterior AS DATE    NO-UNDO.

/** Valida Se parÉmetros est∆o OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens Ç Iniciado **/
assign c-cont2 = 1.
/******************************************
** Validaá∆o do Destino da Importaá∆o
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 AND tt-param.i-km-eqpto = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr031.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr031").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Planos do Equipamento","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    /** Processo Normal (Inclus∆o) **/
    IF tt-param.i-km-eqpto = 1 THEN
        run utp/ut-liter.p (input "Atualizando tabela Planos do Equipamento","*","").
    ELSE 
        run utp/ut-liter.p (input "Atualizando KM Inicial Planos do Equipamento","*","").

/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr031.p PERSISTENT SET h-tabela.
run openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.equipprev NO-LOCK:

    /** Processo Normal **/
    IF tt-param.i-km-eqpto = 1 THEN DO:

        EMPTY TEMP-TABLE tt-mmv-eqpto-plano.
        CREATE  tt-mmv-eqpto-plano.
        
        ASSIGN tt-mmv-eqpto-plano.ep-codigo   = mb.equipprev.codiempr
               tt-mmv-eqpto-plano.cod-eqpto   = STRING (mb.equipprev.numeequi)
               tt-mmv-eqpto-plano.cod-plano   = STRING (mb.equipprev.planprev)
               tt-mmv-eqpto-plano.dat-inicial = mb.equipprev.dtinprev.
    END.
    ELSE DO:
        /** Busca o Registro **/
        RUN goToKey IN h-tabela (INPUT mb.equipprev.codiempr,
                                    INPUT STRING(mb.equipprev.numeequi),
                                    INPUT STRING(mb.equipprev.planprev)).
        IF RETURN-VALUE = "OK":U THEN DO:
            /** Busca o registro da BO **/
            RUN getRecord IN h-tabela (OUTPUT TABLE tt-mmv-eqpto-plano).
            FOR FIRST tt-mmv-eqpto-plano EXCLUSIVE-LOCK:
            END.
        END.
        ELSE DO:
            CREATE tt-mmv-eqpto-plano.
            ASSIGN tt-mmv-eqpto-plano.ep-codigo = mb.equipprev.codiempr
                   tt-mmv-eqpto-plano.cod-eqpto = string(mb.equipprev.numeequi)
                   tt-mmv-eqpto-plano.cod-plano = string(mb.equipprev.planprev).
        END.
    END.
    
    /** Busca a Data de Inclus∆o **/
    for first mb.equipamento
        where mb.equipamento.codiempr  = mb.equipprev.codiempr
        and   mb.equipamento.numeequi  = mb.equipprev.numeequi no-lock:
        if tt-mmv-eqpto-plano.dat-inicial = ? or tt-mmv-eqpto-plano.dat-inicial < mb.equipamento.datainic then do:
            assign tt-mmv-eqpto-plano.dat-inicial = if mb.equipamento.datainic = ? then today else mb.equipamento.datainic.
        end.
        ASSIGN dt-km-anterior = tt-mmv-eqpto-plano.dat-inicial
               de-km-atual    = 0
               de-km-anterior = 0.
        /** Busca £ltima vida do equipamento para atualizar os KM **/
        FOR LAST  mb.equipvida USE-INDEX i-equipvida2
            WHERE mb.equipvida.codiempr = mb.equipamento.codiempr
            AND   mb.equipvida.numeequi = mb.equipamento.numeequi NO-LOCK:
            ASSIGN de-km-atual = mb.equipvida.vida.
        END.
        /** Busca a extens∆o da OM, para o plano de preventiva **/
        FOR LAST  mb.mpordem
            WHERE mb.mpordem.codiempr = mb.equipamento.codiempr 
            AND   mb.mpordem.numeequi = mb.equipamento.numeequi 
            AND   mb.mpordem.planprev = mb.equipprev.planprev NO-LOCK
            /** Classifica as Ordens por Equipamento, Plano e Data **/
            BY    mb.mpordem.codiempr
            BY    mb.mpordem.numeequi
            BY    mb.mpordem.planprev
            BY    mb.mpordem.datareal:
            /** Guarda a Data de Realizaá∆o **/
            ASSIGN dt-km-anterior = mb.mpordem.datareal.
        END.
        /** Busca £ltima vida do equipamento para atualizar os KM **/
        FOR LAST  mb.equipvida USE-INDEX i-equipvida2
            WHERE mb.equipvida.codiempr = mb.equipamento.codiempr
            AND   mb.equipvida.numeequi = mb.equipamento.numeequi 
            AND   mb.equipvida.data    <= dt-km-anterior NO-LOCK:
            ASSIGN de-km-anterior = mb.equipvida.vida.
        END.
        /** Atualiza os KMs percorrridos dos planos **/
        ASSIGN tt-mmv-eqpto-plano.val-km-real    = de-km-atual - de-km-anterior
               tt-mmv-eqpto-plano.val-km-inicial = de-km-atual - de-km-anterior.
        /** Caso tenha erro de KM, coloca zero **/
        IF tt-mmv-eqpto-plano.val-km-real < 0 THEN 
            ASSIGN tt-mmv-eqpto-plano.val-km-real = 0.
        IF tt-mmv-eqpto-plano.val-km-inicial < 0 THEN 
            ASSIGN tt-mmv-eqpto-plano.val-km-inicial = 0.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 AND tt-param.i-km-eqpto = 1 then do:
        OUTPUT TO VALUE(c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mmv-eqpto-plano except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mmv-eqpto-plano).
        IF tt-param.i-km-eqpto = 1 THEN
            RUN createRecord in h-tabela.
        ELSE 
            RUN updateRecord in h-tabela.
    
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Equipamento Plano Manutená∆o","*","").
            for EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mmv-eqpto-plano":U
                       tt-dados.cod-tabela = tt-mmv-eqpto-plano.cod-eqpto
                       tt-dados.des-tabela = tt-mmv-eqpto-plano.cod-plano
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Equipamento Plano Manutená∆o","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mmv-eqpto-plano.cod-eqpto
                   tt-dados.des-tabela = tt-mmv-eqpto-plano.cod-plano
                   tt-dados.tabela     = "mmv-eqpto-plano":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

/******************************************
** Planos dos Implementos 
******************************************/
RUN pi-mmv-eqpto-plano-2 IN THIS-PROCEDURE.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mmv-eqpto-plano-2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mmv-eqpto-plano-2 Procedure 
PROCEDURE pi-mmv-eqpto-plano-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Vari†veis de Controle do KM dos planos **/
DEFINE VARIABLE de-km-atual    AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-km-anterior AS DECIMAL NO-UNDO.
DEFINE VARIABLE dt-km-anterior AS DATE    NO-UNDO.

FOR EACH mb.implepreve NO-LOCK:
    EMPTY TEMP-TABLE tt-mmv-eqpto-plano.

    /** Processo Normal **/
    IF tt-param.i-km-eqpto = 1 THEN DO:
        CREATE  tt-mmv-eqpto-plano.
        
        ASSIGN tt-mmv-eqpto-plano.ep-codigo   = mb.implepreve.codiempr
               tt-mmv-eqpto-plano.cod-eqpto   = STRING (mb.implepreve.codiimpl)
               tt-mmv-eqpto-plano.cod-plano   = STRING (mb.implepreve.planprev)
               tt-mmv-eqpto-plano.dat-inicial = mb.implepreve.dtinprev.
    END.
    ELSE DO:
        /** Busca o Registro **/
        RUN goToKey IN h-tabela (INPUT mb.implepreve.codiempr,
                                    INPUT STRING(mb.implepreve.codiimpl),
                                    INPUT STRING(mb.implepreve.planprev)).
        IF RETURN-VALUE = "OK":U THEN DO:
            /** Busca o registro da BO **/
            RUN getRecord IN h-tabela (OUTPUT TABLE tt-mmv-eqpto-plano).
            FOR FIRST tt-mmv-eqpto-plano EXCLUSIVE-LOCK:
            END.
        END.
        ELSE DO:
            CREATE tt-mmv-eqpto-plano.
            ASSIGN tt-mmv-eqpto-plano.ep-codigo = mb.implepreve.codiempr
                   tt-mmv-eqpto-plano.cod-eqpto = string(mb.implepreve.codiimpl)
                   tt-mmv-eqpto-plano.cod-plano = string(mb.implepreve.planprev).
        END.
    END.

    /** Busca a Data de Inclus∆o **/
    for first mb.implemento
        where mb.implemento.codiempr  = mb.implepreve.codiempr
        and   mb.implemento.codiimpl  = mb.implepreve.codiimpl no-lock:
        if tt-mmv-eqpto-plano.dat-inicial = ? or tt-mmv-eqpto-plano.dat-inicial < mb.implemento.datainic then do:
            assign tt-mmv-eqpto-plano.dat-inicial = if mb.implemento.datainic = ? then today else mb.implemento.datainic.
        end.
        ASSIGN dt-km-anterior = tt-mmv-eqpto-plano.dat-inicial
               de-km-atual    = 0
               de-km-anterior = 0.
        /** Busca £ltima vida do equipamento para atualizar os KM **/
        FOR LAST  mb.implevida
            WHERE mb.implevida.codiempr = mb.implemento.codiempr
            AND   mb.implevida.codiimpl = mb.implemento.codiimpl NO-LOCK:
            ASSIGN de-km-atual = mb.implevida.vida.
        END.
        /** Busca a extens∆o da OM, para o plano de preventiva **/
        FOR LAST  mb.iposemitida USE-INDEX i-iposemitida2
            WHERE mb.iposemitida.codiempr = mb.implemento.codiempr 
            AND   mb.iposemitida.codiimpl = mb.implemento.codiimpl 
            AND   mb.iposemitida.planprev = mb.implepreve.planprev NO-LOCK:
            ASSIGN dt-km-anterior = mb.iposemitida.datareal.
        END.
        /** Busca £ltima vida do implemento para atualizar os KM **/
        FOR LAST  mb.implevida
            WHERE mb.implevida.codiempr = mb.implemento.codiempr
            AND   mb.implevida.codiimpl = mb.implemento.codiimpl 
            AND   mb.implevida.data    <= dt-km-anterior NO-LOCK:
            ASSIGN de-km-anterior = mb.implevida.vida.
        END.
        /** Atualiza os KMs percorridos dos planos **/
        ASSIGN tt-mmv-eqpto-plano.val-km-real    = de-km-atual - de-km-anterior
               tt-mmv-eqpto-plano.val-km-inicial = de-km-atual - de-km-anterior.
        /** Caso tenha erro de KM, coloca zero **/
        IF tt-mmv-eqpto-plano.val-km-real < 0 THEN 
            ASSIGN tt-mmv-eqpto-plano.val-km-real = 0.
        IF tt-mmv-eqpto-plano.val-km-inicial < 0 THEN 
            ASSIGN tt-mmv-eqpto-plano.val-km-inicial = 0.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 AND tt-param.i-km-eqpto = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mmv-eqpto-plano except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mmv-eqpto-plano).
        IF tt-param.i-km-eqpto = 1 THEN
            RUN createRecord in h-tabela.
        ELSE 
            RUN updateRecord in h-tabela.
        
        if RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Equipamento Plano Manutená∆o","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mmv-eqpto-plano":U
                       tt-dados.cod-tabela = tt-mmv-eqpto-plano.cod-eqpto
                       tt-dados.des-tabela = tt-mmv-eqpto-plano.cod-plano
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Equipamento Plano Manutená∆o","*","").
            assign tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mmv-eqpto-plano.cod-eqpto
                   tt-dados.des-tabela = tt-mmv-eqpto-plano.cod-plano
                   tt-dados.tabela     = "mmv-eqpto-plano":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mpn-histor-layout-eixo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-histor-layout-eixo Procedure 
PROCEDURE pi-mpn-histor-layout-eixo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parÉmetros est∆o OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens Ç Iniciado **/
assign c-cont2 = 1.
/******************************************
** Validaá∆o do Destino da Importaá∆o
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr044.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr044").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Hist¢rico Layout Eixo Equipamento","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Hist¢rico Layout Eixo Equipamento","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr044.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.confmovim NO-LOCK:
    EMPTY TEMP-TABLE tt-mpn-histor-layout-eixo.
    CREATE tt-mpn-histor-layout-eixo.
    
    ASSIGN tt-mpn-histor-layout-eixo.ep-codigo      = mb.confmovim.codiempr
           tt-mpn-histor-layout-eixo.cod-eqpto      = STRING (mb.confmovim.numeequi)
           tt-mpn-histor-layout-eixo.dat-inicial    = mb.confmovim.data
           tt-mpn-histor-layout-eixo.cod-layout     = STRING(mb.confmovim.codiconf,"99")
           tt-mpn-histor-layout-eixo.log-usa-estepe = mb.confmovim.estepe.

    /** Busca a Data de Inclus∆o **/
    for first mb.equipamento
        where mb.equipamento.codiempr  = mb.confmovim.codiempr
        and   mb.equipamento.numeequi  = mb.confmovim.numeequi no-lock:
        if tt-mpn-histor-layout-eixo.dat-inicial = ? or tt-mpn-histor-layout-eixo.dat-inicial < mb.equipamento.datainic then do:
            assign tt-mpn-histor-layout-eixo.dat-inicial = if mb.equipamento.datainic = ? then today else mb.equipamento.datainic.
        end.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-histor-layout-eixo except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-histor-layout-eixo).
        RUN createRecord in h-tabela.
    
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Hist¢rico Layout Eixo Equipamento","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-histor-layout-eixo":U
                       tt-dados.cod-tabela = tt-mpn-histor-layout-eixo.cod-eqpto
                       tt-dados.des-tabela = ""
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Hist¢rico Layout Eixo Equipamento","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela =  tt-mpn-histor-layout-eixo.cod-eqpto
                   tt-dados.des-tabela =  ""
                   tt-dados.tabela     = "mpn-histor-layout-eixo":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-retorna-ttdados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-ttdados Procedure 
PROCEDURE pi-retorna-ttdados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-dados.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

