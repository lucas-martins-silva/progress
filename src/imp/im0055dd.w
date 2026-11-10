&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-desp-embarque NO-UNDO LIKE desp-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-despes-embarq-internac NO-UNDO LIKE despes-embarq-internac
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0055DD 2.00.00.029 } /*** "010029" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0055dd MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0055DD
&GLOBAL-DEFINE Version        2.00.00.029
&GLOBAL-DEFINE DBOVersion     1.1

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE InitialPage    0

&GLOBAL-DEFINE page0Widgets   tt-desp-embarque.cod-pto-contr ~
                              tt-desp-embarque.cod-emitente-desp ~
                              tt-desp-embarque.cod-desp ~
                              tt-desp-embarque.cod-cond-pag ~
                              tt-desp-embarque.mo-codigo ~
                              tt-desp-embarque.val-desp ~
                              c-incoterm-rateio ~
                              btOK btCancel btHelp
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets  

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Shared Variable Definitions ---                                      */
def shared var c-acao     as char  no-undo.
def shared var r-row      as rowid no-undo.
def shared var r-row-hist as rowid no-undo.

{cdp/cdcfgmat.i}

/* Local Variable Definitions ---                                       */
def var h-bocx310     as handle no-undo.
def var h-bocx110     as handle no-undo.
def var h-bocx115     as handle no-undo.
def var h-bocx095     as handle no-undo.
def var h-boun005     as handle no-undo.
def var h-bocx230     as handle no-undo.
def var h-boad107     as handle no-undo.
def var h-boad098     as handle no-undo.
def var h-boad039     as handle no-undo.
DEF VAR h-bocx220     AS HANDLE NO-UNDO.
DEF VAR h-bocx250     AS HANDLE NO-UNDO.
DEF VAR h-cdapi050    AS HANDLE NO-UNDO.
DEF VAR h-bocx00465   AS HANDLE NO-UNDO.
DEF VAR h-boin172desc AS HANDLE NO-UNDO.

def var d-val-desp-ant     like desp-embarque.val-desp  NO-UNDO.
def var c-return             as character               no-undo.
def var l-incoterm-rat       as logical                 no-undo.
DEF VAR r-rowid-embarque     AS ROWID                   NO-UNDO.
DEF VAR i-seq-erro           AS INTEGER                 NO-UNDO.
DEF VAR l-forma-preco-compra AS LOGICAL                 NO-UNDO.
DEF VAR l-tax-siscomex       AS LOG                     NO-UNDO.
DEF VAR c-erro               AS CHAR                    NO-UNDO.
DEF VAR c-tax-siscomex       AS CHAR                    NO-UNDO.
DEF VAR i-desp-siscomex      AS INT                     NO-UNDO.
DEFINE VARIABLE c-desc       AS CHARACTER               NO-UNDO.
DEF VAR c-liter-despesa      AS CHAR                    NO-UNDO.

&if "{&bf_mat_versao_ems}" >= "2.05" &then
    DEF VAR i-cod-emitente AS INT NO-UNDO.
&else
    DEF VAR c-char-1       AS CHAR NO-UNDO.
&endif

DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
    FIELD r-rowid AS ROWID.

/* pesquisa */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-desp-embarque.cod-estabel ~
tt-desp-embarque.embarque tt-desp-embarque.cod-itiner ~
tt-desp-embarque.cod-pto-contr tt-desp-embarque.cod-desp ~
tt-desp-embarque.cod-emitente-desp tt-desp-embarque.cod-cond-pag ~
tt-desp-embarque.mo-codigo tt-desp-embarque.val-desp 
&Scoped-define ENABLED-TABLES tt-desp-embarque
&Scoped-define FIRST-ENABLED-TABLE tt-desp-embarque
&Scoped-Define ENABLED-OBJECTS rtToolBar c-nome-est c-desc-iti c-desc-pto ~
c-desc-desp c-nome-abrev c-desc-cond c-desc-mo c-incoterm-rateio ~
tg-forma-preco-compra btOK btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-desp-embarque.cod-estabel ~
tt-despes-embarq-internac.val-preco-unit ~
tt-despes-embarq-internac.val-preco-unit-com-iva tt-desp-embarque.embarque ~
tt-despes-embarq-internac.val-preco-unit-isento tt-desp-embarque.cod-itiner ~
tt-despes-embarq-internac.cdn-imposto tt-desp-embarque.cod-pto-contr ~
tt-desp-embarque.cod-desp tt-desp-embarque.cod-emitente-desp ~
tt-desp-embarque.cod-cond-pag tt-desp-embarque.mo-codigo ~
tt-desp-embarque.val-desp 
&Scoped-define DISPLAYED-TABLES tt-desp-embarque tt-despes-embarq-internac
&Scoped-define FIRST-DISPLAYED-TABLE tt-desp-embarque
&Scoped-define SECOND-DISPLAYED-TABLE tt-despes-embarq-internac
&Scoped-Define DISPLAYED-OBJECTS c-nome-est c-desc-iti c-desc-pto ~
c-desc-impto c-desc-desp c-nome-abrev c-desc-cond c-desc-mo ~
c-incoterm-rateio td-desp-rec tg-forma-preco-compra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-desc-cond AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 22.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-impto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY .79 NO-UNDO.

