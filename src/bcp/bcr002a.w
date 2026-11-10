&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCR002A 2.00.00.007} /*** "010007" 31/07/2024 10:46:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bcr002a MBC}
&ENDIF

&Scoped-define WINDOW-NAME C-Win

/*------------------------------------------------------------------------
File.............: bcr002a.w
Description......: Relat¢rio de Extensäes do Item
Input Parameters : 
Output Parameters: 
Author...........: DATASUL S.A.
Created..........: 08/04/99 - 15:09 - bc
OBS..............: Este fonte foi gerado pelo Data Viewer
------------------------------------------------------------------------*/



CREATE WIDGET-POOL. 

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */

&GLOBAL-DEFINE PGSEL f-pg-sel 
&GLOBAL-DEFINE PGPAR f-pg-par 
&GLOBAL-DEFINE PGIMP f-pg-imp 

/* Include Com as Vari veis Globais */

{utp/ut-glob.i}

/* Parameters Definitions ---                                           */ 


/* Temporary Table Definitions ---                                      */ 

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino              AS INTEGER
    FIELD arquivo              AS CHAR
    FIELD usuario              AS CHAR
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD parametro            AS LOGICAL
    FIELD formato              AS INTEGER
    FIELD v_num_tip_aces_usuar AS INTEGER
    FIELD ep-codigo            LIKE empresa.ep-codigo
    FIELD c-it-codigo-ini      LIKE bc-ext-item.it-codigo
    FIELD c-it-codigo-fim      LIKE bc-ext-item.it-codigo.

/* Transfer Definitions */

DEF VAR raw-param        AS RAW NO-UNDO.

/* Local Variable Definitions ---                                       */ 

DEF VAR l-ok                 AS LOGICAL NO-UNDO. 
DEF VAR c-arq-digita         AS CHAR    NO-UNDO. 
DEF VAR c-terminal           AS CHAR    NO-UNDO. 
DEF VAR v-cod-pg-mouse-selec AS CHAR    NO-UNDO. 
DEF VAR v-cod-prog-i-rprun   AS CHAR    NO-UNDO. 
DEF VAR c-impressora-old     AS CHAR    NO-UNDO. 
DEF VAR c-arquivo-old        AS CHAR    NO-UNDO. 
DEF VAR c-destino-old        AS CHAR    NO-UNDO. 
DEF VAR i-cont               AS INT     NO-UNDO. 
DEF VAR v-cod-prog-gerado    AS CHAR    NO-UNDO. 

/****************** Defini‡ao de Parƒmetros do Relat¢rio *********************/ 

/****************** Defini‡ao de Vari veis de Sele‡Æo do Relat¢rio *********************/ 

DEF NEW SHARED VAR c-it-codigo-ini LIKE bc-ext-item.it-codigo FORMAT "x(16)" INITIAL "" NO-UNDO.
DEF NEW SHARED VAR c-it-codigo-fim LIKE bc-ext-item.it-codigo FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" NO-UNDO.

/* ********************  Preprocessor Definitions  ******************** */ 

/* ***********************  Control Definitions  ********************** */ 

DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO. 


DEFINE BUTTON bt-arquivo
    IMAGE-UP FILE "image~\im-sea"
    IMAGE-INSENSITIVE FILE "image~\ii-sea"
    LABEL " "
    SIZE 4 BY 1.
    
DEFINE BUTTON bt-config-impr
    IMAGE-UP FILE "image~\im-cfprt"
    LABEL " "
    SIZE 4 BY 1.
    
DEFINE IMAGE IMAGE-1
    FILENAME "image~\im-fir"
    SIZE 3 BY .88.
    
DEFINE IMAGE IMAGE-2
    FILENAME "image~\im-las"
    SIZE 3 BY .88.
    
DEFINE IMAGE im-pg-imp
    FILENAME "image~\im-fldup"
    SIZE 15.72 BY 1.19.
    
DEFINE IMAGE im-pg-par
    FILENAME "image~\im-fldup"
    SIZE 15.72 BY 1.19.
    
DEFINE IMAGE im-pg-sel
    FILENAME "image~\im-fldup"
    SIZE 15.72 BY 1.19.


DEFINE VARIABLE c-arquivo AS CHARACTER 
VIEW-AS EDITOR MAX-CHARS 256 
SIZE 40 BY 1.00 
BGCOLOR 15  FONT 2 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)" INITIAL "Destino"
VIEW-AS TEXT 
SIZE 8.57 BY .62 NO-UNDO. 

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)" INITIAL "Execu‡Æo"
VIEW-AS TEXT 
SIZE 10.86 BY .62 NO-UNDO.

