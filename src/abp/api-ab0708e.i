&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : abpi-ab0708e.i
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE TEMP-TABLE tt-mco-compon LIKE mco-compon FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-mco-histor-vida LIKE mco-histor-vida FIELD r-Rowid AS ROWID.

DEFINE VARIABLE h-tabela AS HANDLE NO-UNDO.
DEFINE VARIABLE cont AS INTEGER  INIT 1 NO-UNDO.
DEFINE VARIABLE c-cont2 AS INTEGER INIT 1 NO-UNDO.

 
/* includes*/
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
 
/* temp-table */

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
         HEIGHT             = 5.92
         WIDTH              = 27.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
run abp/api-ab0708h.i persistent set h-cabecalho (input table tt-param).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-mco-compon) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mco-compon Procedure 
PROCEDURE pi-mco-compon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa agregados para mco-compon */
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM h-acomp AS HANDLE NO-UNDO.

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
    ASSIGN c-caminho = tt-param.dir-entrada + "fr029.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr029").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Componentes","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    run utp/ut-liter.p (input "Atualizando tabela Componentes","*","").
/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN frbo/bofr029.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

/** Là somente os componentes numerados **/
FOR EACH  mb.agregados
    where mb.agregados.classifi = 1 NO-LOCK:

    EMPTY TEMP-TABLE tt-mco-compon.
    CREATE  tt-mco-compon.
    ASSIGN tt-mco-compon.num-seqcial         = mb.agregados.controle /** Ser† calculado posteriormente pela BO **/
           tt-mco-compon.cod-sub-sist        = STRING(mb.agregados.codilocal,"9999")
           tt-mco-compon.cod-compon          = STRING(mb.agregados.numeagre)
           tt-mco-compon.des-serie           = STRING(mb.agregados.nroserie)
           tt-mco-compon.cod-model           = STRING(mb.agregados.agremode,"99999")
           tt-mco-compon.cod-localiz-compon  = ""
           &IF "{&mguni_version}" >= "2.071" &THEN
           tt-mco-compon.ep-codigo           = mb.agregados.codiemprprop  /** Empresa do Componente (mco-compon.ep-codigo) **/
           &ELSE
           tt-mco-compon.num-livre-1         = mb.agregados.codiemprprop  /** Empresa do Componente (mco-compon.ep-codigo) **/
           &ENDIF
           tt-mco-compon.num-vida-histor     = 1
           tt-mco-compon.dat-inicial         = mb.agregados.datainst
           tt-mco-compon.dat-atualiz         = ?
           tt-mco-compon.ct-codigo           = "" /** Informaá∆o n∆o utilizada **/
           /** Dados Iniciais **/            
           tt-mco-compon.num-vida-inicial    = mb.agregados.vidainic
           tt-mco-compon.ep-codigo-inicial   = mb.agregados.codiemprini
           tt-mco-compon.cod-eqpto-inicial   = string(mb.agregados.numeequiini)
           tt-mco-compon.cod-estabel-inicial = string(mb.agregados.codisetoini)
           tt-mco-compon.cc-codigo           = tt-param.c-cc-codigo-compon
           /** Dados Atuais **/              
           tt-mco-compon.num-vida-atual      = mb.agregados.vidaatua
           tt-mco-compon.ep-codigo-atual     = mb.agregados.codiempr
           tt-mco-compon.cod-eqpto-atual     = string(mb.agregados.numeequi)
           tt-mco-compon.cod-estabel-atual   = string(mb.agregados.codiseto)
           tt-mco-compon.cc-codigo-atual     = tt-param.c-cc-codigo-compon
           /** Estoque = Branco **/          
           tt-mco-compon.it-codigo           = ""
           tt-mco-compon.cod-item-reformad   = ""
           /** Bem Patrimonial, n∆o ser† informado **/
           tt-mco-compon.cod-cta-pat         = ""
           tt-mco-compon.bm-indice           = 0
           tt-mco-compon.bm-codigo           = 0
           /* Calcular na l¢gica de atualizaá∆o de KM  */
           tt-mco-compon.val-uso-atual       = 0.
    /** Busca o Centro de Custo Inicial do Equipamento **/
    for first mb.equipamento
        where mb.equipamento.codiempr = mb.agregados.codiemprini
        and   mb.equipamento.numeequi = mb.agregados.numeequiini no-lock:
        assign tt-mco-compon.cc-codigo           = string(mb.equipamento.centcusto)
               tt-mco-compon.cod-estabel-inicial = string(mb.equipamento.codiseto).
    end.
    /** Busca o Centro de Custo Atual do Equipamento **/
    for first mb.equipamento
        where mb.equipamento.codiempr = mb.agregados.codiempr
        and   mb.equipamento.numeequi = mb.agregados.numeequi no-lock:
        assign tt-mco-compon.cc-codigo-atual = string(mb.equipamento.centcusto)
               tt-mco-compon.cc-codigo-atual = string(mb.equipamento.centcusto).
    end.
    /** Busca Descriá∆o do Modelo para Componente **/
    for first mb.agremodelo
        where mb.agremodelo.agremode = mb.agregados.agremode no-lock:
        assign tt-mco-compon.des-model = mb.agremodelo.descmode.
    end.
    /** De-Para de Estabelecimento **/
    for first tt-estabelec
        where tt-estabelec.cod-nop = string(mb.agregados.codisetoini) no-lock:
        assign tt-mco-compon.cod-estabel-inicial = tt-estabelec.cod-estabel.
    end.
    /** De-Para de Estabelecimento **/
    for first tt-estabelec
        where tt-estabelec.cod-nop = string(mb.agregados.codiseto) no-lock:
        assign tt-mco-compon.cod-estabel-atual = tt-estabelec.cod-estabel.
    end.
    /** Observaá∆o **/
    assign tt-mco-compon.dsl-obs = "Componente importado em: " + string(today,"99/99/9999") + " " + string(time,"hh:mm:ss").
    /** Validaá∆o da Situaá∆o, Tabela de Situaá∆o (mab-sit-eqpto) deve estar importada antes **/
    if mb.agregados.ativado then do:
        /** Caso esteja ativado, busca a primeira situaá∆o ativa **/
        for first mab-sit-eqpto
            where mab-sit-eqpto.idi-tip = 1 no-lock:
            assign tt-mco-compon.cod-sit-compon-atual   = mab-sit-eqpto.cod-sit-eqpto
                   tt-mco-compon.cod-sit-compon-inicial = mab-sit-eqpto.cod-sit-eqpto
                   tt-mco-compon.dat-situacao           = ?.
        end.
    end.
    else do:
        /** Caso esteja inativo, busca a primeira situaá∆o inativa **/
        for first mab-sit-eqpto
            where mab-sit-eqpto.idi-tip = 2 no-lock:
            assign tt-mco-compon.cod-sit-compon-atual   = mab-sit-eqpto.cod-sit-eqpto
                   tt-mco-compon.cod-sit-compon-inicial = mab-sit-eqpto.cod-sit-eqpto
                   tt-mco-compon.dat-situacao           = mb.agregados.datadesa.
        end.
    end.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mco-compon except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mco-compon).
        RUN createRecord in h-tabela.
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Componentes","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mco-compon":U
                       tt-dados.cod-tabela = tt-mco-compon.cod-compon
                       tt-dados.des-tabela = tt-mco-compon.cod-model
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Componentes","*","").
            assign tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = tt-mco-compon.cod-compon
                   tt-dados.des-tabela = tt-mco-compon.cod-model
                   tt-dados.tabela     = "mco-compo":U
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

