&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : ab0708b.i
    Notes       : Importaá∆o dos dados cadastrais do Frotas (p†gina 1, segunda parte).
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE tt-mab-event          LIKE mab-event          FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-bomba          LIKE mab-bomba          FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-model          LIKE mab-model          FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-marca          LIKE mab-marca          FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-motoris        LIKE mab-motoris        FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-tip-mater      LIKE mab-tip-mater      FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-grp-event      LIKE mab-grp-event      FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mmv-tempo-padr     LIKE mmv-tempo-padr     FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-tip-mater-item LIKE mab-tip-mater-item FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-motoris-model  LIKE mab-motoris-model  FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-consu-model    LIKE mab-consu-model    FIELD r-Rowid AS ROWID.

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
/* variaveis */
DEFINE VARIABLE h-tabela AS HANDLE NO-UNDO.
DEFINE VARIABLE i-bomba1 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-bomba2 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-bomba99 AS INTEGER NO-UNDO.
DEFINE VARIABLE c-cont2 AS INTEGER INITIAL 1 NO-UNDO.

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
         HEIGHT             = 11.83
         WIDTH              = 29.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
run abp/api-ab0708h.i persistent set h-cabecalho (input table tt-param).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-mab-bomba) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-bomba Procedure 
PROCEDURE pi-mab-bomba :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa pontobomba para mab-bomba */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr002.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr002").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Bomba Combust°vel","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Bomba Combust°vel","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
ASSIGN i-bomba1  = 1
       i-bomba2  = 1
       i-bomba99 = 1.

IF NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr002.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.pontobomba NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-bomba.
    CREATE tt-mab-bomba.
    
    /* Foi criado uma logica para que o codigo da bomba (cod-bomba) fosse sequencial para cada posto, pois no 
    banco Sisma era poss≠vel inserir vˇrios cΩdigos de bomba iguais para o mesmo posto, no banco Datasul nao e 
    possivel pois o codigo da bomba faz parte da chave primaria composta juntamente com o codigo do posto (cod-posto) */

    /* Data de desativacao ser† em branco */
    IF mb.pontobomba.codipoab = 1 THEN 
        ASSIGN tt-mab-bomba.cod-posto     = STRING(mb.pontobomba.codipoab,"9999")
               tt-mab-bomba.cod-bomba     = STRING(i-bomba1)
               tt-mab-bomba.cod-tip-mater = STRING(mb.pontobomba.codicolu)
               i-bomba1                   = i-bomba1 + 1.
    
    IF mb.pontobomba.codipoab = 2 THEN 
        ASSIGN tt-mab-bomba.cod-posto     = STRING(mb.pontobomba.codipoab,"9999")
               tt-mab-bomba.cod-bomba     = STRING(i-bomba2)
               tt-mab-bomba.cod-tip-mater = STRING(mb.pontobomba.codicolu)
               i-bomba2                   = i-bomba2 + 1.
    else
        ASSIGN tt-mab-bomba.cod-posto     = STRING(mb.pontobomba.codipoab,"9999")
               tt-mab-bomba.cod-bomba     = STRING(i-bomba99)
               tt-mab-bomba.cod-tip-mater = STRING(mb.pontobomba.codicolu)
               i-bomba99                  = i-bomba99 + 1.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-bomba except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-bomba).
        RUN createRecord in h-tabela.

        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Bomba Combust°vel","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-bomba":U
                       tt-dados.cod-tabela = tt-mab-bomba.cod-bomba
                       tt-dados.des-tabela = tt-mab-bomba.cod-tip-mater
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Bomba Combust°vel","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-bomba.cod-bomba
                   tt-dados.des-tabela = tt-mab-bomba.cod-tip-mater
                   tt-dados.tabela     = "mab-bomba":U
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

