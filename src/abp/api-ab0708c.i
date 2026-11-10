&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : api-ab0708c.i
    Notes       : importa‡Æo cadastros frotas
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE tt-mmv-ofici          LIKE mmv-ofici          FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mmv-tar-plano      LIKE mmv-tar-plano      FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mmv-func-ofici     LIKE mmv-func-ofici     FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mmv-setor-ofici    LIKE mmv-setor-ofici    FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mmv-plano-prevent  LIKE mmv-plano-prevent  FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mmv-tar-plano-item LIKE mmv-tar-plano-item FIELD r-Rowid AS ROWID.

DEFINE VARIABLE h-tabela AS HANDLE NO-UNDO.
DEFINE VARIABLE c-cont AS INTEGER NO-UNDO.
DEFINE VARIABLE c-cont2 AS INTEGER INIT 1 NO-UNDO.

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

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.

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
         HEIGHT             = 8.5
         WIDTH              = 30.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
run abp/api-ab0708h.i persistent set h-cabecalho (input table tt-param).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-mmv-func-ofici) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mmv-func-ofici Procedure 
PROCEDURE pi-mmv-func-ofici :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa mecanico para mmv-func-ofici */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr032.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr032").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Funcion rio Manuten‡Æo","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Funcion rio Manuten‡Æo","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela)   THEN
    RUN  frbo/bofr032.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.
/** Seta o programa AB0708, para permitir colocar o funcion rio sem o Estabelecimento **/
run setaPrograma in h-tabela (input "AB0708":U) no-error.

FOR EACH mb.mecanico NO-LOCK:

    EMPTY TEMP-TABLE tt-mmv-func-ofici.
    CREATE tt-mmv-func-ofici.
    ASSIGN tt-mmv-func-ofici.ep-codigo            = int(tt-param.c-cod-empr2)
           tt-mmv-func-ofici.cod-estabel          = "" /** Envia em branco para posterior manuten‡Æo pelo AB0707 **/
           tt-mmv-func-ofici.cod-matr             = STRING(mb.mecanico.numemeca)
           tt-mmv-func-ofici.nom-func             = mb.mecanico.nome
           tt-mmv-func-ofici.cod-setor-ofici      = STRING(mb.mecanico.codiseof,"999")
           tt-mmv-func-ofici.cd-mob-dir           = ""
           tt-mmv-func-ofici.cc-codigo            = tt-param.c-cod-cc
           tt-mmv-func-ofici.dat-inicial          = mb.mecanico.dataadmis
           tt-mmv-func-ofici.dat-desativ          = mb.mecanico.datdesat
           tt-mmv-func-ofici.log-control-hora     = yes
           tt-mmv-func-ofici.log-permite-cria-tar = no.
    if tt-mmv-func-ofici.dat-inicial = ? THEN
        ASSIGN tt-mmv-func-ofici.dat-inicial = TODAY.
    /** Se a data de desativa‡Æo est  informada, est  inativo **/
    IF mb.mecanico.datdesat = ? THEN 
        ASSIGN tt-mmv-func-ofici.idi-situacao = 1. /** Ativo **/
    ELSE
        ASSIGN tt-mmv-func-ofici.idi-situacao = 2. /** Inativo **/

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mmv-func-ofici except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mmv-func-ofici).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Funcion rio Manuten‡Æo","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mmv-func-ofici"
                       tt-dados.cod-tabela = tt-mmv-func-ofici.cod-matr
                       tt-dados.des-tabela = tt-mmv-func-ofici.nom-func
                       tt-dados.des-tab    = RETURN-VALUE
                       c-cont2 = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Funcion rio Manuten‡Æo","*","").
            ASSIGN tt-dados.i-chave = c-cont2
                   tt-dados.cod-tabela = tt-mmv-func-ofici.cod-matr
                   tt-dados.des-tabela = tt-mmv-func-ofici.nom-func
                   tt-dados.tabela     = "mmv-func-ofici"
                   tt-dados.des-tab    = RETURN-VALUE
                   c-cont2 = c-cont2 + 1.
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