DEFINE VARIABLE c-desc-iti AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-mo AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 14.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-incoterm-rateio AS CHARACTER FORMAT "X(3)":U 
     LABEL "Incoterm de Rateio" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 21.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-est AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 27.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE td-desp-rec AS LOGICAL INITIAL no 
     LABEL "Despesa Recebida?" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-forma-preco-compra AS LOGICAL INITIAL no 
     LABEL "Forma Preáo Compra" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-desp-embarque.cod-estabel AT ROW 1.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-nome-est AT ROW 1.5 COL 35.29 COLON-ALIGNED NO-LABEL
     tt-desp-embarque.embarque AT ROW 2.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-desp-embarque.cod-itiner AT ROW 3.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .88
     c-desc-iti AT ROW 3.5 COL 36.72 COLON-ALIGNED NO-LABEL
     tt-desp-embarque.cod-pto-contr AT ROW 4.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .88
     c-desc-pto AT ROW 4.5 COL 36.72 COLON-ALIGNED NO-LABEL
     c-desc-impto AT ROW 4.5 COL 66 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     tt-desp-embarque.cod-desp AT ROW 5.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .88
     c-desc-desp AT ROW 5.5 COL 36.72 COLON-ALIGNED NO-LABEL
     tt-desp-embarque.cod-emitente-desp AT ROW 6.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-nome-abrev AT ROW 6.5 COL 41.29 COLON-ALIGNED NO-LABEL
     tt-desp-embarque.cod-cond-pag AT ROW 7.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .88
     c-desc-cond AT ROW 7.5 COL 34.57 COLON-ALIGNED NO-LABEL
     tt-desp-embarque.mo-codigo AT ROW 8.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.86 BY .88
     c-desc-mo AT ROW 8.5 COL 34.14 COLON-ALIGNED NO-LABEL
     tt-despes-embarq-internac.val-preco-unit-isento AT ROW 3 COL 74 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 13 BY .79
     tt-despes-embarq-internac.val-preco-unit-com-iva AT ROW 2.25 COL 74 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 13 BY .79
     tt-despes-embarq-internac.val-preco-unit AT ROW 1.5 COL 74 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 13 BY .79
     tt-despes-embarq-internac.cdn-imposto AT ROW 3.75 COL 74 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 4 BY .79
     tt-desp-embarque.val-desp AT ROW 9.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     c-incoterm-rateio AT ROW 10.5 COL 30 COLON-ALIGNED
     td-desp-rec AT ROW 11.5 COL 32
     tg-forma-preco-compra AT ROW 12.29 COL 32 HELP
          "Define se despesa faz parte do preáo de compra."
     btOK AT ROW 13.63 COL 2
     btCancel AT ROW 13.63 COL 13
     btHelp AT ROW 13.63 COL 80
     rtToolBar AT ROW 13.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 14.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-desp-embarque T "?" NO-UNDO mgcex desp-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-despes-embarq-internac T "?" NO-UNDO mgcad despes-embarq-internac
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 14.04
         WIDTH              = 90.43
         MAX-HEIGHT         = 18.5
         MAX-WIDTH          = 94.14
         VIRTUAL-HEIGHT     = 18.5
         VIRTUAL-WIDTH      = 94.14
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN c-desc-impto IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-impto:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN tt-despes-embarq-internac.cdn-imposto IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       tt-despes-embarq-internac.cdn-imposto:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR TOGGLE-BOX td-desp-rec IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-despes-embarq-internac.val-preco-unit IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       tt-despes-embarq-internac.val-preco-unit:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN tt-despes-embarq-internac.val-preco-unit-com-iva IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       tt-despes-embarq-internac.val-preco-unit-com-iva:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN tt-despes-embarq-internac.val-preco-unit-isento IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       tt-despes-embarq-internac.val-preco-unit-isento:HIDDEN IN FRAME fpage0           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
   def var l-desp-rec as log no-undo.

   for each RowErrors:
       delete RowErrors.
   end.

   assign frame fPage0
          tt-desp-embarque.cod-estabel
          tt-desp-embarque.embarque
          tt-desp-embarque.cod-itiner
          tt-desp-embarque.cod-pto-contr
          tt-desp-embarque.cod-emitente-desp
          tt-desp-embarque.cod-desp
          tt-desp-embarque.cod-cond-pag
          tt-desp-embarque.mo-codigo
          tt-desp-embarque.val-desp
          tt-desp-embarque.descricao = c-desc-desp:SCREEN-VALUE IN FRAME fPage0
          c-incoterm-rateio.
   
   IF  c-acao = "ADD":U
       AND l-tax-siscomex
       AND i-desp-siscomex = tt-desp-embarque.cod-desp THEN DO:
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 33677,
                          INPUT "").
       RETURN NO-APPLY.
   END.
   
   IF  tt-desp-embarque.val-desp  < 0.01
   AND tt-desp-embarque.mo-codigo > 0 THEN DO:
       {utp/ut-liter.i Valor_Despesa *}
       ASSIGN c-liter-despesa = RETURN-VALUE + " = " + STRING(tt-desp-embarque.val-desp,"9.99999").
       {utp/ut-liter.i Se_o_valor_ficar_menor_que_0,01_n∆o_ser†_poss°vel_gerar_a_duplicata_da_despesa *}
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 56613,
                          INPUT c-liter-despesa + "~~" + RETURN-VALUE).
       IF RETURN-VALUE = "NO":U THEN DO:
           APPLY "ENTRY":U TO tt-desp-embarque.val-desp IN FRAME fpage0.
           RETURN NO-APPLY.
       END.
   END.

    &if defined(bf-mat-comex) &then
        assign overlay(tt-desp-embarque.char-1,1,3) = c-incoterm-rateio.
    &else
        &if '{&bf_mat_versao_ems}' < '2.062' &then
            assign overlay(tt-desp-embarque.char-1,1,3) = c-incoterm-rateio.
        &else
            assign tt-desp-embarque.cod-incoterm-rat = c-incoterm-rateio. 
        &endif
    &endif

    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
        IF tg-forma-preco-compra:CHECKED IN FRAME fPage0 THEN DO:
           &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
               ASSIGN tt-desp-embarque.log-forma-preco-compra = YES.
           &ELSE
               ASSIGN OVERLAY(tt-desp-embarque.char-1,4,1) = "1".  /* forma preco compra */
           &ENDIF
        END.
        ELSE DO:
           &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
              ASSIGN tt-desp-embarque.log-forma-preco-compra = NO.
           &ELSE
              ASSIGN OVERLAY(tt-desp-embarque.char-1,4,1) = "0". /* nao forma preco compra */
           &ENDIF
        END.

        IF tg-forma-preco-compra:CHECKED IN FRAME fPage0 THEN DO:
           ASSIGN i-seq-erro = i-seq-erro + 1.
           CREATE RowErrors.
           ASSIGN RowErrors.errorsubtype = "Question".
           RUN utp/ut-msgs.p (INPUT "show":U,
                              INPUT 31445,
                              INPUT "").

           IF RETURN-VALUE = "NO" THEN DO:
              SESSION:SET-WAIT-STATE("":U).
              RETURN NO-APPLY.
           END.
           ELSE DO:
               RUN rowidembarque IN h-bocx220 (INPUT tt-desp-embarque.cod-estabel,
                                               INPUT tt-desp-embarque.embarque,
                                               OUTPUT r-rowid-embarque).
               RUN findRowid  IN h-bocx220  (INPUT r-rowid-embarque).
               RUN getCurrent IN h-bocx220  (OUTPUT TABLE tt-embarque-imp).
               FIND FIRST tt-embarque-imp NO-ERROR.

               IF NOT CAN-FIND(FIRST desp-incoterm 
                               WHERE desp-incoterm.cod-incoterm = tt-embarque-imp.cod-incoterm 
                                 AND desp-incoterm.cod-desp     = tt-desp-embarque.cod-desp) THEN DO:
                    ASSIGN i-seq-erro = i-seq-erro + 1.
                    CREATE RowErrors.
                    ASSIGN RowErrors.errorsubtype = "Question".
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 31446,
                                       INPUT tt-embarque-imp.cod-incoterm).
                   IF RETURN-VALUE = "NO" THEN DO:
                       SESSION:SET-WAIT-STATE("":U).
                       RETURN NO-APPLY.
                   END.
               END.
           END.
        END.
    &ENDIF   

    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-imp-forma-preco-compr" 
                               AND funcao.ativo = YES) THEN DO:
       
        RUN VerificaFormaPrecoCompra IN h-bocx310 (INPUT TABLE tt-desp-embarque,
                                                   OUTPUT l-forma-preco-compra).
    END.

    if i-pais-impto-usuario = 9 /*Paraguay*/ then do:
        if tt-despes-embarq-internac.cdn-imposto:sensitive in frame fPage0 = yes 
            and c-desc-impto = '' then do:
            {utp/ut-liter.i C¢digo_imposto *}
            run utp/ut-msgs.p (input "show":U,        
                               input 7488,           
                               input return-value).
            apply "entry":U to tt-despes-embarq-internac.cdn-imposto in frame fpage0.
            return no-apply.
        end.
    end.

    if c-acao = "ADD":u then do:        
        &if '{&bf_mat_versao_ems}' <= '2.05' &then
            assign tt-desp-embarque.log-1 = no.
        &else
            assign tt-desp-embarque.log-despes-ja-recbda = no.
        &endif

        RUN validateCreate IN h-bocx310 (INPUT TABLE tt-desp-embarque,
                                         OUTPUT TABLE RowErrors,
                                         OUTPUT tt-desp-embarque.r-rowid).
    end.
    else if  c-acao = "UPDATE":u then do:
        &if '{&bf_mat_versao_ems}' <= '2.05' &then
            assign tt-desp-embarque.log-1 = input frame fpage0 td-desp-rec.
            if  tt-desp-embarque.log-1 then do:
        &else
            assign tt-desp-embarque.log-despes-ja-recbda = input frame fpage0 td-desp-rec.
            if tt-desp-embarque.log-despes-ja-recbda then do:
        &endif
                run validaValorDespesa IN h-bocx310 (input d-val-desp-ant,
                                                     input tt-desp-embarque.val-desp,
                                                     &if '{&bf_mat_versao_ems}' <= '2.05' &then
                                                          input-output tt-desp-embarque.log-1,
                                                     &else
                                                          input-output tt-desp-embarque.log-despes-ja-recbda,
                                                     &endif
                                                     output table RowErrors).
                if can-find(first RowErrors) then do:
                    find first RowErrors no-lock no-error.
                    run utp/ut-msgs.p (input "show":U,
                                       input RowErrors.ErrorNumber,
                                       input RowErrors.ErrorParameters).
                end.
            end.

        ASSIGN tt-desp-embarque.val-desp = input frame {&frame-name} tt-desp-embarque.val-desp.
        
        RUN validateUpdate IN h-bocx310 (INPUT  TABLE tt-desp-embarque,
                                         INPUT  tt-desp-embarque.r-rowid,
                                         OUTPUT TABLE RowErrors).

    end.
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN 
            RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
        ELSE
            DELETE PROCEDURE hShowMsg.
        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).
        LEAVE.
    END.
    ELSE DO:
        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                IF tt-desp-embarque.log-forma-preco-compra THEN DO:
            &ELSE
                IF SUBSTRING(tt-desp-embarque.char-1,4,1) = "1" THEN DO:
            &ENDIF
                   ASSIGN i-seq-erro = i-seq-erro + 1.
                   CREATE RowErrors.
                   ASSIGN RowErrors.errorsubtype = "Warning".
                   RUN utp/ut-msgs.p (INPUT "show":U,
                                      INPUT 31453,
                                      INPUT "").
                END.
                ELSE DO:
                    IF l-forma-preco-compra AND 
                       &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                            NOT tt-desp-embarque.log-forma-preco-compra THEN DO:
                       &ELSE
                            SUBSTRING(tt-desp-embarque.char-1,4,1) = "0" OR 
                            SUBSTRING(tt-desp-embarque.char-1,4,1) = "" THEN DO:
                       &ENDIF
                       ASSIGN i-seq-erro = i-seq-erro + 1.
                       CREATE RowErrors.
                       ASSIGN RowErrors.errorsubtype = "Warning".
                       RUN utp/ut-msgs.p (INPUT "show":U,
                                          INPUT 31453,
                                          INPUT "").
                    END.
                END.
        &ENDIF
        
        /*** Siscoserv ***/
        IF CAN-FIND (FIRST emitente NO-LOCK
                     WHERE emitente.cod-emitente = tt-desp-embarque.cod-emitente-desp
                     AND   UPPER(emitente.pais) <> "BRASIL":U) THEN DO:
            RUN pi-siscoserv-ativo IN h-cdapi050.
            IF RETURN-VALUE = "OK":U THEN
                FOR FIRST historico-embarque FIELDS(dt-previsao)
                     WHERE historico-embarque.cod-estabel   = tt-desp-embarque.cod-estabel
                     AND   historico-embarque.embarque      = tt-desp-embarque.embarque  
                     AND   historico-embarque.cod-itiner    = tt-desp-embarque.cod-itiner   
                     AND   historico-embarque.cod-pto-contr = tt-desp-embarque.cod-pto-contr NO-LOCK:
                 
                     RUN pi-grava-despes-import-sis IN h-cdapi050 (INPUT tt-desp-embarque.cod-estabel,
                                                                   INPUT tt-desp-embarque.embarque,
                                                                   INPUT tt-desp-embarque.cod-itiner,
                                                                   INPUT tt-desp-embarque.cod-pto-contr,
                                                                   INPUT tt-desp-embarque.cod-desp,
                                                                   INPUT tt-desp-embarque.cod-emitente-desp,
                                                                   INPUT historico-embarque.dt-previsao).
                END.
        END.

        if i-pais-impto-usuario = 9 /*Paraguay*/
        and tt-despes-embarq-internac.val-preco-unit-isento:sensitive in frame fPage0 then
            run pi-atualiza-campos in h-bocx00465 (INPUT tt-desp-embarque.cod-estabel,
                                                   INPUT tt-desp-embarque.embarque,
                                                   INPUT tt-desp-embarque.cod-itiner,
                                                   INPUT tt-desp-embarque.cod-pto-contr,
                                                   INPUT tt-desp-embarque.cod-desp,
                                                   INPUT tt-desp-embarque.cod-emitente-desp,
                                                   INPUT dec(tt-despes-embarq-internac.cdn-imposto:screen-value in frame fPage0),
                                                   INPUT dec(tt-despes-embarq-internac.val-preco-unit-isento:screen-value in frame fPage0),
                                                   INPUT dec(tt-despes-embarq-internac.val-preco-unit-com-iva:screen-value in frame fPage0),
                                                   INPUT dec(tt-despes-embarq-internac.val-preco-unit:screen-value in frame fPage0)).

        RUN getRowid IN h-bocx310 (OUTPUT tt-desp-embarque.r-rowid).
        RUN repositionRecord IN phcaller (INPUT prParent).
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-incoterm-rateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-incoterm-rateio wWindow
ON F5 OF c-incoterm-rateio IN FRAME fpage0 /* Incoterm de Rateio */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z10cx025.w"
                         &FieldZoom1="cod-incoterm"
                         &FieldScreen1="c-incoterm-rateio"
                         &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-incoterm-rateio wWindow