&IF DEFINED(EXCLUDE-pi-mab-consu-model) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-consu-model Procedure 
PROCEDURE pi-mab-consu-model :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      /* importa modelopera para mab-consu-model*/ 
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr006.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr006").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Consumo Padr∆o","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Consumo Padr∆o","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr006.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.modelopera NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-consu-model.
    CREATE tt-mab-consu-model.
    ASSIGN tt-mab-consu-model.cod-model      = STRING(mb.modelopera.codimode + 1000,"99999")
           tt-mab-consu-model.cod-ativid     = STRING(mb.modelopera.codioper,"999")
           tt-mab-consu-model.val-consu-padr = mb.modelopera.conscomb
           tt-mab-consu-model.cod-tip-mater  = tt-param.c-tip-mater.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-consu-model except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-consu-model).
        RUN createRecord in h-tabela.

        if RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).

            run utp/ut-liter.p (input "Consumo Padr∆o","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-consu-model":U
                       tt-dados.cod-tabela = tt-mab-consu-model.cod-model
                       tt-dados.des-tabela = STRING (tt-mab-consu-model.val-consu-padr)
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Consumo Padr∆o","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-consu-model.cod-model
                   tt-dados.des-tabela = STRING (tt-mab-consu-model.val-consu-padr)
                   tt-dados.tabela     = "mab-consu-model"
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

&IF DEFINED(EXCLUDE-pi-mab-event) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-event Procedure 
PROCEDURE pi-mab-event :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa servico para mab-event */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr010.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr010").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Eventos","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Eventos","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr010.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.servico NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-event.
    CREATE tt-mab-event.
    
    ASSIGN tt-mab-event.cod-evento    = STRING(mb.servico.codiserv,"999")
           tt-mab-event.des-evento    = mb.servico.descricao
           tt-mab-event.des-abrev     = SUBSTRING(mb.servico.descricao,1,10)
           tt-mab-event.cod-grp-event = tt-param.c-grp-event.
           /** O restante das informaá‰es ser∆o padr‰es **/

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-event except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-event).
        RUN createRecord in h-tabela.

        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Eventos","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-event"
                       tt-dados.cod-tabela = tt-mab-event.cod-evento
                       tt-dados.des-tabela = tt-mab-event.des-evento
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Eventos","*","").
            assign tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-event.cod-evento
                   tt-dados.des-tabela = tt-mab-event.des-evento
                   tt-dados.tabela     = "mab-event"
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

&IF DEFINED(EXCLUDE-pi-mab-grp-event) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-grp-event Procedure 
PROCEDURE pi-mab-grp-event :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* gera grupo de evento */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr012.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr012").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Grupo Eventos","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Grupo Eventos","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
**             Cria os 6 Grupos de Eventos Padr‰es             **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr012.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

EMPTY TEMP-TABLE tt-mab-grp-event.
CREATE tt-mab-grp-event.
run utp/ut-liter.p (input "Manutená∆o de ‡leo","*","").
ASSIGN tt-mab-grp-event.cod-grp-event = "001"
       tt-mab-grp-event.des-grp-event = return-value
       tt-mab-grp-event.idi-tip= 1.

/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 then do:
    OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
        export delimiter ";" tt-mab-grp-event except r-rowid.
    output close.
end.
else do:
    CREATE tt-dados.
    RUN emptyRowErrors IN h-tabela.
    RUN setRecord IN h-tabela (INPUT TABLE tt-mab-grp-event).
    RUN createRecord in h-tabela.
    
    IF RETURN-VALUE = "NOK" then DO:
        RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        FOR EACH RowErrors NO-LOCK:
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.erro       = RowErrors.ErrorNumber
                   tt-dados.descricao  = RowErrors.ErrorDescription 
                   tt-dados.tabela     = "mab-grp-event":U
                   tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
                   tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
    ELSE DO:
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        ASSIGN tt-dados.i-chave = c-cont2
               tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
               tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
               tt-dados.tabela     = "mab-grp-event":U
               tt-dados.des-tab    = return-value
               c-cont2             = c-cont2 + 1.
    end.
end.

