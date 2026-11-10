&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : api-ab0708a.i
    Notes       : procedures de importa‡Æo da P gina 1 do AB0708
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Temp-Tables */
DEFINE TEMP-TABLE tt-mab-sist       LIKE mab-sist       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-ativid     LIKE mab-ativid     FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-posto      LIKE mab-posto      FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-caract     LIKE mab-caract     FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-trajeto    LIKE mab-trajeto    FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-sub-sist   LIKE mab-sub-sist   FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-sit-eqpto  LIKE mab-sit-eqpto  FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-grp-eqpto  LIKE mab-grp-eqpto  FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-comptmento LIKE mab-comptmento FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mab-estrut-mec LIKE mab-estrut-mec FIELD r-Rowid AS ROWID.


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

/*Variaveis */
DEFINE VARIABLE c-cont2 AS INTEGER INIT 1 NO-UNDO.

DEFINE VARIABLE h-tabela AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE c-cont AS INTEGER INIT 1  NO-UNDO.

DEFINE VARIABLE h-cabecalho AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-caminho AS CHARACTER  NO-UNDO.

/** Temp-Tables de Parƒmetros **/
{abp/ab0708.i1}

define input parameter table for tt-param.

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
         HEIGHT             = 11.08
         WIDTH              = 28.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
run abp/api-ab0708h.i persistent set h-cabecalho (input table tt-param).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-mab-ativid) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-ativid Procedure 
PROCEDURE pi-mab-ativid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:    /* importa operacao para mab-ativid */   
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parƒmetros estÆo OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens ‚ Iniciado **/
assign c-cont2 = 1.
/******************************************
** Valida‡Æo do Destino da Importa‡Æo
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr001.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr001").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Atividades","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Atividades","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN frbo/bofr001.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.operacao NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-ativid.
    CREATE tt-mab-ativid.
    
    ASSIGN tt-mab-ativid.cod-ativid = STRING(mb.operacao.codioper,"999")
           tt-mab-ativid.des-ativid = mb.operacao.descr.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
        export delimiter ";" tt-mab-ativid except r-rowid.
        output close.
    end.
    /** Exporta para o Banco de Frotas **/
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-ativid).
        RUN createRecord IN h-tabela.
        
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Atividades","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-ativid"
                       tt-dados.cod-tabela = tt-mab-ativid.cod-ativid
                       tt-dados.des-tabela = tt-mab-ativid.des-ativid
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Atividades","*","").
            assign tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-ativid.cod-ativid
                   tt-dados.des-tabela = tt-mab-ativid.des-ativid
                   tt-dados.tabela     = "mab-ativid"
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

&IF DEFINED(EXCLUDE-pi-mab-caract) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-caract Procedure 
PROCEDURE pi-mab-caract :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa caractecnica para mab-caract */
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parƒmetros estÆo OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens ‚ Iniciado **/
assign c-cont2 = 1.
/******************************************
** Valida‡Æo do Destino da Importa‡Æo
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr098.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr098").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Caracter¡sticas","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Caracter¡sticas","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr098.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** mb.caractecnica **/
FOR EACH mb.caractecnica NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-caract.
    CREATE tt-mab-caract.
    
    ASSIGN tt-mab-caract.cod-caract = STRING (mb.caractecnica.codicatc)                                    
           tt-mab-caract.des-caract = mb.caractecnica.descricao
           tt-mab-caract.des-abrev  =  substring(mb.caractecnica.descricao,1,10).

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-caract except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-caract).
        RUN createRecord in h-tabela.

        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Caracter¡stica","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-caract"
                       tt-dados.cod-tabela = tt-mab-caract.cod-caract
                       tt-dados.des-tabela = tt-mab-caract.des-caract
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Caracter¡stica","*","").
            ASSIGN tt-dados.i-chave     = c-cont2
                   tt-dados.cod-tabela  = tt-mab-caract.cod-caract
                    tt-dados.des-tabela = tt-mab-caract.des-caract
                    tt-dados.tabela     = "mab-caract"
                    tt-dados.des-tab    = return-value
                    c-cont2             = c-cont2 + 1.
        end.
    end.
end.