&IF DEFINED(EXCLUDE-pi-mco-histor-vida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mco-histor-vida Procedure 
PROCEDURE pi-mco-histor-vida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       /* importa agrevida para mco-historvida */
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
if tt-param.dest-exportacao = 1 AND tt-param.i-km-vida-comp = 1 THEN DO:
    ASSIGN c-caminho = tt-param.dir-entrada + "fr030.txt".
    OUTPUT TO VALUE (c-caminho) convert target "iso8859-1":U.
        /** Mostra o Cabeáalho da tabela **/
        RUN piGeraCabecalho in h-cabecalho (INPUT "fr030").
    OUTPUT CLOSE.
    run utp/ut-liter.p (input "Exportando tabela Hist¢rico Vida Componente","*","").
END.
/** Exporta para Banco Frotas **/
ELSE 
    /** Processo Normal (Inclus∆o) **/
    IF tt-param.i-km-vida-comp = 1 THEN
        run utp/ut-liter.p (input "Atualizando tabela Hist¢rico Vida Componente","*","").
    ELSE 
        run utp/ut-liter.p (input "Atualizando KM Hist¢rico Vida Componente","*","").

/** Mostra Acompanhamento **/
RUN pi-acompanhar IN h-acomp(input return-value).

/****************************************************************
**                In°cio da L¢gica de Exportaá∆o               **
****************************************************************/
IF NOT VALID-HANDLE(h-tabela) then
    RUN frbo/bofr030.p PERSISTENT SET h-tabela.
RUN openQueryStatic IN h-tabela (INPUT "Main":U) NO-ERROR.

find first tt-param no-lock no-error.
if not avail tt-param then return "NOK":U.

/** Là as vidas dos componentes **/
FOR EACH mb.agrevida NO-LOCK:
    /** Caso seja a vida de um componente n∆o numerado, busca pr¢xima vida **/
    for first mb.agregados
        where mb.agregados.controle = mb.agrevida.controle
        and   mb.agregados.classifi = 1 no-lock:
    end.
    if not avail mb.agregados then next.

    EMPTY TEMP-TABLE tt-mco-histor-vida.
    /** Processo Normal **/
    IF tt-param.i-km-vida-comp = 1 THEN DO:
        CREATE tt-mco-histor-vida.
        
        ASSIGN tt-mco-histor-vida.num-seqcial        = mb.agrevida.controle   /** Ser† avaliado posteriormente pelo sequencial **/
               tt-mco-histor-vida.cod-sub-sist       = STRING(mb.agregados.codilocal,"9999")
               tt-mco-histor-vida.cod-compon         = STRING(mb.agregados.numeagre)
               tt-mco-histor-vida.num-vida           = mb.agrevida.vida
               /** In°cio **/                        
               tt-mco-histor-vida.dat-inicial        = mb.agrevida.datainic
               tt-mco-histor-vida.hra-inicial        = "000000":U
               tt-mco-histor-vida.val-uso-inicial    = mb.agrevida.periusoini-km
               /** Caso esteja colocado em equipamento, atualiza data de inclus∆o **/
               tt-mco-histor-vida.dat-inclusao       = if mb.agregados.numeequi > 0 then mb.agrevida.datainic else ?
               /** Fim **/                           
               tt-mco-histor-vida.dat-final          = mb.agrevida.dataterm
               tt-mco-histor-vida.val-uso-final      = mb.agrevida.periuso-km
               /** Aquisiá∆o **/                     
               tt-mco-histor-vida.nr-nota-fis        = STRING(mb.agrevida.notafisc)
               tt-mco-histor-vida.serie              = mb.agrevida.serie
               tt-mco-histor-vida.val-mater-1        = mb.agrevida.custaquis
               tt-mco-histor-vida.cod-emitente       = int(tt-param.c-cod-emitente)
               /** Ordem que criou = 0 **/           
               tt-mco-histor-vida.nr-ord-produ       = 0
               tt-mco-histor-vida.num-seq            = 0
               /** Estimativa e Garantia, calcular na l¢gica de KM **/
               tt-mco-histor-vida.val-km-hora-gartia = 0
               tt-mco-histor-vida.val-uso-estimad    = 0
               tt-mco-histor-vida.num-dias-estimad   = 0
               tt-mco-histor-vida.num-dias-gartia    = 0.    
    END.
    ELSE DO:
        FOR FIRST mco-compon
            WHERE mco-compon.cod-sub-sist = STRING(mb.agregados.codilocal)
            AND   mco-compon.cod-compon   = STRING(mb.agregados.numeagre) NO-LOCK:
            /** Busca o Registro **/
            RUN goToKey IN h-tabela (INPUT mco-compon.num-seqcial,
                                     INPUT mb.agrevida.vida).
            IF RETURN-VALUE = "OK":U THEN DO:
                /** Busca o registro da BO **/
                RUN getRecord IN h-tabela (OUTPUT TABLE tt-mco-histor-vida).
                FOR FIRST tt-mco-histor-vida EXCLUSIVE-LOCK:
                END.
            END.
            ELSE DO:
                CREATE tt-mco-histor-vida.
                ASSIGN tt-mco-histor-vida.num-seqcial        = mb.agrevida.controle   /** Ser† avaliado posteriormente pelo sequencial **/
                       tt-mco-histor-vida.cod-sub-sist       = STRING(mb.agregados.codilocal)
                       tt-mco-histor-vida.cod-compon         = STRING(mb.agregados.numeagre)
                       tt-mco-histor-vida.num-vida           = mb.agrevida.vida.
            END.
        END.
        IF NOT AVAIL mco-compon THEN DO:
            CREATE tt-mco-histor-vida.
            ASSIGN tt-mco-histor-vida.num-seqcial        = mb.agrevida.controle   /** Ser† avaliado posteriormente pelo sequencial **/
                   tt-mco-histor-vida.cod-sub-sist       = STRING(mb.agregados.codilocal)
                   tt-mco-histor-vida.cod-compon         = STRING(mb.agregados.numeagre)
                   tt-mco-histor-vida.num-vida           = mb.agrevida.vida.
        END.
    END.

    /** Busca Uso Estimado em KM e Dias para a Vida do Componente **/
    FOR FIRST mb.agreperiuso
        WHERE mb.agreperiuso.controle = mb.agrevida.controle 
        AND   mb.agreperiuso.vidaatua = mb.agrevida.vida NO-LOCK:
        ASSIGN tt-mco-histor-vida.val-uso-estimad  = mb.agreperiuso.plano-km
               tt-mco-histor-vida.num-dias-estimad = mb.agreperiuso.plano-dia.
    END.
    /** KM Inicial e Final **/
    ASSIGN tt-mco-histor-vida.val-uso-inicial = mb.agrevida.periusoini-km
           tt-mco-histor-vida.val-uso-final   = mb.agrevida.periuso-km.

    /** Exporta para Excel **/
    if tt-param.dest-exportacao = 1 AND tt-param.i-km-vida-comp = 1 then do:
        OUTPUT TO VALUE (c-caminho) append convert target "iso8859-1":U.
            export delimiter ";" tt-mco-histor-vida except r-rowid.
        output close.
    end.
    else do:
        CREATE tt-dados.
        RUN emptyRowErrors IN h-tabela. /*Limpa temp-tables Rowerros no DBO*/
        RUN setRecord IN h-tabela (INPUT TABLE tt-mco-histor-vida).
        IF tt-param.i-km-vida-comp = 1 THEN
            RUN createRecord in h-tabela.
        ELSE 
            RUN updateRecord in h-tabela.
        
        IF RETURN-VALUE = "NOK" then DO:
            RUN getRowErrors IN h-tabela (OUTPUT TABLE RowErrors).
            run utp/ut-liter.p (input "Hit¢rico Vida Componente","*","").
            FOR EACH RowErrors NO-LOCK:
                ASSIGN tt-dados.i-chave    = c-cont2
                       tt-dados.erro       = RowErrors.ErrorNumber
                       tt-dados.descricao  = RowErrors.ErrorDescription 
                       tt-dados.tabela     = "mco-histor-vida":U
                       tt-dados.cod-tabela = STRING(tt-mco-histor-vida.num-vida)
                       tt-dados.des-tabela = STRING(tt-mco-histor-vida.val-mater-1)
                       tt-dados.des-tab    = return-value
                       c-cont2             = c-cont2 + 1.
            end.
        end.
        ELSE DO:
            run utp/ut-liter.p (input "Hit¢rico Vida Componente","*","").
            ASSIGN tt-dados.i-chave    = c-cont2
                   tt-dados.cod-tabela = STRING(tt-mco-histor-vida.num-vida)
                   tt-dados.des-tabela = STRING(tt-mco-histor-vida.val-mater-1)
                   tt-dados.tabela     = "mco-histor-vida":U
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