&IF DEFINED(EXCLUDE-pi-mmv-ofici) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mmv-ofici Procedure 
PROCEDURE pi-mmv-ofici :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa tipooficina para mmv-ofici */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr033.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr033").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Oficina Mecƒnica","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Oficina Mecƒnica","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela)   THEN
   RUN  frbo/bofr033.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.pontomanut NO-LOCK:
    EMPTY TEMP-TABLE tt-mmv-ofici.
    CREATE tt-mmv-ofici.
    
    ASSIGN tt-mmv-ofici.cod-ofici               = string(mb.pontomanut.codipoma,"999")
           tt-mmv-ofici.des-ofici               = mb.pontomanut.descricao 
           tt-mmv-ofici.idi-tip-ofici           = 1                      /* Oficina Interna */
           tt-mmv-ofici.cod-estabel             = string(mb.pontomanut.codiseto)
           tt-mmv-ofici.nr-ord-produ            = 0
           tt-mmv-ofici.cod-calend              = tt-param.c-cod-calend  /** Calend rio da Manuten‡Æo gen‚rico **/
           tt-mmv-ofici.cod-posto               = tt-param.c-cod-posto   /* Posto gen‚rico para todas as oficinas */
           tt-mmv-ofici.cod-emitente            = 0                      /** Emitente Zero (PadrÆo) **/
           tt-mmv-ofici.log-encerra-om-tar-aber = NO.
    /** Refaz a descri‡Æo caso encontre o tipo da oficina **/
    for first mb.tipopontoman
        where mb.tipopontoman.coditipm = mb.pontomanut.coditipm no-lock:
        /** Tipo da Oficina + Descri‡Æo da oficna, para facilitar na identifica‡Æo das manuten‡äes posteriores **/
        assign tt-mmv-ofici.des-ofici = trim(mb.tipopontoman.descricao) + " - " + trim(mb.pontomanut.descricao).
    end.
    /*** Utiliza o De-para de Estabelecimento **/
    if tt-param.l-de-para then do:
        for first tt-estabelec
            where tt-estabelec.cod-nop = string(mb.pontomanut.codiseto) no-lock:
            assign tt-mmv-ofici.cod-estabel = tt-estabelec.cod-estabel.
        end.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mmv-ofici except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mmv-ofici).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Oficina Mecƒnica","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mmv-ofici"
                       tt-dados.cod-tabela = tt-mmv-ofici.cod-ofici
                       tt-dados.des-tabela = tt-mmv-ofici.des-ofici
                       tt-dados.des-tab    = RETURN-VALUE
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Oficina Mecƒnica","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mmv-ofici.cod-ofici
                   tt-dados.des-tabela = tt-mmv-ofici.des-ofici
                   tt-dados.tabela     = "mmv-ofici"
                   tt-dados.des-tab    = RETURN-VALUE
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

