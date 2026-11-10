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
{include/i-prgvrs.i BCAPI017 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI017 MUT}
&ENDIF


/*------------------------------------------------------------------------
    File        : BCAPI017.P
    Purpose     : Tratamento gen‚rico do C¢digo 2D no Data Collection

    Syntax      : run bcp/bcapi017.p persistent

    Description : Fun‡äes gerais de manipula‡Æo de C¢digo 2D e XML

    Author(s)   : Alcides Schulz
    Created     : Janeiro/2001
    Notes       : 
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{bcp/bcapi017.i}                /* temp-table tt-xml    */
{bcp/bcapi019.i}                /* temp-table tt-campos */
{cdp/cd0666.i}                  /* temp-table tt-erros */
{bcp/bc1000.i &local=BCAPI017}  /* procedure geraTTErro */
{bcp/bc1003.i}                  /* Fun‡Æo formataCodLayout */
{include/i-freeac.i}            /* fun‡Æo fn-free-accent */

/* nomes de atibutos para cada segmento */
&SCOPED-DEFINE TagSegment   "Segment":U
&SCOPED-DEFINE AttrDesc     "Description":U
&SCOPED-DEFINE AttrLNum     "RecordLayoutNumber":U
&SCOPED-DEFINE AttrRNum     "RecordNumber":U

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-prepareTagName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareTagName Procedure 
FUNCTION prepareTagName RETURNS CHARACTER
  ( tag-name AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-geraCampos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraCampos Procedure 
PROCEDURE geraCampos :
/*------------------------------------------------------------------------------
  Purpose:     Converte tt-xml para tt-campos
  Parameters:  tt-xml, output tt-campos
  Notes:       separa por segmento e registro
------------------------------------------------------------------------------*/

DEF INPUT PARAM TABLE   FOR tt-xml.
DEF OUTPUT PARAM TABLE  FOR tt-campos.

DEF VAR h-xml           AS HANDLE NO-UNDO.

DEF VAR v-segmento      AS CHARACTER NO-UNDO.
DEF VAR v-descricao     AS CHARACTER NO-UNDO.
DEF VAR v-id            AS INTEGER   NO-UNDO.
DEF VAR v-campos        AS CHARACTER NO-UNDO.
DEF VAR v-cont          AS INTEGER   NO-UNDO.
DEF VAR v-id-campo      AS INTEGER   NO-UNDO.
DEF VAR v-nome          AS CHARACTER NO-UNDO.
DEF VAR v-valor         AS CHARACTER NO-UNDO.
DEF VAR v-extent        AS CHARACTER NO-UNDO.
DEF VAR v-decimal       AS CHARACTER NO-UNDO.

RUN utp/utapi021.p PERSISTENT SET h-xml.

EMPTY TEMP-TABLE tt-campos.

FOR EACH tt-xml:
    /* gera estrutura XML na api */
    RUN loadXMLFromString IN h-xml (tt-xml.conteudo).

    /* obtem segmento */
    RUN getChildrenList IN h-xml (0, OUTPUT v-segmento).
    RUN getTagName IN h-xml (INTEGER(v-segmento), OUTPUT v-descricao).

    /* obtem campos */
    RUN getChildrenList IN h-xml (INTEGER(v-segmento), OUTPUT v-campos).
    REPEAT v-cont = 1 TO NUM-ENTRIES(v-campos): 
        v-id-campo = INTEGER(ENTRY(v-cont, v-campos)).
        RUN getTagName   IN h-xml (v-id-campo, OUTPUT v-nome).
        RUN getValue     IN h-xml (v-id-campo, OUTPUT v-valor).
        RUN getAttrValue IN h-xml (v-id-campo, "EXTENT":U, OUTPUT v-extent).        
        RUN getAttrValue IN h-xml (v-id-campo, "DECIMALS":U, OUTPUT v-decimal).

        CREATE tt-campos.
        ASSIGN tt-campos.sequencia   = tt-xml.sequencia
               tt-campos.segmento    = tt-xml.segmento
               tt-campos.registro    = tt-xml.registro
               tt-campos.campo       = v-nome 
                                     + (IF v-extent = ? THEN ""
                                        ELSE "[":U + v-extent + "]":U)
               tt-campos.valor       = v-valor
               tt-campos.num-decimal = (IF v-decimal = ? THEN 0 ELSE INT(v-decimal)) NO-ERROR.
    END.

    /* limpa XML */
    RUN reset IN h-xml.
END.

DELETE PROCEDURE h-xml.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-geraXML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraXML Procedure 
PROCEDURE geraXML :
/*------------------------------------------------------------------------------
  Purpose:     Converte tt-campos para tt-xml
  Parameters:  tt-campos, output tt-xml 
  Notes:       separa por segmento e registro
------------------------------------------------------------------------------*/

DEF INPUT PARAM TABLE   FOR tt-campos.
DEF OUTPUT PARAM TABLE  FOR tt-xml.

DEF VAR h-xml           AS HANDLE       NO-UNDO.
DEF VAR v-id-segmento   AS INTEGER      NO-UNDO.
DEF VAR v-id-campo      AS INTEGER      NO-UNDO.
DEF VAR v-label         AS CHARACTER    NO-UNDO.
DEF VAR v-tabela        AS CHARACTER    NO-UNDO.
DEF VAR v-campo         AS CHARACTER    NO-UNDO.
DEF VAR v-extent        AS INTEGER      NO-UNDO.
DEF VAR v-descricao     AS CHARACTER    NO-UNDO.

RUN utp/utapi021.p PERSISTENT SET h-xml.

EMPTY TEMP-TABLE tt-xml.

DEF VAR L-MOSTRA AS LOG.

/* inicio - grava 1 xml por segmento/registro*/
FOR EACH tt-campos BREAK BY tt-campos.sequencia BY tt-campos.segmento BY tt-campos.registro:
/* inicializa xml com dados do segmento/registro */


    IF  FIRST-OF(tt-campos.registro) THEN DO:

        RUN reset IN h-xml.
        RUN addNode IN h-xml (0, {&TagSegment} + "_" + STRING(tt-campos.segmento) + "_":U + STRING(tt-campos.registro), "":U, OUTPUT v-id-segmento).
        RUN setAttribute IN h-xml (v-id-segmento, {&AttrLNum}, STRING(tt-campos.segmento)).
        RUN setAttribute IN h-xml (v-id-segmento, {&AttrRNum}, STRING(tt-campos.registro)).
        RUN obtemDescSegmento (tt-campos.segmento, OUTPUT v-descricao).       

        IF  RETURN-VALUE = "OK":U THEN
            RUN setAttribute IN h-xml (v-id-segmento, {&AttrDesc}, fn-free-accent(v-descricao)).
    END.            

    /* Verifica se ‚ um campo com extent. Caso positivo gera atributo extent no xml */
    RUN obtemTabelaCampoExtent (tt-campos.campo, OUTPUT v-tabela, OUTPUT v-campo, OUTPUT v-extent).  

    IF  RETURN-VALUE = "NOK":U THEN DO:

        RUN addNode IN h-xml (v-id-segmento, prepareTagName(tt-campos.campo), tt-campos.valor, OUTPUT v-id-campo).

    END.
    ELSE DO: /* campo.tabela (talvez com extent)*/

        RUN addNode IN h-xml (v-id-segmento, v-tabela + ".":U + v-campo, tt-campos.valor, OUTPUT v-id-campo).

        IF  v-extent > 0 THEN
            RUN setAttribute IN h-xml (v-id-campo, "EXTENT":U, STRING(v-extent)).

    END.

    /* se for tabela.campo, obtem label e grava como atributo para auxiliar identifica‡Æo do xml */
    RUN obtemLabel (tt-campos.campo, OUTPUT v-label).
    IF  RETURN-VALUE = "OK":U THEN
        RUN setAttribute IN h-xml (v-id-campo, "LABEL":U, fn-free-accent(v-label)).                                             

    /* grava n£mero de decimais caso possua */       
    IF  tt-campos.num-decimal > 0  THEN
        RUN setAttribute IN h-xml (v-id-campo, "DECIMALS":U, STRING(tt-campos.num-decimal)).    

    /* grava registro em tt-xml com todos os campos do segmento/registro */
    IF  LAST-OF(tt-campos.registro) THEN DO:               
        CREATE tt-xml.
        ASSIGN tt-xml.sequencia     = tt-campos.sequencia
               tt-xml.segmento      = tt-campos.segmento
               tt-xml.registro      = tt-campos.registro.
        RUN generateXMLToString IN h-xml (OUTPUT tt-xml.conteudo).

    END.
END.

DELETE PROCEDURE h-xml.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemCampos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemCampos Procedure 
PROCEDURE obtemCampos :
/*------------------------------------------------------------------------------
  Purpose:     Obtem o valor dos campos de uma tabela de acordo com o layout de 
               registro
  Parameters:  cod-layout, log-datasul, num-versao, 
               tipo-registro, num-registro
               tt-tab-handle, tt-campos
               output segmento
  Notes:       Grava tamb‚m os campos auxiliares e livres em tt-campos.
               Retorna o numero do segmento gerado em tt-campos.
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-cod-layout            AS INTEGER NO-UNDO.
DEF INPUT PARAM p-log-datasul           AS LOGICAL NO-UNDO.
DEF INPUT PARAM p-num-versao            AS INTEGER NO-UNDO.
DEF INPUT PARAM p-tipo-registro         AS INTEGER NO-UNDO.
DEF INPUT PARAM p-num-registro          AS INTEGER NO-UNDO.
DEF INPUT PARAM TABLE                   FOR tt-tab-handle.
DEF INPUT-OUTPUT PARAM TABLE            FOR tt-campos.
DEF OUTPUT PARAM p-segmento             AS INTEGER NO-UNDO.

DEF VAR v-tabela        AS CHARACTER NO-UNDO.
DEF VAR v-campo         AS CHARACTER NO-UNDO.
DEF VAR h-campo         AS HANDLE    NO-UNDO.
DEF VAR v-extent        AS INTEGER   NO-UNDO.

    /* verifica se precisa obter campos para este layout */
    FIND FIRST bc-layout-registro NO-LOCK
         WHERE bc-layout-registro.cod-layout  = p-cod-layout
           AND bc-layout-registro.log-datasul = p-log-datasul
           AND bc-layout-registro.num-versao  = p-num-versao
           AND bc-layout-registro.cod-tipo-layout-registro = p-tipo-registro
         NO-ERROR.
    IF  NOT AVAIL bc-layout-registro THEN
        RETURN.

    /* retorno do segmento gerado */
    p-segmento = bc-layout-registro.num-layout-registro.

    /* obtem o valor dos campos que estÆo no layout */
    FOR EACH bc-layout-registro-item NO-LOCK
        WHERE bc-layout-registro-item.num-layout-registro = bc-layout-registro.num-layout-registro:
        /* despreza constante, nova-linha e espa‡os */
        IF  bc-layout-registro-item.tipo-item = 2 /* constante */
        OR  bc-layout-registro-item.tipo-item = 3 /* nova-linha */
        OR  bc-layout-registro-item.tipo-item = 4 /* espa‡o */ THEN
            NEXT.
        /* grava campo auxiliar e livre (valor podera ser preenchido via UPC no FT0513CL.P) */
        IF  bc-layout-registro-item.tipo-item = 5 /* auxiliar */
        OR  bc-layout-registro-item.tipo-item = 6 /* campo fixo */ THEN DO:
            CREATE tt-campos.
            ASSIGN tt-campos.sequencia = bc-layout-registro.sequencia
                   tt-campos.segmento  = bc-layout-registro.num-layout-registro
                   tt-campos.registro  = p-num-registro
                   tt-campos.campo     = bc-layout-registro-item.valor-item
                   tt-campos.valor     = (IF bc-layout-registro-item.tipo-item = 6  /* campo fixo, valor pr‚-fixado */
                                          THEN &IF '{&mgcld_version}' >= '2.05'
                                               &THEN bc-layout-registro-item.valor-campo
                                               &ELSE bc-layout-registro-item.char-2
                                               &ENDIF
                                          ELSE "")
                   tt-campos.num-decimal = bc-layout-registro-item.num-decimais.

            NEXT.
        END.

        /* nome do campo deve estar no formato tabela.campo */
        RUN obtemTabelaCampoExtent(bc-layout-registro-item.valor-item, 
                                   OUTPUT v-tabela, OUTPUT v-campo, OUTPUT v-extent).
        IF  RETURN-VALUE = "NOK":U THEN
            NEXT.

        /* localiza o handle da tabela */
        FIND FIRST tt-tab-handle
            WHERE tt-tab-handle.tabela = v-tabela
            NO-ERROR.
        IF  NOT AVAIL tt-tab-handle THEN
            NEXT.

        /* obtem o handle para ler o valor do campo */
        h-campo = tt-tab-handle.tab-handle:BUFFER-FIELD(v-campo).

        /* cria tt-campos */
        CREATE tt-campos.
        ASSIGN tt-campos.sequencia = bc-layout-registro.sequencia
               tt-campos.segmento  = bc-layout-registro.num-layout-registro
               tt-campos.registro  = p-num-registro
               tt-campos.campo     = bc-layout-registro-item.valor-item
               tt-campos.valor     = (IF v-extent = 0 
                                      THEN h-campo:BUFFER-VALUE 
                                      ELSE h-campo:BUFFER-VALUE(v-extent))
               tt-campos.num-decimal = bc-layout-registro-item.num-decimais.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemDescSegmento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemDescSegmento Procedure 
PROCEDURE obtemDescSegmento :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a descri‡Æo do segmento
  Parameters:  num-layout-registro, output descricao
  Notes:       retorna em return-value "OK" ou "NOK"
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-layout-registro       AS INTEGER NO-UNDO.
DEF OUTPUT PARAM p-descricao            AS CHARACTER NO-UNDO.

    /* le o layout-registro (segmento) */
    FIND FIRST bc-layout-registro
        WHERE bc-layout-registro.num-layout-registro = p-layout-registro
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-layout-registro THEN
        RETURN "NOK":U.

    /* busca o layout do segmento para obter o tipo-layout */
    FIND bc-layout
        WHERE bc-layout.cod-layout = bc-layout-registro.cod-layout
          AND bc-layout.log-datasul = bc-layout-registro.log-datasul
          AND bc-layout.num-versao  = bc-layout-registro.num-versao
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-layout THEN
        RETURN "NOK":U.

    /* le o tipo-layout-registro (tipo-segmento) */
    FIND bc-tipo-layout-registro
        WHERE bc-tipo-layout-registro.cod-tipo-layout = bc-layout.cod-tipo-layout
          AND bc-tipo-layout-registro.cod-tipo-layout-registro = bc-layout-registro.cod-tipo-layout-registro
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-tipo-layout-registro THEN
        RETURN "NOK":U.

    /* retorna a descri‡Æo do segmento */
    p-descricao = bc-tipo-layout-registro.descricao.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemLabel Procedure 
PROCEDURE obtemLabel :
/*------------------------------------------------------------------------------
  Purpose:     Tenta identificar um label de campo usando buffer dinamico
  Parameters:  tabela.campo, output label
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-tabela-campo      AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM p-label            AS CHARACTER NO-UNDO.

DEF VAR h-tabela        AS HANDLE    NO-UNDO.
DEF VAR h-campo         AS HANDLE    NO-UNDO.
DEF VAR v-tabela        AS CHARACTER NO-UNDO.
DEF VAR v-campo         AS CHARACTER NO-UNDO.
DEF VAR v-extent        AS INTEGER   NO-UNDO.

    /* NÆo est  no formato tabela.campo */
    RUN obtemTabelaCampoExtent(p-tabela-campo, OUTPUT v-tabela, OUTPUT v-campo, OUTPUT v-extent).
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /* Tenta cria buffer dinamico para tabela */
    CREATE BUFFER h-tabela FOR TABLE v-tabela NO-ERROR.
    IF  ERROR-STATUS:ERROR THEN
        RETURN "NOK":U.

    /* Tenta localizar campo na tabela para pegar o label */
    h-campo = h-tabela:BUFFER-FIELD(v-campo) NO-ERROR.

    IF  ERROR-STATUS:ERROR THEN DO:

        IF  VALID-HANDLE(h-tabela) THEN
            DELETE WIDGET h-tabela.

        RETURN "NOK":U.
    END.

    /* retorna label */
    IF  VALID-HANDLE(h-campo) THEN DO:

        p-label = h-campo:LABEL.

        IF VALID-HANDLE(h-tabela) THEN
           DELETE WIDGET h-tabela.

        RETURN "OK":U.

    END.
    ELSE
        RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemLayout2D) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemLayout2D Procedure 