ASSIGN c-cont = 1.
/** mb.tipocaractec **/
FOR EACH mb.tipocaractec NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-caract.
    CREATE tt-mab-caract.
    ASSIGN tt-mab-caract.cod-caract = STRING (c-cont)
           tt-mab-caract.des-caract = mb.tipocaractec.descricao
           tt-mab-caract.des-abrev  = substring(mb.tipocaractec.descricao,1,10)
           c-cont                   = c-cont + 1.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-caract except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-caract).
        RUN createRecord in h-tabela.

        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Carater¡stica","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-caract"
                       tt-dados.cod-tabela = tt-mab-caract.cod-caract
                       tt-dados.des-tabela = tt-mab-caract.des-caract
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Carater¡stica","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-caract.cod-caract
                   tt-dados.des-tabela = tt-mab-caract.cod-caract
                   tt-dados.tabela     = "mab-caract"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

/** mb.itemcaractec **/
FOR EACH mb.itemcaractec NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-caract.
    CREATE tt-mab-caract.
    
    ASSIGN tt-mab-caract.cod-caract = STRING (c-cont) 
           tt-mab-caract.des-caract = mb.itemcaractec.descricao
           tt-mab-caract.des-abrev  = substring(mb.itemcaractec.descricao,1,10)
           c-cont                   = c-cont + 1.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-caract except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-caract).
        run createRecord in h-tabela.

        if RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Caracter¡stica","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-caract"
                       tt-dados.cod-tabela = tt-mab-caract.cod-caract
                       tt-dados.des-tabela = tt-mab-caract.des-caract
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Caracter¡stica","*","").
            ASSIGN tt-dados.i-chave = c-cont2
                   tt-dados.cod-tabela = tt-mab-caract.cod-caract
                   tt-dados.des-tabela = tt-mab-caract.des-caract
                   tt-dados.tabela     = "mab-caract"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

/** mb.modcartec **/
FOR EACH mb.modcartec NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-caract.
    CREATE tt-mab-caract.
    
    ASSIGN tt-mab-caract.cod-caract = STRING(mb.modcartec.codicatc)
           tt-mab-caract.des-caract = substring(string(mb.modcartec.codicatc),1,10)
           tt-mab-caract.des-abrev  = substring(string(mb.modcartec.codicatc),1,10).

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-caract except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-caract).
        RUN createRecord in h-tabela.

        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Caracter¡stica","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave     =  c-cont2
                       tt-dados.erro        =  RowErrors.ErrorNumber
                       tt-dados.descricao   =  RowErrors.ErrorDescription 
                       tt-dados.tabela      =  "mab-caract"
                       tt-dados.cod-tabela  =  tt-mab-caract.cod-caract
                       tt-dados.des-tabela  =  tt-mab-caract.des-caract
                       tt-dados.des-tab     =  return-value
                       c-cont2              =  c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Caracter¡stica","*","").
            ASSIGN tt-dados.i-chave     =  c-cont2
                   tt-dados.cod-tabela  =  tt-mab-caract.cod-caract
                   tt-dados.des-tabela  =  tt-mab-caract.des-caract
                   tt-dados.tabela      =  "mab-caract"
                   tt-dados.des-tab     =  return-value
                   c-cont2              =  c-cont2 + 1.
        end.
    end.
end.

/** mb.modcartec-it **/
FOR EACH mb.modcartec-it NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-caract.
    CREATE tt-mab-caract.
    
    ASSIGN tt-mab-caract.cod-caract = STRING(mb.modcartec-it.codicatc)
           tt-mab-caract.des-caract = substring(string(mb.modcartec-it.codicatc),1,10)
           tt-mab-caract.des-abrev  = substring(string(mb.modcartec-it.codicatc),1,10).

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-caract except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-caract).
        RUN createRecord in h-tabela.

        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).

            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave     =  c-cont2
                       tt-dados.erro        =  RowErrors.ErrorNumber
                       tt-dados.descricao   =  RowErrors.ErrorDescription 
                       tt-dados.tabela      =  "mab-caract"
                       tt-dados.cod-tabela  =  tt-mab-caract.cod-caract
                       tt-dados.des-tabela  =  tt-mab-caract.des-caract
                       tt-dados.des-tab     =  "Caracteristica"     
                       c-cont2              =  c-cont2 + 1.
            end.
        end.
        else DO:
            ASSIGN tt-dados.i-chave     =  c-cont2
                   tt-dados.cod-tabela  =  tt-mab-caract.cod-caract
                   tt-dados.des-tabela  =  tt-mab-caract.des-caract
                   tt-dados.tabela      =  "mab-caract"
                   tt-dados.des-tab     =  "Caracteristica"
                   c-cont2              =  c-cont2 + 1.
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

