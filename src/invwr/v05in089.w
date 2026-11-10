&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*********************************************************************************/
{include/i-prgvrs.i V05IN089 2.00.00.041 } /* 09/09/2026 10:53:16 */



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v05in089 MUT}
&ENDIF

    CREATE WIDGET-POOL.
    &Scop adm-attribute-dlg support/viewerd.w

    def buffer b-doc         for doc-fisico.
    def buffer b-emit-estab  for emitente.

    def var rw-saldo-terc as rowid  no-undo.
    def var rw-doc-fisico as rowid  no-undo.
    def var v-row-parent  as rowid  no-undo.
    def var i-observa     as integer no-undo initial 1.
    def var i-especie     as integer no-undo.
    def var l-mensagem    as logical no-undo init no.
    def var i-cgc         as integer init 1.
    def var l-novo        as log.
    def var c-formato     as char no-undo.
    def var c-nat-oper    as char no-undo.
    def var c-emit        like doc-fisico.cod-emitente no-undo.
    def var c-docto-aux   like doc-fisico.nro-docto.
    def var i-tipo-nota   as integer FORMAT 99 no-undo.
    def var i-tipo-aux    as integer no-undo.
    def var l-grava-consist-nota  as log no-undo.
    def var l-passou-btfinalizar  as log no-undo.
    def var de-nota               as decimal no-undo.
    def var dt-retorno-saldo-terc as date    no-undo.
    def var l-comercio            as logical no-undo.
    DEF VAR h-cdapi034            AS HANDLE  NO-UNDO.
    DEF VAR i-cod-regra-utilizada AS INTEGER NO-UNDO.

    def new global shared var l-mostra-fornec  as logical no-undo initial no.
    def new global shared var l-re1001a-inclui as logical no-undo initial no.
    def new global shared var gr-doc-fisico    as rowid   no-undo.

    {METHOD/dbotterr.i}

    DEFINE TEMP-TABLE tt-variavel NO-UNDO
        FIELD cod-var-oper   AS CHARACTER FORMAT "x(16)"
        FIELD valor-variavel AS CHARACTER FORMAT "x(60)".

    DEFINE TEMP-TABLE tt-retorno NO-UNDO
        FIELD valor-retorno AS CHARACTER FORMAT "x(60)"
        FIELD campo-retorno AS CHARACTER FORMAT "x(60)"
        FIELD perc-rateio   AS DECIMAL FORMAT ">>9,99".

    {cdp/cdcfgmat.i}  /** Include uso de pre-processadores                          **/
    {cdp/cd4305.i1}   /**  Definicao TT-DOCTO, TT-IT-DOCTO                          **/
    {cdp/cd4401.i3}   /**  Definicao da temp-table TT-SALDO-ESTOQ                   **/
    {rep/re1001o.i01} /**  Definicao da temp-table TT-CONSIST                       **/
    {cdp/cd4300.i3}   /**  Variaveis para Quebra CHAR-1                             **/
    {rep/re2001.i60}  /**  Variaveis Contidas no CHAR-1                             **/
    {rep/re2001a.i}   /**  temp table para passagem de parƒmetros entre as viewers  **/
    {rep/re2001a.i11} /**  Execu‡Æo do Engine                                       **/
    {rep/re1903.i1}   /**  Atualiza o item-doc-est a partir do tt-it-docto          **/
    {cdp/cd9098.i}    /**  Vari veis para Zoom Emitentes                            **/
    {cdp/cd0669.i}    /**  Temp-table de erros verificados na cdapi029.p            **/ 

    def buffer b-saldo-terc  for saldo-terc.
    def buffer b-tt-it-docto for tt-it-docto.

    {cdp/cdcfgdis.i}
    {cdp/cdcfgmat.i}

    DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel.
    DEF BUFFER bf-estabelec FOR estabelec.

    {cdp/cd0031.i "MRE"} /* Seguran‡a por Estabelecimento leave*/

/*Utilizado no pre-processador {&bf_libera_15_posicoes}*/
define variable c-formato-nf  as char format "x(16)" no-undo.

DEFINE VARIABLE h-boin847  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin089  AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES doc-fisico
&Scoped-define FIRST-EXTERNAL-TABLE doc-fisico


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR doc-fisico.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS doc-fisico.cod-estabel doc-fisico.estab-de-or ~
doc-fisico.dt-emissao doc-fisico.dt-trans 
&Scoped-define ENABLED-TABLES doc-fisico
&Scoped-define FIRST-ENABLED-TABLE doc-fisico
&Scoped-Define ENABLED-OBJECTS rt-key rt-key-2 
&Scoped-Define DISPLAYED-FIELDS doc-fisico.cod-emitente ~
doc-fisico.serie-docto doc-fisico.cod-estabel doc-fisico.estab-de-or ~
doc-fisico.dt-emissao doc-fisico.dt-trans 
&Scoped-define DISPLAYED-TABLES doc-fisico
&Scoped-define FIRST-DISPLAYED-TABLE doc-fisico
&Scoped-Define DISPLAYED-OBJECTS fi-emitente c-cgc c-tipo-nota fi-estabel ~
fi-estabel-origem 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS doc-fisico.cod-emitente ~
doc-fisico.serie-docto i-nro-docto c-tipo-nota 
&Scoped-define ADM-ASSIGN-FIELDS i-nro-docto 
&Scoped-define ADM-MODIFY-FIELDS c-cgc 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-tipo-nota AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Nota" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 23.57 BY 1 NO-UNDO.

DEFINE VARIABLE i-nro-docto AS DECIMAL FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cgc AS CHARACTER FORMAT "x(19)" 
     LABEL "CGC" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel-origem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.86 BY 6.63.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.86 BY 6.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     doc-fisico.cod-emitente AT ROW 1.75 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-emitente AT ROW 1.75 COL 30 COLON-ALIGNED NO-LABEL
     c-cgc AT ROW 2.75 COL 20.86 COLON-ALIGNED HELP
          "CGC ou CIC do cliente/fornecedor"
     doc-fisico.serie-docto AT ROW 3.75 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     i-nro-docto AT ROW 4.75 COL 11.28
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-tipo-nota AT ROW 5.75 COL 20.86 COLON-ALIGNED
     doc-fisico.cod-estabel AT ROW 9 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.29 BY .88
     fi-estabel AT ROW 9 COL 28.57 COLON-ALIGNED NO-LABEL
     doc-fisico.estab-de-or AT ROW 10 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.29 BY .88
     fi-estabel-origem AT ROW 10 COL 28.57 COLON-ALIGNED NO-LABEL
     doc-fisico.dt-emissao AT ROW 11 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     doc-fisico.dt-trans AT ROW 12 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     rt-key AT ROW 7.63 COL 1
     rt-key-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.doc-fisico
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 13.33
         WIDTH              = 85.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 13.33
       FRAME f-main:WIDTH            = 85.

