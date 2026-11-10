&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : api-ab0708d.i
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE tt-mpn-pneu            LIKE mpn-pneu            FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-desen           LIKE mpn-desen           FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-medid           LIKE mpn-medid           FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-model           LIKE mpn-model           FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-pos-pneu        LIKE mpn-pos-pneu        FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-ambien-trab     LIKE mpn-ambien-trab     FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-tip-borracha    LIKE mpn-tip-borracha    FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-layout          LIKE mpn-layout          FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-layout-eixo-pos LIKE mpn-layout-eixo-pos FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-histor-vida     LIKE mpn-histor-vida     FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-serv            LIKE mpn-serv            FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mpn-km-esperad      LIKE mpn-km-esperad      FIELD r-Rowid AS ROWID.

DEFINE VARIABLE h-tabela AS HANDLE         NO-UNDO.
DEFINE VARIABLE c-cont2  AS INTEGER INIT 1 NO-UNDO.

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

define input parameter table for tt-param.

DEFINE VARIABLE c-caminho AS CHARACTER  NO-UNDO.
DEFINE VARIABLE h-cabecalho AS HANDLE     NO-UNDO.

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
         HEIGHT             = 13.08
         WIDTH              = 30.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
run abp/api-ab0708h.i persistent set h-cabecalho (input table tt-param).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-mpn-ambien-trab) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-ambien-trab Procedure 
PROCEDURE pi-mpn-ambien-trab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa aplicacao para mpn-ambien-trab */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr042.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr042").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Ambiente Trabalho","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Ambiente Trabalho","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
if NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr042.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.aplicacao NO-LOCK:

    EMPTY TEMP-TABLE tt-mpn-ambien-trab.
    CREATE tt-mpn-ambien-trab.
    assign tt-mpn-ambien-trab.cod-ambien-trab = STRING(mb.aplicacao.codiapli,"999")
           tt-mpn-ambien-trab.des-ambien-trab = mb.aplicacao.descricao.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-ambien-trab except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-ambien-trab).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Ambiente Trabalho","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-ambien-trab":U
                       tt-dados.cod-tabela = tt-mpn-ambien-trab.cod-ambien-trab
                       tt-dados.des-tabela = tt-mpn-ambien-trab.des-ambien-trab
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        else DO:
            run utp/ut-liter.p (input "Ambiente Trabalho","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mpn-ambien-trab.cod-ambien-trab
                   tt-dados.des-tabela = tt-mpn-ambien-trab.des-ambien-trab
                   tt-dados.tabela     = "mpn-ambiem-trab":U
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

&IF DEFINED(EXCLUDE-pi-mpn-desen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-desen Procedure 
PROCEDURE pi-mpn-desen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa desenho para mpn-desen */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr043.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr043").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Desenho Pneu","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Desenho Pneu","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr043.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.desenho NO-LOCK:

    EMPTY TEMP-TABLE tt-mpn-desen.
    CREATE tt-mpn-desen.
    ASSIGN tt-mpn-desen.cod-desen = STRING(mb.desenho.codidese,"999")
           tt-mpn-desen.des-desen = mb.desenho.descricao
           tt-mpn-desen.qti-sulco = mb.desenho.qtdsulco.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-desen except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.   
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-desen).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Desenho Pneu","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-desen":U
                       tt-dados.cod-tabela = tt-mpn-desen.cod-desen
                       tt-dados.des-tabela = tt-mpn-desen.des-desen
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Desenho Pneu","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mpn-desen.cod-desen
                   tt-dados.des-tabela = tt-mpn-desen.des-desen
                   tt-dados.tabela     = "mpn-desen":U
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

&IF DEFINED(EXCLUDE-pi-mpn-histor-vida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-histor-vida Procedure 
PROCEDURE pi-mpn-histor-vida :
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
if tt-param.dest-exportacao = 1 AND tt-param.i-km-vida-pneu = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr045.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr045").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Hist¢rico Vida Pneu","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    /** Processo Normal (Inclus∆o) **/
    IF tt-param.i-km-vida-pneu = 1 THEN
        run utp/ut-liter.p (input "Atualizando tabela Hist¢rico Vida Pneu","*","").
    ELSE 
        run utp/ut-liter.p (input "Atualizando KM Hist¢rico Vida Pneu","*","").

/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr045.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.pneuvida NO-LOCK:
    EMPTY TEMP-TABLE tt-mpn-histor-vida.
    /** Processo Normal **/
    IF tt-param.i-km-vida-pneu = 1 THEN DO:
        CREATE tt-mpn-histor-vida.
        ASSIGN tt-mpn-histor-vida.cod-pneu           = STRING(mb.pneuvida.numepneu)
               tt-mpn-histor-vida.num-vida           = int(mb.pneuvida.vida)
               tt-mpn-histor-vida.cod-desen          = STRING(mb.pneuvida.codidese,"999") 
               tt-mpn-histor-vida.dat-inicial        = mb.pneuvida.datarefo
               tt-mpn-histor-vida.hra-inicial        = "000000"
               tt-mpn-histor-vida.dat-final          = mb.pneuvida.datafimvida
               tt-mpn-histor-vida.nr-nota-fis        = mb.pneuvida.numenota
               tt-mpn-histor-vida.val-sulco-inicial  = mb.pneuvida.sulcoini
               tt-mpn-histor-vida.val-sulco-final    = mb.pneuvida.sulcofim
               tt-mpn-histor-vida.val-sulco-retir    = mb.pneuvida.profretirar
               tt-mpn-histor-vida.dat-sulco-adc      = ?
               tt-mpn-histor-vida.val-sulco-adc      = 0
               tt-mpn-histor-vida.cod-borracha       = STRING(mb.pneuvida.codiborr,"999")
               tt-mpn-histor-vida.val-km-hora-gartia = 0
               tt-mpn-histor-vida.cod-emitente       = mb.pneuvida.codifore
               tt-mpn-histor-vida.val-uso-inicial    = mb.pneuvida.periusoini
               tt-mpn-histor-vida.val-uso-final      = mb.pneuvida.periuso
               tt-mpn-histor-vida.cod-emitente       = 0  /** Deve ser revisto posteriormente **/
               tt-mpn-histor-vida.val-mater-1        = mb.pneuvida.gasto
               tt-mpn-histor-vida.val-venda          = 0
               tt-mpn-histor-vida.num-docto          = 0
               tt-mpn-histor-vida.log-km-final-confiav  = yes
               /** Estar† zerado a parte de estoque para posterior alteraá∆o **/
               tt-mpn-histor-vida.it-codigo          = ""
               tt-mpn-histor-vida.cod-refer          = ""
               tt-mpn-histor-vida.lote               = ""
               tt-mpn-histor-vida.cod-localiz        = ""
               tt-mpn-histor-vida.cod-depos          = "".
    
        /** Tratamento do erro (265) - Campo Sulco inicial deve ser informado(a) **/
        if tt-mpn-histor-vida.val-sulco-inicial = 0 then do:
            assign tt-mpn-histor-vida.val-sulco-inicial = 15.
        end.
    
        /** Tratamento do erro (198) - Data inicial maior que a data final **/
        if tt-mpn-histor-vida.dat-inicial > tt-mpn-histor-vida.dat-final then do:
            assign tt-mpn-histor-vida.dat-final = tt-mpn-histor-vida.dat-inicial.
        end.
    
        /** Data Final da Vida n∆o pode ser maior que data atual **/
        IF tt-mpn-histor-vida.dat-inicial > TODAY THEN
            ASSIGN tt-mpn-histor-vida.dat-inicial = TODAY.
    
        /** Tratamento do erro (17567) - Valor Sulco Final n∆o pode ser maior que Valor Sulco Inicial **/
        if tt-mpn-histor-vida.val-sulco-final > tt-mpn-histor-vida.val-sulco-inicial then do:
            assign tt-mpn-histor-vida.val-sulco-final = tt-mpn-histor-vida.val-sulco-inicial.
        end.
    END.
    ELSE DO:
        /** Busca o Registro **/
        RUN goToKey IN h-tabela (INPUT STRING(mb.pneuvida.numepneu),
                                    INPUT int(mb.pneuvida.vida)).
        IF RETURN-VALUE = "OK":U THEN DO:
            /** Busca o registro da BO **/
            RUN getRecord IN h-tabela (OUTPUT TABLE tt-mpn-histor-vida).
            FOR FIRST tt-mpn-histor-vida EXCLUSIVE-LOCK:
                ASSIGN tt-mpn-histor-vida.val-uso-inicial = mb.pneuvida.periusoini
                       tt-mpn-histor-vida.val-uso-final   = mb.pneuvida.periuso.
            END.
        END.
        ELSE DO:
            CREATE tt-mpn-histor-vida.
            ASSIGN tt-mpn-histor-vida.cod-pneu           = STRING(mb.pneuvida.numepneu)
                   tt-mpn-histor-vida.num-vida           = int(mb.pneuvida.vida).
        END.
    END.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 AND tt-param.i-km-vida-pneu = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-histor-vida except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-histor-vida).
        /** Processo Normal (Inclus∆o) **/
        IF tt-param.i-km-vida-pneu = 1 THEN
            RUN createRecord in h-tabela.
        /** Atualizaá∆o dos KMs **/
        ELSE 
            RUN updateRecord IN h-tabela.
    
        IF RETURN-VALUE = "NOK":U then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Hist¢rico Vida Pneu","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-histor-vida":U
                       tt-dados.cod-tabela = string(tt-mpn-histor-vida.num-vida)
                       tt-dados.des-tabela = tt-mpn-histor-vida.cod-pneu
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Hist¢rico Vida Pneu","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = STRING(tt-mpn-histor-vida.num-vida)
                   tt-dados.des-tabela = tt-mpn-histor-vida.cod-pneu
                   tt-dados.tabela     = "mpn-histor-vida":U
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

&IF DEFINED(EXCLUDE-pi-mpn-km-esperad) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-km-esperad Procedure 
PROCEDURE pi-mpn-km-esperad :
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr046.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr046").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela KM Esperado Pneu","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela KM Esperado Pneu","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
if NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr046.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.pneuvida NO-LOCK:

    EMPTY TEMP-TABLE tt-mpn-km-esperad.
    CREATE tt-mpn-km-esperad.
    ASSIGN tt-mpn-km-esperad.cod-desen         = STRING(mb.pneuvida.codidese,"999")
           tt-mpn-km-esperad.num-vida          = mb.pneuvida.vida
           tt-mpn-km-esperad.qti-consu-esperad = mb.pneuvida.periuso   /** Uso Final da Vida **/
           tt-mpn-km-esperad.val-sulco-ini     = mb.pneuvida.sulcoini  /** Sulco Inicial da Vida **/
           tt-mpn-km-esperad.val-sulco-retir   = mb.pneuvida.sulcofim  /** Sulco Final   da Vida **/
           tt-mpn-km-esperad.it-codigo         = tt-param.c-it-codigo.
    /** Busca o Pneu, para buscar o modelo do pneu, onde se encontra a medida **/
    FOR FIRST mb.pneu
        WHERE mb.pneu.numepneu = mb.pneuvida.numepneu NO-LOCK:
        for first mb.pnmodelo
            where mb.pnmodelo.codimopn = mb.pneu.codimopn no-lock:
            assign tt-mpn-km-esperad.cod-medid = string(mb.pnmodelo.codimedi,"999").
        end.
    END.
    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-km-esperad except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-km-esperad ).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "KM Esperado Pneu","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-km-esperad":U
                       tt-dados.cod-tabela = tt-mpn-km-esperad.cod-desen
                       tt-dados.des-tabela = STRING(tt-mpn-km-esperad.qti-consu-esperad)
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "KM Esperado Pneu","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mpn-km-esperad.cod-desen
                   tt-dados.des-tabela = STRING (tt-mpn-km-esperad.qti-consu-esperad)
                   tt-dados.tabela     = "mpn-km-esperad":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