EMPTY TEMP-TABLE tt-mab-grp-event.
CREATE tt-mab-grp-event.
run utp/ut-liter.p (input "Manuteá∆o de Filtro","*","").
ASSIGN tt-mab-grp-event.cod-grp-event = "002"
       tt-mab-grp-event.des-grp-event = return-value
       tt-mab-grp-event.idi-tip       = 2.

/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 then do:
    OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
        export delimiter ";" tt-mab-grp-event except r-rowid.
    output close.
end.
else do:
    CREATE tt-dados.
    RUN emptyRowErrors IN h-tabela.
    RUN setRecord IN h-tabela (INPUT TABLE tt-mab-grp-event).
    RUN createRecord in h-tabela.
    
    IF RETURN-VALUE = "NOK" then DO:
        RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        FOR EACH RowErrors NO-LOCK:
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.erro       = RowErrors.ErrorNumber
                   tt-dados.descricao  = RowErrors.ErrorDescription 
                   tt-dados.tabela     = "mab-grp-event":U
                   tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
                   tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
    ELSE DO:
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        ASSIGN tt-dados.i-chave    = c-cont2
               tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
               tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
               tt-dados.tabela     = "mab-grp-event":U
               tt-dados.des-tab    = return-value
               c-cont2             = c-cont2 + 1.
    end.
end.

EMPTY TEMP-TABLE tt-mab-grp-event.
CREATE tt-mab-grp-event.
run utp/ut-liter.p (input "Manutená∆o MecÉnica","*","").
ASSIGN tt-mab-grp-event.cod-grp-event = "003"
       tt-mab-grp-event.des-grp-event = return-value
       tt-mab-grp-event.idi-tip       = 3.

/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 then do:
    OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
        export delimiter ";" tt-mab-grp-event except r-rowid.
    output close.
end.
else do:
    CREATE tt-dados.
    RUN emptyRowErrors IN h-tabela.
    RUN setRecord IN h-tabela (INPUT TABLE tt-mab-grp-event).
    RUN createRecord in h-tabela.
    
    IF RETURN-VALUE = "NOK" then DO:
        RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        FOR EACH RowErrors NO-LOCK:
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.erro       = RowErrors.ErrorNumber
                   tt-dados.descricao  = RowErrors.ErrorDescription 
                   tt-dados.tabela     = "mab-grp-event":U
                   tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
                   tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
    ELSE DO:
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        ASSIGN tt-dados.i-chave    = c-cont2
               tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
               tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
               tt-dados.tabela     = "mab-grp-event":U
               tt-dados.des-tab    = return-value
               c-cont2             = c-cont2 + 1.
    end.
end.

EMPTY TEMP-TABLE tt-mab-grp-event.
CREATE tt-mab-grp-event.
run utp/ut-liter.p (input "Motivos Parada","*","").
ASSIGN tt-mab-grp-event.cod-grp-event = "004"
       tt-mab-grp-event.des-grp-event = return-value
       tt-mab-grp-event.idi-tip       = 4.

/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 then do:
    OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
        export delimiter ";" tt-mab-grp-event except r-rowid.
    output close.
end.
else do:
    CREATE tt-dados.
    run emptyRowErrors IN h-tabela.
    RUN setRecord IN h-tabela (INPUT TABLE tt-mab-grp-event).
    RUN createRecord in h-tabela.
    
    if RETURN-VALUE = "NOK" then DO:
        RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        FOR EACH RowErrors NO-LOCK:
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.erro       = RowErrors.ErrorNumber
                   tt-dados.descricao  = RowErrors.ErrorDescription 
                   tt-dados.tabela     = "mab-grp-event"
                   tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
                   tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
    ELSE DO:
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        ASSIGN tt-dados.i-chave    = c-cont2
               tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
               tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
               tt-dados.tabela     = "mab-grp-event":U
               tt-dados.des-tab    = return-value
               c-cont2             = c-cont2 + 1.
    end.
end.