/* SETTINGS FOR FILL-IN c-cgc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX c-tipo-nota IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN doc-fisico.cod-emitente IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estabel-origem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nro-docto IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L 1 2                                     */
/* SETTINGS FOR FILL-IN doc-fisico.serie-docto IN FRAME f-main
   NO-ENABLE 1                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cgc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cgc V-table-Win
ON ENTRY OF c-cgc IN FRAME f-main /* CGC */
DO:

    if l-novo = yes then do:
        find emitente where
            emitente.cod-emitente = input frame {&frame-name} doc-fisico.cod-emitente
            no-lock no-error.
        if avail emitente then
            assign i-cgc = emitente.natureza.
        assign l-novo = no.
    end.

    if avail param-global then do:
        case i-cgc:
            when 1 then do:
                if param-global.formato-id-pessoal <> "":U then
                    assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-pessoal.
            end.
            when 2 then do:
                if param-global.formato-id-federal <> "":U then
                    assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal.
            end.
            otherwise
                assign c-cgc:format in frame {&FRAME-NAME} = "x(19)":U.
        end.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cgc V-table-Win
ON LEAVE OF c-cgc IN FRAME f-main /* CGC */
DO:

    {include/i-epcgeneric.i LEAVE-CGC VIEWER THIS-PROCEDURE {&FRAME-NAME} doc-fisico ROWID(doc-fisico)}

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    if input frame {&frame-name} doc-fisico.cod-emitente = 0 then do:
        FOR FIRST emitente where
            emitente.cgc = input frame {&frame-name} c-cgc
            AND CAN-FIND(FIRST dist-emitente 
                     WHERE dist-emitente.cod-emitente = emitente.cod-emitente
                       AND dist-emitente.idi-sit-fornec <> 4) NO-LOCK:
        END.
        if avail emitente then do:
            assign doc-fisico.cod-emitente:screen-value in frame {&frame-name} = string(emitente.cod-emit)
                   fi-emitente:screen-value in frame {&frame-name}             = string(emitente.nome-emit).

            if l-re1001a-inclui then do:
                run pi-recria-tt-inicializa.
                assign tt-inicializa.cod-emitente = emitente.cod-emitente.
                RUN pi-inicializa-campos IN h_v06in089 ( INPUT table tt-inicializa ).
            end.
        end.
    end.

    case i-cgc:
        when 1 then do:
            if avail param-global and param-global.formato-id-pessoal <> "":U then
                assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-pessoal.
        end.
        when 2 then do:
            if avail param-global and param-global.formato-id-federal <> "":U then
                assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal.
        end.
        otherwise
            assign c-cgc:format in frame {&FRAME-NAME} = "x(19)":U.
    end.

    assign c-formato = input frame {&FRAME-NAME} c-cgc no-error.

    if ERROR-STATUS:ERROR then do:
        assign c-cgc:format in frame {&FRAME-NAME} = "x(19)":U.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tipo-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tipo-nota V-table-Win
ON VALUE-CHANGED OF c-tipo-nota IN FRAME f-main /* Tipo Nota */
DO:

    assign input frame {&frame-name} c-tipo-nota.
    assign i-tipo-aux = {ininc/i01in089.i 06 c-tipo-nota}.

    if i-tipo-aux = 3 
    then enable doc-fisico.estab-de-or with frame {&frame-name}.
    else disable doc-fisico.estab-de-or with frame {&frame-name}.   
    
    if i-tipo-aux <> 3 then
        assign doc-fisico.estab-de-or:screen-value in frame {&frame-name} = "":U
               fi-estabel-origem:screen-value in frame {&frame-name} = "":U.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME doc-fisico.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.cod-emitente V-table-Win
ON F5 OF doc-fisico.cod-emitente IN FRAME f-main /* Emitente */
DO:

    assign i-filtro = 2.

    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z07ad098.w
                       &campo=doc-fisico.cod-emitente
                       &campozoom=cod-emitente}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.cod-emitente V-table-Win
ON LEAVE OF doc-fisico.cod-emitente IN FRAME f-main /* Emitente */
DO:

    {include/i-epcgeneric.i LEAVE-EMITENTE VIEWER THIS-PROCEDURE {&FRAME-NAME} doc-fisico ROWID(doc-fisico)}

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.

    assign l-novo = yes.

    if input frame {&frame-name} doc-fisico.cod-emitente <> 0 then do:

        {include/leave.i &tabela=emitente
                         &atributo-ref=nome-emit
                         &variavel-ref=fi-emitente
                         &where="emitente.cod-emitente = input frame {&frame-name}
                                 doc-fisico.cod-emitente"}

        assign c-cgc:format in frame {&FRAME-NAME} = "x(19)":U.

        {include/leave.i &tabela=emitente
                         &atributo-ref=cgc
                         &variavel-ref=c-cgc
                         &where="emitente.cod-emitente = input frame {&frame-name}
                                 doc-fisico.cod-emitente"}
    end.
    else assign c-cgc:screen-value in frame {&frame-name} = "":U.

    if  avail emitente 
    AND l-re1001a-inclui then do:

        run pi-recria-tt-inicializa.
        assign tt-inicializa.cod-emitente = emitente.cod-emitente.
        RUN pi-inicializa-campos IN h_v06in089 (INPUT table tt-inicializa).


        assign input frame {&frame-name} c-tipo-nota
               i-tipo-nota   = {ininc/i01in089.i 06 c-tipo-nota}.
            
        if i-tipo-nota = 3 then do with frame {&frame-name}:

            run pi-totaliza-entrada-transfer (output dt-retorno-saldo-terc).

            if dt-retorno-saldo-terc <> ? then
                assign doc-fisico.dt-emissao:screen-value in frame {&FRAME-NAME} = string(saldo-terc.dt-retorno).
            
        END.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF doc-fisico.cod-emitente IN FRAME f-main /* Emitente */
DO:

    apply "F5":U to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME doc-fisico.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.cod-estabel V-table-Win
ON F5 OF doc-fisico.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:

    FOR FIRST param-global NO-LOCK:
        IF i-tipo-aux = 3 AND SUBSTRING(param-global.char-2, 37, 1) = "S"  THEN DO:
            ON FIND OF estabelec DO:
                IF NOT CAN-FIND(tt_estab_ems2
                          WHERE tt_estab_ems2.tta_cod_estab = doc-fisico.cod-estabel) THEN
                    RETURN ERROR.
            END.
        END.    
    END.

    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=doc-fisico.cod-estabel
                       &campozoom=cod-estabel}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.cod-estabel V-table-Win
ON LEAVE OF doc-fisico.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:

    FOR FIRST param-global NO-LOCK:
        IF i-tipo-aux = 3 AND SUBSTRING(param-global.char-2, 37, 1) = "S"  THEN DO:
            ON FIND OF estabelec DO:
            IF NOT CAN-FIND(tt_estab_ems2
                      WHERE tt_estab_ems2.tta_cod_estab = input frame {&frame-name}
                                     doc-fisico.cod-estabel) THEN
                RETURN ERROR.
            END.
        END.
    END.

    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=fi-estabel
                     &where="estabelec.cod-estabel = input frame {&frame-name}
                             doc-fisico.cod-estabel"}
    if not avail estabelec then
        assign doc-fisico.cod-estabel:SCREEN-VALUE in frame {&FRAME-NAME} = "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF doc-fisico.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:

    apply "F5":U to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME doc-fisico.estab-de-or
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.estab-de-or V-table-Win
ON F5 OF doc-fisico.estab-de-or IN FRAME f-main /* Est Origem/Destino */
DO:

    IF i-tipo-aux = 3 THEN DO:
        ON FIND OF estabelec DO:
        END.
    END.

    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=doc-fisico.cod-estabel
                       &campozoom=cod-estabel}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.estab-de-or V-table-Win