IF valid-handle(h-tabela) then
    run Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mpn-layout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-layout Procedure 
PROCEDURE pi-mpn-layout :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.
DEFINE VARIABLE c-txt-layout AS CHARACTER  NO-UNDO.

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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr047.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr047").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Layout Eixos","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Layout Eixos","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

run utp/ut-liter.p (input "Layout Eixos","*","").
assign c-txt-layout = return-value.

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr047.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.configuracao NO-LOCK
    break by mb.configuracao.codiconf:
    if first-of(mb.configuracao.codiconf) then do:
        
        EMPTY TEMP-TABLE tt-mpn-layout.
        CREATE tt-mpn-layout.
        ASSIGN tt-mpn-layout.cod-layout = STRING(mb.configuracao.codiconf,"99")
               tt-mpn-layout.des-layout = c-txt-layout + " " + STRING(mb.configuracao.codiconf,"99").

        /** Exporta para Excel **/
        if tt-param.dest-exportacao = 1 then do:
            OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
                export delimiter ";" tt-mpn-layout except r-rowid.
            output close.
        end.
        else do:
            CREATE tt-dados.
            RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
            RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-layout).
            RUN createRecord in h-tabela.
            IF RETURN-VALUE = "NOK" then DO:
                RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
                run utp/ut-liter.p (input "Layout Eixos","*","").
                FOR EACH RowErrors NO-LOCK:
                    ASSIGN tt-dados.i-chave    = c-cont2
                           tt-dados.erro       = RowErrors.ErrorNumber
                           tt-dados.descricao  = RowErrors.ErrorDescription 
                           tt-dados.tabela     = "mpn-layout":U
                           tt-dados.cod-tabela = tt-mpn-layout.cod-layout 
                           tt-dados.des-tabela = tt-mpn-layout.des-layout
                           tt-dados.des-tab    = return-value
                           c-cont2             = c-cont2 + 1.
                end.
            end.
            ELSE DO:
                run utp/ut-liter.p (input "Layout Eixos","*","").
                assign tt-dados.i-chave    = c-cont2
                       tt-dados.cod-tabela = tt-mpn-layout.cod-layout
                       tt-dados.des-tabela = tt-mpn-layout.des-layout
                       tt-dados.tabela     = "mpn-layout":U
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
    end. /** first of **/