&IF DEFINED(EXCLUDE-pi-mmv-plano-prevent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mmv-plano-prevent Procedure 
PROCEDURE pi-mmv-plano-prevent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa agendaeletro para mmv-plano-prevent */
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-acomp AS HANDLE NO-UNDO.
DEFINE VARIABLE c-text-plano AS CHARACTER  NO-UNDO.

{utp/ut-liter.i "Plano Preventiva"}
assign c-text-plano = return-value.

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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr035.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr035").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Plano Preventiva","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Plano Preventiva","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
if NOT VALID-HANDLE(h-tabela) then
    RUN  frbo/bofr035.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** Planos de Equipamentos **/
FOR EACH mb.modelpreve no-lock:
    find first mb.agendaeletro
        WHERE  mb.agendaeletro.codiseof = mb.modelpreve.codiseof no-lock no-error.
    if avail agendaeletro then do:
        EMPTY TEMP-TABLE tt-mmv-plano-prevent.
        CREATE tt-mmv-plano-prevent.
        ASSIGN tt-mmv-plano-prevent.cod-model       = STRING(mb.modelpreve.codimode + 1000,"99999")
               tt-mmv-plano-prevent.cod-plano       = STRING(mb.modelpreve.planprev)
               tt-mmv-plano-prevent.des-plano-manut = c-text-plano + " " + string(mb.agendaeletro.perihkm)
               tt-mmv-plano-prevent.vli-dia         = mb.agendaeletro.peridia
               tt-mmv-plano-prevent.val-km-padr     = mb.agendaeletro.perihkm
               tt-mmv-plano-prevent.vli-dia-aviso   = 0
               tt-mmv-plano-prevent.val-km-aviso    = 0
               tt-mmv-plano-prevent.cod-evento      = tt-param.c-cod-event
               tt-mmv-plano-prevent.cod-sub-sist    = tt-param.c-sub-sist2
               tt-mmv-plano-prevent.val-tempo-padr  = mb.modelpreve.peripadr
               tt-mmv-plano-prevent.cod-calend-padr = tt-param.c-cod-calend
               tt-mmv-plano-prevent.cd-tipo         = tt-param.i-cd-tipo
               tt-mmv-plano-prevent.log-gera-tar-om = YES
               tt-mmv-plano-prevent.log-gera-manut  = YES.
        /** Coloca o primeiro setor da oficina para o plano (tabela mmv-setor-ofici deve estar importada antes) **/
        for first mmv-setor-ofici no-lock:
            assign tt-mmv-plano-prevent.cod-setor-ofici = mmv-setor-ofici.cod-setor-ofici.
        end.
        /** Exporta para Excel **/
        if tt-param.dest-exportacao = 1 then do:
            OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
                export delimiter ";" tt-mmv-plano-prevent except r-rowid.
            output close.
        end.
        else do:
            CREATE tt-dados.
            run emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
            RUN setRecord IN h-tabela (INPUT TABLE tt-mmv-plano-prevent).
            RUN createRecord in h-tabela.
            IF RETURN-VALUE = "NOK" then DO:
                RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
                run utp/ut-liter.p (input "Plano Preventivo Equipamento","*","").
                FOR EACH RowErrors NO-LOCK:
                    ASSIGN tt-dados.i-chave    = c-cont2
                           tt-dados.erro       = RowErrors.ErrorNumber
                           tt-dados.descricao  = RowErrors.ErrorDescription 
                           tt-dados.tabela     = "mmv-plano-prevent"
                           tt-dados.cod-tabela = tt-mmv-plano-prevent.cod-plano
                           tt-dados.des-tabela = tt-mmv-plano-prevent.des-plano-manut
                           tt-dados.des-tab    = return-value
                           c-cont2             = c-cont2 + 1.
                end.
            end.
            ELSE DO:
                run utp/ut-liter.p (input "Plano Preventivo Equipamento","*","").
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.cod-tabela = tt-mmv-plano-prevent.cod-plano
                       tt-dados.des-tabela = tt-mmv-plano-prevent.des-plano-manut
                       tt-dados.tabela     = "mmv-plano-prevent"
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
    END. /** agendaeletro **/
end.
/*** Planos de Componentes **/
FOR EACH mb.agremodelo no-lock:

    EMPTY TEMP-TABLE tt-mmv-plano-prevent.
    CREATE tt-mmv-plano-prevent.
    ASSIGN tt-mmv-plano-prevent.cod-model       = STRING(mb.agremodelo.agremode,"99999")
           tt-mmv-plano-prevent.cod-plano       = STRING(mb.agremodelo.agreesfa)
           tt-mmv-plano-prevent.des-plano-manut = c-text-plano + " " + mb.agremodelo.descmode
           tt-mmv-plano-prevent.vli-dia         = mb.agremodelo.plano-dia
           tt-mmv-plano-prevent.val-km-padr     = mb.agremodelo.plano-km
           tt-mmv-plano-prevent.vli-dia-aviso   = 0
           tt-mmv-plano-prevent.val-km-aviso    = 0
           tt-mmv-plano-prevent.cod-evento      = tt-param.c-cod-event
           tt-mmv-plano-prevent.cod-sub-sist    = tt-param.c-sub-sist2
           tt-mmv-plano-prevent.val-tempo-padr  = mb.agremodelo.plano-hora
           tt-mmv-plano-prevent.cod-calend-padr = tt-param.c-cod-calend
           tt-mmv-plano-prevent.cd-tipo         = tt-param.i-cd-tipo
           tt-mmv-plano-prevent.log-gera-tar-om = no
           tt-mmv-plano-prevent.log-gera-manut  = YES.
    /** Coloca o primeiro setor da oficina para o plano **/
    for first mmv-setor-ofici no-lock:
        assign tt-mmv-plano-prevent.cod-setor-ofici = mmv-setor-ofici.cod-setor-ofici.
    end.
    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mmv-plano-prevent except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        run emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mmv-plano-prevent).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Plano Preventivo Componente","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mmv-plano-prevent"
                       tt-dados.cod-tabela = tt-mmv-plano-prevent.cod-plano
                       tt-dados.des-tabela = tt-mmv-plano-prevent.des-plano-manut
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Plano Preventivo Componente","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mmv-plano-prevent.cod-plano
                   tt-dados.des-tabela = tt-mmv-plano-prevent.des-plano-manut
                   tt-dados.tabela     = "mmv-plano-prevent"
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