ON MOUSE-SELECT-DBLCLICK OF c-incoterm-rateio IN FRAME fpage0 /* Incoterm de Rateio */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-embarq-internac.cdn-imposto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-embarq-internac.cdn-imposto wWindow
ON F5 OF tt-despes-embarq-internac.cdn-imposto IN FRAME fpage0 /* C¢digo Imposto */
DO:
    {include/zoomvar.i &prog-zoom= "dizoom/Z01DI217.w"
                       &campo= tt-despes-embarq-internac.cdn-imposto
                       &campozoom= "cod-tax"
                       &campo2= c-desc-impto
                       &campozoom2=descricao
                       &frame= "fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-embarq-internac.cdn-imposto wWindow
ON leave OF tt-despes-embarq-internac.cdn-imposto IN FRAME fpage0 /* C¢digo Imposto */
DO:
    RUN getDescTax in h-boin172desc (INPUT  tt-despes-embarq-internac.cdn-imposto:screen-value in frame fPage0,
                                     OUTPUT c-desc-impto).
    ASSIGN c-desc-impto:SCREEN-VALUE IN FRAME fPage0 = c-desc-impto.
    run pi-calcula-campos-loc-pry.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-embarq-internac.cdn-imposto wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-despes-embarq-internac.cdn-imposto IN FRAME fpage0 /* C¢digo Imposto */
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-embarque.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-cond-pag wWindow
ON F5 OF tt-desp-embarque.cod-cond-pag IN FRAME fpage0 /* Condiá∆o Pagamento */
DO:

{method/zoomfields.i 
     &ProgramZoom="adzoom/z10ad039.w"
     &FieldZoom1="cod-cond-pag"
     &FieldScreen1="tt-desp-embarque.cod-cond-pag"
     &Frame1="fPage0"
     &FieldZoom2="descricao"
     &FieldScreen2="c-desc-cond"
     &Frame2="fPage0"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-cond-pag wWindow
ON LEAVE OF tt-desp-embarque.cod-cond-pag IN FRAME fpage0 /* Condiá∆o Pagamento */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boad039"
      &FindMethod="findCodigo"
      &KeyValue1="tt-desp-embarque.cod-cond-pag:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="descricao"
      &FieldScreen1="c-desc-cond"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-cond-pag wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-desp-embarque.cod-cond-pag IN FRAME fpage0 /* Condiá∆o Pagamento */
DO:
   apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-embarque.cod-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-desp wWindow
ON F5 OF tt-desp-embarque.cod-desp IN FRAME fpage0 /* Despesa */
DO:
  {method/zoomfields.i 
     &ProgramZoom="cxzoom/z10cx095.w"
     &FieldZoom1="cod-desp"
     &FieldScreen1="tt-desp-embarque.cod-desp"
     &Frame1="fPage0"
     &FieldZoom2="descricao"
     &FieldScreen2="c-desc-desp"
     &Frame2="fPage0"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-desp wWindow
ON LEAVE OF tt-desp-embarque.cod-desp IN FRAME fpage0 /* Despesa */
DO:
    /**
    * DESCRIÄ«O DA DESPESA 
    ***/
    RUN findCodigo IN h-bocx310 (INPUT tt-desp-embarque.cod-estabel,
                                 INPUT tt-desp-embarque.embarque,
                                 INPUT INT(tt-desp-embarque.cod-itiner:SCREEN-VALUE IN FRAME fPage0),
                                 INPUT INT(tt-desp-embarque.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0),
                                 INPUT INT(tt-desp-embarque.cod-desp:SCREEN-VALUE IN FRAME fPage0),
                                 OUTPUT c-return).
        
    IF c-return = "":U THEN DO:
        RUN getCharField IN h-bocx310 (INPUT "descricao":U, 
                                       OUTPUT c-desc).
        IF c-desc <> "":U THEN
            ASSIGN c-desc-desp:SCREEN-VALUE IN FRAME fPage0 = c-desc.
    END.

    IF TRIM(c-desc) = "":U OR c-return <> "":U THEN DO:
        {method/referencefields.i &HandleDBOLeave="h-bocx095"
                              &FindMethod="findCodigo"
                              &KeyValue1="tt-desp-embarque.cod-desp:SCREEN-VALUE IN FRAME fPage0"
                              &FieldName1="descricao"
                              &FieldScreen1="c-desc-desp"
                              &Frame1="fPage0"}
    END.


    if  tt-desp-embarque.cod-desp:modified in frame fPage0 
    and c-acao = "ADD":U then do:

        /* Verifica se o campo Incoterm de Rateio deve estar habilitado */
        run pi-habilita-incoterm-rateio in h-bocx310 (input input frame fPage0 tt-desp-embarque.cod-desp,  
                                                      input input frame fPage0 tt-desp-embarque.cod-estabel,
                                                      output l-incoterm-rat).

        run openQuery    in h-bocx095 (input 1).
        run findCodigo   in h-bocx095 (input  input frame fPage0 tt-desp-embarque.cod-desp,
                                       output c-return).
        if  not l-incoterm-rat then do:
            assign c-incoterm-rateio:screen-value in frame fPage0 = "".
            disable c-incoterm-rateio with frame fPage0.
        end.
        else do:

            enable c-incoterm-rateio with frame fPage0.

            /* Se o campo Incoterm de Rateio estiver habilitado 
               sugere o valor default cadastrado no cd2565      */
            
            if  c-return = "" then do:
                run getCharField in h-bocx095 (input  "cod-incoterm-rat":U,
                                               output c-incoterm-rateio).
                assign c-incoterm-rateio:screen-value in frame fPage0 = c-incoterm-rateio.
            end.
            else
                assign c-incoterm-rateio:screen-value in frame fPage0 = ""
                       tt-desp-embarque.cod-emitente-desp:SCREEN-VALUE IN FRAME fPage0 = "".
        end.
        IF c-return = "" THEN DO:
            &if "{&bf_mat_versao_ems}" >= "2.05" &then
                run getIntField in h-bocx095 (input  "cod-emitente":U,
                                              output i-cod-emitente).
                ASSIGN tt-desp-embarque.cod-emitente-desp:SCREEN-VALUE IN FRAME fPage0 = string(i-cod-emitente).
            &else
            
                run getCharField in h-bocx095 (input  "char-1":U,
                                               output c-char-1).
                
                ASSIGN tt-desp-embarque.cod-emitente-desp:SCREEN-VALUE IN FRAME fPage0 = SUBSTRING(c-char-1,1,9).
            &endif
             APPLY "leave" TO tt-desp-embarque.cod-emitente-desp IN FRAME fPage0.
        END.
        ELSE
             ASSIGN tt-desp-embarque.cod-emitente-desp:SCREEN-VALUE IN FRAME fPage0 = "".

        assign tt-desp-embarque.cod-desp:modified in frame fPage0 = no.
    end.

    if i-pais-impto-usuario = 9 /*Paraguay*/ then
        run pi-enable-campos-loc-pry.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-desp wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-desp-embarque.cod-desp IN FRAME fpage0 /* Despesa */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-embarque.cod-emitente-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-emitente-desp wWindow
ON F5 OF tt-desp-embarque.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
     &campo="tt-desp-embarque.cod-emitente-desp"
     &campozoom="cod-emitente"
     &frame="fPage0"
     &campo2="c-nome-abrev"
     &campozoom2="nome-abrev"
     &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-emitente-desp wWindow
ON LEAVE OF tt-desp-embarque.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boad098"
      &FindMethod="findCodigo"
      &KeyValue1="tt-desp-embarque.cod-emitente-desp:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="nome-abrev"
      &FieldScreen1="c-nome-abrev"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-emitente-desp wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-desp-embarque.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-embarque.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-estabel wWindow
ON LEAVE OF tt-desp-embarque.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  {method/referencefields.i 
      &HandleDBOLeave="h-boad107"
      &FindMethod="findCodigo"
      &KeyValue1="tt-desp-embarque.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="nome"
      &FieldScreen1="c-nome-est"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-embarque.cod-itiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-itiner wWindow
ON LEAVE OF tt-desp-embarque.cod-itiner IN FRAME fpage0 /* C¢digo Itiner†rio */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-bocx115"
      &FindMethod="findCodigo"
      &KeyValue1="tt-desp-embarque.cod-itiner:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="descricao"
      &FieldScreen1="c-desc-iti"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-embarque.cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-pto-contr wWindow
ON F5 OF tt-desp-embarque.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z01cx310.w"
                     &FieldZoom1="cod-pto-contr"
                     &FieldScreen1="tt-desp-embarque.cod-pto-contr"
                     &frame1=fPage0
                     &RunMethod="RUN setaVariable IN hProgramZoom (INPUT prParent)."
                     &EnableImplant="no"}
    WAIT-FOR "CLOSE":U OF hProgramZoom.
    APPLY "LEAVE":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-pto-contr wWindow
ON LEAVE OF tt-desp-embarque.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
    /* Descriá∆o do ponto de controle */
    RUN findCh-itiner IN h-bocx230 (INPUT tt-desp-embarque.cod-estabel,
                                    INPUT tt-desp-embarque.embarque,
                                    INPUT tt-desp-embarque.cod-itiner,
                                    INPUT INT(tt-desp-embarque.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0),
                                    OUTPUT c-return).
    IF c-return = "":U THEN DO:
        RUN getCharField IN h-bocx230 (INPUT "descricao":U, 
                                       OUTPUT c-desc).
        IF c-desc <> "":U THEN
            ASSIGN c-desc-pto:SCREEN-VALUE IN FRAME fPage0 = c-desc.
    END.

    IF TRIM(c-desc) = "":U OR c-return <> "":U THEN DO:
        {method/referencefields.i &HandleDBOLeave="h-bocx110"
                                  &FindMethod="findCodigo"
                                  &KeyValue1="tt-desp-embarque.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0"
                                  &FieldName1="descricao"
                                  &FieldScreen1="c-desc-pto"
                                  &Frame1="fPage0"}
    END.

    if  i-pais-impto-usuario = 9 /*Paraguay*/ then
        run pi-enable-campos-loc-pry.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.cod-pto-contr wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-desp-embarque.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-desp-embarque.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.mo-codigo wWindow
ON F5 OF tt-desp-embarque.mo-codigo IN FRAME fpage0 /* Moeda */
DO:
    {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                       &campo=tt-desp-embarque.mo-codigo
                       &campozoom=mo-codigo
                       &campo2=c-desc-mo
                       &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.mo-codigo wWindow
ON LEAVE OF tt-desp-embarque.mo-codigo IN FRAME fpage0 /* Moeda */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boun005"
      &FindMethod="findCodigo"
      &KeyValue1="tt-desp-embarque.mo-codigo:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="descricao"
      &FieldScreen1="c-desc-mo"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-desp-embarque.mo-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-desp-embarque.mo-codigo IN FRAME fpage0 /* Moeda */
DO:
    apply "F5":U to self in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-embarq-internac.val-preco-unit-com-iva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-embarq-internac.val-preco-unit-com-iva wWindow
ON LEAVE OF tt-despes-embarq-internac.val-preco-unit-com-iva IN FRAME fpage0 /* Precio Unitario com Imposto */
DO:
    if dec(tt-despes-embarq-internac.val-preco-unit-com-iva:screen-value in frame fpage0) <> 0 then
        assign tt-despes-embarq-internac.cdn-imposto:sensitive in frame fpage0 = yes.
    else
        assign tt-despes-embarq-internac.cdn-imposto:sensitive    in frame fpage0 = no
               tt-despes-embarq-internac.cdn-imposto:screen-value in frame fpage0 = ''
               c-desc-impto:screen-value                          in frame fpage0 = ''.

    run pi-calcula-campos-loc-pry.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-embarq-internac.val-preco-unit-com-iva wWindow
ON value-changed OF tt-despes-embarq-internac.val-preco-unit-com-iva IN FRAME fpage0 /* Precio Unitario com Imposto */
DO:
    if dec(tt-despes-embarq-internac.val-preco-unit-com-iva:screen-value in frame fpage0) <> 0 then
        assign tt-despes-embarq-internac.cdn-imposto:sensitive in frame fpage0 = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-despes-embarq-internac.val-preco-unit-isento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-despes-embarq-internac.val-preco-unit-isento wWindow
ON LEAVE OF tt-despes-embarq-internac.val-preco-unit-isento IN FRAME fpage0 /* Preáo Unit†rio Isento */
DO:
    IF  i-pais-impto-usuario = 9 THEN
        run pi-calcula-campos-loc-pry.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializaá∆o do programam ---*/
RUN cxbo/bocx310.p persistent set h-bocx310.
RUN cxbo/bocx110.p persistent set h-bocx110.
RUN cxbo/bocx115.p persistent set h-bocx115.
RUN cxbo/bocx095.p persistent set h-bocx095.
RUN cxbo/bocx230.p persistent set h-bocx230.
RUN adbo/boad107.p persistent set h-boad107.
RUN adbo/boad098.p persistent set h-boad098.
RUN adbo/boad039.p persistent set h-boad039.
RUN unbo/boun005.p persistent set h-boun005.
RUN cxbo/bocx220.p persistent set h-bocx220.
RUN cdp/cdapi050.p persistent set h-cdapi050.

IF i-pais-impto-usuario = 9 /*Paraguay*/ THEN DO:
    IF  NOT VALID-HANDLE(h-bocx00465) THEN
        RUN cxbo/bocx00465.p persistent set h-bocx00465.
    RUN openQueryStatic IN h-bocx00465 (INPUT "Main":U) NO-ERROR.

    IF  NOT VALID-HANDLE(h-boin172desc) THEN
        RUN inbo/boin172desc.p PERSISTENT SET h-boin172desc.
END.

IF  NOT VALID-HANDLE(h-bocx250) OR
    h-bocx250:TYPE <> "PROCEDURE":U OR
    h-bocx250:FILE-NAME <> "cxbo/bocx250.p":U THEN DO:
    RUN cxbo/bocx250.p PERSISTENT SET h-bocx250.
    RUN openQuery IN h-bocx250 (INPUT "1":U).
END.

tt-desp-embarque.cod-emitente-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-desp-embarque.cod-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-desp-embarque.cod-pto-contr:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-desp-embarque.cod-cond-pag:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-desp-embarque.mo-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
c-incoterm-rateio:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VALID-HANDLE(h-bocx310) THEN DO:
   delete procedure h-bocx310.
END.

IF VALID-HANDLE(h-bocx110) THEN DO:
   delete procedure h-bocx110.
END.

IF VALID-HANDLE(h-bocx115) THEN DO:
   delete procedure h-bocx115.
END.

IF VALID-HANDLE(h-bocx095) THEN DO:
   delete procedure h-bocx095.
END.

IF VALID-HANDLE(h-bocx230) THEN DO:
   delete procedure h-bocx230.
END.

IF VALID-HANDLE(h-boad107) THEN DO:
   delete procedure h-boad107.
END.

IF VALID-HANDLE(h-boad098) THEN DO:
   delete procedure h-boad098.
END.

IF VALID-HANDLE(h-boad039) THEN DO:
   delete procedure h-boad039.
END.

IF VALID-HANDLE(h-boun005) THEN DO:
   delete procedure h-boun005.
END.

IF VALID-HANDLE(h-bocx250) THEN DO:
   DELETE PROCEDURE h-bocx250.
END.

IF VALID-HANDLE(h-bocx00465) THEN DO:
   run destroy in h-bocx00465.
END.

IF VALID-HANDLE(h-boin172desc) THEN DO:
   run destroy in h-boin172desc.
END.

IF VALID-HANDLE(h-cdapi050) THEN DO:
    DELETE PROCEDURE h-cdapi050.
    ASSIGN h-cdapi050 = ?.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdisplayWidgets wWindow 
PROCEDURE AfterdisplayWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if  c-acao = "UPDATE":U then do:

    run findRowid  in h-bocx310 (input r-row).
    run getCurrent in h-bocx310 (output table tt-desp-embarque).

    find first tt-desp-embarque no-error.
    if  avail tt-desp-embarque then do:

        assign tt-desp-embarque.cod-estabel:screen-value       in frame fpage0 = tt-desp-embarque.cod-estabel
               tt-desp-embarque.embarque:screen-value          in frame fpage0 = tt-desp-embarque.embarque
               tt-desp-embarque.cod-itiner:screen-value        in frame fpage0 = string(tt-desp-embarque.cod-itiner)
               tt-desp-embarque.cod-pto-contr:screen-value     in frame fpage0 = string(tt-desp-embarque.cod-pto-contr)
               tt-desp-embarque.cod-emitente-desp:screen-value in frame fpage0 = string(tt-desp-embarque.cod-emitente-desp)
               tt-desp-embarque.cod-desp:screen-value          in frame fpage0 = string(tt-desp-embarque.cod-desp)
               tt-desp-embarque.cod-cond-pag:screen-value      in frame fpage0 = string(tt-desp-embarque.cod-cond-pag)
               tt-desp-embarque.mo-codigo:screen-value         in frame fpage0 = string(tt-desp-embarque.mo-codigo)
               tt-desp-embarque.val-desp:screen-value          in frame fpage0 = string(tt-desp-embarque.val-desp).

        &if '{&bf_mat_versao_ems}' <= '2.05' &then
             assign td-desp-rec:screen-value in frame fpage0 = string(tt-desp-embarque.log-1).
        &else
             assign td-desp-rec:screen-value in frame fpage0 = string(tt-desp-embarque.log-despes-ja-recbda).
        &endif

        &if defined(bf-mat-comex) &then
            assign c-incoterm-rateio:screen-value in frame fPage0 = substr(tt-desp-embarque.char-1,1,3). /* Incoterm de rateio */
        &else
            &if '{&bf_mat_versao_ems}' < '2.062' &then
                assign c-incoterm-rateio:screen-value in frame fPage0 = substr(tt-desp-embarque.char-1,1,3). /* Incoterm de rateio */
            &else
                assign c-incoterm-rateio:screen-value in frame fPage0 = tt-desp-embarque.cod-incoterm-rat. 
            &endif
        &endif

        &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
              ASSIGN tg-forma-preco-compra:CHECKED IN FRAME fPage0 = tt-desp-embarque.log-forma-preco-compra.
        &ELSE
              IF SUBSTRING(tt-desp-embarque.char-1,4,1) = "1" THEN  /* forma preco compra */
                  ASSIGN tg-forma-preco-compra:CHECKED IN FRAME fPage0 = YES.
              ELSE
                  IF SUBSTRING(tt-desp-embarque.char-1,4,1) = "0" OR 
                     SUBSTRING(tt-desp-embarque.char-1,4,1) = ""  THEN
                  ASSIGN tg-forma-preco-compra:CHECKED IN FRAME fPage0 = NO.
        &ENDIF       
        
        apply "leave":U to tt-desp-embarque.cod-estabel       in frame fpage0.
        apply "leave":U to tt-desp-embarque.cod-itiner        in frame fpage0.
        apply "leave":U to tt-desp-embarque.cod-pto-contr     in frame fpage0.
        apply "leave":U to tt-desp-embarque.cod-emitente-desp in frame fpage0.
        apply "leave":U to tt-desp-embarque.cod-desp          in frame fpage0.
        apply "leave":U to tt-desp-embarque.cod-cond-pag      in frame fpage0.
        apply "leave":U to tt-desp-embarque.mo-codigo         in frame fpage0.
        apply "entry":U to tt-desp-embarque.cod-cond-pag      in frame fpage0.

        if i-pais-impto-usuario = 9 /*Paraguay*/ then do:

            run goToKey in h-bocx00465 (input tt-desp-embarque.cod-estabel,
                                        input tt-desp-embarque.embarque,
                                        input tt-desp-embarque.cod-itiner,
                                        input tt-desp-embarque.cod-pto-contr,
                                        input tt-desp-embarque.cod-desp,
                                        input tt-desp-embarque.cod-emitente-desp).

            if  return-value = "OK":U then do:
                find first tt-despes-embarq-internac no-error.
                if  not avail tt-despes-embarq-internac then
                    create tt-despes-embarq-internac.

                run getDecField in h-bocx00465 (input 'val-preco-unit-isento',
                                                output tt-despes-embarq-internac.val-preco-unit-isento).
                run getDecField in h-bocx00465 (input 'val-preco-unit-com-iva',
                                                output tt-despes-embarq-internac.val-preco-unit-com-iva).
                run getDecField in h-bocx00465 (input 'val-preco-unit',
                                                output tt-despes-embarq-internac.val-preco-unit).
                run getIntField in h-bocx00465 (input 'cdn-imposto',
                                                output tt-despes-embarq-internac.cdn-imposto).
                
                assign tt-despes-embarq-internac.val-preco-unit-isento:screen-value in frame fPage0  = string(tt-despes-embarq-internac.val-preco-unit-isento)
                       tt-despes-embarq-internac.val-preco-unit-com-iva:screen-value in frame fPage0 = string(tt-despes-embarq-internac.val-preco-unit-com-iva)
                       tt-despes-embarq-internac.val-preco-unit:screen-value in frame fPage0         = string(tt-despes-embarq-internac.val-preco-unit)
                       tt-despes-embarq-internac.cdn-imposto:screen-value in frame fPage0            = string(tt-despes-embarq-internac.cdn-imposto).

                IF  i-pais-impto-usuario = 9 THEN DO:
                    apply "leave":U to tt-despes-embarq-internac.val-preco-unit-com-iva in frame fpage0.
                    apply "leave":U to tt-despes-embarq-internac.cdn-imposto in frame fpage0.
                END.
            end.
        end.
    end.
end.
else 
    if  c-acao = "ADD":U then do:

        run findRowid    in h-bocx230 (input r-row-hist).
        run getCharField in h-bocx230 (input "cod-estabel",   output tt-desp-embarque.cod-estabel).
        run getCharField in h-bocx230 (input "embarque",      output tt-desp-embarque.embarque).
        run getIntField  in h-bocx230 (input "cod-itiner",    output tt-desp-embarque.cod-itiner).

        assign tt-desp-embarque.cod-estabel:screen-value   in frame fpage0 = tt-desp-embarque.cod-estabel
               tt-desp-embarque.embarque:screen-value      in frame fpage0 = tt-desp-embarque.embarque
               tt-desp-embarque.cod-itiner:screen-value    in frame fpage0 = string(tt-desp-embarque.cod-itiner)
               tt-desp-embarque.cod-pto-contr:screen-value in frame fpage0 = string(tt-desp-embarque.cod-pto-contr).

        apply "leave":U to tt-desp-embarque.cod-estabel in frame fpage0.
        apply "leave":U to tt-desp-embarque.cod-itiner in frame fpage0.
        apply "leave":U to tt-desp-embarque.cod-pto-contr in frame fpage0.  
        enable tt-desp-embarque.cod-emitente-desp with frame fpage0.
        enable tt-desp-embarque.cod-desp with frame fpage0.     

end.    


&if defined(bf-mat-comex) &then
   ASSIGN td-desp-rec:hidden in frame fpage0 = yes. 
&else
    &if '{&bf_mat_versao_ems}' < '2.04' &then
        ASSIGN td-desp-rec:hidden in frame fpage0 = yes. 
    &endif
&endif

&if defined(bf-mat-comex) &then
&else
    &if '{&bf_mat_versao_ems}' >= '2.04' &then
        run mostraDespesaRecebida in h-bocx310 (input r-row-hist).
        if return-value = "NOK" then
          td-desp-rec:hidden in frame fpage0 = yes. 
    &endif
&endif

IF  VALID-HANDLE(h-bocx250) THEN DO:
    RUN findCodigo IN h-bocx250 (INPUT tt-desp-embarque.cod-estabel, OUTPUT c-erro).
    
    IF  c-erro <> "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,INPUT 17567, INPUT c-erro).
    END.
    ELSE DO:
        &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
         RUN getLogField IN h-bocx250 (INPUT "log-tax-siscomex",
                                       OUTPUT l-tax-siscomex).
         RUN getIntField IN h-bocx250 (INPUT "cdn-despes-siscomex",
                                       OUTPUT i-desp-siscomex).
        &ELSE
         RUN getCharField IN h-bocx250 (INPUT "char-1",
                                        OUTPUT c-tax-siscomex).
         ASSIGN l-tax-siscomex  = IF INT(SUBSTR(c-tax-siscomex, 105, 1)) = 1 THEN YES ELSE NO
                i-desp-siscomex = INT(SUBSTR(c-tax-siscomex, 91, 5)).
        &ENDIF
    END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterEnableWidgets wWindow 
PROCEDURE AfterEnableWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF  c-acao = "UPDATE":U
    AND l-tax-siscomex
    AND i-desp-siscomex = tt-desp-embarque.cod-desp THEN DO:
        DISABLE tt-desp-embarque.mo-codigo
                tt-desp-embarque.val-desp WITH FRAME fpage0.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeinterface wWindow 
PROCEDURE afterInitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  c-acao = "UPDATE":U then do:

        disable tt-desp-embarque.cod-emitente-desp
                tt-desp-embarque.cod-pto-contr
                tt-desp-embarque.cod-desp with frame fpage0.

        if  td-desp-rec:visible then
            enable td-desp-rec with frame fpage0. 

        run pi-habilita-incoterm-rateio in h-bocx310 (input tt-desp-embarque.cod-desp,  
                                                      input tt-desp-embarque.cod-estabel,
                                                      output l-incoterm-rat).
        if  not l-incoterm-rat then
            disable c-incoterm-rateio with frame fPage0.

    end.

    if avail tt-desp-embarque then
        assign d-val-desp-ant = tt-desp-embarque.val-desp.
    else
        assign d-val-desp-ant = 0.

    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.04" &THEN
         IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-imp-forma-preco-compr" 
                                    AND funcao.ativo = YES) THEN DO:
             ASSIGN tg-forma-preco-compra:HIDDEN    IN FRAME fPage0 = NO
                    tg-forma-preco-compra:SENSITIVE IN FRAME fPage0 = YES.
         END.
         ELSE DO:
             ASSIGN tg-forma-preco-compra:HIDDEN    IN FRAME fPage0 = YES
                    tg-forma-preco-compra:SENSITIVE IN FRAME fPage0 = NO.
         END.
    &ELSE
        ASSIGN tg-forma-preco-compra:HIDDEN    IN FRAME fPage0 = YES
               tg-forma-preco-compra:SENSITIVE IN FRAME fPage0 = NO.
    &ENDIF
             
    if i-pais-impto-usuario = 9 /*Paraguay*/ then do:
        assign tt-despes-embarq-internac.val-preco-unit-isento :hidden in frame fPage0 = no
               tt-despes-embarq-internac.val-preco-unit-com-iva:hidden in frame fPage0 = no
               tt-despes-embarq-internac.val-preco-unit        :hidden in frame fPage0 = no
               tt-despes-embarq-internac.cdn-imposto           :hidden in frame fPage0 = no
               c-desc-impto                                    :hidden in frame fPage0 = no

               tt-despes-embarq-internac.val-preco-unit-isento :col in frame fPage0 = 32
               tt-despes-embarq-internac.val-preco-unit-com-iva:col in frame fPage0 = 32
               tt-despes-embarq-internac.val-preco-unit        :col in frame fPage0 = 32
               c-incoterm-rateio                               :col in frame fPage0 = 32
               tt-despes-embarq-internac.cdn-imposto           :col in frame fPage0 = 60
               c-desc-impto                                    :col in frame fPage0 = 64.2
               tt-desp-embarque.val-desp                       :col in frame fPage0 = 60
               td-desp-rec                                     :col in frame fPage0 = 60
               tg-forma-preco-compra                           :col in frame fPage0 = 41

               tt-despes-embarq-internac.val-preco-unit-isento :row in frame fPage0 = 9.50 
               tt-despes-embarq-internac.val-preco-unit-com-iva:row in frame fPage0 = 10.42
               tt-despes-embarq-internac.val-preco-unit        :row in frame fPage0 = 11.33
               c-incoterm-rateio                               :row in frame fPage0 = 12.25
               tt-despes-embarq-internac.cdn-imposto           :row in frame fPage0 = 10.42
               c-desc-impto                                    :row in frame fPage0 = 10.42
               tt-desp-embarque.val-desp                       :row in frame fPage0 = 11.33
               td-desp-rec                                     :row in frame fPage0 = 12.25
               tg-forma-preco-compra                           :row in frame fPage0 = 12.25

               tt-despes-embarq-internac.val-preco-unit-isento :side-label-handle:row = 9.50 
               tt-despes-embarq-internac.val-preco-unit-com-iva:side-label-handle:row = 10.42
               tt-despes-embarq-internac.val-preco-unit        :side-label-handle:row = 11.33
               c-incoterm-rateio                               :side-label-handle:row = 12.25
               tt-despes-embarq-internac.cdn-imposto           :side-label-handle:row = 10.42
               tt-desp-embarque.val-desp                       :side-label-handle:row = 11.33

               tt-despes-embarq-internac.val-preco-unit-isento :side-label-handle:col = 16.45
               tt-despes-embarq-internac.val-preco-unit-com-iva:side-label-handle:col = 12
               tt-despes-embarq-internac.val-preco-unit        :side-label-handle:col = 11.6
               c-incoterm-rateio                               :side-label-handle:col = 17.9
               tt-despes-embarq-internac.cdn-imposto           :side-label-handle:col = 48.25
               tt-desp-embarque.val-desp                       :side-label-handle:col = 49.3.

        tt-despes-embarq-internac.val-preco-unit-isento :MOVE-AFTER-TAB-ITEM(tt-desp-embarque.mo-codigo:HANDLE).
        tt-despes-embarq-internac.val-preco-unit-com-iva:MOVE-AFTER-TAB-ITEM(tt-despes-embarq-internac.val-preco-unit-isento:HANDLE).
        tt-despes-embarq-internac.val-preco-unit        :MOVE-AFTER-TAB-ITEM(tt-despes-embarq-internac.val-preco-unit-com-iva:HANDLE).
        c-incoterm-rateio                               :MOVE-AFTER-TAB-ITEM(tt-despes-embarq-internac.val-preco-unit:HANDLE).
        tt-despes-embarq-internac.cdn-imposto           :MOVE-AFTER-TAB-ITEM(c-incoterm-rateio:HANDLE).
        tt-desp-embarque.val-desp                       :MOVE-AFTER-TAB-ITEM(tt-despes-embarq-internac.cdn-imposto:HANDLE).
        
        tt-despes-embarq-internac.cdn-imposto:load-mouse-pointer  ('image~\lupa.cur') in frame {&FRAME-NAME}.
        run pi-enable-campos-loc-pry.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforedisplayWidgets wWindow 
PROCEDURE BeforedisplayWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    create tt-desp-embarque.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-campos-loc-pry wWindow 
PROCEDURE pi-calcula-campos-loc-pry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var v-val-preco-unit         as dec no-undo.
    def var v-val-desp               as dec no-undo.
    def var v-val-preco-unit-isento  as dec no-undo.
    def var v-val-preco-unit-com-iva as dec no-undo.

    assign v-val-preco-unit         = dec(tt-despes-embarq-internac.val-preco-unit:screen-value in frame fPage0)
           v-val-desp               = dec(tt-desp-embarque.val-desp:screen-value in frame fPage0)
           v-val-preco-unit-isento  = dec(tt-despes-embarq-internac.val-preco-unit-isento:screen-value in frame fPage0)
           v-val-preco-unit-com-iva = dec(tt-despes-embarq-internac.val-preco-unit-com-iva:screen-value in frame fPage0).

    assign v-val-preco-unit = 0.
    if c-desc-impto <> '' then do:
        find first tipo-tax
             where tipo-tax.cod-tax = int(tt-despes-embarq-internac.cdn-imposto:screen-value in frame fPage0)
               and tipo-tax.tipo = 2 no-lock no-error.
        if avail tipo-tax then
            assign v-val-preco-unit = v-val-preco-unit-com-iva / (tipo-tax.tax-perc / 100 + 1).
    end.
    
    assign v-val-desp = v-val-preco-unit-isento + v-val-preco-unit.
    
    assign tt-despes-embarq-internac.val-preco-unit:screen-value in frame fPage0         = string(v-val-preco-unit)
           tt-desp-embarque.val-desp:screen-value in frame fPage0                        = string(v-val-desp)
           tt-despes-embarq-internac.val-preco-unit-isento:screen-value in frame fPage0  = string(v-val-preco-unit-isento)
           tt-despes-embarq-internac.val-preco-unit-com-iva:screen-value in frame fPage0 = string(v-val-preco-unit-com-iva).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-enable-campos-loc-pry wWindow 
PROCEDURE pi-enable-campos-loc-pry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var l-complementar    as log initial no no-undo.
    def var l-despesa-inc-iva as log initial no no-undo.

    if tt-desp-embarque.cod-pto-contr:screen-value in frame fPage0 <> '0' then do:

        /*Para saber si es un punto de control complementar o no*/
        run pi-complementar in h-bocx00465 (input tt-desp-embarque.cod-estabel,
                                            input tt-desp-embarque.embarque,
                                            input int(tt-desp-embarque.cod-pto-contr:screen-value in frame fPage0),
                                            output l-complementar).
        assign tt-despes-embarq-internac.val-preco-unit-isento:sensitive in frame fPage0 = l-complementar
               tt-desp-embarque.val-desp:sensitive in frame fPage0 = if l-complementar then no else yes.

        if l-complementar and tt-desp-embarque.cod-desp:screen-value in frame fPage0 <> '0' then do:
            /*Para saber si la despesa esta parametrizada para incidir IVA (param en el cd1070)*/
            run pi-despesa-inc-iva in h-bocx00465 (input int(tt-desp-embarque.cod-desp:screen-value in frame fPage0),
                                                   output l-despesa-inc-iva).
            assign tt-despes-embarq-internac.val-preco-unit-com-iva:sensitive in frame fPage0 = l-despesa-inc-iva.
        end.
    end.

    if not l-complementar then
        assign tt-despes-embarq-internac.val-preco-unit-isento:sensitive in frame fPage0     = no
               tt-despes-embarq-internac.val-preco-unit-com-iva:sensitive in frame fPage0    = no
               tt-despes-embarq-internac.cdn-imposto:sensitive in frame fPage0               = no
               tt-desp-embarque.val-desp:sensitive in frame fPage0                           = yes
               tt-despes-embarq-internac.val-preco-unit:screen-value in frame fPage0         = '0'
               tt-despes-embarq-internac.val-preco-unit-isento:screen-value in frame fPage0  = '0'
               tt-despes-embarq-internac.val-preco-unit-com-iva:screen-value in frame fPage0 = '0'
               tt-despes-embarq-internac.cdn-imposto:screen-value in frame fPage0            = ''
               c-desc-impto:screen-value in frame fPage0                                     = ''.
    else
        if not l-despesa-inc-iva then
            assign tt-despes-embarq-internac.val-preco-unit-com-iva:sensitive in frame fPage0    = no
                   tt-despes-embarq-internac.cdn-imposto:sensitive in frame fPage0               = no
                   tt-despes-embarq-internac.val-preco-unit:screen-value in frame fPage0         = '0'
                   tt-despes-embarq-internac.val-preco-unit-com-iva:screen-value in frame fPage0 = '0'
                   tt-despes-embarq-internac.cdn-imposto:screen-value in frame fPage0            = ''
                   c-desc-impto:screen-value in frame fPage0                                     = ''.

   if l-complementar then
       run pi-calcula-campos-loc-pry.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