end.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mpn-layout-eixo-pos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-layout-eixo-pos Procedure 
PROCEDURE pi-mpn-layout-eixo-pos :
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr048.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr048").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Layout Eixo Posiá∆o","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Layout Eixo Posiá∆o","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr048.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.configuracao NO-LOCK:

    EMPTY TEMP-TABLE tt-mpn-layout-eixo-pos.
    CREATE tt-mpn-layout-eixo-pos.
    ASSIGN tt-mpn-layout-eixo-pos.cod-layout = STRING(mb.configuracao.codiconf,"99")
           tt-mpn-layout-eixo-pos.cod-pos    = STRING(mb.configuracao.codiposi,"99").
    
    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-layout-eixo-pos except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-layout-eixo-pos).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Layout Eixo Posiá‰es","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-layout-eixo-pos":U
                       tt-dados.cod-tabela = tt-mpn-layout-eixo-pos.cod-layout 
                       tt-dados.des-tabela = tt-mpn-layout-eixo-pos.cod-pos
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Layout Eixo Posiá‰es","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mpn-layout-eixo-pos.cod-layout
                   tt-dados.des-tabela = tt-mpn-layout-eixo-pos.cod-pos
                   tt-dados.tabela     = "mpn-layout-eixo-pos":U
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

&IF DEFINED(EXCLUDE-pi-mpn-medid) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-medid Procedure 
PROCEDURE pi-mpn-medid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa medida para mpn-medid */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr049.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr049").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Medida Pneu","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Medida Pneu","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr049.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.medida NO-LOCK:

    EMPTY TEMP-TABLE tt-mpn-medid.
    CREATE tt-mpn-medid.
    ASSIGN tt-mpn-medid.cod-medid = STRING(mb.medida.codimedi,"999")
           tt-mpn-medid.des-medid = mb.medida.descricao.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-medid except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-medid).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Medida Pneu","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-medid":U
                       tt-dados.cod-tabela = tt-mpn-medid.cod-medid
                       tt-dados.des-tabela = tt-mpn-medid.des-medid
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Medida Pneu","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mpn-medid.cod-medid
                   tt-dados.des-tabela = tt-mpn-medid.des-medid
                   tt-dados.tabela     = "mpn-medid":U
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