&IF DEFINED(EXCLUDE-pi-mmv-setor-ofici) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mmv-setor-ofici Procedure 
PROCEDURE pi-mmv-setor-ofici :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa secaoofici para mmv-setor-ofici */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr036.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr036").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Setor Oficina","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Setor Oficina","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN frbo/bofr036.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

FOR EACH mb.secaoofici NO-LOCK:

    EMPTY TEMP-TABLE tt-mmv-setor-ofici.
    CREATE tt-mmv-setor-ofici.
    ASSIGN tt-mmv-setor-ofici.cod-setor-ofici = STRING(mb.secaoofici.codiseof,"999")
           tt-mmv-setor-ofici.des-setor-ofici = mb.secaoofici.descr
           tt-mmv-setor-ofici.cod-ofici       = tt-param.c-cod-ofic
           tt-mmv-setor-ofici.cc-codigo       = tt-param.c-cod-cc.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mmv-setor-ofici except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. 
        RUN setRecord IN h-tabela (INPUT TABLE tt-mmv-setor-ofici).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Setor Oficina","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mmv-setor-ofici"
                       tt-dados.cod-tabela = tt-mmv-setor-ofici.cod-setor-ofici
                       tt-dados.des-tabela = tt-mmv-setor-ofici.des-setor-ofici
                       tt-dados.des-tab    = RETURN-VALUE
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Setor Oficina","*","").
            assign tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mmv-setor-ofici.cod-setor-ofici
                   tt-dados.des-tabela = tt-mmv-setor-ofici.des-setor-ofici
                   tt-dados.tabela     = RETURN-VALUE
                   tt-dados.des-tab    = "Setor Oficina"
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

&IF DEFINED(EXCLUDE-pi-mmv-tar-plano) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mmv-tar-plano Procedure 
PROCEDURE pi-mmv-tar-plano :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa itempreve para mmv-tar-plano */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr037.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr037").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Tarefa Plano Preventivo","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Tarefa Plano Preventivo","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In¡cio da L¢gica de Exporta‡Æo               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) THEN
    RUN  frbo/bofr037.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.