PROCEDURE obtemLayout2D :
/*------------------------------------------------------------------------------
  Purpose:     Para determinado processo e nome-abrev retorna o layout 2D
  Parameters:  processo, nome-abrev, output bc-layout
  Notes:       Retorna "OK" ou "NOK"
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-processo          AS INTEGER   NO-UNDO.
DEF INPUT PARAM p-nome-abrev        AS CHARACTER NO-UNDO.
DEF INPUT PARAM p-transacao         AS CHARACTER NO-UNDO.
DEF PARAM BUFFER pb-layout          FOR bc-layout.
DEF INPUT-OUTPUT PARAM TABLE        FOR tt-erro.


/* verifica se o cliente tem etiqueta para processo de entrada */
FIND bc-emitente-etiqueta
    WHERE bc-emitente-etiqueta.processo   = p-processo
      AND bc-emitente-etiqueta.nome-abrev = p-nome-abrev
    NO-LOCK NO-ERROR.
IF  NOT AVAIL bc-emitente-etiqueta THEN DO:
    RUN geraTTErro (25934, p-nome-abrev, "":U).
    RETURN "NOK":U.
END.

/* verifica se etiqueta existe */
FIND tipo-etiqueta
    WHERE tipo-etiqueta.tipo-etiq = bc-emitente-etiqueta.tipo-etiq
    NO-LOCK NO-ERROR.