&IF DEFINED(EXCLUDE-pi-mpn-model) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-model Procedure 
PROCEDURE pi-mpn-model :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      /*importa mb.pnmodelo para mpn-modelo */ 
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr050.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr050").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Modelo Pneu","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Modelo Pneu","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN frbo/bofr050.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.pnmodelo NO-LOCK:
    EMPTY TEMP-TABLE tt-mpn-model.
    CREATE tt-mpn-model.
    
    ASSIGN tt-mpn-model.cod-model-pneu  = STRING(mb.pnmodelo.codimopn,"999")
           tt-mpn-model.cod-marca       = STRING(mb.pnmodelo.codifabr,"9999")
           tt-mpn-model.cod-desen       = STRING(mb.pnmodelo.codidese,"999")
           tt-mpn-model.cod-borracha    = string(mb.pnmodelo.codimate,"999")
           tt-mpn-model.cod-ambien-trab = STRING(mb.pnmodelo.codiapli,"999")
           tt-mpn-model.qti-lona        = mb.pnmodelo.qtdlona
           tt-mpn-model.idi-estrut-pneu = 1        /** 1 = Radial = Padr∆o para Equipamentos **/
           tt-mpn-model.un              = "KM":U.
    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-model except r-rowid.
        output close.
    end.
    else do:
        create tt-dados.
        RUN emptyRowErrors IN h-tabela.     
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-model).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Modelo Pneu","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-model":U
                       tt-dados.cod-tabela = tt-mpn-model.cod-model-pneu
                       tt-dados.des-tabela = tt-mpn-model.cod-borracha
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Modelo Pneu","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mpn-model.cod-model-pneu
                   tt-dados.des-tabela = tt-mpn-model.cod-borracha
                   tt-dados.tabela     = "mpn-pos-pneu":U
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

&IF DEFINED(EXCLUDE-pi-mpn-pneu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-pneu Procedure 
PROCEDURE pi-mpn-pneu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.
DEFINE VARIABLE i-media      AS INTEGER NO-UNDO.
DEFINE VARIABLE i-num-sulcos AS INTEGER NO-UNDO.

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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr051.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr051").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Pneu","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Pneu","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN frbo/bofr051.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.pneu NO-LOCK:
    EMPTY TEMP-TABLE tt-mpn-pneu.
    CREATE tt-mpn-pneu.

    for first mb.pneumovim
        where mb.pneumovim.numepneu = mb.pneu.numepneu no-lock:
    end.
    if avail mb.pneumovim then do:
        assign tt-mpn-pneu.cod-sit-pneu-atual = string(mb.pneumovim.codiest,"999").
    end.
    else do:
        assign tt-mpn-pneu.cod-sit-pneu-atual   = string(mb.pneu.codiest,"999").
    end.
    
    ASSIGN tt-mpn-pneu.cod-pneu             = STRING(mb.pneu.numepneu)
           tt-mpn-pneu.des-serie            = mb.pneu.numeserie
           tt-mpn-pneu.cod-model-pneu       = STRING(mb.pneu.codimopn,"999")
           tt-mpn-pneu.dat-inicial          = /*mb.pneu.datainic*/  TODAY  /** Data Atual de implantaá∆o, para n∆o ocorrer erro na importaá∆o de vidas **/
           tt-mpn-pneu.ep-codigo-pneu       = mb.pneu.codiemprprop
           tt-mpn-pneu.num-vida-histor      = 1  /** Vida Hist¢rico ser† importada desde a primeira **/
           tt-mpn-pneu.val-uso-atual        = 0  /** Dever† ap¢s a importaá∆o da Vida, utilizar o programa PN0401, para calcular este campo **/
           /** Inicial do pneu **/
           tt-mpn-pneu.ep-codigo-inicial    = mb.pneu.codiempr
           tt-mpn-pneu.cod-eqpto-inicial    = string(mb.pneu.numeequi)
           tt-mpn-pneu.cod-pos-inicial      = string(mb.pneu.codiposi)
           tt-mpn-pneu.cod-sit-pneu-inicial = string(mb.pneu.codiest,"999")
           tt-mpn-pneu.cod-estabel-inicial  = string(mb.pneu.codiseto)
           tt-mpn-pneu.num-vida-inicial     = mb.pneu.vida
           /** Atual do Pneu **/
           tt-mpn-pneu.ep-codigo-atual      = mb.pneu.codiempr
           tt-mpn-pneu.cod-eqpto-atual      = string(mb.pneu.numeequi)
           tt-mpn-pneu.cod-pos-atual        = string(mb.pneu.codiposi)
           tt-mpn-pneu.cod-estabel-atual    = string(mb.pneu.codiseto)
           tt-mpn-pneu.num-vida-atual       = mb.pneu.vida.
    /** Tipo de Serviáo, para validar pneus em teste **/
    if mb.pneu.emteste then
        assign tt-mpn-pneu.cod-tip-serv = "999". /** Serviáo Padr∆o de Teste, deve estar previamente cadastrado **/
    else 
        assign tt-mpn-pneu.cod-tip-serv = tt-param.c-cod-serv.

    /** Validaá∆o da Situaá∆o **/
    for first mab-sit-eqpto
        where mab-sit-eqpto.cod-sit-eqpto = tt-mpn-pneu.cod-sit-pneu-atual no-lock:
        /** Ativo **/
        if mab-sit-eqpto.idi-tip = 1 then
            assign tt-mpn-pneu.cd-causa-padr = ""
                   tt-mpn-pneu.dat-situacao  = ?
                   tt-mpn-pneu.hra-situacao  = "".
        else 
            assign tt-mpn-pneu.cd-causa-padr = tt-param.c-causa
                   tt-mpn-pneu.dat-situacao  = today
                   tt-mpn-pneu.hra-situacao  = replace(string(time,"HH:MM:SS"),":","").
    end.
    /*** De-Para Estabelecimento ***/
    for first tt-estabelec
        where tt-estabelec.cod-nop = string(mb.pneu.codiseto) no-lock:
        assign tt-mpn-pneu.cod-estabel-inicial = tt-estabelec.cod-estabel
               tt-mpn-pneu.cod-estabel-atual   = tt-estabelec.cod-estabel.
    end.
    /** Busca o c¢digo da medida do modelo do pneu no SISMA **/
    for first mb.pnmodelo
        where mb.pnmodelo.codimopn = mb.pneu.codimopn no-lock:
        assign tt-mpn-pneu.cod-medid = string(mb.pnmodelo.codimedi,"999").
    end.
    assign i-media      = 0
           i-num-sulcos = 0.
    /** Busca os Sulcos do Pneu **/
    for each  mb.pneusulco
        where mb.pneusulco.numepneu = mb.pneu.numepneu no-lock:
        assign i-media      = i-media + mb.pneusulco.profsulco
               i-num-sulcos = i-num-sulcos + 1.
        case mb.pneusulco.sulco:
            when 1  then assign tt-mpn-pneu.val-sulco-1  = mb.pneusulco.profsulco.
            when 2  then assign tt-mpn-pneu.val-sulco-2  = mb.pneusulco.profsulco.
            when 3  then assign tt-mpn-pneu.val-sulco-3  = mb.pneusulco.profsulco.
            when 4  then assign tt-mpn-pneu.val-sulco-4  = mb.pneusulco.profsulco.
            when 5  then assign tt-mpn-pneu.val-sulco-5  = mb.pneusulco.profsulco.
            when 6  then assign tt-mpn-pneu.val-sulco-6  = mb.pneusulco.profsulco.
            when 7  then assign tt-mpn-pneu.val-sulco-7  = mb.pneusulco.profsulco.
            when 8  then assign tt-mpn-pneu.val-sulco-8  = mb.pneusulco.profsulco.
            when 9  then assign tt-mpn-pneu.val-sulco-9  = mb.pneusulco.profsulco.
            when 10 then assign tt-mpn-pneu.val-sulco-10 = mb.pneusulco.profsulco.
        end case.
    end.
    /** Calcula o valor do sulco inicial pela mÇdia dos sulcos **/
    assign tt-mpn-pneu.val-sulco-inicial = if (i-media / i-num-sulcos) <> ? then i-media / i-num-sulcos else 0.
    /** OBS da Importaá∆o **/
    assign tt-mpn-pneu.dsl-obs = "Pneu importado em " + string(today,"99/99/9999") + " " + string(time,"HH:MM:SS").

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-pneu except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-pneu).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Pneu","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-pneu":U
                       tt-dados.cod-tabela = tt-mpn-pneu.cod-pneu
                       tt-dados.des-tabela = tt-mpn-pneu.des-serie
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Pneu","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mpn-pneu.cod-pneu
                   tt-dados.des-tabela = tt-mpn-pneu.des-serie
                   tt-dados.tabela     = "mpn-pneu":U
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