ON LEAVE OF doc-fisico.estab-de-or IN FRAME f-main /* Est Origem/Destino */
DO:

    IF i-tipo-aux = 3 THEN DO:
        ON FIND OF estabelec DO:
        END.
    END.

    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=fi-estabel-origem
                     &where="estabelec.cod-estabel = input frame {&frame-name}
                             doc-fisico.estab-de-or"}

    IF NOT AVAIL estabelec THEN
      assign doc-fisico.estab-de-or:screen-value in frame {&frame-name} = "":U
             fi-estabel-origem:screen-value in frame {&frame-name} = "":U.
 
    if l-re1001a-inclui then do:
        if avail estabelec then do:
            run pi-recria-tt-inicializa.
            assign tt-inicializa.cod-emitente = input frame {&FRAME-NAME} doc-fisico.cod-emitente.

            RUN pi-inicializa-campos IN h_v06in089
              (INPUT table tt-inicializa).

        end.
    end.

    assign input frame {&frame-name} c-tipo-nota.
    assign i-tipo-nota = {ininc/i01in089.i 06 c-tipo-nota}.

    if l-re1001a-inclui and
        i-tipo-nota = 3 then do with frame {&frame-name}:

         run pi-totaliza-entrada-transfer (output dt-retorno-saldo-terc).

         if dt-retorno-saldo-terc <> ? then
            assign doc-fisico.dt-emissao:screen-value in frame {&FRAME-NAME} = string(saldo-terc.dt-retorno).
        
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.estab-de-or V-table-Win
ON MOUSE-SELECT-DBLCLICK OF doc-fisico.estab-de-or IN FRAME f-main /* Est Origem/Destino */
DO:

    apply "F5":U to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nro-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nro-docto V-table-Win
ON LEAVE OF i-nro-docto IN FRAME f-main /* Documento */
DO:
    IF LENGTH(i-nro-docto:SCREEN-VALUE IN frame {&frame-name}, "CHARACTER") < 8 THEN
        assign i-nro-docto:screen-value in frame {&frame-name} = left-trim(string(dec(input frame {&frame-name} i-nro-docto),c-formato-nf)).

     /*if length(input frame {&frame-name} doc-fisico.nro-docto) > length(c-formato-nf) then do:
        /*{include/i-vldprg.i} */
        run utp/ut-msgs.p (input "show":U,  /*Numero maior que o formato*/ 
                           input 36151, 
                           input c-formato-nf).
        
        apply "entry":U to doc-fisico.nro-docto in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end. 


    assign doc-fisico.nro-docto:screen-value in frame {&frame-name} = left-trim(string(dec(input frame {&frame-name} doc-fisico.nro-docto),c-formato-nf)).*/
    /*assign self:screen-value = string(int(self:screen-value),self:format).      */
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME doc-fisico.serie-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.serie-docto V-table-Win
ON F5 OF doc-fisico.serie-docto IN FRAME f-main /* S‚rie */
DO:

    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in407.w
                       &campo=doc-fisico.serie-docto
                       &campozoom=serie}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.serie-docto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF doc-fisico.serie-docto IN FRAME f-main /* S‚rie */