IF  NOT AVAIL tipo-etiqueta THEN DO:
    {utp/ut-table.i mgcld tipo-etiqueta 1}
    RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(bc-emitente-etiqueta.tipo-etiq)).
    RETURN "NOK":U.
END.

/* verifica se etiqueta ‚ do tipo 2D */
&IF '{&mgcld_version}' >= '2.04' &THEN
IF  tipo-etiqueta.ind-dimensao <> 2 THEN DO:
&else
IF  tipo-etiqueta.int-2 <> 2 THEN DO:
&ENDIF
    RUN geraTTErro (25939, STRING(tipo-etiqueta.tipo-etiq), "":U).
    RETURN "NOK":U.
END.

/* localiza a ultima versÆo do layout da etiqueta */
FIND LAST pb-layout
&IF '{&mgcld_version}' >= '2.04' &THEN
    WHERE pb-layout.cod-layout = tipo-etiqueta.cod-layout
      AND pb-layout.log-datasul = tipo-etiqueta.log-datasul
    NO-LOCK NO-ERROR.
IF  NOT AVAIL pb-layout THEN DO:
    RUN geraTTErro (25940, STRING(tipo-etiqueta.tipo-etiq) + "~~" +
                           formataCodLayout(tipo-etiqueta.cod-layout, tipo-etiqueta.log-datasul, 1),
                           "":U).
    RETURN "NOK":U.