&IF DEFINED(EXCLUDE-pi-mpn-pos-pneu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-pos-pneu Procedure 
PROCEDURE pi-mpn-pos-pneu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa posicao para mpn-pos-pneu */
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE i-pos AS INTEGER    NO-UNDO.

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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr052.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr052").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Posiá∆o Pneu","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Posiá∆o Pneu","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr052.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.posicao NO-LOCK:
    EMPTY TEMP-TABLE tt-mpn-pos-pneu.
    CREATE tt-mpn-pos-pneu.
    
    assign tt-mpn-pos-pneu.cod-pos      = STRING(mb.posicao.codiposi,"99")
           tt-mpn-pos-pneu.des-pos      = mb.posicao.descricao
           tt-mpn-pos-pneu.cod-sub-sist = tt-param.c-sub-sist3
           tt-mpn-pos-pneu.idi-local    = 1.   /** Realizar manutená∆o futura **/
    /** Caso a Descriá∆o comece com 0, significa que Ç um estepe, ent∆o parametriza o registro para um estepe **/
    if substring(mb.posicao.descricao,1,1) = "0" then do:
        assign tt-mpn-pos-pneu.log-estepe = yes
               tt-mpn-pos-pneu.idi-local  = 5
               tt-mpn-pos-pneu.num-eixo   = 0.
    end.
    else do:
        /** Valida se posiá∆o inicial Ç um n£mero, e utiliza este como n£mero do eixo **/
        ASSIGN i-pos = int(SUBSTRING(mb.posicao.descricao,1,1)) NO-ERROR.
        IF not(ERROR-STATUS:ERROR) THEN
            ASSIGN tt-mpn-pos-pneu.num-eixo = int(SUBSTRING(mb.posicao.descricao,1,1)).
        ELSE 
            /* como o n£mero de eixos n∆o pode ser zero e nem nulo utilizar um valor padr∆o */
            ASSIGN tt-mpn-pos-pneu.num-eixo = 1.
        /** Valida em qual posiá∆o no layout a posiá∆o se encontra, cfm a descriá∆o **/
        case trim(substring(mb.posicao.descricao,2,2)):
            when "D":U or when "DE":U then assign tt-mpn-pos-pneu.idi-local = 1. /** Direito Externo **/
            when "DI"                 then assign tt-mpn-pos-pneu.idi-local = 2. /** Direito Interno **/
            when "E":U or when "EE":U then assign tt-mpn-pos-pneu.idi-local = 3. /** Esquerdo Externo **/
            when "EI"                 then assign tt-mpn-pos-pneu.idi-local = 4. /** Esquerdo Interno **/
        end case.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-pos-pneu except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-pos-pneu).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Posiá∆o Pneu","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-pos-pneu":U
                       tt-dados.cod-tabela = tt-mpn-pos-pneu.cod-pos
                       tt-dados.des-tabela = tt-mpn-pos-pneu.des-pos
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Posiá∆o Pneu","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mpn-pos-pneu.cod-pos
                   tt-dados.des-tabela = tt-mpn-pos-pneu.des-pos
                   tt-dados.tabela     = "mpn-pos-pneu":U
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