DO:

    apply "f5":U to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF
    

    {utp/ut-liter.i Tipo_Nota MRE L}
    assign c-tipo-nota:label in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Estabel_Origem * L}
    assign doc-fisico.estab-de-or:label in frame {&frame-name} = return-value.

    {utp/ut-field.i mgind doc-fisico nro-docto 1}
    assign i-nro-docto:label in frame {&frame-name} = trim(return-value).

    {utp/ut-field.i mgadm emitente cgc 1}
    assign c-cgc:label in frame {&frame-name} = trim(return-value).

    doc-fisico.cod-emitente:load-mouse-pointer("image/lupa.cur":U).
    doc-fisico.cod-estabel:load-mouse-pointer("image/lupa.cur":U).
    doc-fisico.estab-de-or:load-mouse-pointer("image/lupa.cur":U).
    doc-fisico.serie-docto:load-mouse-pointer("image/lupa.cur":U).
    c-cgc:load-mouse-pointer ("image~\rbm.cur":U) in frame {&frame-name}.

    find first param-global
        no-lock no-error.

    find first param-estoq
        no-lock no-error.

    ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

    /* Funcao Super/Minas */
    &IF DEFINED(Bf_dis_usuario_estab) &THEN
        IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                             AND funcao.ativo     = YES) THEN DO:
           RUN cdp/cd8702.p (INPUT c-seg-usuario,
                             INPUT-OUTPUT c-cod-estabel-usuar).
        END.
    &ENDIF

    find param-re where
        param-re.usuario = c-seg-usuario
        no-lock no-error.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "doc-fisico"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "doc-fisico"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    do with frame {&FRAME-NAME}:
        if avail param-estoq then do:
            find estabelec where
                estabelec.cod-estabel = c-cod-estabel-usuar
                no-lock no-error.
            assign doc-fisico.dt-emissao:screen-value  = string(today)
                   doc-fisico.dt-trans:screen-value    = string(today)
                   doc-fisico.cod-estabel:screen-value = if avail estabelec then c-cod-estabel-usuar else "":U
                   fi-estabel:screen-value             = if avail estabelec then estabelec.nome else "":U.

            find first emitente WHERE
                emitente.cod-emitente = doc-fisico.cod-emitente no-lock no-error.
            assign fi-emitente:screen-value = if avail emitente then emitente.nome-abrev else "":U.

            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                ASSIGN cAuxTraducao001 = {ininc/i01in089.i 04 01}.
                run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                    INPUT "",
                                    INPUT "").
                ASSIGN c-tipo-nota:screen-value            = RETURN-VALUE.
            &else
                ASSIGN c-tipo-nota:screen-value            = {ininc/i01in089.i 04 01}.
            &endif
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

    /*****
    if l-re1001a-inclui = no then do:
        if avail doc-fisico and docum-est.pais-origem <> "RE1001":U then do:
            if l-mensagem = no then do:
                run utp/ut-msgs.p( input "show",
                                   input 15023,
                                   input "").
                assign l-mensagem = yes.
            end.
            RUN dispatch IN h_v05in089 ('local-disable-fields':U).
            run dispatch in h_v06in089 ('local-disable-fields':U).
            run dispatch in h_v07in089 ('local-disable-fields':U).
            run dispatch in h_v08in089 ('local-disable-fields':U).
            run pi-desabilita-ok in h_re1001a.
        end.
    end.
    *****/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
    
    {include/i-valid.i}

    def buffer bf-estabelec-dep        for estabelec.

    assign input frame {&frame-name} c-tipo-nota.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then
        return 'ADM-ERROR':U.

    if avail doc-fisico then do:

        assign doc-fisico.nro-docto = left-trim(string(dec(input frame {&frame-name} i-nro-docto),c-formato-nf)).

        &if defined (bf_mat_bloqueio_fornec) &then
            if l-grava-consist-nota then do:
                 run rep/re8885.p (rowid(doc-fisico),       
                                   0,                                  
                                   0,                                  
                                   27886,                              
                                   NO,                                 
                                   0,            
                                   2 ).
                 assign l-grava-consist-nota = no.
            end.
        &endif

        assign doc-fisico.usuario   = c-seg-usuario
               rw-doc-fisico        = rowid(doc-fisico).

        run rep/re2902.p ( input rowid(doc-fisico),
                           input yes,                /* TT-DOCTO         */
                           input yes,                /* TT-IT-DOCTO      */
                           input yes,                /* TT-SALDO-ESTOQ   */
                           input yes,                /* TT-CONSIST       */
                           input-output table tt-docto,
                           input-output table tt-it-docto,
                           input-output table tt-saldo-estoq,
                           input-output table tt-consist ).

        if doc-fisico.tipo-nota = 3 then do:

            RUN pi-totaliza-entrada-transfer(output dt-retorno-saldo-terc).

            if adm-new-record THEN
                RUN pi-gera-itens-entrada-transf.

        end.

        /* Conversor NFe */
        IF  CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U AND funcao.ativo NO-LOCK) THEN DO:

            RUN atualizaSituacao IN h-boin847 (INPUT doc-fisico.cod-chave-aces-nf-eletro,
                                               INPUT doc-fisico.cod-emitente,
                                               INPUT doc-fisico.cod-estabel,
                                               INPUT doc-fisico.serie-docto,
                                               INPUT doc-fisico.nro-docto,
                                               INPUT "",
                                               INPUT doc-fisico.dt-emissao,
                                               INPUT 6). /* Situa‡Æo 6: Digitada Receb. F¡sico */
        END.
        /* Fim Conversor NFe */

        IF doc-fisico.tipo-nota = 12  THEN DO: /*Remessa deposito fechado*/

             FOR first estabelec 
                 where estabelec.cod-estabel  = input frame {&FRAME-NAME} doc-fisico.cod-estabel NO-LOCK: 
             END.

             for first bf-estabelec-dep
                  where bf-estabelec-dep.cod-emitente = input frame {&FRAME-NAME} doc-fisico.cod-emitente NO-LOCK:   /*Procura pelo estabelecimento do emitente da nota Fabrica*/
             end.
     
             IF NOT CAN-FIND (FIRST saldo-terc  
                                WHERE saldo-terc.serie-docto   = input frame {&FRAME-NAME} doc-fisico.serie-docto               
                                  AND saldo-terc.nro-docto     = input frame {&FRAME-NAME} i-nro-docto 
                                  AND saldo-terc.cod-emitente  = estabelec.cod-emitente
                                  AND saldo-terc.cod-estabel   = bf-estabelec-dep.cod-estabel
                                  AND saldo-terc.tipo-sal-terc = 7 )THEN DO: /*Sa¡da deposito fechado*/
     
               RUN utp/ut-msgs.p(INPUT "show":U,
                                 INPUT 56824, /*Nota Fiscal de Remessa de Dep¢sito Fechado deve possuir o mesmo n£mero de documento, emitente e s‚rie da opera‡Æo de remessa sa¡da*/
                                 INPUT "").  
               run rep/re8885.p (rowid(doc-fisico),       
                                 0,                                  
                                 0,                                  
                                 56824,                              
                                 NO,                                 
                                 0,            
                                 2 ).
           END.
        END.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

    assign input frame {&frame-name} c-tipo-nota.

    if avail doc-fisico then
        assign doc-fisico.nro-docto = left-trim(string(dec(input frame {&frame-name} i-nro-docto),c-formato-nf))
               doc-fisico.tipo-nota = {ininc/i01in089.i 06 c-tipo-nota}. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose: Elimina‡Æo de handles    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U AND funcao.ativo NO-LOCK) THEN DO:
        IF  VALID-HANDLE(h-boin847)        AND
            h-boin847:TYPE = "PROCEDURE":U AND
            h-boin847:FILE-NAME = "inbo/boin847.p":U THEN DO:
            DELETE PROCEDURE h-boin847.
            ASSIGN h-boin847 = ?.
        END.
    END.

    IF  VALID-HANDLE(h-boin089)  THEN DO:
        DELETE PROCEDURE h-boin089.
        ASSIGN h-boin089 = ?.
    END.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
    assign i-nro-docto:width in frame {&frame-name}  = 16
           i-nro-docto:format in frame {&frame-name} = c-formato-nf. 

    if avail doc-fisico then do:

        if not adm-new-record then
            assign i-nro-docto:screen-value in frame {&FRAME-NAME} = doc-fisico.nro-docto.
        

        find emitente where
            emitente.cod-emitente = doc-fisico.cod-emitente
            no-lock no-error.
        if avail emitente and emitente.cod-emitente <> 0 then do:
            assign c-cgc:screen-value in frame {&FRAME-NAME} = emitente.cgc.
            case emitente.natureza:
                when 1 then do:
                    if avail param-global and
                        param-global.formato-id-pessoal <> "":U then
                        assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-pessoal.
                end.
                when 2 then do:
                    if avail param-global and
                        param-global.formato-id-federal <> "":U then
                        assign c-cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal.
                end.
                otherwise
                    assign c-cgc:format in frame {&FRAME-NAME} = "x(19)":U.
            end.
        end.
        else
    	    assign c-cgc:format in frame {&FRAME-NAME} = "x(19)":U.

        find estabelec where
            estabelec.cod-estabel = doc-fisico.cod-estabel
            no-lock no-error.

        if avail estabelec then
            assign fi-estabel = estabelec.nome.
        else
            doc-fisico.cod-estabel:SCREEN-VALUE in frame {&FRAME-NAME} = "":U.    
        find estabelec where
            estabelec.cod-estabel = doc-fisico.estab-de-or
            no-lock no-error.
        assign fi-estabel-origem = if avail estabelec then estabelec.nome else "":U.

    end.
        FIND FIRST emitente where
             emitente.cod-emitente = doc-fisico.cod-emitente no-lock no-error.
                                                                                     
        if avail emitente then
             assign fi-emitente = emitente.nome-abrev.

    if available doc-fisico then do with frame {&frame-name}:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao002 = {ininc/i01in089.i 04 doc-fisico.tipo-nota}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  c-tipo-nota:screen-value = RETURN-VALUE.
        &else
            ASSIGN c-tipo-nota:screen-value = {ininc/i01in089.i 04 doc-fisico.tipo-nota}.
        &endif
    end.
    else do with frame {&frame-name}:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao003 = {ininc/i01in089.i 04 01}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  c-tipo-nota:screen-value = RETURN-VALUE.
        &else
            ASSIGN c-tipo-nota:screen-value = {ininc/i01in089.i 04 01}.
        &endif
    end.



    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    run pi-inicializa-campos in this-procedure.

    disable doc-fisico.estab-de-or with frame {&frame-name}.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U AND funcao.ativo NO-LOCK) THEN DO:
        RUN inbo/boin847.p PERSISTENT SET h-boin847.
    END.

    do with frame {&frame-name}:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao004 = {ininc/i01in089.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao004).
            ASSIGN  c-tipo-nota:LIST-ITEM-PAIRS = cAuxTraducao004.
        &else
            ASSIGN c-tipo-nota:list-items = {ininc/i01in089.i 03}.
        &endif
    end.

    &if '{&bf_libera_15_posicoes}' = 'yes' &then
        assign c-formato-nf = ">>>>>>>>9999999". /* Formato de 15 posi‡äes */
    &else
        assign c-formato-nf = ">>>9999999". /* Formato de 10 posi‡äes */
    &endif
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    define input parameter v-row-parent-externo as rowid no-undo.

    assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita V-table-Win 