DEFINE VARIABLE text-parametro AS CHARACTER FORMAT "X(256)" INITIAL "Parƒmetros de ImpressÆo"
VIEW-AS TEXT 
SIZE 24.72 BY .62 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 3 
VIEW-AS RADIO-SET HORIZONTAL
RADIO-BUTTONS 
"Impressora", 1,
"Arquivo", 2,
"Terminal", 3
SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
VIEW-AS RADIO-SET HORIZONTAL 
RADIO-BUTTONS 
"On-Line", 1,
"Batch", 2
SIZE 27.72 BY .92 NO-UNDO.

DEFINE VARIABLE tb-parametro AS LOGICAL INITIAL NO 
LABEL "Imprimir P gina de Parƒmetros"
VIEW-AS TOGGLE-BOX 
SIZE 32 BY .83 
NO-UNDO.

DEFINE VARIABLE rs-formato AS INTEGER INITIAL 2 
VIEW-AS RADIO-SET HORIZONTAL 
RADIO-BUTTONS 
"80 colunas", 1,
"132 colunas", 2
SIZE 32 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7 
EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
SIZE 46.29 BY 2.92. 

DEFINE RECTANGLE RECT-9 
EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
SIZE 46.29 BY 1.69.

DEFINE RECTANGLE RECT-10 
EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
SIZE 46.29 BY 3.50.

DEFINE VARIABLE l-param-1 AS LOGICAL INITIAL NO 
LABEL "Parƒmetro 1"
VIEW-AS TOGGLE-BOX 
SIZE 44 BY 1.08 NO-UNDO. 

DEFINE BUTTON bt-ajuda 
LABEL "Ajuda"
SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
LABEL "Fechar"
SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
LABEL "Executar"
SIZE 10 BY 1.

DEFINE RECTANGLE RECT-1
EDGE-PIXELS 2 GRAPHIC-EDGE 
SIZE 79 BY 1.42 
BGCOLOR 7 . 

DEFINE RECTANGLE RECT-6
EDGE-PIXELS 0
SIZE 78.72 BY .12
BGCOLOR 7.

DEFINE RECTANGLE rt-folder
EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL
SIZE 79 BY 11.38
FGCOLOR 0.

DEFINE RECTANGLE rt-folder-left
EDGE-PIXELS 0
SIZE .43 BY 11.19
BGCOLOR 15.

DEFINE RECTANGLE rt-folder-right
EDGE-PIXELS 0
SIZE .43 BY 11.15
BGCOLOR 7.

DEFINE RECTANGLE rt-folder-top
EDGE-PIXELS 0
SIZE 78.72 BY .12
BGCOLOR 15 .

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
    bt-executar AT ROW 14.54 COL 3 HELP
"Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
"Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
"Ajuda"
     im-pg-sel AT ROW 1.5 COL 2.14
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-imp AT ROW 1.5 COL 33.58
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.65 COL 80.43
     RECT-6 AT ROW 13.73 COL 2.14
     RECT-1 AT ROW 14.31 COL 2
     WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
     SIDE-LABELS NO-UNDERLINE THREE-D
     AT COL 1 ROW 1
     SIZE 81 BY 15
     DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-imp
    text-destino AT ROW 1.62 COL 3.86 NO-LABEL
    rs-destino AT ROW 2.38 COL 3.29 HELP
    "Destino de ImpressÆo do Relat¢rio" NO-LABEL
    bt-arquivo AT ROW 3.58 COL 43.29 HELP
    "Escolha do nome do arquivo"
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
    "Configura‡Æo da impressora"
     c-arquivo AT ROW 3.56 COL 3.29 HELP
    "Nome do arquivo de destino do relat¢rio" NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     rs-execucao AT ROW 5.77 COL 3 HELP
    "Modo de Execu‡Æo" NO-LABEL
     tb-parametro AT ROW 7.92 COL 3.2
     rs-formato AT ROW 8.8 COL 3 HELP
    "Formato de ImpressÆo" NO-LABEL
     text-parametro AT ROW 7.17 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.31 COL 2.14
     RECT-10 AT ROW 7.46 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
    SIDE-LABELS NO-UNDERLINE THREE-D
    AT COL 3 ROW 3
    SIZE 73.72 BY 10.