&IF DEFINED(EXCLUDE-pi-mpn-serv) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-serv Procedure 
PROCEDURE pi-mpn-serv :
/*------------------------------------------------------------------------------
  Purpose:     pi-mpn-serv
  Parameters:  <none>
  Notes:       Cadastra os serviáos Padr‰es de Pneus.
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr053.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr053").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Serviáo","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Serviáo","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr053.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

EMPTY TEMP-TABLE tt-mpn-serv.
CREATE tt-mpn-serv.

run utp/ut-liter.p (input "Colocar","*","").
ASSIGN tt-mpn-serv.cod-servico            = "001":U
       tt-mpn-serv.des-servico            = return-value
       tt-mpn-serv.cod-evento             = tt-param.c-evento
       tt-mpn-serv.cod-sit-eqpto          = tt-param.c-sit-eqpto
       tt-mpn-serv.log-atualiza-vida-pneu = NO
       tt-mpn-serv.log-medi-sulco         = NO
       tt-mpn-serv.log-calib-pneu         = NO
       tt-mpn-serv.log-situacao-pneu      = YES
       tt-mpn-serv.log-eqpto-dest         = YES
       tt-mpn-serv.log-pos-dest           = YES
       tt-mpn-serv.log-estabel-dest       = YES
       tt-mpn-serv.log-contador           = NO
       tt-mpn-serv.log-dados-nf           = NO
       tt-mpn-serv.log-quant-conserto     = NO
       tt-mpn-serv.cd-tipo                = 1  /** Tipo de Manutená∆o 1 Deve estar cadastrado **/
       tt-mpn-serv.cd-causa-padr          = tt-param.c-causa.

/** Realiza a Exportaá∆o **/
RUN pi-mpn-serv-2 IN THIS-PROCEDURE.

EMPTY TEMP-TABLE tt-mpn-serv.
CREATE tt-mpn-serv.      
run utp/ut-liter.p (input "Retirada","*","").
ASSIGN tt-mpn-serv.cod-servico            = "002":U
       tt-mpn-serv.des-servico            = return-value
       tt-mpn-serv.cod-evento             = tt-param.c-evento
       tt-mpn-serv.cod-sit-eqpto          = tt-param.c-sit-eqpto
       tt-mpn-serv.log-atualiza-vida-pneu = NO
       tt-mpn-serv.log-medi-sulco         = NO
       tt-mpn-serv.log-calib-pneu         = NO
       tt-mpn-serv.log-situacao-pneu      = YES
       tt-mpn-serv.log-eqpto-dest         = YES
       tt-mpn-serv.log-pos-dest           = YES
       tt-mpn-serv.log-estabel-dest       = YES
       tt-mpn-serv.log-contador           = NO
       tt-mpn-serv.log-dados-nf           = NO
       tt-mpn-serv.log-quant-conserto     = NO
       tt-mpn-serv.cd-tipo                = 1  /** Tipo de Manutená∆o 1 Deve estar cadastrado **/
       tt-mpn-serv.cd-causa-padr          = tt-param.c-causa.

/** Realiza a Exportaá∆o **/
RUN pi-mpn-serv-2 IN THIS-PROCEDURE.

EMPTY TEMP-TABLE tt-mpn-serv.
CREATE tt-mpn-serv.
run utp/ut-liter.p (input "Reforma","*","").
ASSIGN tt-mpn-serv.cod-servico            = "003":U
       tt-mpn-serv.des-servico            = return-value
       tt-mpn-serv.cod-evento             = tt-param.c-evento
       tt-mpn-serv.cod-sit-eqpto          = tt-param.c-sit-eqpto
       tt-mpn-serv.log-atualiza-vida-pneu = YES
       tt-mpn-serv.log-medi-sulco         = NO
       tt-mpn-serv.log-calib-pneu         = NO
       tt-mpn-serv.log-situacao-pneu      = YES
       tt-mpn-serv.log-eqpto-dest         = NO
       tt-mpn-serv.log-pos-dest           = NO
       tt-mpn-serv.log-estabel-dest       = NO
       tt-mpn-serv.log-contador           = NO
       tt-mpn-serv.log-dados-nf           = YES
       tt-mpn-serv.log-quant-conserto     = YES
       tt-mpn-serv.cd-tipo                = 1  /** Tipo de Manutená∆o 1 Deve estar cadastrado **/
       tt-mpn-serv.cd-causa-padr          = tt-param.c-causa.

/** Realiza a Exportaá∆o **/
RUN pi-mpn-serv-2 IN THIS-PROCEDURE.