&IF DEFINED(EXCLUDE-pi-mab-comptmento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-comptmento Procedure 
PROCEDURE pi-mab-comptmento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa compartimento para mab-comptmento */
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parƒmetros estÆo OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens ‚ Iniciado **/
assign c-cont2 = 1.
/******************************************
** Valida‡Æo do Destino da Importa‡Æo
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr003.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr003").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Compartimentos","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Compartimentos","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr003.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** mb.compartimento **/
FOR EACH mb.compartimento NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-comptmento.
    CREATE tt-mab-comptmento.

    ASSIGN tt-mab-comptmento.cod-comptmento  = STRING(mb.compartimento.codicomp,"9999")
           tt-mab-comptmento.des-comptmento  = mb.compartimento.descr
           tt-mab-comptmento.idi-oleo-filtro = 1.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-comptmento except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-comptmento).
        RUN createRecord in h-tabela.

        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).

            FOR EACH RowErrors NO-LOCK:
                run utp/ut-liter.p (input "Compartimento","*","").
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-comptmento"
                       tt-dados.cod-tabela = tt-mab-comptmento.cod-comptmento
                       tt-dados.des-tabela = tt-mab-comptmento.des-comptmento
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Compartimento","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-comptmento.cod-comptmento
                   tt-dados.des-tabela = tt-mab-comptmento.des-comptmento
                   tt-dados.tabela     = "mab-comptmento"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

/** mb.filtro **/
FOR EACH mb.filtro NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-comptmento.
    CREATE tt-mab-comptmento.
    /** Filtros tˆm numera‡Æo que come‡a a partir de 500, para nÆo ocorrer duplicidade de c¢digos com Compartimentos àleo **/
    ASSIGN tt-mab-comptmento.cod-comptmento  = STRING (mb.filtro.codifilt + 500,"9999")
           tt-mab-comptmento.des-comptmento  = mb.filtro.descr
           tt-mab-comptmento.idi-oleo-filtro = 2.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-comptmento except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-comptmento).
        RUN createRecord in h-tabela.
    
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Filtro","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-comptmento":U
                       tt-dados.cod-tabela = tt-mab-comptmento.cod-comptmento
                       tt-dados.des-tabela = tt-mab-comptmento.des-comptmento
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Filtro","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-comptmento.cod-comptmento
                   tt-dados.des-tabela = tt-mab-comptmento.des-comptmento
                   tt-dados.tabela     = "mab-comptmento":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

return "OK":U.

END procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-estrut-mec) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-estrut-mec Procedure 
PROCEDURE pi-mab-estrut-mec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa classmecan para mab-estrut-mec */
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.
DEFINE VARIABLE l-eai AS LOGICAL    NO-UNDO.

/** Valida Se parƒmetros estÆo OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens ‚ Iniciado **/
assign c-cont2 = 1
       l-eai   = NO.
/******************************************
** Valida‡Æo do Destino da Importa‡Æo
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr009.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr009").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Estrutura Mecƒnica","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Estrutura Mecƒnica","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
/** Desabilita EAI no processo **/
IF v_log_eai_habilit THEN
    assign v_log_eai_habilit = NO
           l-eai             = YES.

IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr009.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.classmecan NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-estrut-mec.
    CREATE tt-mab-estrut-mec.
    
    ASSIGN tt-mab-estrut-mec.cod-estrut-mec = STRING (mb.classmecan.codiclme,"999")
           tt-mab-estrut-mec.des-estrut-mec = mb.classmecan.descr.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-estrut-mec except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-estrut-mec).
        RUN createRecord in h-tabela.

        IF RETURN-VALUE = "NOK":U then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Estrutura Mecƒnica","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-estrut-mec"
                       tt-dados.cod-tabela = tt-mab-estrut-mec.cod-estrut-mec
                       tt-dados.des-tabela = tt-mab-estrut-mec.des-estrut-mec
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Estrutura Mecƒnica","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-estrut-mec.cod-estrut-mec
                   tt-dados.des-tabela = tt-mab-estrut-mec.des-estrut-mec
                   tt-dados.tabela     = "mab-estrut-mec"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