EMPTY TEMP-TABLE tt-mab-grp-event.
CREATE tt-mab-grp-event.
run utp/ut-liter.p (input "Custos","*","").
ASSIGN tt-mab-grp-event.cod-grp-event = "005"
       tt-mab-grp-event.des-grp-event = return-value
       tt-mab-grp-event.idi-tip       = 5.

/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 then do:
    OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
        export delimiter ";" tt-mab-grp-event except r-rowid.
    output close.
end.
else do:
    CREATE tt-dados.
    RUN emptyRowErrors IN h-tabela.
    RUN setRecord IN h-tabela (INPUT TABLE tt-mab-grp-event).
    RUN createRecord in h-tabela.
    
    if RETURN-VALUE = "NOK" then DO:
        RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        FOR EACH RowErrors NO-LOCK:
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.erro       = RowErrors.ErrorNumber
                   tt-dados.descricao  = RowErrors.ErrorDescription 
                   tt-dados.tabela     = "mab-grp-event":U
                   tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
                   tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
    ELSE DO:
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        ASSIGN tt-dados.i-chave    = c-cont2
               tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
               tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
               tt-dados.tabela     = "mab-grp-event":U
               tt-dados.des-tab    = return-value
               c-cont2             = c-cont2 + 1.
    end.
end.

EMPTY TEMP-TABLE tt-mab-grp-event.
CREATE tt-mab-grp-event.
run utp/ut-liter.p (input "Outros","*","").
assign tt-mab-grp-event.cod-grp-event = "006"
       tt-mab-grp-event.des-grp-event = return-value
       tt-mab-grp-event.idi-tip       = 6.

/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 then do:
    OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
        export delimiter ";" tt-mab-grp-event except r-rowid.
    output close.
end.
else do:
    CREATE tt-dados.
    RUN emptyRowErrors IN h-tabela.
    RUN setRecord IN h-tabela (INPUT TABLE tt-mab-grp-event).
    RUN createRecord in h-tabela.
    
    IF RETURN-VALUE = "NOK" then DO:
        RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        FOR EACH RowErrors NO-LOCK:
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.erro       = RowErrors.ErrorNumber
                   tt-dados.descricao  = RowErrors.ErrorDescription 
                   tt-dados.tabela     = "mab-grp-event":U
                   tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
                   tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
    ELSE DO:
        run utp/ut-liter.p (input "Grupo Eventos","*","").
        ASSIGN tt-dados.i-chave    = c-cont2
               tt-dados.cod-tabela = tt-mab-grp-event.cod-grp-event
               tt-dados.des-tabela = tt-mab-grp-event.des-grp-event
               tt-dados.tabela     = "mab-grp-event":U
               tt-dados.des-tab    = return-value
               c-cont2             = c-cont2 + 1.
    end.
end.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-marca) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-marca Procedure 
PROCEDURE pi-mab-marca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa fabricante para mab-marca */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr015.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr015").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Marca","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Marca","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr015.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/*** Marca dos Equipamentos ***/
FOR EACH mb.fabricante NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-marca.
    CREATE tt-mab-marca.
    assign tt-mab-marca.cod-marca = STRING(mb.fabricante.codifabr + 100,"9999")
           tt-mab-marca.nom-marca = mb.fabricante.descr.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE(c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-marca except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-marca).
        RUN createRecord in h-tabela.
    
        IF RETURN-VALUE = "NOK":U then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Marca Equipamentos","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-marca":U
                       tt-dados.cod-tabela = tt-mab-marca.cod-marca
                       tt-dados.des-tabela = tt-mab-marca.nom-marca
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Marca Equipamentos","*","").
            assign tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-marca.cod-marca
                   tt-dados.des-tabela = tt-mab-marca.nom-marca
                   tt-dados.tabela     = "mab-marca":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