END.
&else
    WHERE pb-layout.cod-layout = tipo-etiqueta.int-1
      AND pb-layout.log-datasul = tipo-etiqueta.log-1
    NO-LOCK NO-ERROR.
IF  NOT AVAIL pb-layout THEN DO:
    RUN geraTTErro (25940, STRING(tipo-etiqueta.tipo-etiq) + "~~" +
                           formataCodLayout(tipo-etiqueta.int-1, tipo-etiqueta.log-1, 1),
                           "":U).
    RETURN "NOK":U.
END.
&endif


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemLayoutEtiqueta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemLayoutEtiqueta Procedure 
PROCEDURE obtemLayoutEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o layout usado na etiqueta na ultima versÆo
  Parameters:  tipo-etiq, output cod-layout, output log-datasul, output versao
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-tipo-etiq     AS INTEGER  NO-UNDO.
DEF OUTPUT PARAM p-cod-layout   AS INTEGER  NO-UNDO.
DEF OUTPUT PARAM p-log-datasul  AS LOGICAL  NO-UNDO.
DEF OUTPUT PARAM p-num-versao   AS INTEGER  NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE    FOR tt-erro.

    /* le a transa‡Æo */
    FIND tipo-etiqueta
        WHERE tipo-etiqueta.tipo-etiq = p-tipo-etiq
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL tipo-etiqueta THEN DO:
        {utp/ut-table.i mgcld tipo-etiqueta 1}
        RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(p-tipo-etiq)).
        RETURN "NOK":U.
    END.
