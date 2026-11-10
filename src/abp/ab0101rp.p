&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0101RP 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0101rp MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: AB0101RP.p
**
**       DATA....: 29/12/2006
**
**       AUTOR...: Marcio da Silva - Manufatura - DATASUL S.A.
**
**       OBJETIVO: ImpressÆo dos Parƒmetros de Frota
**
*****************************************************************************/
                                             /** Defini‡Æo das temp-tables **/
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino              AS INTEGER
    FIELD arquivo              AS CHARACTER FORMAT "x(35)":U
    FIELD usuario              AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD log-max-eqptos-contr AS LOGICAL
    FIELD log-eqptos-cadastr   AS LOGICAL
    FIELD log-param            AS LOGICAL
    FIELD log-modulos          AS LOGICAL
    FIELD i-maximo-eqptos      AS INTEGER
    FIELD i-eqptos-cadastrados AS INTEGER.

DEFINE SHARED TEMP-TABLE tt-digita NO-UNDO
    FIELD i-tp-tabela          AS INTEGER /* 1-ttParam 2-ttModulos */
    FIELD codigo               LIKE mab-param.cdn-param
    FIELD descricao            LIKE mab-param.des-label-param
    FIELD valor                LIKE mab-param.des-valor.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
/****************************************************************************/
                                               /** Defini‡Æo de Parƒmetros **/   
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

/****************************************************************************/
                    /** Transferˆncia de parƒmetros para temp-table padrÆo **/
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.
/** Este c¢digo deve existir somente se relat¢rio contiver digita‡Æo **/
FOR EACH tt-raw-digita NO-LOCK:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.
/****************************************************************************/
                                                /** Defini‡Æo de Vari veis **/
DEFINE VARIABLE h-acomp            AS HANDLE                              NO-UNDO.
DEFINE VARIABLE c-destino          AS CHARACTER FORMAT "x(09)":U          NO-UNDO.
DEFINE VARIABLE c-char-aux         AS CHARACTER FORMAT "x(40)":U          NO-UNDO.
DEFINE VARIABLE i-nr-caracter      AS INTEGER                             NO-UNDO.

{include/i-rpvar.i}
/****************************************************************************/
                                                     /** Cabe‡alho e Forms **/
 /** Defini‡Æo de Vari veis **/
form tt-digita.codigo
     tt-digita.descricao
     tt-digita.valor
    with width 132 no-attr-space no-box down frame f-dados stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dados:HANDLE).

/*****************************************************************************/
                                               /** Literais Form Parƒmetros **/
{utp/ut-liter.i C¢digo *}
ASSIGN tt-digita.codigo:LABEL IN FRAME f-dados = RETURN-VALUE.
{utp/ut-liter.i Descri‡Æo *}
ASSIGN tt-digita.descricao:LABEL IN FRAME f-dados = RETURN-VALUE.
{utp/ut-liter.i Valor *}
ASSIGN tt-digita.valor:LABEL IN FRAME f-dados = RETURN-VALUE.
/*****************************************************************************/

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
         HEIGHT             = 6.63
         WIDTH              = 32.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/** Parametriza padräes de cabe‡alho e rodap‚ a serem exibidos **/
RUN piInicial IN THIS-PROCEDURE.

/** Imprime cabe‡alho e abre o output para arquivo **/
{include/i-rpcab.i}    
{include/i-rpout.i}

/** Procedure para inicializar c lculos e impressÆo **/
RUN piPrincipal IN THIS-PROCEDURE.

/** Fecha o output para arquivo **/
{include/i-rpclo.i}