/*** Marca dos Componentes ***/
FOR EACH mb.agrefabric NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-marca.
    CREATE tt-mab-marca.
    assign tt-mab-marca.cod-marca = STRING(mb.agrefabric.agrefabr + 1000,"9999")
           tt-mab-marca.nom-marca = mb.agrefabric.descr.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE(c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-marca except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-marca).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK":U then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Marca Componentes","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-marca":U
                       tt-dados.cod-tabela = tt-mab-marca.cod-marca
                       tt-dados.des-tabela = tt-mab-marca.nom-marca
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Marca Componentes","*","").
            assign tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-marca.cod-marca
                   tt-dados.des-tabela = tt-mab-marca.nom-marca
                   tt-dados.tabela     = "mab-marca":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

/*** Marca dos Pneus ***/
FOR EACH mb.pnfabricante NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-marca.
    CREATE tt-mab-marca.
    assign tt-mab-marca.cod-marca = STRING(mb.pnfabricante.codifabr,"9999")
           tt-mab-marca.nom-marca = mb.pnfabricante.descricao.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE(c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-marca except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-marca).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK":U then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Marca Pneus","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-marca":U
                       tt-dados.cod-tabela = tt-mab-marca.cod-marca
                       tt-dados.des-tabela = tt-mab-marca.nom-marca
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Marca Pneus","*","").
            assign tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-marca.cod-marca
                   tt-dados.des-tabela = tt-mab-marca.nom-marca
                   tt-dados.tabela     = "mab-marca":U
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

&IF DEFINED(EXCLUDE-pi-mab-model) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-model Procedure 
PROCEDURE pi-mab-model :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa modelo para mab-model */ 
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr016.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr016").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Modelo","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Modelo","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
if NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr016.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** Modelo de Equipamentos **/
FOR EACH mb.modelo NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-model.
    CREATE tt-mab-model.
    ASSIGN tt-mab-model.cod-model     = STRING (mb.modelo.codimode + 1000,"99999")
           tt-mab-model.cod-marca     = STRING (mb.modelo.codifabr + 100,"9999")
           tt-mab-model.idi-tip-model = 1 /* padr∆o como equipamento*/
           tt-mab-model.des-model     = mb.modelo.resum.
    /** Coloca Descriá∆o Completa do Modelo do Equipamento **/
    for first mb.classopera
        where mb.classopera.codiclop = mb.modelo.codiclop no-lock:
        assign tt-mab-model.des-model = mb.modelo.resum + "-" + mb.classopera.descr.
    end.
    /** Busca a Unidade de Medida **/
    case mb.modelo.codimedi:
        when 1 or when 3 then
            assign tt-mab-model.un = "H":U.
        otherwise
            assign tt-mab-model.un = "KM":U.
    end case.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-model except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-model).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK":U then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Modelo Equipamento","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-model":U
                       tt-dados.cod-tabela = tt-mab-model.cod-model
                       tt-dados.des-tabela = tt-mab-model.des-model
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Modelo Equipamento","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-model.cod-model
                   tt-dados.des-tabela = tt-mab-model.des-model
                   tt-dados.tabela     = "mab-model":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

/** Modelo de Implementos **/
FOR EACH mb.ipmodelo NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-model.
    CREATE tt-mab-model.
    ASSIGN tt-mab-model.cod-model     = STRING (mb.ipmodelo.codimode + 10000,"99999")
           tt-mab-model.des-model     = ipmodelo.descr
           tt-mab-model.cod-marca     = STRING (mb.ipmodelo.codifabr + 100,"9999")
           tt-mab-model.idi-tip-model = 1. /* padr∆o como equipamento*/
    /** Busca a Unidade de Medida **/
    case mb.ipmodelo.codimedi:
        when 1 or when 3 then
            assign tt-mab-model.un = "H":U.
        otherwise
            assign tt-mab-model.un = "KM":U.
    end case.
    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-model except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-model).
        RUN createRecord in h-tabela.
    
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Modelo Implemento","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-model":U
                       tt-dados.cod-tabela = tt-mab-model.cod-model
                       tt-dados.des-tabela = tt-mab-model.des-model
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Modelo Implemento","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-model.cod-model
                   tt-dados.des-tabela = tt-mab-model.des-model
                   tt-dados.tabela     = "mab-model":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