&IF '{&mgcld_version}' >= '2.04' &THEN
    /* le o layout */
    FIND LAST bc-layout
        WHERE bc-layout.cod-layout = tipo-etiqueta.cod-layout
          AND bc-layout.log-datasul = tipo-etiqueta.log-datasul
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-layout THEN DO:
        {utp/ut-table.i mgcld bc-layout 1}
        RUN geraTTErro (2, TRIM(RETURN-VALUE), formataCodLayout(tipo-etiqueta.cod-layout, tipo-etiqueta.log-datasul, 1)).
        RETURN "NOK":U.
    END.
&else
    /* le o layout */
    FIND LAST bc-layout
        WHERE bc-layout.cod-layout = tipo-etiqueta.int-1
          AND bc-layout.log-datasul = tipo-etiqueta.log-1
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-layout THEN DO:
        {utp/ut-table.i mgcld bc-layout 1}
        RUN geraTTErro (2, TRIM(RETURN-VALUE), formataCodLayout(tipo-etiqueta.int-1, tipo-etiqueta.log-1, 1)).
        RETURN "NOK":U.
    END.
&ENDIF    
    /* retorna dados */
    p-cod-layout  = bc-layout.cod-layout.
    p-log-datasul = bc-layout.log-datasul.
    p-num-versao  = bc-layout.num-versao.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemLayoutTransacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemLayoutTransacao Procedure 