PROCEDURE pi-desabilita :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    disable all with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-itens-entrada-transf V-table-Win 
PROCEDURE pi-gera-itens-entrada-transf :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def var i-sequencia    like it-doc-fisico.sequencia.
    def var l-calcula-subs as logical no-undo.

    find first saldo-terc 
         where rowid(saldo-terc) = rw-saldo-terc no-lock no-error.

    if avail param-re then
        assign i-sequencia = param-re.seq-item-um.

    find first tt-docto no-error.

    /**  Geracao dos Itens da Nota
    **/

    /*****8900*****/
    for each componente  use-index documento 
       where componente.serie-docto  = saldo-terc.serie-docto  
         and componente.nro-docto    = saldo-terc.nro-docto    
         and componente.cod-emitente = saldo-terc.cod-emitente 
        /*and componente.nat-operacao = saldo-terc.nat-operacao */
         no-lock
        by componente.sequencia:

        if index(c-nat-oper, componente.nat-operacao) = 0 then next.

        find item where
            item.it-codigo = componente.it-codigo
            no-lock no-error.

        find last b-tt-it-docto use-index seq
            no-lock no-error.

        if avail doc-fisico then do:
            create tt-it-docto.
            assign tt-it-docto.cod-emitente = doc-fisico.cod-emitente
                   tt-it-docto.nr-nota      = doc-fisico.nro-docto
                   tt-it-docto.serie        = doc-fisico.serie-docto
                   tt-it-docto.cod-estabel  = doc-fisico.cod-estabel
                   tt-it-docto.vl-despes-it = componente.despesas[1]
                   tt-it-docto.nr-sequencia = i-sequencia
                   tt-it-docto.calcula      = yes
                   tt-it-docto.alterado     = yes
                   tt-it-docto.quantidade   = componente.quantidade
                   i-sequencia              = i-sequencia + param-re.inc-seq
                   tt-it-docto.seq-tt-it-docto = if available b-tt-it-docto then
                                                 b-tt-it-docto.seq-tt-it-docto + 1
                                                 else 1.
        end.
        /**  Atualiza Itens da Nota de Acordo com Nota de Saida
        **/
        run cdp/cd4326.p ( tt-docto.seq-tt-docto,
                           tt-it-docto.seq-tt-it-docto,
                           rowid(componente),
                           0,
                           input        table tt-docto,
                           input-output table tt-it-docto,
                           input-output table tt-it-imposto,
                           input-output table tt-saldo-estoq ).

    end.

    run pi-gera-itens-da-nota.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campos V-table-Win 
PROCEDURE pi-inicializa-campos :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    assign input frame {&frame-name} c-tipo-nota.
    assign i-tipo-nota = {ininc/i01in089.i 06 c-tipo-nota}.

    do with frame {&FRAME-NAME}:
        if l-re1001a-inclui = no then do:
            if avail doc-fisico then do:
                assign doc-fisico.dt-emissao:sensitive = doc-fisico.tipo-nota <> 3.
            end.
        end.
        assign doc-fisico.cod-estabel:sensitive = (l-re1001a-inclui and param-estoq.estab-uni = no).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-inclusao V-table-Win 
PROCEDURE pi-retorna-inclusao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def output parameter l-incluir as logical no-undo.
    assign l-incluir = adm-new-record.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-temp-table V-table-Win 
PROCEDURE pi-retorna-temp-table :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def output param p-rw-doc-fisico as rowid.
    def output param table for tt-docto.
    def output param table for tt-it-docto.
    def output param table for tt-it-imposto.
    def output param table for tt-saldo-estoq.
    def output param table for tt-consist.

    assign p-rw-doc-fisico = rw-doc-fisico.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-totaliza-entrada-transfer V-table-Win 