DEFINE FRAME f-pg-sel
   c-it-codigo-ini LABEL "Item"
     AT ROW 1 COL 9 COLON-ALIGNED
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1

   c-it-codigo-fim NO-LABEL
     AT ROW 1 COL 36 COLON-ALIGNED
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     FONT 1

   IMAGE-1 AT ROW 01.00 COL 29
   IMAGE-2 AT ROW 01.00 COL 34
   WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
   SIDE-LABELS NO-UNDERLINE THREE-D
   AT COL 3 ROW 2.85
   SIZE 76.86 BY 10.62.

DEFINE FRAME f-pg-par

   WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
   SIDE-LABELS NO-UNDERLINE THREE-D
   AT COL 3 ROW 3
   SIZE 75 BY 10.

/* *************************  Create Window  ************************** */

CREATE WINDOW C-Win ASSIGN
   HIDDEN             = YES
   TITLE              = "Relat¢rio de Extensäes do Item - bcr002a"
   HEIGHT             = 15
   WIDTH              = 81.14
   MAX-HEIGHT         = 22.35
   MAX-WIDTH          = 114.29
   VIRTUAL-HEIGHT     = 22.35
   VIRTUAL-WIDTH      = 114.29
   RESIZE             = YES
   SCROLL-BARS        = NO
   STATUS-AREA        = YES
   BGCOLOR            = ?
   FGCOLOR            = ?
   KEEP-FRAME-Z-ORDER = YES
   THREE-D            = YES
   MESSAGE-AREA       = NO
   SENSITIVE          = YES.

/* ***************  Runtime Attributes and UIB Settings  ************** */

ASSIGN FRAME f-pg-imp:FRAME = FRAME f-relat:HANDLE
       FRAME f-pg-par:FRAME = FRAME f-relat:HANDLE
       FRAME f-pg-sel:FRAME = FRAME f-relat:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI" AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = NO.

/* ************************* Included-Libraries *********************** */


{src/adm/method/containr.i}


{include/w-relat.i}



ASSIGN FRAME f-relat:visible = NO
       FRAME f-relat:font = 1.
&IF "{&PGSEL}" <> "" &THEN
    ASSIGN FRAME f-pg-sel:visible = NO
           FRAME f-pg-sel:font = 1.
    &IF "{&botao}" <> "no" &THEN
        ON  GO OF FRAME {&pgsel} ANYWHERE DO:    
            IF  SELF:type <> "editor" 
                OR (SELF:type = "editor" 
                AND keyfunction(LASTKEY) <> "RETURN") THEN DO: 
                APPLY "choose" TO bt-executar IN FRAME f-relat.
            END.
        END.              
    &ENDIF  
&ENDIF
&IF "{&PGCLA}" <> "" &THEN
    assign frame f-pg-cla:visible = no
           frame f-pg-cla:font = 1.
    &IF "{&botao}" <> "no" &THEN
        ON  GO OF frame {&pgcla} ANYWHERE DO:    
            if  self:type <> "editor" 
                or (self:type = "editor" 
                and keyfunction(lastkey) <> "RETURN") then do: 
                apply "choose" to bt-executar in frame f-relat.
            end.
        END.              
    &ENDIF  
&ENDIF
&IF "{&PGPAR}" <> "" &THEN
    ASSIGN FRAME f-pg-par:visible = NO
           FRAME f-pg-par:font = 1.
    &IF "{&botao}" <> "no" &THEN
        ON  GO OF FRAME {&pgpar} ANYWHERE DO:    
            IF  SELF:type <> "editor" 
                OR (SELF:type = "editor" 
                AND keyfunction(LASTKEY) <> "RETURN") THEN DO: 
                APPLY "choose" TO bt-executar IN FRAME f-relat.
            END.
        END.              
    &ENDIF  
&ENDIF
&IF "{&PGDIG}" <> "" &THEN
    assign frame f-pg-dig:visible = no
           frame f-pg-dig:font = 1.
    &IF "{&botao}" <> "no" &THEN
        ON  GO OF frame {&pgdig} ANYWHERE DO:    
            if  self:type <> "editor" 
                or (self:type = "editor" 
                and keyfunction(lastkey) <> "RETURN") then do: 
                apply "choose" to bt-executar in frame f-relat.
            end.
        END.              
    &ENDIF  
&ENDIF
&IF "{&PGIMP}" <> "" &THEN
    ASSIGN FRAME f-pg-imp:visible = NO
           FRAME f-pg-imp:font = 1.
    &IF "{&botao}" <> "no" &THEN
        ON  GO OF FRAME {&pgimp} ANYWHERE DO:    
            IF  SELF:type <> "editor" 
                OR (SELF:type = "editor" 
                AND keyfunction(LASTKEY) <> "RETURN") THEN DO: 
                APPLY "choose" TO bt-executar IN FRAME f-relat.
            END.
        END.              
    &ENDIF  