EMPTY TEMP-TABLE tt-mpn-serv.
CREATE tt-mpn-serv.                 
run utp/ut-liter.p (input "Rod°zio","*","").
ASSIGN tt-mpn-serv.cod-servico            = "004":U
       tt-mpn-serv.des-servico            = return-value
       tt-mpn-serv.cod-evento             = tt-param.c-evento
       tt-mpn-serv.cod-sit-eqpto          = tt-param.c-sit-eqpto
       tt-mpn-serv.log-atualiza-vida-pneu = NO
       tt-mpn-serv.log-medi-sulco         = NO
       tt-mpn-serv.log-calib-pneu         = NO
       tt-mpn-serv.log-situacao-pneu      = NO
       tt-mpn-serv.log-eqpto-dest         = NO
       tt-mpn-serv.log-pos-dest           = YES
       tt-mpn-serv.log-estabel-dest       = NO
       tt-mpn-serv.log-contador           = NO
       tt-mpn-serv.log-dados-nf           = NO
       tt-mpn-serv.log-quant-conserto     = NO
       tt-mpn-serv.cd-tipo                = 1  /** Tipo de Manutená∆o 1 Deve estar cadastrado **/
       tt-mpn-serv.cd-causa-padr          = tt-param.c-causa.

/** Realiza a Exportaá∆o **/
RUN pi-mpn-serv-2 IN THIS-PROCEDURE.

EMPTY TEMP-TABLE tt-mpn-serv.
CREATE tt-mpn-serv.
run utp/ut-liter.p (input "Conserto","*","").
ASSIGN tt-mpn-serv.cod-servico            = "005":U
       tt-mpn-serv.des-servico            = return-value
       tt-mpn-serv.cod-evento             = tt-param.c-evento
       tt-mpn-serv.cod-sit-eqpto          = tt-param.c-sit-eqpto
       tt-mpn-serv.log-atualiza-vida-pneu = YES
       tt-mpn-serv.log-medi-sulco         = NO
       tt-mpn-serv.log-calib-pneu         = NO
       tt-mpn-serv.log-situacao-pneu      = YES
       tt-mpn-serv.log-eqpto-dest         = NO
       tt-mpn-serv.log-pos-dest           = YES
       tt-mpn-serv.log-estabel-dest       = NO
       tt-mpn-serv.log-contador           = NO
       tt-mpn-serv.log-dados-nf           = YES
       tt-mpn-serv.log-quant-conserto     = YES
       tt-mpn-serv.cd-tipo                = 1  /** Tipo de Manutená∆o 1 Deve estar cadastrado **/
       tt-mpn-serv.cd-causa-padr          = tt-param.c-causa.

/** Realiza a Exportaá∆o **/
RUN pi-mpn-serv-2 IN THIS-PROCEDURE.

EMPTY TEMP-TABLE tt-mpn-serv.
CREATE tt-mpn-serv.
run utp/ut-liter.p (input "Mediá∆o de Sulco","*","").
ASSIGN tt-mpn-serv.cod-servico            = "006":U
       tt-mpn-serv.des-servico            = return-value
       tt-mpn-serv.cod-evento             = tt-param.c-evento
       tt-mpn-serv.cod-sit-eqpto          = tt-param.c-sit-eqpto
       tt-mpn-serv.log-atualiza-vida-pneu = NO
       tt-mpn-serv.log-medi-sulco         = YES
       tt-mpn-serv.log-calib-pneu         = NO
       tt-mpn-serv.log-situacao-pneu      = NO
       tt-mpn-serv.log-eqpto-dest         = NO
       tt-mpn-serv.log-pos-dest           = NO
       tt-mpn-serv.log-estabel-dest       = NO
       tt-mpn-serv.log-contador           = NO
       tt-mpn-serv.log-dados-nf           = NO
       tt-mpn-serv.log-quant-conserto     = NO
       tt-mpn-serv.cd-tipo                = 1  /** Tipo de Manutená∆o 1 Deve estar cadastrado **/
       tt-mpn-serv.cd-causa-padr          = tt-param.c-causa.

/** Realiza a Exportaá∆o **/
RUN pi-mpn-serv-2 IN THIS-PROCEDURE.

EMPTY TEMP-TABLE tt-mpn-serv.
CREATE tt-mpn-serv.
run utp/ut-liter.p (input "Eliminaá∆o","*","").
ASSIGN tt-mpn-serv.cod-servico            = "007":U
       tt-mpn-serv.des-servico            = return-value
       tt-mpn-serv.cod-evento             = tt-param.c-evento
       tt-mpn-serv.cod-sit-eqpto          = tt-param.c-sit-eqpto
       tt-mpn-serv.log-atualiza-vida-pneu = NO
       tt-mpn-serv.log-medi-sulco         = YES
       tt-mpn-serv.log-calib-pneu         = YES
       tt-mpn-serv.log-situacao-pneu      = YES
       tt-mpn-serv.log-eqpto-dest         = YES
       tt-mpn-serv.log-pos-dest           = YES
       tt-mpn-serv.log-estabel-dest       = YES
       tt-mpn-serv.log-contador           = NO
       tt-mpn-serv.log-dados-nf           = NO
       tt-mpn-serv.log-quant-conserto     = NO
       tt-mpn-serv.cd-tipo                = 1  /** Tipo de Manutená∆o 1 Deve estar cadastrado **/
       tt-mpn-serv.cd-causa-padr          = tt-param.c-causa.

/** Realiza a Exportaá∆o **/
RUN pi-mpn-serv-2 IN THIS-PROCEDURE.