PROCEDURE obtemLayoutTransacao :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o layout usado na transa‡Æo
  Parameters:  num-trans, output cod-layout, output log-datasul, output versao
  Notes:       O layout da transa‡Æo ‚ obtido a partir de 
               bc-trans-filho.num-layout-registro
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-nr-trans      AS INTEGER  NO-UNDO.
DEF OUTPUT PARAM p-cod-layout   AS INTEGER  NO-UNDO.
DEF OUTPUT PARAM p-log-datasul  AS LOGICAL  NO-UNDO.
DEF OUTPUT PARAM p-num-versao   AS INTEGER  NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE    FOR tt-erro.

    /* le a transa‡Æo */
    FIND bc-trans
        WHERE bc-trans.nr-trans = p-nr-trans
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-trans THEN DO:
        {utp/ut-table.i mgcld bc-trans 1}
        RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(p-nr-trans)).
        RETURN "NOK":U.
    END.

    /* le o primeiro registro da transa‡Æo */
    FIND FIRST bc-trans-filho 
        WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans 
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-trans-filho THEN DO:
        {utp/ut-table.i mgcld bc-trans-filho 1}
        RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(p-nr-trans)).
        RETURN "NOK":U.
    END.

    /* le o layout do registro */
    FIND bc-layout-registro
        WHERE bc-layout-registro.num-layout-registro = bc-trans-filho.num-layout-registro
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-layout-registro THEN DO:
        {utp/ut-table.i mgcld bc-layout-registro 1}
        RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(bc-trans-filho.num-layout-registro)).
        RETURN "NOK":U.
    END.

    /* retorna dados */
    p-cod-layout  = bc-layout-registro.cod-layout.
    p-log-datasul = bc-layout-registro.log-datasul.
    p-num-versao  = bc-layout-registro.num-versao.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemTabelaCampoExtent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemTabelaCampoExtent Procedure 