/** Habilita EAI novamente ap¢s inclusÆo **/
IF l-eai THEN
    ASSIGN v_log_eai_habilit = YES.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-grp-eqpto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-grp-eqpto Procedure 
PROCEDURE pi-mab-grp-eqpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      /* importa classopera para mab-grp-eqpto */ 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.
DEFINE VARIABLE l-eai AS LOGICAL    NO-UNDO.

/** Valida Se parƒmetros estÆo OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens ‚ Iniciado **/
assign c-cont2 = 1
       l-eai   = NO.
/******************************************
** Valida‡Æo do Destino da Importa‡Æo
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr011.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr011").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Grupo Equipamento","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Grupo Equipamento","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
/** Desabilita EAI no processo **/
IF v_log_eai_habilit THEN
    assign v_log_eai_habilit = NO
           l-eai             = YES.

IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr011.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.classopera NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-grp-eqpto.
    CREATE tt-mab-grp-eqpto.
    ASSIGN tt-mab-grp-eqpto.cod-grp-eqpto =STRING(mb.classopera.codiclop,"999")
           tt-mab-grp-eqpto.des-grp-eqpto = mb.classopera.descr.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-grp-eqpto except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-grp-eqpto).
        RUN createRecord in h-tabela.
    
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Grupo Equipamento","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-grp-eqpto":U
                       tt-dados.cod-tabela = tt-mab-grp-eqpto.cod-grp-eqpto
                       tt-dados.des-tabela = tt-mab-grp-eqpto.des-grp-eqpto
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        else DO:
            run utp/ut-liter.p (input "Grupo Equipamento","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-grp-eqpto.cod-grp-eqpto
                   tt-dados.des-tabela = tt-mab-grp-eqpto.des-grp-eqpto
                   tt-dados.tabela     = "mab-grp-eqpto":U
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

IF valid-handle(h-tabela) then
    RUN Destroy in h-tabela.

/** Habilita EAI novamente ap¢s inclusÆo **/
IF l-eai THEN
    ASSIGN v_log_eai_habilit = YES.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mab-posto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-posto Procedure 
PROCEDURE pi-mab-posto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa pontoabast to mab-posto */
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parƒmetros estÆo OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens ‚ Iniciado **/
assign c-cont2 = 1.
/******************************************
** Valida‡Æo do Destino da Importa‡Æo
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr021.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr021").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Posto Combust¡vel","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Posto Combust¡vel","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela)   THEN
    RUN  frbo/bofr021.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.pontoabast NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-posto.
    CREATE tt-mab-posto.
    
    ASSIGN tt-mab-posto.cod-posto    = STRING(mb.pontoabast.codipoab,"9999")
           tt-mab-posto.des-posto    = mb.pontoabast.descr
           tt-mab-posto.ep-codigo    = mb.pontoabast.codiempr
           tt-mab-posto.cod-depos    = tt-param.c-depos
           tt-mab-posto.cod-estabel  = string(mb.pontoabast.codiseto)
           tt-mab-posto.idi-posto    = 1  /** Todo posto ‚ importado como pr¢prio, podetriormente dever  ser atualizado **/
           tt-mab-posto.cod-emitente = 0. /** Todo posto ‚ importado como pr¢prio, podetriormente dever  ser atualizado **/

    /*** Utiliza o De-para de Estabelecimento **/
    if tt-param.l-de-para then do:
        for first tt-estabelec
            where tt-estabelec.cod-nop = string(mb.pontoabast.codiseto) no-lock:
            assign tt-mab-posto.cod-estabel = tt-estabelec.cod-estabel.
        end.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-posto except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-posto).
        RUN createRecord in h-tabela.

        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Posto Combust¡vel","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-posto"
                       tt-dados.cod-tabela = tt-mab-posto.cod-posto
                       tt-dados.des-tabela = tt-mab-posto.des-posto
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Posto Combust¡vel","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-posto.cod-posto
                   tt-dados.des-tabela = tt-mab-posto.des-posto
                   tt-dados.tabela     = "mab-posto"
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