/** Model de Componentes **/
FOR EACH mb.agremodelo NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-model.
    CREATE tt-mab-model.
    ASSIGN tt-mab-model.cod-model     = STRING (mb.agremodelo.agremode,"99999")
           tt-mab-model.cod-marca     = STRING (mb.agremodelo.agreesfa + 1000,"9999")
           tt-mab-model.idi-tip-model = 2 /*padr∆o como componente*/
           tt-mab-model.un            = "KM":U /* somente controla em quilometros */
           tt-mab-model.des-model     = mb.agremodelo.descmode.
    /** Busca descriá∆o completa do Modelo do Componente **/
    for first mb.agreespefabr
        where mb.agreespefabr.agreesfa = mb.agremodelo.agreesfa no-lock:
        assign tt-mab-model.des-model = mb.agremodelo.descmode + "-" + mb.agreespefabr.descr.
    end.
    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-model except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-model).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Modelo Componente","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-model":U
                       tt-dados.cod-tabela = tt-mab-model.cod-model
                       tt-dados.des-tabela = tt-mab-model.des-model
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        else DO:
            run utp/ut-liter.p (input "Modelo Componente","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-model.cod-model
                   tt-dados.des-tabela = tt-mab-model.des-model
                   tt-dados.tabela     = "mab-model":U
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

&IF DEFINED(EXCLUDE-pi-mab-motoris) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-motoris Procedure 
PROCEDURE pi-mab-motoris :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa mltmotorista para mab-motoris */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr017.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr017").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Motorista","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Motorista","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr017.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.mltmotorista NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-motoris.
    CREATE tt-mab-motoris.
    ASSIGN tt-mab-motoris.ep-codigo   = mb.mltmotorista.codiempr
           tt-mab-motoris.cod-estabel = string(mb.mltmotorista.codiseto)  /*tt-param.c-estabel*/
           tt-mab-motoris.cod-matr    = STRING(mb.mltmotorista.matricula)
           tt-mab-motoris.nom-motoris = mb.mltmotorista.nome.
    /*** Utiliza o De-para de Estabelecimento **/
    if tt-param.l-de-para then do:
        for first tt-estabelec
            where tt-estabelec.cod-nop = string(mb.mltmotorista.codiseto) no-lock:
            assign tt-mab-motoris.cod-estabel = tt-estabelec.cod-estabel.
        end.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-motoris except r-rowid.
        output close.
    end.
    else do:
        create tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-motoris).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Motorista","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-motoris":U
                       tt-dados.cod-tabela = tt-mab-motoris.cod-matr
                       tt-dados.des-tabela = tt-mab-motoris.nom-motoris
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE do:
            run utp/ut-liter.p (input "Motorista","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-motoris.cod-matr
                   tt-dados.des-tabela = tt-mab-motoris.nom-motoris
                   tt-dados.tabela     = "mab-motoris":U
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

&IF DEFINED(EXCLUDE-pi-mab-motoris-model) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-motoris-model Procedure 
PROCEDURE pi-mab-motoris-model :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa mltmotorequi para mab-motoris-model */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr018.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr018").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Motorista x Modelo","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Motorista x Modelo","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr018.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.mltmotorequi NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-motoris-model.
    CREATE tt-mab-motoris-model.
    
    for first mb.mltmotorista
        where mb.mltmotorista.matricula = mb.mltmotorequi.matricula no-lock:
        ASSIGN tt-mab-motoris-model.ep-codigo   = mb.mltmotorista.codiempr
               tt-mab-motoris-model.cod-estabel = string(mb.mltmotorista.codiseto)
               tt-mab-motoris-model.cod-matr    = STRING(mb.mltmotorequi.matricula)
               tt-mab-motoris-model.dat-inicial = mb.mltmotorequi.data.
        IF tt-mab-motoris-model.dat-inicial = ? THEN
            ASSIGN tt-mab-motoris-model.dat-inicial = TODAY.
        /** Busca o modelo do equipamento **/
        for first mb.equipamento
            where mb.equipamento.codiempr = mb.mltmotorequi.codiempr
            and   mb.equipamento.numeequi = mb.mltmotorequi.numeequi no-lock:
            assign tt-mab-motoris-model.cod-model = string(mb.equipamento.codimode + 1000,"99999").
        end.
        /** Utiliza o De-para de Estabelecimento **/
        if tt-param.l-de-para then do:
            for first tt-estabelec
                where tt-estabelec.cod-nop = string(mb.mltmotorista.codiseto) no-lock:
                assign tt-mab-motoris-model.cod-estabel = tt-estabelec.cod-estabel.
            end.
        end.
    end.

    /** S¢ tenta Criar caso n∆o exista o motorista x modelo **/
    if not can-find(first mab-motoris-model
                    where mab-motoris-model.ep-codigo   = tt-mab-motoris-model.ep-codigo  
                    and   mab-motoris-model.cod-estabel = tt-mab-motoris-model.cod-estabel
                    and   mab-motoris-model.cod-matr    = tt-mab-motoris-model.cod-matr   
                    and   mab-motoris-model.cod-model   = tt-mab-motoris-model.cod-model no-lock) then do:

        /** Exporta para Excel **/
        if tt-param.dest-exportacao = 1 then do:
            OUTPUT TO VALUE(c-caminho) append convert target "iso8859-1":U.
                export delimiter ";" tt-mab-motoris-model except r-rowid.
            output close.
        end.
        else do:
            CREATE tt-dados.
            RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
            RUN setRecord IN h-tabela (INPUT TABLE tt-mab-motoris-model).
            RUN createRecord in h-tabela.
        
            IF RETURN-VALUE = "NOK" then DO:
                RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
                run utp/ut-liter.p (input "Motorista X Modelo","*","").
                FOR EACH RowErrors NO-LOCK:
                    ASSIGN tt-dados.i-chave    = c-cont2
                           tt-dados.erro       = RowErrors.ErrorNumber
                           tt-dados.descricao  = RowErrors.ErrorDescription 
                           tt-dados.tabela     = "mab-model"
                           tt-dados.cod-tabela = tt-mab-motoris-model.cod-matr
                           tt-dados.des-tabela = "":U
                           tt-dados.des-tab    = return-value
                           c-cont2             = c-cont2 + 1.
                end.
            end.
            ELSE DO:
                run utp/ut-liter.p (input "Motorista X Modelo","*","").
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.cod-tabela = tt-mab-motoris-model.cod-matr
                       tt-dados.des-tabela = ""
                       tt-dados.tabela     = "mab-motoris-model"
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
    end.
end.

if valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-tip-mater) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-tip-mater Procedure 
PROCEDURE pi-mab-tip-mater :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa combulubri para mab-tip-mater */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr026.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr026").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Tipo Material","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Tipo Material","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN frbo/bofr026.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** Combust°vel e lubrificantes **/
FOR EACH mb.combulubri NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-tip-mater.
    CREATE tt-mab-tip-mater.
    ASSIGN tt-mab-tip-mater.cod-tip-mater = STRING(mb.combulubri.codicolu,"999")
           tt-mab-tip-mater.des-tip-mater = STRING(mb.combulubri.descr)
           tt-mab-tip-mater.un            = "L":U
           tt-mab-tip-mater.dat-livre-1   = today
           tt-mab-tip-mater.log-integr    = no. /** ir† vir de tela **/

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-tip-mater except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables RowErrors no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-tip-mater).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Tipo Material","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-tip-mater"
                       tt-dados.cod-tabela = tt-mab-tip-mater.cod-tip-mater
                       tt-dados.des-tabela = tt-mab-tip-mater.des-tip-mater
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Tipo Material","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-tip-mater.cod-tip-mater
                   tt-dados.des-tabela = tt-mab-tip-mater.des-tip-mater
                   tt-dados.tabela     = "mab-tip-mater"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