PROCEDURE pi-totaliza-entrada-transfer :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    def output parameter dt-retorno    as date no-undo.

    def var de-despesa-nota like doc-fisico.despesa-nota no-undo.
    def var de-tot-peso     like doc-fisico.tot-peso     no-undo.
    def var de-valor-frete  like doc-fisico.valor-frete  no-undo.
    def var de-valor-mercad like doc-fisico.valor-mercad no-undo.
    def var c-nat-oper-saldo as char no-undo.

    assign rw-saldo-terc = ? 
           c-nat-oper    = "".

    for each saldo-terc
       where saldo-terc.serie-docto   = input frame {&frame-name} doc-fisico.serie-docto
         and saldo-terc.nro-docto     = left-trim(string(dec(input i-nro-docto),c-formato-nf))
         and saldo-terc.cod-emitente  = input doc-fisico.cod-emitente
         and saldo-terc.cod-estabel   = input doc-fisico.estab-de-or
         and saldo-terc.quantidade    > 0
         and saldo-terc.tipo-sal-terc = 3 no-lock:

        if rw-saldo-terc = ? then
            assign rw-saldo-terc    = rowid(saldo-terc)
                   c-nat-oper-saldo =  saldo-terc.nat-operacao.
        
        IF INDEX(c-nat-oper, saldo-terc.nat-operacao) = 0 THEN
            ASSIGN c-nat-oper = c-nat-oper + saldo-terc.nat-operacao.
                     

        /*****8900*****/
        for each componente use-index documento 
           where componente.serie-docto  = saldo-terc.serie-docto  
             and componente.nro-docto    = saldo-terc.nro-docto    
             and componente.cod-emitente = saldo-terc.cod-emitente  
             and componente.nat-operacao = saldo-terc.nat-operacao
             and componente.it-codigo    = saldo-terc.it-codigo 
             and componente.sequencia    = saldo-terc.sequencia no-lock:

            assign de-despesa-nota = de-despesa-nota + componente.despesas[1]
                   de-tot-peso     = de-tot-peso     + componente.peso-liquido
                   de-valor-frete  = de-valor-frete  + componente.despesas[1].

            FOR FIRST nota-fiscal
                WHERE nota-fiscal.cod-estabel   = saldo-terc.cod-estabel
                  AND nota-fiscal.serie         = componente.serie-docto
                  AND nota-fiscal.nr-nota-fis   = componente.nro-docto
                  AND nota-fiscal.cod-emitente  = saldo-terc.emite-comp NO-LOCK:


                FIND FIRST it-nota-fisc NO-LOCK
                     WHERE it-nota-fisc.cod-estabel = saldo-terc.cod-estabel
                       AND it-nota-fisc.serie       = componente.serie-docto
                       AND it-nota-fisc.nr-nota-fis = componente.nro-docto 
                       AND it-nota-fisc.nr-seq-fat  = componente.sequencia
                       AND it-nota-fisc.it-codigo   = componente.it-codigo NO-ERROR.

                IF AVAIL it-nota-fisc AND it-nota-fisc.per-des-icms > 0 THEN   /*desconto ICMS desonerado*/ 
                    ASSIGN de-valor-mercad = de-valor-mercad + it-nota-fisc.vl-merc-ori.
                ELSE 
                    ASSIGN de-valor-mercad = de-valor-mercad + componente.preco-total[1].
            END.
        end.
    end.

    if c-nat-oper-saldo <> "" and
       can-find(first saldo-terc
                where saldo-terc.serie-docto   = input doc-fisico.serie-docto
                  and saldo-terc.nro-docto     = left-trim(string(dec(input i-nro-docto),c-formato-nf))
                  and saldo-terc.cod-emitente  = input doc-fisico.cod-emitente
                  and saldo-terc.nat-operacao  = c-nat-oper-saldo
                  and saldo-terc.cod-estabel   = input doc-fisico.estab-de-or
                  and saldo-terc.quantidade    > 0
                  and saldo-terc.tipo-sal-terc = 3) then do:
        
        for first saldo-terc fields(dt-retorno)
            where rowid(saldo-terc) = rw-saldo-terc no-lock:
            assign dt-retorno = saldo-terc.dt-retorno.
        end.
    end.

    run pi-recria-tt-inicializa.
    assign tt-inicializa.despesa-nota = de-despesa-nota
           tt-inicializa.tot-peso     = de-tot-peso
           tt-inicializa.valor-frete  = de-valor-frete
           tt-inicializa.valor-mercad = de-valor-mercad.

    RUN pi-inicializa-campos IN h_v06in089
        (INPUT table tt-inicializa).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro
  ainda nÆo foi criado.
------------------------------------------------------------------------------*/
     