/** tarefas Planos Preventivo Equipamento **/
FOR EACH mb.itempreve NO-LOCK 
    BREAK BY mb.itempreve.codimode 
          BY mb.itempreve.planprev:
    /** Coloca a Sequencia 10 quando modelo ou plano mudar **/
    IF FIRST-OF (mb.itempreve.codimode) OR FIRST-OF (mb.itempreve.planprev) THEN
        ASSIGN c-cont = 10.
    
    EMPTY TEMP-TABLE tt-mmv-tar-plano.
    CREATE tt-mmv-tar-plano.
    ASSIGN tt-mmv-tar-plano.cod-model      = STRING(mb.itempreve.codimode + 1000,"99999")
           tt-mmv-tar-plano.cod-plano      = STRING(mb.itempreve.planprev)
           tt-mmv-tar-plano.num-seq        = c-cont 
           tt-mmv-tar-plano.cod-sub-sist   = STRING(mb.itempreve.codilocal,"9999")
           tt-mmv-tar-plano.cod-evento     = STRING(mb.itempreve.codiserv,"999")
           tt-mmv-tar-plano.val-tempo-padr = 1
           c-cont = c-cont + 10.
    /** Busca Setor da Oficina **/
    IF mb.itempreve.codiseof <> 0 THEN
        assign tt-mmv-tar-plano.cod-setor-ofici = STRING(mb.itempreve.codiseof).
    ELSE 
        /* tabela de setores das oficinas devem ser importada antes antes da Tarefa do Plano */
        FOR FIRST mmv-setor-ofici NO-LOCK: 
            ASSIGN tt-mmv-tar-plano.cod-setor-ofici = mmv-setor-ofici.cod-setor-ofici.
        end.

    /* Tabela de Sub-Sistema e Evento deve ser importada antes da Tarefa do Plano */
    FOR FIRST mab-sub-sist 
        WHERE mab-sub-sist.cod-sub-sist = tt-mmv-tar-plano.cod-sub-sist NO-LOCK:
        FOR FIRST mab-event 
            WHERE mab-event.cod-evento = tt-mmv-tar-plano.cod-evento NO-LOCK:
            /** Concatena as Descri‡äes **/
            ASSIGN tt-mmv-tar-plano.des-tarefa = mab-event.des-evento + " - " + mab-sub-sist.des-sub-sist.
        end.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mmv-tar-plano except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mmv-tar-plano).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Tarefa Plano Preventivo Equipamento","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mmv-tar-plano"
                       tt-dados.cod-tabela = tt-mmv-tar-plano.cod-plano
                       tt-dados.des-tabela = ""
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Tarefa Plano Preventivo Equipamento","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mmv-tar-plano.cod-plano
                   tt-dados.des-tabela = ""
                   tt-dados.tabela     = "mmv-tar-plano"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.
/** Tarefas dos Planos de Preventiva dos Implementos **/
FOR EACH mb.ipitempreve NO-LOCK
    BREAK BY mb.ipitempreve.codimode 
          BY mb.ipitempreve.planprev:

    /** Coloca a Sequencia 10 quando modelo ou plano mudar **/
    IF FIRST-OF (mb.ipitempreve.codimode) OR FIRST-OF (mb.ipitempreve.planprev) THEN
        ASSIGN c-cont = 10.

    EMPTY TEMP-TABLE tt-mmv-tar-plano.
    CREATE tt-mmv-tar-plano.
    ASSIGN tt-mmv-tar-plano.cod-model      = STRING(mb.ipitempreve.codimode + 10000,"99999")
           tt-mmv-tar-plano.cod-plano      = STRING(mb.ipitempreve.planprev)
           tt-mmv-tar-plano.num-seq        = c-cont 
           tt-mmv-tar-plano.cod-sub-sist   = STRING(mb.ipitempreve.codilocal,"9999")
           tt-mmv-tar-plano.cod-evento     = STRING(mb.ipitempreve.codiserv,"999")
           tt-mmv-tar-plano.val-tempo-padr = 1
           c-cont = c-cont + 10.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mmv-tar-plano except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela.
        RUN setRecord IN h-tabela (INPUT TABLE tt-mmv-tar-plano).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Tarefa Plano Preventivo Implemento","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mmv-tar-plano"
                       tt-dados.cod-tabela = tt-mmv-tar-plano.cod-plano
                       tt-dados.des-tabela = ""
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Tarefa Plano Preventivo Implemento","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mmv-tar-plano.cod-plano
                   tt-dados.des-tabela = ""
                   tt-dados.tabela     = "mmv-tar-plano"
                   tt-dados.des-tab    = return-value
                   c-cont2             = c-cont2 + 1.
        end.
    end.
end.

IF valid-handle(h-tabela) THEN   
    RUN Destroy in h-tabela.

return "OK":U.

END procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mmv-tar-plano-item) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mmv-tar-plano-item Procedure 
PROCEDURE pi-mmv-tar-plano-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa ipitempreve para mmv-tar-plano-item */
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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr041.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabe‡alho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr041").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Item Tarefa Plano Preventivo","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Item Tarefa Plano Preventivo","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/** Revisar esta l¢gica posteriormente, esta tabela est  errada **/

/* /****************************************************************                            */
/* **                In¡cio da L¢gica de Exporta‡Æo               **                            */
/* ****************************************************************/                            */
/* IF NOT VALID-HANDLE(h-tabela) then                                                           */
/*     RUN  frbo/bofr041.p PERSISTENT SET h-tabela.                                             */
/* RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.                                   */
/*                                                                                              */
/* FOR EACH mb.ipitempreve NO-LOCK:                                                             */
/*                                                                                              */
/*     EMPTY TEMP-TABLE tt-mmv-tar-plano-item.                                                  */
/*     CREATE tt-mmv-tar-plano-item.                                                            */
/*     ASSIGN tt-mmv-tar-plano-item.cod-model = STRING(mb.ipitempreve.codimode + 10000,"9999")  */
/*            tt-mmv-tar-plano-item.cod-plano = STRING(mb.ipitempreve.planprev)                 */
/*            tt-mmv-tar-plano-item.num-seq   = 10                                              */
/*            tt-mmv-tar-plano-item.it-codigo = STRING(mb.ipitempreve.itemplano)                */
/*            tt-mmv-tar-plano-item.qtd-item  = 1.                                              */
/*                                                                                              */
/*     /** Exporta para Excel **/                                                               */
/*     if tt-param.dest-exportacao = 1 then do:                                                 */
/*         ASSIGN c-caminho = tt-param.dir-entrada + "fr041.txt".                               */
/*         OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.                     */
/*         if l-primeiro then do:                                                               */
/*             RUN piGeraCabecalho in h-cabecalho (INPUT "fr041").                              */
/*             assign l-primeiro = no.                                                          */
/*         end.                                                                                 */
/*         export delimiter ";" tt-mmv-tar-plano-item except r-rowid.                           */
/*         output close.                                                                        */
/*     end.                                                                                     */
/*     else do:                                                                                 */
/*         CREATE tt-dados.                                                                     */
/*         RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/                */
/*         RUN setRecord IN h-tabela (INPUT TABLE tt-mmv-tar-plano-item).                       */
/*         RUN createRecord in h-tabela.                                                        */
/*                                                                                              */
/*         IF RETURN-VALUE = "NOK" then DO:                                                     */
/*             RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).                           */
/*             run utp/ut-liter.p (input "Relaciomento Plano X Item","*","").                   */
/*             FOR EACH RowErrors NO-LOCK:                                                      */
/*                 ASSIGN tt-dados.i-chave    = c-cont2                                         */
/*                        tt-dados.erro       = RowErrors.ErrorNumber                           */
/*                        tt-dados.descricao  = RowErrors.ErrorDescription                      */
/*                        tt-dados.tabela     = "mmv-tar-plano-item"                            */
/*                        tt-dados.cod-tabela = tt-mmv-tar-plano-item.cod-plano                 */
/*                        tt-dados.des-tabela = tt-mmv-tar-plano-item.it-codigo                 */
/*                        tt-dados.des-tab    = return-value                                    */
/*                        c-cont2             = c-cont2 + 1.                                    */
/*             end.                                                                             */
/*         end.                                                                                 */
/*         ELSE DO:                                                                             */
/*             ASSIGN tt-dados.i-chave    = c-cont2                                             */
/*                    tt-dados.cod-tabela = tt-mmv-tar-plano-item.cod-plano                     */
/*                    tt-dados.des-tabela = tt-mmv-tar-plano-item.it-codigo                     */
/*                    tt-dados.tabela     = "mmv-tar-plano-item"                                */
/*                    tt-dados.des-tab    = "Relacionamento Plano X Item"                       */
/*                    c-cont2             = c-cont2 + 1.                                        */
/*         end.                                                                                 */
/*     end.                                                                                     */
/* end.                                                                                         */

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