&ENDIF



ON "close" OF THIS-PROCEDURE DO:
    RUN btb/btb918za.p (INPUT NO).
    RUN disable_UI.
END.

/* ************************  Control Triggers  ************************ */

ON END-ERROR OF C-Win
OR ENDKEY OF C-Win ANYWHERE DO:
   RETURN NO-APPLY.
END.

ON WINDOW-CLOSE OF C-Win
DO:
   APPLY "CLOSE" TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

ON ENDKEY OF FRAME f-relat DO:
   RETURN NO-APPLY.
END.

ON CHOOSE OF bt-ajuda IN FRAME f-relat
DO:

   {include/ajuda.i}

END.

ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:

   {include/i-rparq.i}

END.

ON CHOOSE OF bt-cancelar IN FRAME f-relat
DO:
   APPLY "close" TO THIS-PROCEDURE.
END.

ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:

   {include/i-rpimp.i}

END.

ON CHOOSE OF bt-executar IN FRAME f-relat
DO:
   DO  ON ERROR UNDO, RETURN NO-APPLY:
      RUN pi-executar.
   END.
END.

ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
   rs-formato:disable(ENTRY(1,rs-formato:radio-buttons IN FRAME f-pg-imp)) IN FRAME f-pg-imp.
   RUN pi-troca-pagina.
END.

ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
   RUN pi-troca-pagina.
END.

ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
   RUN pi-troca-pagina.
END.

ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:   
   DO WITH FRAME f-pg-imp:
      CASE SELF:SCREEN-VALUE:
         WHEN "1" THEN DO:
            IF c-destino-old = "2" THEN
               ASSIGN c-impressora-old = c-arquivo:SCREEN-VALUE.
               
            ASSIGN c-arquivo:SENSITIVE = NO
                   c-destino-old = "1"
                   c-arquivo:VISIBLE = YES
                   c-arquivo:SCREEN-VALUE = c-arquivo-old
                   bt-arquivo:VISIBLE = NO
                   bt-config-impr:VISIBLE = YES.
         END.
         WHEN "2" THEN DO:
            IF c-destino-old = "1" THEN
               ASSIGN c-arquivo-old = c-arquivo:SCREEN-VALUE.
               
            ASSIGN c-arquivo:SENSITIVE = YES
                   c-destino-old = "2"
                   c-arquivo:VISIBLE = YES
                   c-arquivo:SCREEN-VALUE = c-impressora-old
                   bt-arquivo:VISIBLE     = YES
                   bt-config-impr:VISIBLE  = NO.
         END.
         WHEN "3" THEN DO:
            IF c-destino-old = "2" THEN
               ASSIGN c-impressora-old = c-arquivo:SCREEN-VALUE.
               
            IF c-destino-old = "1" THEN
               ASSIGN c-arquivo-old = c-arquivo:SCREEN-VALUE.
               
            ASSIGN c-arquivo:SENSITIVE = NO
                   c-destino-old = "3"
                   c-arquivo:VISIBLE = NO
                   bt-arquivo:VISIBLE = NO
                   bt-config-impr:VISIBLE = NO.
         END.
      END CASE.
   END.
END.

ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp DO:

   {utp/ut-liter.i Terminal * L} 
   
   ASSIGN c-terminal = RETURN-VALUE.

   {include/i-rprse.i}

END.

/* ***************************  Main Block  *************************** */

ASSIGN CURRENT-WINDOW             = {&WINDOW-NAME}
   THIS-PROCEDURE:CURRENT-WINDOW  = {&WINDOW-NAME}.

    ASSIGN v-cod-prog-gerado = "bcr002a".