{include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

    DEF VAR l-erro          AS LOG     NO-UNDO.
    DEF VAR c-label         AS CHAR    NO-UNDO.
    def var c-cod-estabel   as char    no-undo.
    def var c-cod-emitente  as char    no-undo.
   
    EMPTY TEMP-TABLE RowErrors.
   
    &if defined (bf_mat_bloqueio_fornec) &then
        def var i-situacao     as int  no-undo.  
        def var dt-vig-ini     as date no-undo.  
        def var dt-vig-fim     as date no-undo.  
    &endif
    
    if not can-find (first emitente 
                     where emitente.cod-emitente = input frame {&FRAME-NAME} doc-fisico.cod-emitente ) then do:
        {include/i-vldprg.i}
        {utp/ut-table.i mgadm emitente 1}
        run utp/ut-msgs.p (input "show":U, input 2, input return-value).
        apply "entry":U to doc-fisico.cod-emitente in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    
    if not can-find(first estabelec 
                    where estabelec.cod-estabel = input frame {&frame-name} doc-fisico.cod-estabel) then do:
        {include/i-vldprg.i}
        {utp/ut-table.i mgadm estabelec 1}
        run utp/ut-msgs.p (input "show":U, input 2, input return-value).
        apply "entry":U to doc-fisico.cod-estabel in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
   
    if not can-find(first serie 
                    where serie.serie = TRIM(input frame {&frame-name} doc-fisico.serie-docto)) then do:
        {include/i-vldprg.i}
        {utp/ut-table.i mgind serie 1}
        run utp/ut-msgs.p (input "show":U, input 2, input return-value).
        apply "entry":U to doc-fisico.serie-docto in frame {&frame-name}.
        return 'ADM-ERROR':U.
     END.
    
    if input frame {&frame-name} doc-fisico.cod-emitente = 0 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, input 6189, input "":U).
        apply "entry":U to doc-fisico.cod-emitente in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    
    if  input frame {&frame-name} i-nro-docto = "0000000":U 
    or  input frame {&frame-name} i-nro-docto = "":U then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, input 16686, input "":U).
        apply "entry":U to i-nro-docto in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    IF CAN-FIND(first docum-est
                where docum-est.nro-docto    = input frame {&FRAME-NAME} i-nro-docto     
                  and docum-est.serie-docto  = input frame {&FRAME-NAME} doc-fisico.serie-docto   
                  and docum-est.cod-emitente = input frame {&FRAME-NAME} doc-fisico.cod-emitente  
                  AND docum-est.dt-emissao   = input frame {&FRAME-NAME} doc-fisico.dt-emissao) THEN DO:

        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, input 54992, input "":U).
        apply "entry":U to i-nro-docto in frame {&frame-name}.
        return 'ADM-ERROR':U.
        
    END.

    if length(input frame {&frame-name} i-nro-docto) > length(c-formato-nf) then do:
       {include/i-vldprg.i} 
       run utp/ut-msgs.p (input "show":U, 
                          input 36151, 
                          input length(c-formato-nf)).

       apply "entry":U to i-nro-docto in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end. 
    
    assign de-nota = dec(input frame {&frame-name} i-nro-docto) no-error.
    if (ERROR-STATUS:ERROR 
        or (error-status:get-number(1) = 76
        and error-status:num-messages  <> 0))then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 972,
                           input "").
        apply "entry":U to i-nro-docto in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.
    
    assign input frame {&frame-name} c-tipo-nota.
    assign i-tipo-nota = {ininc/i01in089.i 06 c-tipo-nota}.

    ASSIGN c-cod-estabel = INPUT FRAME {&FRAME-NAME} doc-fisico.cod-estabel.
    IF  {cdp/cd0066.i2 c-cod-estabel} AND i-tipo-nota = 7 THEN DO:
       RUN utp/ut-msgs.p (INPUT "show":U, INPUT 35097, INPUT "":U).
       APPLY "entry":U TO c-tipo-nota IN FRAME {&FRAME-NAME}.
       RETURN 'ADM-ERROR':U.
    END.

    &if defined (bf_mat_bloqueio_fornec) &then
    
        /**Valida a situacao fornecedor qndo nao for (remessa benef ou retorno benef ou dev.consig)**/
        if (i-tipo-nota <> 2 AND    /* Devolu‡Æo */
            i-tipo-nota <> 4 and    /* Entrada Benef */
            i-tipo-nota <> 5 and    /* Retorno Benef */
            i-tipo-nota <> 8)       /* Devolu‡Æo Consig */
        then do:
            run cdp/cdapi029.p (input c-seg-usuario,
                                input 2,
                                input input frame {&frame-name} doc-fisico.dt-trans ,
                                input input frame {&frame-name} doc-fisico.cod-emitente,
                                output i-situacao,  
                                output dt-vig-ini,  
                                output dt-vig-fim,  
                                output table tt-erro).
            if return-value = "nok":U then do:
                if can-find (first tt-erro) then do:
                    run cdp/cd0669.w (table tt-erro).
                    return 'ADM-ERROR':U.
                end.
            end.
            else if i-situacao = 3 then do:
                {include/i-vldprg.i} 
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "para_Recebimento" *}
                run utp/ut-msgs.p (input "show":U, input 27886, input RETURN-VALUE).
                assign l-grava-consist-nota = yes.
            end.
        end.
    &endif

    if doc-fisico.cod-emitente:sensitive in frame {&frame-name} then do:
        find first b-doc 
             where b-doc.cod-emitente = input frame {&FRAME-NAME} doc-fisico.cod-emitente 
               and b-doc.tipo-nota    = i-tipo-nota                                       
               and b-doc.serie-docto  = input frame {&FRAME-NAME} doc-fisico.serie-docto  
               and b-doc.nro-docto    = left-trim(string(dec(input frame {&FRAME-NAME} i-nro-docto),c-formato-nf)) no-lock no-error.
        if avail b-doc then do:
            {include/i-vldprg.i}
            {utp/ut-table.i mgind doc-fisico 1}
            run utp/ut-msgs.p (input "show":U, input 7, input return-value).
            apply "entry":U to doc-fisico.cod-emitente in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.         
    end.

    if i-tipo-nota = 3 then do with frame {&FRAME-NAME}: /*entrada de transferencia*/
    
        if  input doc-fisico.estab-de-or = input doc-fisico.cod-estabel then do:
            /**  Estabelecimento Origem deve ser o Estabelecimento Emitente. **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, input 7298, input "":U).
            apply "entry":U to doc-fisico.estab-de-or in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        
        if not can-find(first estabelec 
                        where estabelec.cod-estabel = input doc-fisico.estab-de-or) then do:
            /**  Estabelecimento de origem nao cadastrado **/
            {include/i-vldprg.i}
            {utp/ut-field.i mgind doc-fisico estab-de-or 01}
            run utp/ut-msgs.p (input "show",input 47,input return-value).
            apply 'entry':U to doc-fisico.estab-de-or in frame {&frame-name} .
            return 'adm-error':U.
        end.

        &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
            /** Emitente Origem x Estabelecimento Origem **/
            if not can-find(first estabelec 
                            where estabelec.cod-estabel  = input frame {&FRAME-NAME} doc-fisico.estab-de-or 
                            and   estabelec.cod-emitente = input frame {&FRAME-NAME} doc-fisico.cod-emitente) then do:
                assign c-cod-estabel  = doc-fisico.estab-de-or:screen-value in frame {&FRAME-NAME}
                       c-cod-emitente = doc-fisico.cod-emitente:screen-value in frame {&FRAME-NAME}.
                
                {include/i-vldprg.i}
                {utp/ut-liter.i origem *}
                run utp/ut-msgs.p (input "show",
                                   input 34320,
                                   input RETURN-VALUE + "~~" + c-cod-estabel + "~~" + c-cod-emitente).
                apply 'entry':U to doc-fisico.estab-de-or in frame {&frame-name} .
                return 'adm-error':U.
            end.
            else do:
                /** Emitente Destino x Estabelecimento Destino **/
                for first bf-estabelec fields (cod-emitente cod-estabel)
                    where bf-estabelec.cod-estabel = input frame {&FRAME-NAME} doc-fisico.cod-estabel no-lock:
                    for first saldo-terc fields (emite-comp)
                        where saldo-terc.serie-docto   = input doc-fisico.serie-docto 
                          and saldo-terc.nro-docto     = left-trim(string(dec(input i-nro-docto),c-formato-nf)) 
                          and saldo-terc.cod-emitente  = input doc-fisico.cod-emitente 
                          and saldo-terc.cod-estabel   = input doc-fisico.estab-de-or
                          and saldo-terc.tipo-sal-terc = 3 NO-LOCK:
                        if saldo-terc.emite-comp <> bf-estabelec.cod-emitente then do:
                            {include/i-vldprg.i}
                            {utp/ut-liter.i destino *}
                            run utp/ut-msgs.p (input "show",
                                               input 34320,
                                               input RETURN-VALUE + "~~" + bf-estabelec.cod-estabel + "~~" + string(saldo-terc.emite-comp)).
                            apply 'entry':U to doc-fisico.cod-estabel in frame {&frame-name} .
                            return 'adm-error':U.
                        end.
                    end.
                end.
            end.
        &else
            /** Emitente Destino x Estabelecimento Destino **/
            if not can-find(first estabelec 
                            where estabelec.cod-estabel  = input frame {&FRAME-NAME} doc-fisico.cod-estabel 
                            and   estabelec.cod-emitente = input frame {&FRAME-NAME} doc-fisico.cod-emitente) then do:
                assign c-cod-estabel  = doc-fisico.cod-estabel:screen-value in frame {&FRAME-NAME}
                       c-cod-emitente = doc-fisico.cod-emitente:screen-value in frame {&FRAME-NAME}.

                {include/i-vldprg.i}
                {utp/ut-liter.i destino *}
                run utp/ut-msgs.p (input "show",
                                   input 34320,
                                   input RETURN-VALUE + "~~" + c-cod-estabel + "~~" + c-cod-emitente).
                apply 'entry':U to doc-fisico.cod-emitente in frame {&frame-name} .
                return 'adm-error':U.
            end.
        &ENDIF

        if not can-find(first saldo-terc
                        where saldo-terc.serie-docto   = input doc-fisico.serie-docto 
                          and saldo-terc.nro-docto     = left-trim(string(dec(input i-nro-docto),c-formato-nf)) 
                          and saldo-terc.cod-emitente  = input doc-fisico.cod-emitente 
                          and saldo-terc.cod-estabel   = input doc-fisico.estab-de-or 
                          and saldo-terc.quantidade    > 0 
                          and saldo-terc.tipo-sal-terc = 3) then do:
            /**  Nao Existe Documento de Saida. Usuario Devera Informar Documento Manualmente. **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, input 5128, input "":U).
            apply "entry":U to doc-fisico.estab-de-or in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        
    end.

    do with frame {&FRAME-NAME}:
    
        if doc-fisico.dt-emissao:sensitive and input doc-fisico.dt-emissao < (today - param-re.var-emis) then do:
            {include/i-vldprg.i}
            {utp/ut-field.i mgind doc-fisico dt-emissao 2}
            run utp/ut-msgs.p (input "show":U, input 8824, input return-value).
            apply "entry":U to doc-fisico.dt-emissao in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        if doc-fisico.dt-trans:sensitive and input doc-fisico.dt-trans > today then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, input 1788, input "":U).
            apply "entry":U to doc-fisico.dt-trans in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        if doc-fisico.dt-trans:sensitive and input doc-fisico.dt-trans  < input doc-fisico.dt-emissao then do:
            {include/i-vldprg.i}
            {utp/ut-field.i mgind doc-fisico dt-emissao 2}
            assign c-label = return-value.
            {utp/ut-field.i mgind doc-fisico dt-trans 2}
            run utp/ut-msgs.p (input "show":U, input 89, input return-value + "~~":U + c-label).
            apply "entry":U to doc-fisico.dt-trans in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.


        &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
            if  param-estoq.tp-fech = 2 then do:
                find estab-mat where 
                     estab-mat.cod-estabel = input frame {&frame-name} doc-fisico.cod-estabel no-lock no-error.
                if  avail estab-mat and 
                    INPUT doc-fisico.dt-trans <= estab-mat.mensal-ate then DO:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show":U, input 1586, input "":U).
                    apply "entry":U to doc-fisico.dt-trans in frame {&frame-name}.
                    return 'ADM-ERROR':U.
    
                END.
            end.
            else 
               if  param-estoq.log-1 and INPUT doc-fisico.dt-trans <= param-estoq.mensal-ate then DO:
                   {include/i-vldprg.i}
                   run utp/ut-msgs.p (input "show":U, input 1586, input "":U).
                   apply "entry":U to doc-fisico.dt-trans in frame {&frame-name}.
                   return 'ADM-ERROR':U.
               END.
        &else
           if  param-estoq.log-1 and INPUT doc-fisico.dt-trans <= param-estoq.mensal-ate then DO:
               {include/i-vldprg.i}
               run utp/ut-msgs.p (input "show":U, input 1586, input "":U).
               apply "entry":U to doc-fisico.dt-trans in frame {&frame-name}.
               return 'ADM-ERROR':U.
           END.
        &endif
        
        if doc-fisico.dt-trans:sensitive and input doc-fisico.dt-trans < (today - param-re.var-atual)  then do:
            {include/i-vldprg.i}
            {utp/ut-field.i mgind doc-fisico dt-transacao 2}
            run utp/ut-msgs.p (input "show":U, input 8824, input return-value).
            apply "entry":U to doc-fisico.dt-trans in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.    

    IF CAN-FIND(FIRST funcao 
                WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U 
                  AND funcao.ativo) THEN DO:
    
        FOR FIRST doc-orig-nfe FIELDS(ch-acesso-comp-nfe idi-situacao)
            WHERE doc-orig-nfe.cod-emitente  = INPUT FRAME {&FRAME-NAME} doc-fisico.cod-emitente
              AND doc-orig-nfe.cod-estabel   = INPUT FRAME {&FRAME-NAME} doc-fisico.cod-estabel
              AND doc-orig-nfe.serie-docto   = INPUT FRAME {&FRAME-NAME} doc-fisico.serie-docto
              AND doc-orig-nfe.nro-docto     = INPUT FRAME {&FRAME-NAME} i-nro-docto
              AND doc-orig-nfe.dt-emissao    = INPUT FRAME {&FRAME-NAME} doc-fisico.dt-emissao
              AND doc-orig-nfe.idi-orig-trad = 2 NO-LOCK:
            IF CAN-DO("2,4", STRING(doc-orig-nfe.idi-situacao)) THEN DO:
                IF CAN-FIND(FIRST item-doc-orig-nfe
                            WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe
                              AND item-doc-orig-nfe.idi-orig-trad      = 2
                              AND item-doc-orig-nfe.numero-ordem       > 0)
                OR CAN-FIND(FIRST rat-ordem-orig-nfe
                            WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe) THEN DO:
                    RUN utp/ut-msgs.p(INPUT "show":U, 
                                      INPUT 55110, 
                                      INPUT "").
                    RETURN 'ADM-ERROR':U.
                END.
    
                IF CAN-FIND(FIRST item-ref-nfe
                            WHERE item-ref-nfe.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe) THEN DO:
                    RUN utp/ut-msgs.p(INPUT "show":U,
                                      INPUT 55111,
                                      INPUT "").
                    RETURN 'ADM-ERROR':U.
                END.
            END.
        END.
        IF NOT VALID-HANDLE(h-boin089) THEN
           RUN inbo/boin089.p PERSISTENT SET h-boin089.
        
        RUN emptyRowErrors       IN h-boin089.
        RUN openQueryStatic      IN h-boin089 (INPUT "Main":U).
        RUN gotokey IN h-boin089 (INPUT INPUT FRAME {&FRAME-NAME} doc-fisico.serie-docto,
                                  INPUT INPUT FRAME {&FRAME-NAME} i-nro-docto,
                                  INPUT INPUT FRAME {&FRAME-NAME} doc-fisico.cod-emitente,
                                  INPUT i-tipo-nota).

        RUN bloqueiaNfeComDiverg IN h-boin089 (INPUT INPUT FRAME {&FRAME-NAME} doc-fisico.cod-emitente, 
                                               INPUT INPUT FRAME {&FRAME-NAME} doc-fisico.cod-estabel,   
                                               INPUT INPUT FRAME {&FRAME-NAME} doc-fisico.serie-docto,   
                                               INPUT INPUT FRAME {&FRAME-NAME} i-nro-docto,              
                                               INPUT INPUT FRAME {&FRAME-NAME} doc-fisico.dt-emissao).    
                                               
        RUN bloqueiaDigitXML IN h-boin089 (INPUT INPUT FRAME {&FRAME-NAME} doc-fisico.cod-emitente,
                                           INPUT INPUT FRAME {&FRAME-NAME} doc-fisico.cod-estabel,
                                           INPUT INPUT FRAME {&FRAME-NAME} doc-fisico.serie-docto,
                                           INPUT i-nro-docto:SCREEN-VALUE IN frame {&frame-name},                                            
                                           INPUT INPUT FRAME {&FRAME-NAME} doc-fisico.dt-emissao).
                                           
        RUN getRowErrors         IN h-boin089 (OUTPUT TABLE RowErrors APPEND).
        IF CAN-FIND(FIRST RowErrors 
                    WHERE RowErrors.ErrorType   <> "INTERNAL":U
                      AND RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            FOR EACH RowErrors:                
                RUN utp/ut-msgs.p(INPUT "show":U, 
                                  INPUT RowErrors.ErrorNumber, 
                                  INPUT "").
                RETURN 'ADM-ERROR':U.
            END.
        END.
    END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "doc-fisico"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