&IF DEFINED(EXCLUDE-pi-mab-sist) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-sist Procedure 
PROCEDURE pi-mab-sist :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa sistema para mab-sist */
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parƒmetros estÆo OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens ‚ Iniciado **/
assign c-cont2 = 1.
/******************************************
** Valida‡Æo do Destino da Importa‡Æo
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr023.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr023").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Sistema Mecƒnico","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Sistema Mecƒnico","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr023.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.sistema NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-sist.
    CREATE tt-mab-sist.
    
    ASSIGN tt-mab-sist.cod-sistema = STRING(mb.sistema.codisist,"999")
           tt-mab-sist.des-sistema = mb.sistema.descricao.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-sist except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-sist).
        RUN createRecord in h-tabela.
    
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Sistema Mecƒnico","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-sist"
                       tt-dados.cod-tabela = tt-mab-sist.cod-sistema
                       tt-dados.des-tabela = tt-mab-sist.des-sistema
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Sistema Mecƒnico","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-sist.cod-sistema
                   tt-dados.des-tabela = tt-mab-sist.des-sistema
                   tt-dados.tabela     = "mab-sist"
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

&IF DEFINED(EXCLUDE-pi-mab-sit-eqpto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-sit-eqpto Procedure 
PROCEDURE pi-mab-sit-eqpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa situacao para mab-sit-eqpto */
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parƒmetros estÆo OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens ‚ Iniciado **/
assign c-cont2 = 1.
/******************************************
** Valida‡Æo do Destino da Importa‡Æo
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr024.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr024").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Situa‡Æo","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Situa‡Æo","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr024.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** Busca Situa‡Æo dos Equipamentos **/
FOR EACH mb.situacao NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-sit-eqpto.
    CREATE tt-mab-sit-eqpto.
    /** Situa‡Æo Equipamento ter  numera‡Æo a partir de 100 para nÆo ocorrer duplicidade **/
    ASSIGN tt-mab-sit-eqpto.cod-sit-eqpto = STRING(mb.situacao.codisitu + 100,"999")
           tt-mab-sit-eqpto.des-sit-eqpto = mb.situacao.descr
           tt-mab-sit-eqpto.idi-tip       = 1.  /** Todas as situa‡äes serÆo colocadas como Ativa **/

    /** Somente se encontrar na descri‡Æo "Inativo", coloca como inativo **/
    IF INDEX(tt-mab-sit-eqpto.des-sit-eqpto,"Inativo":U) > 0 THEN
        ASSIGN tt-mab-sit-eqpto.idi-tip = 2.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-sit-eqpto except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-sit-eqpto).
        RUN createRecord in h-tabela.
        
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Situa‡Æo","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-sit-eqpto"
                       tt-dados.cod-tabela = tt-mab-sit-eqpto.cod-sit-eqpto
                       tt-dados.des-tabela = tt-mab-sit-eqpto.des-sit-eqpto
                       tt-dados.des-tab    = return-value
                       c-cont2 = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Situa‡Æo","*","").
            ASSIGN tt-dados.i-chave = c-cont2
                   tt-dados.cod-tabela = tt-mab-sit-eqpto.cod-sit-eqpto
                   tt-dados.des-tabela = tt-mab-sit-eqpto.des-sit-eqpto
                   tt-dados.tabela     = "mab-sit-eqpto"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