PROCEDURE obtemTabelaCampoExtent :
/*------------------------------------------------------------------------------
  Purpose:     Retorna Tabela, Campo e Extent de um nome de campo
  Parameters:  tabela.campo, output tabela, output campo, output extent
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-tabela-campo      AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM p-tabela           AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM p-campo            AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM p-extent           AS INTEGER   NO-UNDO.

DEF VAR v-aux       AS CHARACTER NO-UNDO.

    IF  NUM-ENTRIES(p-tabela-campo, ".":U) <> 2 THEN DO:
        ASSIGN 
              p-tabela = (IF p-tabela = ? THEN "" ELSE RIGHT-TRIM(TRIM(p-tabela)))
              p-campo  = (IF p-campo = ? THEN "" ELSE RIGHT-TRIM(TRIM(p-campo)))
              p-extent = (IF p-extent = ? THEN 0 ELSE p-extent).
        RETURN "NOK":U.
    END.

    p-tabela = ENTRY(1, p-tabela-campo, ".":U).
    p-campo  = ENTRY(2, p-tabela-campo, ".":U).
    IF  INDEX(p-campo, "[":U) > 0 THEN DO:
        v-aux = SUBSTR(p-campo, INDEX(p-campo, "[":U) + 1).
        v-aux = REPLACE(v-aux, "]":U, "":U).
        p-extent = INTEGER(v-aux).
        p-campo = SUBSTR(p-campo, 1, INDEX(p-campo, "[":U) - 1).
    END.

    ASSIGN p-tabela = (IF p-tabela = ? THEN "" ELSE RIGHT-TRIM(TRIM(p-tabela)))
           p-campo  = (IF p-campo = ? THEN "" ELSE RIGHT-TRIM(TRIM(p-campo)))
           p-extent = (IF p-extent = ? THEN 0 ELSE p-extent).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtemTTCampos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtemTTCampos Procedure 
PROCEDURE obtemTTCampos :
/*------------------------------------------------------------------------------
  Purpose:     Retorna tt-campos a partir da transa‡Æo
  Parameters:  num-transa‡Æo, output tt-campos
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-nr-trans      AS INTEGER NO-UNDO.
DEF OUTPUT PARAM TABLE          FOR tt-campos.
DEF INPUT-OUTPUT PARAM TABLE    FOR tt-erro.

    EMPTY TEMP-TABLE tt-campos.

    /* le a transa‡Æo */
    FIND bc-trans
        WHERE bc-trans.nr-trans = p-nr-trans
        NO-LOCK NO-ERROR.
    IF  NOT AVAIL bc-trans THEN DO:
        {utp/ut-table.i mgcld bc-trans 1}
        RUN geraTTErro (2, TRIM(RETURN-VALUE), STRING(p-nr-trans)).
        RETURN "NOK":U.
    END.

    /* prepara‡Æo dos dados */
    EMPTY TEMP-TABLE tt-xml.
    EMPTY TEMP-TABLE tt-campos.

    /* gera tt-xml com base nos bc-trans-filho */
    FOR EACH bc-trans-filho 
        WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans NO-LOCK:
        /* cria tt-xml para cada bc-trans-filho */
        CREATE tt-xml.
        ASSIGN tt-xml.sequencia = bc-trans-filho.sequencia
               tt-xml.segmento  = bc-trans-filho.num-layout-registro
               tt-xml.registro  = INTEGER(bc-trans-filho.cod-aux[1])
               tt-xml.conteudo  = bc-trans-filho.conteudo-trans.
    END.

    /* converte tt-xml para tt-campos */
    RUN geraCampos (INPUT TABLE tt-xml, OUTPUT TABLE tt-campos).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-prepareTagName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareTagName Procedure 
FUNCTION prepareTagName RETURNS CHARACTER
  ( tag-name AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  substituir caracteres no nome da tag para o xml
    Notes:  
------------------------------------------------------------------------------*/

  tag-name = REPLACE(tag-name, " ":U, "_":U).
  tag-name = fn-free-accent(tag-name).
  RETURN tag-name.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