/** Filtros **/
FOR EACH mb.filtro NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-tip-mater.
    CREATE tt-mab-tip-mater.
    ASSIGN tt-mab-tip-mater.cod-tip-mater = STRING(mb.filtro.codifilt + 100,"999")
           tt-mab-tip-mater.des-tip-mater = STRING(mb.filtro.descr)
           tt-mab-tip-mater.un            = "UN":U
           tt-mab-tip-mater.dat-livre-1   = TODAY
           tt-mab-tip-mater.log-integr    = no. /** ir† vir de tela **/

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-tip-mater except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables RowErrors no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-tip-mater).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Tipo Material","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-tip-mater"
                       tt-dados.cod-tabela = tt-mab-tip-mater.cod-tip-mater
                       tt-dados.des-tabela = tt-mab-tip-mater.des-tip-mater
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Tipo Material","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-tip-mater.cod-tip-mater
                   tt-dados.des-tabela = tt-mab-tip-mater.des-tip-mater
                   tt-dados.tabela     = "mab-tip-mater"
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

&IF DEFINED(EXCLUDE-pi-mab-tip-mater-item) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-tip-mater-item Procedure 
PROCEDURE pi-mab-tip-mater-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /*importa relamat para mab-tip-mater-item*/
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr027.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr027").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Tipo Material x Item Estoque","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Tipo Material x Item Estoque","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr027.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.relamat NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-tip-mater-item.
    CREATE tt-mab-tip-mater-item.
    ASSIGN tt-mab-tip-mater-item.cod-tip-mater = STRING(mb.relamat.codicolu,"999")
           tt-mab-tip-mater-item.it-codigo     = STRING(mb.relamat.codimat).

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-tip-mater-item except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-tip-mater-item ).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Tipo Material X Item Estoque","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-tip-mater-item"
                       tt-dados.cod-tabela = tt-mab-tip-mater-item.cod-tip-mater
                       tt-dados.des-tabela = tt-mab-tip-mater-item.it-codigo
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Tipo Material X Item Estoque","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-tip-mater-item.cod-tip-mater
                   tt-dados.des-tabela = tt-mab-tip-mater-item.it-codigo
                   tt-dados.tabela     = "mab-tip-mater-item"
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