/** Busca Situa‡Æo dos Pneus **/
FOR EACH mb.estado NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-sit-eqpto.
    CREATE tt-mab-sit-eqpto.
    ASSIGN tt-mab-sit-eqpto.cod-sit-eqpto = STRING(mb.estado.codiest,"999")
           tt-mab-sit-eqpto.des-sit-eqpto = mb.estado.descricao
           tt-mab-sit-eqpto.idi-tip       = 1.  /** Todas as situa‡äes serÆo colocadas como Ativa **/

    /** Somente se encontrar na descri‡Æo "Inativo", coloca como inativo **/
    IF INDEX(tt-mab-sit-eqpto.des-sit-eqpto,"Inativo":U) > 0 THEN
        ASSIGN tt-mab-sit-eqpto.idi-tip = 2.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-sit-eqpto except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-sit-eqpto).
        RUN createRecord in h-tabela.
        
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Situa‡Æo","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-sit-eqpto"
                       tt-dados.cod-tabela = tt-mab-sit-eqpto.cod-sit-eqpto
                       tt-dados.des-tabela = tt-mab-sit-eqpto.des-sit-eqpto
                       tt-dados.des-tab    = return-value
                       c-cont2 = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Situa‡Æo","*","").
            ASSIGN tt-dados.i-chave = c-cont2
                   tt-dados.cod-tabela = tt-mab-sit-eqpto.cod-sit-eqpto
                   tt-dados.des-tabela = tt-mab-sit-eqpto.des-sit-eqpto
                   tt-dados.tabela     = "mab-sit-eqpto"
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

&IF DEFINED(EXCLUDE-pi-mab-sub-sist) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-sub-sist Procedure 
PROCEDURE pi-mab-sub-sist :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa local para mab-sub-sist */
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parƒmetros estÆo OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens ‚ Iniciado **/
assign c-cont2 = 1.
/******************************************
** Valida‡Æo do Destino da Importa‡Æo
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr025.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr025").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Sub-Sistema","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Sub-Sistema","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr025.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.local NO-LOCK:

    EMPTY TEMP-TABLE tt-mab-sub-sist.
    CREATE tt-mab-sub-sist.
    ASSIGN  tt-mab-sub-sist.cod-sub-sist = STRING (mb.local.codilocal,"9999")
            tt-mab-sub-sist.des-sub-sist = mb.local.descricao.

    /** Busca na estrutura da compisi‡Æo, a qual sistema pertence o sub-sistema **/
    FOR FIRST mb.composicao WHERE mb.composicao.codilocal = mb.local.codilocal:
        ASSIGN tt-mab-sub-sist.cod-sistema = STRING (mb.composicao.codisist,"999").
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-sub-sist except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-sub-sist).
        RUN createRecord in h-tabela.
    
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Sub-Sistema","*","").
            for EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-sub-sist":U
                       tt-dados.cod-tabela = tt-mab-sub-sist.cod-sub-sist
                       tt-dados.des-tabela = tt-mab-sub-sist.des-sub-sist
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Sub-Sistema","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mab-sub-sist.cod-sub-sist
                   tt-dados.des-tabela = tt-mab-sub-sist.des-sub-sist
                   tt-dados.tabela     = "mab-sub-sist":U
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

&IF DEFINED(EXCLUDE-pi-mab-trajeto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mab-trajeto Procedure 
PROCEDURE pi-mab-trajeto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa trajetolocal para mab-trajeto */
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.

/** Valida Se parƒmetros estÆo OK **/
find first tt-param no-lock.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
/** Contador de Mensagens ‚ Iniciado **/
assign c-cont2 = 1.
/******************************************
** Valida‡Æo do Destino da Importa‡Æo
******************************************/
/** Exporta para Excel **/
if tt-param.dest-exportacao = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr028.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr028").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Trajetos","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Trajetos","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr028.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.trajetolocal NO-LOCK:
    EMPTY TEMP-TABLE tt-mab-trajeto.
    CREATE tt-mab-trajeto.
    
    ASSIGN tt-mab-trajeto.cod-rota = STRING(mb.trajetolocal.coditraj,"99999")
           tt-mab-trajeto.des-rota = mb.trajetolocal.descricao.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mab-trajeto except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mab-trajeto).
        RUN createRecord in h-tabela.
    
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Trajetos","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mab-trajeto"
                       tt-dados.cod-tabela = tt-mab-trajeto.cod-rota
                       tt-dados.des-tabela = tt-mab-trajeto.des-rota
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE do:
            run utp/ut-liter.p (input "Trajetos","*","").
            ASSIGN tt-dados.i-chave = c-cont2
                   tt-dados.cod-tabela = tt-mab-trajeto.cod-rota
                   tt-dados.des-tabela = tt-mab-trajeto.des-rota
                   tt-dados.tabela     = "mab-trajeto"
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