return "OK":U. 
/*--- Fim do Programa ---*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piInicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicial Procedure 
PROCEDURE piInicial :
/*------------------------------------------------------------------------------
  Purpose:     piInicial
  Parameters:  <none>
  Notes:       Define os valores que serÆo mostrados o cabe‡alho e rodap‚
------------------------------------------------------------------------------*/
    ASSIGN c-programa = "AB/0101"
           c-versao   = "2.00"
           c-revisao  = "000".
    /** Define o destino do arquivo a ser gerado **/
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 INTEGER(tt-param.destino)}.
        RUN utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN c-destino  = RETURN-VALUE.
    &ELSE
        ASSIGN c-destino  = {varinc/var00002.i 04 INTEGER(tt-param.destino)}.
    &ENDIF
    
    /** Busca os parƒmetros criados na interface gr fica **/
    FIND FIRST tt-param NO-LOCK NO-ERROR.
    
    /** Busca empresa padrÆo **/
    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF  AVAILABLE param-global THEN
        ASSIGN c-empresa = param-global.grupo.
    
    /** Guarda valores para imprimir t¡tulos **/
    {utp/ut-liter.i Parƒmetros_Frota *}
    ASSIGN c-titulo-relat = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "MAB" *}
    ASSIGN c-sistema = TRIM(RETURN-VALUE).
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPrincipal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrincipal Procedure 
PROCEDURE piPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     piPrincipal
  Parameters:  <none>
  Notes:       Corpo princiapl da aplica‡Æo
------------------------------------------------------------------------------*/
    /** Mostra frames de cabe‡alho e rodap‚ padräes da Datasul **/
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape. 
    
    /** Inicializa programa de acompanhamento padrÆo Datasul **/
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp(INPUT c-titulo-relat).
    
    /*********************************************************************
       Neste espa‡o deve-se colocar a l¢gica para busca as informa‡äes e 
       tamb‚m para fazer o display, pode-se inclui a chamada de procedures
       ou fazer a l¢gica neste espa‡o.
    *********************************************************************/

    /** L¢gica opcional do programador **/

    IF  AVAIL tt-param THEN DO:
        IF  tt-param.log-max-eqptos-contr THEN DO:
            {utp/ut-liter.i M ximo_Equipamentos_Controlados *}
            ASSIGN c-char-aux = TRIM(RETURN-VALUE) + ": ".
            PUT c-char-aux.
            PUT tt-param.i-maximo-eqptos FORMAT ">>>,>>>,>>9":U.
            PUT "    ":U.
        END.

        IF  tt-param.log-eqptos-cadastr THEN DO:
            {utp/ut-liter.i Equipamentos_Cadastrados *}
            ASSIGN c-char-aux = TRIM(RETURN-VALUE) + ": ".
            PUT c-char-aux.
            PUT tt-param.i-eqptos-cadastrados FORMAT ">>>,>>>,>>9":U.
        END.

        IF  tt-param.log-max-eqptos-contr OR tt-param.log-eqptos-cadastr THEN
            PUT SKIP(1).

        IF  tt-param.log-param THEN DO:
            {utp/ut-liter.i PAR¶METROS *}
            ASSIGN i-nr-caracter = LENGTH(TRIM(RETURN-VALUE)).
            PUT RETURN-VALUE FORMAT "x(20)":U SKIP.
            PUT FILL("-":U, i-nr-caracter) FORMAT "x(20)":U.
            FOR EACH tt-digita
                WHERE tt-digita.i-tp-tabela = 1 NO-LOCK:
                DISPLAY tt-digita.codigo
                        tt-digita.descricao FORMAT "x(90)":U
                        tt-digita.valor FORMAT "x(31)":U
                    WITH FRAME f-dados.
                DOWN WITH FRAME f-dados.
            END.
        END.

        IF  tt-param.log-modulos THEN DO:
            {utp/ut-liter.i Implantado *}
            ASSIGN tt-digita.valor:LABEL IN FRAME f-dados = RETURN-VALUE.
            PAGE.
            {utp/ut-liter.i MàDULOS *}
            ASSIGN i-nr-caracter = LENGTH(TRIM(RETURN-VALUE)).
            PUT RETURN-VALUE FORMAT "x(20)":U SKIP.
            PUT FILL("-":U, i-nr-caracter) FORMAT "x(20)":U.
            FOR EACH tt-digita
                WHERE tt-digita.i-tp-tabela = 2 NO-LOCK:
                DISPLAY tt-digita.codigo
                        tt-digita.descricao
                        tt-digita.valor
                    WITH FRAME f-dados.
                DOWN WITH FRAME f-dados.
            END.
        END.
    END.
    
    /*********************************************************************
       Fim do espa‡o para l¢gica de c lculo e display das informa‡äes
    *********************************************************************/
    
    /** Finaliza programa de acompanhamento padrÆo Datasul **/
    run pi-finalizar in h-acomp.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