FIND usuar_mestre WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.
IF AVAIL usuar_mestre THEN 
   ASSIGN c-arquivo = IF LENGTH(usuar_mestre.nom_subdir_spool) <> 0
                      THEN CAPS(REPLACE(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + replace(usuar_mestre.nom_subdir_spool, "~\", "~/") + "~/" + v-cod-prog-gerado + "~.lst")
                      ELSE CAPS(REPLACE(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + v-cod-prog-gerado + "~.lst").
ELSE 
    ASSIGN c-arquivo = CAPS("spool~/" + v-cod-prog-gerado + "~.lst").

c-arq-old = c-arquivo.

{utp/ut9000.i "BCR002A" "2.00.00.007"} /* 31/07/2024 10:46:30 */

 /*include de inicializa‡Æo do relat¢rio */

 /*inicializa‡äes do template de relat¢rio */

ASSIGN {&window-name}:VIRTUAL-WIDTH-CHARS  = {&window-name}:WIDTH-CHARS  
       {&window-name}:VIRTUAL-HEIGHT-CHARS = {&window-name}:HEIGHT-CHARS 
       {&window-name}:MIN-WIDTH-CHARS      = {&window-name}:WIDTH-CHARS  
       {&window-name}:MAX-WIDTH-CHARS      = {&window-name}:WIDTH-CHARS  
       {&window-name}:MIN-HEIGHT-CHARS     = {&window-name}:HEIGHT-CHARS 
       {&window-name}:MAX-HEIGHT-CHARS     = {&window-name}:HEIGHT-CHARS.
ASSIGN c-terminal = "Terminal".

ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.


{include/i-rplbl.i}

  ASSIGN wh-label-imp:screen-value = "ImpressÆo".
PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   RUN enable_UI.

   {utp/ut-liter.i Destino *}
   ASSIGN text-destino:SCREEN-VALUE IN FRAME f-pg-imp = RETURN-VALUE.
   {utp/ut-liter.i Execu‡Æo *}
   ASSIGN text-modo:SCREEN-VALUE IN FRAME f-pg-imp = RETURN-VALUE.
   {utp/ut-liter.i Parƒmetros_de_ImpressÆo *}
   ASSIGN text-parametro:SCREEN-VALUE IN FRAME f-pg-imp = RETURN-VALUE.

   rs-formato:DISABLE(ENTRY(1,rs-formato:RADIO-BUTTONS IN FRAME f-pg-imp)) IN FRAME f-pg-imp.

   ASSIGN v-cod-pg-mouse-selec = "im-pg-sel".

   APPLY "value-changed" TO rs-destino IN FRAME f-pg-imp.

   IF v-cod-pg-mouse-selec = "im-pg-sel" THEN
      APPLY "mouse-select-click" TO im-pg-sel IN FRAME f-relat.

   IF v-cod-pg-mouse-selec = "im-pg-par" THEN
      APPLY "mouse-select-click" TO im-pg-par IN FRAME f-relat.

   IF v-cod-pg-mouse-selec = "im-pg-imp" THEN
      APPLY "mouse-select-click" TO im-pg-imp IN FRAME f-relat.

   IF im-pg-sel:SENSITIVE IN FRAME f-relat = NO THEN DO:
      {utp/ut-liter.i Sele‡Æo *}
      RUN pi-muda-cor-label-folder(INPUT RETURN-VALUE).
   END.   

   IF im-pg-par:SENSITIVE IN FRAME f-relat = NO THEN DO:
      {utp/ut-liter.i Parƒmetros *}
      RUN pi-muda-cor-label-folder(INPUT RETURN-VALUE).
   END.
   
   IF  NOT THIS-PROCEDURE:PERSISTENT THEN
      WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.
/* **********************  Internal Procedures  *********************** */

PROCEDURE adm-row-available :
   /* Define variables needed by this internal procedure.             */
  /* Process the newly available records (i.e. display fields, 
     open queries, and/or pass records on to any RECORD-TARGETS).    */
END PROCEDURE.

PROCEDURE disable_UI :
   IF SESSION:DISPLAY-TYPE = "GUI" AND VALID-HANDLE(C-Win)
   THEN DELETE WIDGET C-Win.
   IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

PROCEDURE enable_UI :
   ENABLE bt-executar bt-cancelar bt-ajuda im-pg-imp im-pg-sel
   WITH FRAME f-relat IN WINDOW C-Win.
   
   DISPLAY  
   c-it-codigo-ini c-it-codigo-fim
   WITH FRAME f-pg-sel IN WINDOW C-Win.

   ENABLE IMAGE-1 IMAGE-2  
   c-it-codigo-ini c-it-codigo-fim
   WITH FRAME f-pg-sel IN WINDOW C-Win.
   
   DISPLAY rs-destino c-arquivo rs-execucao tb-parametro rs-formato
   WITH FRAME f-pg-imp IN WINDOW C-Win.
   ENABLE RECT-7 rs-destino bt-arquivo bt-config-impr c-arquivo RECT-9 rect-10 rs-execucao tb-parametro rs-formato
   WITH FRAME f-pg-imp IN WINDOW C-Win.
   
   DISPLAY 
   WITH FRAME f-pg-par IN WINDOW C-Win.

   ENABLE 
   WITH FRAME f-pg-par IN WINDOW C-Win.
   
   VIEW C-Win.
END PROCEDURE.

PROCEDURE local-exit :
   APPLY "CLOSE" TO THIS-PROCEDURE.
   RETURN.
END PROCEDURE.

PROCEDURE pi-executar :
   DO ON ERROR UNDO, RETURN ERROR
      ON STOP  UNDO, RETURN ERROR:


      {include/i-rpexa.i}
   
      IF INPUT FRAME f-pg-imp rs-destino = 2 THEN DO:
         RUN utp/ut-vlarq.p (INPUT INPUT FRAME f-pg-imp c-arquivo).
         IF RETURN-VALUE =  "nok" THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 73,
                               INPUT "").
            APPLY "mouse-select-click" TO im-pg-imp IN FRAME f-relat.
            APPLY "entry" TO c-arquivo IN FRAME f-pg-imp.
            RETURN ERROR.
         END.
      END.
   
   
      /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
          devem apresentar uma mensagem de erro cadastrada, posicionar na p gina
          com problemas e colocar o focus no campo com problemas             */ 
   
      IF v_cdn_empres_usuar <> ? THEN
         ASSIGN i-ep-codigo-usuario = v_cdn_empres_usuar.
   
      CREATE tt-param.
      ASSIGN tt-param.usuario              = c-seg-usuario
             tt-param.destino              = INPUT FRAME f-pg-imp rs-destino
             tt-param.data-exec            = TODAY
             tt-param.hora-exec            = TIME
             tt-param.parametro            = IF INPUT FRAME f-pg-imp tb-parametro = "yes" THEN YES ELSE NO
             tt-param.formato              = IF INPUT FRAME f-pg-imp rs-formato   = "1" THEN 1 ELSE 2
             tt-param.v_num_tip_aces_usuar = v_num_tip_aces_usuar
             tt-param.ep-codigo            = i-ep-codigo-usuario.
             
      IF tt-param.destino = 1 THEN
         ASSIGN tt-param.arquivo = "".
      ELSE
         IF tt-param.destino = 2 THEN
            ASSIGN tt-param.arquivo = INPUT FRAME f-pg-imp c-arquivo.
         ELSE
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + "bcr002a" + ".tmp".
   
      ASSIGN tt-param.c-it-codigo-ini = INPUT FRAME f-pg-sel c-it-codigo-ini
             tt-param.c-it-codigo-fim = INPUT FRAME f-pg-sel c-it-codigo-fim
             tt-param.c-it-codigo-fim = INPUT FRAME f-pg-sel c-it-codigo-fim.
   
   
      {include/i-rpexb.i}
   
      IF SESSION:SET-WAIT-STATE("general") THEN.
      ASSIGN v-cod-prog-i-rprun = "bcp/bcr0021.p".
   
      {include/i-rprun.i &ProgramaRP=v-cod-prog-i-rprun}
   
   
      {include/i-rpexc.i}
   
      IF SESSION:SET-WAIT-STATE("") THEN.
      DEF VAR c-key-value AS CHAR NO-UNDO.

      IF tt-param.destino = 3 THEN DO:
         IF c-key-value = ""OR  c-key-value = ?  THEN DO:
            ASSIGN c-key-value = "notepad.exe".
         END.
         IF SEARCH("utp/ut-showreport.r") <> ? OR SEARCH("utp/ut-showreport.p") <> ? THEN DO:
            RUN utp/ut-showreport.p (tt-param.arquivo).
         END.
         ELSE DO:
            RUN winexec (INPUT c-key-value + CHR(32) + tt-param.arquivo, INPUT 1).
         END.
      END.
   END.
END PROCEDURE.
PROCEDURE pi-troca-pagina:
&IF "{&product_version}" >= "12.1.X.2307" &THEN
    {include/i-rptrp.i}
&ELSE
/* ***** Editado automaticamente para o projeto de facelift ***** */

SELF:move-to-top() IN FRAME f-relat.


CASE SELF:name:
    WHEN "im-pg-sel" THEN DO WITH FRAME f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            VIEW FRAME {&PGSEL}.
            RUN pi-first-child (INPUT FRAME {&PGSEL}:handle).
            im-pg-sel:load-image("image/im-fldup") .
            ASSIGN im-pg-sel:height = 1.20
                   im-pg-sel:row    = 1.50.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            HIDE FRAME {&PGCLA}.
              im-pg-cla:load-image("image/im-flddn") .
              im-pg-cla:move-to-bottom() .
            ASSIGN im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            HIDE FRAME {&PGPAR}.
              im-pg-par:load-image("image/im-flddn") .
              im-pg-par:move-to-bottom() .
            ASSIGN im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            HIDE FRAME {&PGDIG}.
              im-pg-dig:load-image("image/im-flddn") .
              im-pg-dig:move-to-bottom() .
            ASSIGN im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            HIDE FRAME {&PGIMP}.
              im-pg-imp:load-image("image/im-flddn") .
              im-pg-imp:move-to-bottom() .
            ASSIGN im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    END.



    WHEN "im-pg-cla" THEN DO WITH FRAME f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            HIDE FRAME {&PGSEL}.
              im-pg-sel:load-image("image/im-flddn") .
              im-pg-sel:move-to-bottom() .
            ASSIGN im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            VIEW FRAME {&PGCLA}.
            RUN pi-first-child (INPUT FRAME {&PGCLA}:handle).
              im-pg-cla:load-image("image/im-fldup") .
            ASSIGN im-pg-cla:height = 1.20
                   im-pg-cla:row    = 1.50.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            HIDE FRAME {&PGPAR}.
              im-pg-par:load-image("image/im-flddn") .
              im-pg-par:move-to-bottom() .
            ASSIGN im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            HIDE FRAME {&PGDIG}.
              im-pg-dig:load-image("image/im-flddn") .
              im-pg-dig:move-to-bottom() .
            ASSIGN im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            HIDE FRAME {&PGIMP}.
              im-pg-imp:load-image("image/im-flddn") .
              im-pg-imp:move-to-bottom() .
            ASSIGN im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    END.



    WHEN "im-pg-par" THEN DO WITH FRAME f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            HIDE FRAME {&PGSEL}.
              im-pg-sel:load-image("image/im-flddn") .
              im-pg-sel:move-to-bottom() .
            ASSIGN im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            HIDE FRAME {&PGCLA}.
              im-pg-cla:load-image("image/im-flddn") .
              im-pg-cla:move-to-bottom() .
            ASSIGN im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            VIEW FRAME {&PGPAR}.
            RUN pi-first-child (INPUT FRAME {&PGPAR}:handle).
              im-pg-par:load-image("image/im-fldup") .
            ASSIGN im-pg-par:height = 1.20
                   im-pg-par:row    = 1.5.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            HIDE FRAME {&PGDIG}.
              im-pg-dig:load-image("image/im-flddn") .
              im-pg-dig:move-to-bottom() .
            ASSIGN im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            HIDE FRAME {&PGIMP}.
              im-pg-imp:load-image("image/im-flddn") .
              im-pg-imp:move-to-bottom() .
            ASSIGN im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    END.



    WHEN "im-pg-dig" THEN DO WITH FRAME f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            HIDE FRAME {&PGSEL}.
              im-pg-sel:load-image("image/im-flddn") .
              im-pg-sel:move-to-bottom() .
            ASSIGN im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            HIDE FRAME {&PGCLA}.
              im-pg-cla:load-image("image/im-flddn") .
              im-pg-cla:move-to-bottom() .
            ASSIGN im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            HIDE FRAME {&PGPAR}.
              im-pg-par:load-image("image/im-flddn") .
              im-pg-par:move-to-bottom() .
            ASSIGN im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            VIEW FRAME {&PGDIG}.
            RUN pi-first-child (INPUT FRAME {&PGDIG}:handle).
              im-pg-dig:load-image("image/im-fldup") .
            ASSIGN im-pg-dig:height = 1.20
                   im-pg-dig:row    = 1.5.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            HIDE FRAME {&PGIMP}.
              im-pg-imp:load-image("image/im-flddn") .
              im-pg-imp:move-to-bottom() .
            ASSIGN im-pg-imp:height = 1
                   im-pg-imp:row    = 1.6.
        &ENDIF
    END.



    WHEN "im-pg-imp" THEN DO WITH FRAME f-relat:
        &IF "{&PGSEL}" <> "" &THEN
            HIDE FRAME {&PGSEL}.
              im-pg-sel:load-image("image/im-flddn") .
              im-pg-sel:move-to-bottom() .
            ASSIGN im-pg-sel:height = 1
                   im-pg-sel:row    = 1.6.
        &ENDIF
        &IF "{&PGCLA}" <> "" &THEN
            HIDE FRAME {&PGCLA}.
              im-pg-cla:load-image("image/im-flddn") .
              im-pg-cla:move-to-bottom() .
            ASSIGN im-pg-cla:height = 1
                   im-pg-cla:row    = 1.6.
        &ENDIF
        &IF "{&PGPAR}" <> "" &THEN
            HIDE FRAME {&PGPAR}.
              im-pg-par:load-image("image/im-flddn") .
              im-pg-par:move-to-bottom() .
            ASSIGN im-pg-par:height = 1
                   im-pg-par:row    = 1.6.
        &ENDIF
        &IF "{&PGDIG}" <> "" &THEN
            HIDE FRAME {&PGDIG}.
              im-pg-dig:load-image("image/im-flddn") .
              im-pg-dig:move-to-bottom() .
            ASSIGN im-pg-dig:height = 1
                   im-pg-dig:row    = 1.6.
        &ENDIF
        &IF "{&PGIMP}" <> "" &THEN
            VIEW FRAME {&PGIMP}.
            RUN pi-first-child (INPUT FRAME {&PGIMP}:handle).
              im-pg-imp:load-image("image/im-fldup") .
            ASSIGN im-pg-imp:height = 1.20
                   im-pg-imp:row    = 1.5.
        &ENDIF
    END.
END CASE.

i-current-folder = LOOKUP(SELF:name,c-list-folders).


&ENDIF
END PROCEDURE.

PROCEDURE send-records :
    /* Define variables needed by this internal procedure.               */ 
    /* For each requested table, put it':Us ROWID in the output list.      */
    /* Deal with any unexpected table requests before closing.           */ 
END PROCEDURE.

PROCEDURE state-changed :
    DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
    RUN pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

PROCEDURE pi-muda-cor-label-folder:
   DEF INPUT PARAMETER p-cod-label AS CHAR.
   DEF VAR wh-pai   AS WIDGET-HANDLE.
   DEF VAR wh-filho AS WIDGET-HANDLE.

   ASSIGN wh-pai = FRAME f-relat:handle
          wh-pai = wh-pai:FIRST-CHILD.
          
   DO WHILE wh-pai <> ?:
      DO WHILE VALID-HANDLE(wh-pai):
         ASSIGN wh-filho = wh-pai:FIRST-CHILD.
         DO  WHILE VALID-HANDLE(wh-filho):
            IF wh-filho:TYPE = "TEXT" THEN
               IF wh-filho:SCREEN-VALUE = p-cod-label THEN
                  ASSIGN wh-filho:FGCOLOR = 7.
               ASSIGN wh-filho = wh-filho:NEXT-SIBLING.
         END.
         ASSIGN wh-pai = wh-pai:NEXT-SIBLING.
      END.
   END.
END PROCEDURE.

PROCEDURE OpenDocument:

    DEF INPUT PARAM c-doc AS CHAR.
    DEF VAR c-exec AS CHAR.
    DEF VAR h-Inst AS INT.

    ASSIGN c-exec = FILL("x",255).
    RUN FindExecutableA (INPUT c-doc,
                         INPUT "",
                         INPUT-OUTPUT c-exec,
                         OUTPUT h-inst).

    IF h-inst >= 0 AND h-inst <=32 THEN
      RUN ShellExecuteA (INPUT 0,
                         INPUT "open",
                         INPUT "rundll32.exe",
                         INPUT "shell32.dll,OpenAs_RunDLL " + c-doc,
                         INPUT "",
                         INPUT 1,
                         OUTPUT h-inst).

    RUN ShellExecuteA (INPUT 0,
                       INPUT "open",
                       INPUT c-doc,
                       INPUT "",
                       INPUT "",
                       INPUT 1,
                       OUTPUT h-inst).

    IF h-inst < 0 OR h-inst > 32 THEN RETURN "OK".
    ELSE RETURN "NOK".

END PROCEDURE.

PROCEDURE FindExecutableA EXTERNAL "Shell32.dll":

    DEFINE INPUT PARAMETER lpFile AS CHAR.
    DEFINE INPUT PARAMETER lpDirectory AS CHAR.
    DEFINE INPUT-OUTPUT PARAMETER lpResult AS CHAR.
    DEFINE RETURN PARAMETER hInstance AS long.

END.

PROCEDURE ShellExecuteA EXTERNAL "Shell32.dll":

    DEFINE INPUT PARAMETER hwnd AS long.
    DEFINE INPUT PARAMETER lpOperation AS CHAR.
    DEFINE INPUT PARAMETER lpFile AS CHAR.
    DEFINE INPUT PARAMETER lpParameters AS CHAR.
    DEFINE INPUT PARAMETER lpDirectory AS CHAR.
    DEFINE INPUT PARAMETER nShowCmd AS long.
    DEFINE RETURN PARAMETER hInstance AS long.

END PROCEDURE.