EMPTY TEMP-TABLE tt-mpn-serv.
CREATE tt-mpn-serv.
run utp/ut-liter.p (input "Transferància","*","").
ASSIGN tt-mpn-serv.cod-servico            = "008":U
       tt-mpn-serv.des-servico            = return-value
       tt-mpn-serv.cod-evento             = tt-param.c-evento
       tt-mpn-serv.cod-sit-eqpto          = tt-param.c-sit-eqpto
       tt-mpn-serv.log-atualiza-vida-pneu = NO
       tt-mpn-serv.log-medi-sulco         = NO
       tt-mpn-serv.log-calib-pneu         = NO
       tt-mpn-serv.log-situacao-pneu      = NO
       tt-mpn-serv.log-eqpto-dest         = YES
       tt-mpn-serv.log-pos-dest           = YES
       tt-mpn-serv.log-estabel-dest       = YES
       tt-mpn-serv.log-contador           = NO
       tt-mpn-serv.log-dados-nf           = NO
       tt-mpn-serv.log-quant-conserto     = NO
       tt-mpn-serv.cd-tipo                = 1  /** Tipo de Manutená∆o 1 Deve estar cadastrado **/
       tt-mpn-serv.cd-causa-padr          = tt-param.c-causa.

/** Realiza a Exportaá∆o **/
RUN pi-mpn-serv-2 IN THIS-PROCEDURE.

EMPTY TEMP-TABLE tt-mpn-serv.
CREATE tt-mpn-serv.
run utp/ut-liter.p (input "Calibragem","*","").
ASSIGN tt-mpn-serv.cod-servico            = "009":U
       tt-mpn-serv.des-servico            = return-value
       tt-mpn-serv.cod-evento             = tt-param.c-evento
       tt-mpn-serv.cod-sit-eqpto          = tt-param.c-sit-eqpto
       tt-mpn-serv.log-atualiza-vida-pneu = NO
       tt-mpn-serv.log-medi-sulco         = NO
       tt-mpn-serv.log-calib-pneu         = YES
       tt-mpn-serv.log-situacao-pneu      = NO
       tt-mpn-serv.log-eqpto-dest         = NO
       tt-mpn-serv.log-pos-dest           = NO
       tt-mpn-serv.log-estabel-dest       = NO
       tt-mpn-serv.log-contador           = NO
       tt-mpn-serv.log-dados-nf           = NO
       tt-mpn-serv.log-quant-conserto     = NO
       tt-mpn-serv.cd-tipo                = 1  /** Tipo de Manutená∆o 1 Deve estar cadastrado **/
       tt-mpn-serv.cd-causa-padr          = tt-param.c-causa.

/** Realiza a Exportaá∆o **/
RUN pi-mpn-serv-2 IN THIS-PROCEDURE.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mpn-serv-2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-serv-2 Procedure 
PROCEDURE pi-mpn-serv-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 then do:
    OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
        export delimiter ";" tt-mpn-serv except r-rowid.
    output close.
end.
else do:
    CREATE tt-dados.
    RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
    RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-serv).
    RUN createRecord in h-tabela.
    IF RETURN-VALUE = "NOK" then DO:
        RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
        run utp/ut-liter.p (input "Serviáo","*","").
        FOR EACH RowErrors NO-LOCK:
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.erro       = RowErrors.ErrorNumber
                   tt-dados.descricao  = RowErrors.ErrorDescription 
                   tt-dados.tabela     = "mpn-serv":U
                   tt-dados.cod-tabela = tt-mpn-serv.cod-servico
                   tt-dados.des-tabela = tt-mpn-serv.des-servico
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
    ELSE DO:
        run utp/ut-liter.p (input "Serviáo","*","").
        ASSIGN tt-dados.i-chave    = c-cont2
               tt-dados.cod-tabela = tt-mpn-serv.cod-servico 
               tt-dados.des-tabela = tt-mpn-serv.des-servico
               tt-dados.tabela     = "mpn-serv":U
               tt-dados.des-tab    = return-value
               c-cont2             = c-cont2 + 1.
    end.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mpn-tip-borracha) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mpn-tip-borracha Procedure 
PROCEDURE pi-mpn-tip-borracha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa pnmaterial para mpn-tip-borracha */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr054.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr054").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Tipo Borracha","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Tipo Borracha","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr054.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.pnmaterial NO-LOCK:
    EMPTY TEMP-TABLE tt-mpn-tip-borracha.

    CREATE tt-mpn-tip-borracha.
    ASSIGN tt-mpn-tip-borracha.cod-borracha = string(mb.pnmaterial.codimate,"999")
           tt-mpn-tip-borracha.des-borracha = mb.pnmaterial.descricao.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-tip-borracha except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-tip-borracha).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Tipo Borracha","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-tip-borracha":U
                       tt-dados.cod-tabela = tt-mpn-tip-borracha.cod-borracha
                       tt-dados.des-tabela = tt-mpn-tip-borracha.des-borracha
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Tipo Borracha","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mpn-tip-borracha.cod-borracha
                   tt-dados.des-tabela = tt-mpn-tip-borracha.des-borracha
                   tt-dados.tabela     = "mpn-tip-borracha":U
                   tt-dados.des-tab    = return-value
                   c-cont2 = c-cont2 + 1.
        end.
    end.
end.


FOR EACH mb.borracha NO-LOCK:

    EMPTY TEMP-TABLE tt-mpn-tip-borracha.
    CREATE tt-mpn-tip-borracha.
    ASSIGN tt-mpn-tip-borracha.cod-borracha = STRING(mb.borracha.codiborr,"999")
           tt-mpn-tip-borracha.des-borracha = mb.borracha.descricao.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mpn-tip-borracha except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mpn-tip-borracha).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Tipo Borracha","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mpn-tip-borracha":U
                       tt-dados.cod-tabela = tt-mpn-tip-borracha.cod-borracha
                       tt-dados.des-tabela = tt-mpn-tip-borracha.des-borracha
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Tipo Borracha","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mpn-tip-borracha.cod-borracha
                   tt-dados.des-tabela = tt-mpn-tip-borracha.des-borracha
                   tt-dados.tabela     = "mpn-tip-borracha"
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