&IF DEFINED(EXCLUDE-pi-mmv-tempo-padr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mmv-tempo-padr Procedure 
PROCEDURE pi-mmv-tempo-padr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa mmv-tar-plano para mmv-tempo-padr*/
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr078.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr078").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Tempo Padr∆o","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Tempo Padr∆o","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr078.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** Tabela Tarefas do Plano Preventivo deve estar importada antes da tabela Tempo Padr∆o **/
FOR EACH mmv-tar-plano NO-LOCK:

    EMPTY TEMP-TABLE tt-mmv-tempo-padr.
    CREATE tt-mmv-tempo-padr.
    assign tt-mmv-tempo-padr.cod-model      = mmv-tar-plano.cod-model
           tt-mmv-tempo-padr.cod-sub-sist   = mmv-tar-plano.cod-sub-sist
           tt-mmv-tempo-padr.cod-evento     = mmv-tar-plano.cod-evento
           tt-mmv-tempo-padr.val-tempo-padr = mmv-tar-plano.val-tempo-padr.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mmv-tempo-padr except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mmv-tempo-padr).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Tempo Padr∆o","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mmv-tempo-padr"
                       tt-dados.cod-tabela = tt-mmv-tempo-padr.cod-evento
                       tt-dados.des-tabela = STRING(tt-mmv-tempo-padr.val-tempo-padr)
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Tempo Padr∆o","*","").
            ASSIGN tt-dados.i-chave = c-cont2
                   tt-dados.cod-tabela = tt-mmv-tempo-padr.cod-evento
                   tt-dados.des-tabela = STRING(tt-mmv-tempo-padr.val-tempo-padr)
                   tt-dados.tabela     = "mab-tempo-padr"
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
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

