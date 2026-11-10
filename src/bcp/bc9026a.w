&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9026A 2.00.00.029 } /*** "010029" 14/08/2023 08:00:53  ***/

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
&GLOBAL-DEFINE Program        BC9026A
&GLOBAL-DEFINE Version        2.00.00.029
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */
DEF INPUT PARAM h-handleParam      AS HANDLE                                  NO-UNDO.
DEF INPUT PARAM l-habilita         AS INTEGER                                 NO-UNDO.
DEF INPUT PARAM c-cod-estabel      LIKE wm-item-embalagem-local.cod-estabel   NO-UNDO.
DEF INPUT PARAM c-cod-local        LIKE wm-item-embalagem-local.cod-local     NO-UNDO.
DEF INPUT PARAM i-id-docto         LIKE wm-docto-itens.id-docto               NO-UNDO.
DEF INPUT PARAM c-num-docto        LIKE wm-docto.num-docto                    NO-UNDO.
DEF INPUT PARAM num-seq-item       LIKE wm-docto-itens.num-seq-item           NO-UNDO.
DEF INPUT PARAM it-codigo          LIKE wm-item.cod-item                      NO-UNDO.
DEF INPUT PARAM lote               LIKE bc-etiqueta.lote                      NO-UNDO.
DEF INPUT PARAM cod-refer          AS CHARACTER FORMAT "x(8)"                 NO-UNDO.
DEF INPUT PARAM cod-embalagem      AS CHARACTER FORMAT "X(10)"                NO-UNDO.
DEF INPUT PARAM qtd-item           AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U     NO-UNDO.
DEF INPUT PARAM qtd-peso-item      AS DECIMAL FORMAT ">,>>>,>>9.9999":U       NO-UNDO.
DEF INPUT PARAM qtd-etiqueta       AS INTEGER                                 NO-UNDO.
DEF INPUT PARAM qtd-item-embalagem AS DECIMAL FORMAT ">,>>>,>>9.9999":U       NO-UNDO.
DEF INPUT PARAM i-tipo-geracao     AS INTEGER                                 NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VAR h-bosc040            AS HANDLE  NO-UNDO.
DEFINE VAR h-bosc044            AS HANDLE  NO-UNDO.
DEFINE VAR i-ind-tipo-contr-est AS INTEGER NO-UNDO.
DEFINE VAR de-qtd-peso-aux      AS DECIMAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE NO

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar i-num-seq-item c-cod-item ~
c-des-item c-cod-lote c-cod-refer c-cod-embalagem c-des-embalagem ~
de-qtd-item de-qtd-item-original de-qtd-peso i-qtd-etiqueta btOK btCancel 
&Scoped-Define DISPLAYED-OBJECTS i-num-seq-item c-cod-item c-des-item ~
c-cod-lote c-cod-refer c-cod-embalagem c-des-embalagem de-qtd-item ~
de-qtd-item-original de-qtd-peso i-qtd-etiqueta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-embalagem AS CHARACTER FORMAT "X(10)":U 
     LABEL "Embalagem" 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-item AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-lote AS CHARACTER FORMAT "X(40)":U 
     LABEL "Lote" 
     VIEW-AS FILL-IN 
     SIZE 42.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-refer AS CHARACTER FORMAT "X(8)":U 
     LABEL "Referˆncia" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-embalagem AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 23.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-item AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Item" 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-item-original AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Original" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-peso AS DECIMAL FORMAT ">,>>>,>>9.9999" INITIAL 0 
     LABEL "Peso Item" 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-seq-item AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Sequˆncia" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-qtd-etiqueta AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Qtd Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 62.29 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     i-num-seq-item AT ROW 1.46 COL 12.57 COLON-ALIGNED
     c-cod-item AT ROW 2.46 COL 12.57 COLON-ALIGNED
     c-des-item AT ROW 2.46 COL 31.14 COLON-ALIGNED NO-LABEL
     c-cod-lote AT ROW 3.46 COL 12.57 COLON-ALIGNED
     c-cod-refer AT ROW 4.46 COL 12.57 COLON-ALIGNED
     c-cod-embalagem AT ROW 5.46 COL 12.57 COLON-ALIGNED
     c-des-embalagem AT ROW 5.46 COL 30.57 COLON-ALIGNED NO-LABEL
     de-qtd-item AT ROW 6.46 COL 12.57 COLON-ALIGNED
     de-qtd-item-original AT ROW 6.46 COL 39.43 COLON-ALIGNED
     de-qtd-peso AT ROW 7.46 COL 12.57 COLON-ALIGNED
     i-qtd-etiqueta AT ROW 8.46 COL 12.57 COLON-ALIGNED
     btOK AT ROW 9.83 COL 2.14
     btCancel AT ROW 9.83 COL 13
     rtToolBar AT ROW 9.63 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.29 BY 10.08
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 10.04
         WIDTH              = 62.14
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
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
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = YES.

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

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
      In a persistently run window, just ignore this.  If we did not, the
      application would exit. */
   IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
   /* This event will close the window and terminate the procedure.  */
   {report/logfin.i}  
   ASSIGN it-codigo = "".

   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RUN destroyInstance IN THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
   ASSIGN it-codigo = "".
	
   APPLY "CLOSE":U TO THIS-PROCEDURE.	
	RUN destroyInstance IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
   IF i-num-seq-item:SENSITIVE IN FRAME fPage0 = YES THEN DO:
      RUN LeaveItem IN THIS-PROCEDURE.      
      IF RETURN-VALUE = "NOK":U THEN DO:
         APPLY 'entry':U TO i-num-seq-item IN FRAME fPage0.
         RETURN "NOK":U.
      END.
   END.
    
   IF c-cod-lote:SENSITIVE IN FRAME fPage0 = YES AND c-cod-lote:SCREEN-VALUE IN FRAME fPage0 = "" THEN DO:
      {utp/ut-liter.i "Lote" *}
      RUN utp/ut-msgs.p("SHOW":U,
                        36,
                        RETURN-VALUE).
      APPLY 'ENTRY':U TO c-cod-lote IN FRAME fPage0.
      RETURN "NOK":U.
   END.	
	
   IF i-id-docto <> 0 AND INT(i-num-seq-item:SCREEN-VALUE IN FRAME fPage0) <> 0 THEN DO:
      FIND FIRST bc-etiqueta
           WHERE bc-etiqueta.it-codigo        = c-cod-item:SCREEN-VALUE IN FRAME fPage0
             AND (bc-etiqueta.id-docto        = i-id-docto AND i-id-docto <> 0) 
             AND (bc-etiqueta.sequencia-docto = INTEGER(i-num-seq-item:SCREEN-VALUE IN FRAME fPage0) 
             AND INTEGER(i-num-seq-item:SCREEN-VALUE IN FRAME fPage0) <> 0) NO-LOCK NO-ERROR.
      IF AVAIL bc-etiqueta THEN DO:
         DEF VAR c-sequencia-item AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Sequˆncia_de_item" *}
         ASSIGN c-sequencia-item = TRIM(RETURN-VALUE).
         DEF VAR c-etiquetas-imp AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "etiquetas_impressas" *}
         ASSIGN c-etiquetas-imp = TRIM(RETURN-VALUE).
         RUN utp/ut-msgs.p("SHOW":U,
                           34995,
                           c-sequencia-item + "~~" + c-etiquetas-imp). /*&1 possui &2*/
      END.
   END.
   FIND FIRST wm-item-embalagem-etiq
        WHERE wm-item-embalagem-etiq.cod-item  = c-cod-item:SCREEN-VALUE IN FRAME fPage0
          AND wm-item-embalagem-etiq.cod-embal = c-cod-embalagem:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR.
   IF NOT AVAIL wm-item-embalagem-etiq THEN DO:
      RUN utp/ut-msgs.p("SHOW":U,
                        54752,
                        RETURN-VALUE).
      APPLY 'entry':U TO c-cod-embalagem IN FRAME fPage0.
      RETURN "NOK":U.
   END.

   IF DECIMAL(de-qtd-item:SCREEN-VALUE IN FRAME fPage0) = 0 THEN  DO:
      {utp/ut-liter.i "Quantidade_do_item" *}
      RUN utp/ut-msgs.p("SHOW":U,
                        36,
                        RETURN-VALUE).
      APPLY 'ENTRY':U TO de-qtd-item IN FRAME fPage0.
      RETURN "NOK":U.
   END.

   IF DECIMAL(i-qtd-etiqueta:SCREEN-VALUE IN FRAME fPage0) = 0 THEN DO:
      {utp/ut-liter.i "Quantidade_de_etiquetas" *}
      RUN utp/ut-msgs.p("SHOW":U,
                        36,
                        RETURN-VALUE).
      APPLY 'ENTRY':U TO i-qtd-etiqueta IN FRAME fPage0.
      RETURN "NOK":U.
   END.

   
   ASSIGN de-qtd-peso-aux = 0. 

   RUN goToKey IN h-bosc044(INPUT c-cod-item:SCREEN-VALUE IN FRAME fPage0).
   IF RETURN-VALUE = "OK" THEN DO:
      RUN getDecField IN h-bosc044( INPUT "qtd-peso":U,
                                    OUTPUT de-qtd-peso-aux).
   END.                                 
   IF de-qtd-peso-aux > 0 AND DECIMAL(de-qtd-peso:SCREEN-VALUE IN FRAME fPage0) = 0 THEN  DO:
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Peso" *}
      RUN utp/ut-msgs.p("SHOW":U,
                        36,
                        RETURN-VALUE).
   END.
   ELSE DO:
      FIND FIRST wm-item-embalagem-local
           WHERE wm-item-embalagem-local.cod-estabel  = c-cod-estabel
             AND wm-item-embalagem-local.cod-local    = c-cod-local
             AND wm-item-embalagem-local.cod-item     = c-cod-item:SCREEN-VALUE IN FRAME fPage0
             AND (wm-item-embalagem-local.cod-embal    = c-cod-embalagem:SCREEN-VALUE IN FRAME fPage0
              OR wm-item-embalagem-local.cod-emb-item = c-cod-embalagem:SCREEN-VALUE IN FRAME fPage0) NO-LOCK NO-ERROR.
      IF AVAIL wm-item-embalagem-local THEN DO:
         IF (wm-item-embalagem-local.cod-embal     = c-cod-embalagem:SCREEN-VALUE IN FRAME fPage0
            AND wm-item-embalagem-local.qtd-item-emb >= DECIMAL(de-qtd-item:SCREEN-VALUE IN FRAME fPage0))
             OR (wm-item-embalagem-local.cod-emb-item  = c-cod-embalagem:SCREEN-VALUE IN FRAME fPage0
            AND wm-item-embalagem-local.qtd-emb-item >= DECIMAL(de-qtd-item:SCREEN-VALUE IN FRAME fPage0)) THEN DO:
                    
            ASSIGN num-seq-item  = INT(i-num-seq-item:SCREEN-VALUE IN FRAME fPage0)
                   it-codigo     = c-cod-item:SCREEN-VALUE IN FRAME fPage0
                   lote          = c-cod-lote:SCREEN-VALUE IN FRAME fPage0
                   cod-refer     = c-cod-refer:SCREEN-VALUE IN FRAME fPage0
                   cod-embalagem = c-cod-embalagem:SCREEN-VALUE IN FRAME fPage0
                   qtd-item      = DECIMAL(de-qtd-item:SCREEN-VALUE IN FRAME fPage0)
                   qtd-peso-item = DECIMAL(de-qtd-peso:SCREEN-VALUE IN FRAME fPage0)
                   qtd-etiqueta  = INTEGER(i-qtd-etiqueta:SCREEN-VALUE IN FRAME fPage0).

            IF wm-item-embalagem-local.cod-embal = c-cod-embalagem:SCREEN-VALUE IN FRAME fPage0 THEN DO:
               ASSIGN qtd-item-embalagem = wm-item-embalagem-local.qtd-item-emb.
            END.
            ELSE DO:
               ASSIGN qtd-item-embalagem = wm-item-embalagem-local.qtd-emb-item.
            END.
            RUN destroyInstance IN THIS-PROCEDURE.
            APPLY "CLOSE":U TO THIS-PROCEDURE.
         END.
         ELSE DO:
            DEF VAR c-quantidade-item AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Quantidade_do_item" *}
            ASSIGN c-quantidade-item = TRIM(RETURN-VALUE).
            DEF VAR c-o-limite AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "o_limite_permitido_por_embalagem" *}
            ASSIGN c-o-limite = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p("SHOW":U,
                              6671,
                              c-quantidade-item + "~~" + c-o-limite). /*&1 ultrapassa &2*/
         END.
      END.
      ELSE DO:
         DEF VAR c-quantidade-item2 AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Quantidade_do_item" *}
         ASSIGN c-quantidade-item2 = TRIM(RETURN-VALUE).
         DEF VAR c-o-limite2 AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "o_limite_permitido_por_embalagem" *}
         ASSIGN c-o-limite2 = TRIM(RETURN-VALUE).
         RUN utp/ut-msgs.p("SHOW":U,
                           6671,
                           c-quantidade-item2 + "~~" + c-o-limite2). /*&1 ultrapassa &2*/
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-embalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-embalagem wReport
ON ENTRY OF c-cod-embalagem IN FRAME fpage0 /* Embalagem */
DO:
   IF i-num-seq-item:SENSITIVE IN FRAME fPage0 = YES THEN
      RUN LeaveItem IN THIS-PROCEDURE. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-embalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-embalagem wReport
ON F5 OF c-cod-embalagem IN FRAME fpage0 /* Embalagem */
DO:
   {method/zoomfields.i
      &ProgramZoom="sczoom/z01sc040.w"
      &FieldZoom1="cod-embalagem"
      &FieldScreen1="c-cod-embalagem"
      &Frame1="fPage0"
      &FieldZoom2="des-embalagem"
      &FieldScreen2="c-des-embalagem"
      &Frame2="fPage0"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-embalagem wReport
ON LEAVE OF c-cod-embalagem IN FRAME fpage0 /* Embalagem */
DO:
   RUN goToKey IN h-bosc040(INPUT c-cod-embalagem:SCREEN-VALUE IN FRAME fPage0).
   IF RETURN-VALUE = "OK" THEN
      RUN getCharField IN h-bosc040(INPUT "des-embalagem":U,
                                    OUTPUT c-des-embalagem).
   ELSE
      ASSIGN c-des-embalagem = "".
    
   ASSIGN c-des-embalagem:SCREEN-VALUE IN FRAME fPage0 = c-des-embalagem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-embalagem wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-embalagem IN FRAME fpage0 /* Embalagem */
DO:
   APPLY "F5" TO SELF.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-item wReport
ON F5 OF c-cod-item IN FRAME fpage0 /* Item */
DO:
   {include/zoomvar.i
      &prog-zoom=bcp/bc8208.w
      &campo=c-cod-item
      &campozoom=it-codigo
      &frame=fPage0}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-item wReport
ON LEAVE OF c-cod-item IN FRAME fpage0 /* Item */
DO:
   RUN goToKey IN h-bosc044(INPUT c-cod-item:SCREEN-VALUE IN FRAME fPage0).
   IF RETURN-VALUE = "OK" THEN DO:
      RUN getCharField IN h-bosc044(INPUT "des-item":U,
                                    OUTPUT c-des-item).
      
      RUN getDecField IN h-bosc044( INPUT "qtd-peso":U,
                                    OUTPUT de-qtd-peso).
	
      ASSIGN c-des-item:SCREEN-VALUE IN FRAME fPage0  = c-des-item
             de-qtd-peso:SCREEN-VALUE IN FRAME fPage0 = STRING(de-qtd-peso).
	END.
   ELSE DO:
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Item" *}
      RUN utp/ut-msgs.p("SHOW":U,
                        56,
                        RETURN-VALUE).
      UNDO, LEAVE.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-item wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-item IN FRAME fpage0 /* Item */
DO:
   APPLY "F5" TO SELF.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-qtd-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-qtd-item wReport
ON ENTRY OF de-qtd-item IN FRAME fpage0 /* Qtd Item */
DO:
   IF i-num-seq-item:SENSITIVE IN FRAME fPage0 = YES THEN
      RUN LeaveItem IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME de-qtd-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-qtd-item wReport
ON LEAVE OF de-qtd-item IN FRAME fpage0 /* Qtd Item */
DO:
   FIND FIRST wm-item-embalagem-local
        WHERE wm-item-embalagem-local.cod-estabel   = c-cod-estabel
          AND wm-item-embalagem-local.cod-local     = c-cod-local
          AND wm-item-embalagem-local.cod-item      = c-cod-item:SCREEN-VALUE IN FRAME fPage0
          AND wm-item-embalagem-local.cod-embalagem = c-cod-embalagem:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR.
   IF AVAIL wm-item-embalagem-local THEN DO:
      ASSIGN i-qtd-etiqueta = DECIMAL(de-qtd-item:SCREEN-VALUE IN FRAME fPage0) / wm-item-embalagem-local.qtd-item-emb.

      IF (DECIMAL(de-qtd-item:SCREEN-VALUE IN FRAME fPage0) - (i-qtd-etiqueta * wm-item-embalagem-local.qtd-item-emb)) > 0 THEN
          ASSIGN i-qtd-etiqueta = i-qtd-etiqueta + 1.

      ASSIGN i-qtd-etiqueta:SCREEN-VALUE IN FRAME fPage0 = STRING(i-qtd-etiqueta).
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-qtd-peso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-qtd-peso wReport
ON ENTRY OF de-qtd-peso IN FRAME fpage0 /* Qtd Peso */
DO:
   IF i-num-seq-item:SENSITIVE IN FRAME fPage0 = YES THEN
      RUN LeaveItem IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-qtd-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-qtd-etiqueta wReport
ON ENTRY OF i-qtd-etiqueta IN FRAME fpage0 /* Qtd Peso */
DO:
   IF i-num-seq-item:SENSITIVE IN FRAME fPage0 = YES THEN
      RUN LeaveItem IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport
   IF VALID-HANDLE(h-handleParam) THEN
      RUN piBloqWindow IN h-handleParam. 
    
   RUN InitializeDBOS.
   RUN goToKey IN h-bosc044(INPUT it-codigo).
   IF RETURN-VALUE = "OK" THEN DO:
      RUN getIntField IN h-bosc044( INPUT "ind-tipo-contr-est":U,
                                    OUTPUT i-ind-tipo-contr-est).
   END.
   
   IF l-habilita = 1 THEN DO:
      ASSIGN i-num-seq-item:SENSITIVE IN FRAME fPage0 = NO
             c-cod-item:SENSITIVE IN FRAME fPage0     = NO
             c-cod-refer:Sensitive IN FRAME fPage0    = NO.
      IF lote = "" AND i-ind-tipo-contr-est <> 1 THEN
         ASSIGN c-cod-lote:Sensitive IN FRAME fPage0 = YES.
      ELSE
         ASSIGN c-cod-lote:Sensitive IN FRAME fPage0 = NO.
   END.
   IF l-habilita = 2 THEN DO:
      ASSIGN i-num-seq-item:SENSITIVE IN FRAME fPage0 = YES
             c-cod-item:SENSITIVE IN FRAME fPage0     = NO
             c-cod-lote:SENSITIVE IN FRAME fPage0     = NO
             c-cod-refer:SENSITIVE IN FRAME fPage0    = NO.
   END.
   IF l-habilita = 3 THEN DO:
      ASSIGN i-num-seq-item:SENSITIVE IN FRAME fPage0 = NO
             c-cod-item:SENSITIVE IN FRAME fPage0     = NO
             c-cod-lote:SENSITIVE IN FRAME fPage0     = NO
             c-cod-refer:SENSITIVE IN FRAME fPage0    = NO.
   END.
   IF l-habilita = 4 THEN DO:
      ASSIGN i-num-seq-item:SENSITIVE IN FRAME fPage0 = YES
             c-cod-item:SENSITIVE IN FRAME fPage0     = NO
             c-cod-refer:Sensitive IN FRAME fPage0    = NO.
      IF lote = "" AND i-ind-tipo-contr-est <> 1 THEN
         ASSIGN c-cod-lote:SENSITIVE IN FRAME fPage0 = YES.
      ELSE
         ASSIGN c-cod-lote:SENSITIVE IN FRAME fPage0 = NO.
   END.
   
   ASSIGN c-des-item:SENSITIVE IN FRAME fPage0         = NO
          c-cod-embalagem:SENSITIVE IN FRAME fPage0    = YES
          c-des-embalagem:SENSITIVE IN FRAME fPage0    = NO
          de-qtd-item:SENSITIVE IN FRAME fPage0        = YES
          de-qtd-peso:SENSITIVE IN FRAME fPage0        = YES
          i-qtd-etiqueta:SENSITIVE IN FRAME fPage0     = YES
          i-num-seq-item:SCREEN-VALUE IN FRAME fPage0  = STRING(num-seq-item)
          c-cod-item:SCREEN-VALUE IN FRAME fPage0      = it-codigo
          c-cod-lote:SCREEN-VALUE IN FRAME fPage0      = lote
          c-cod-refer:SCREEN-VALUE IN FRAME fPage0     = cod-refer
          c-cod-embalagem:SCREEN-VALUE IN FRAME fPage0 = cod-embalagem
          de-qtd-item:SCREEN-VALUE IN FRAME fPage0     = STRING(qtd-item)
          de-qtd-peso:SCREEN-VALUE IN FRAME fPage0     = STRING(qtd-peso-item)
          i-qtd-etiqueta:SCREEN-VALUE IN FRAME fPage0  = STRING(qtd-etiqueta).
   
   
   IF l-habilita = 1 THEN
      APPLY 'leave':U TO c-cod-item IN FRAME fPage0.
   
   IF l-habilita = 3 AND num-seq-item <> 0 THEN
      APPLY 'leave':U TO i-num-seq-item IN FRAME fPage0.
          
   c-cod-embalagem:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME fPage0.
   c-cod-item:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME fPage0.
   
   {report/mainblock.i}
   
   /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeDBOS wReport 
PROCEDURE InitializeDBOS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF NOT VALID-HANDLE(h-bosc040)
      OR h-bosc040:TYPE <> "PROCEDURE":U
      OR h-bosc040:FILE-NAME <> "scbo/bosc040.p":U THEN 
      RUN scbo/bosc040.p PERSISTENT SET h-bosc040.
   RUN openQueryStatic IN h-bosc040 (INPUT "Main":U) NO-ERROR.

   IF NOT VALID-HANDLE(h-bosc044)
      OR h-bosc044:TYPE <> "PROCEDURE":U
      OR h-bosc044:FILE-NAME <> "scbo/bosc044.p":U THEN 
      RUN scbo/bosc044.p PERSISTENT SET h-bosc044.
   RUN openQueryStatic IN h-bosc044 (INPUT "Main":U) NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveItem wReport 
PROCEDURE LeaveItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF INTEGER(i-num-seq-item:SCREEN-VALUE IN FRAME fPage0) <> 0 THEN DO:
      IF i-id-docto <> 0 THEN DO:
         FIND FIRST wm-docto-itens
              WHERE wm-docto-itens.cod-estabel  = c-cod-estabel
                AND wm-docto-itens.cod-local    = c-cod-local
                AND wm-docto-itens.id-docto     = i-id-docto
                AND wm-docto-itens.num-seq-item = INTEGER(i-num-seq-item:SCREEN-VALUE IN FRAME fPage0) NO-LOCK NO-ERROR.
         IF AVAIL wm-docto-itens THEN DO:
            ASSIGN c-cod-item:SCREEN-VALUE IN FRAME fPage0           = wm-docto-itens.cod-item
                   c-cod-lote:SCREEN-VALUE IN FRAME fPage0           = wm-docto-itens.cod-lote
                   c-cod-refer:SCREEN-VALUE IN FRAME fPage0          = wm-docto-itens.cod-refer
                   de-qtd-item-original:SCREEN-VALUE IN FRAME fPage0 = STRING(wm-docto-itens.qtd-item).
            APPLY 'leave':U TO c-cod-item IN FRAME fPage0.
         END.
         ELSE DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Sequˆncia_de_Item" *}
            RUN utp/ut-msgs.p("SHOW":U,
                              56,
                              RETURN-VALUE).
            APPLY 'entry':U TO i-num-seq-item IN FRAME fPage0.
            RETURN "NOK".
         END.
      END.
      ELSE DO:
         FIND FIRST rat-lote
              WHERE rat-lote.nro-docto    = c-num-docto
                AND rat-lote.sequencia    = INTEGER(i-num-seq-item:SCREEN-VALUE IN FRAME fPage0)
                AND rat-lote.nat-operacao = "" NO-LOCK NO-ERROR.
         IF AVAIL rat-lote THEN DO:
            ASSIGN c-cod-item:SCREEN-VALUE IN FRAME fPage0           = rat-lote.it-codigo
                   c-cod-lote:SCREEN-VALUE IN FRAME fPage0           = rat-lote.lote
                   de-qtd-item-original:SCREEN-VALUE IN FRAME fPage0 = STRING(rat-lote.quantidade).
            
            FIND FIRST it-doc-fisico
                 WHERE it-doc-fisico.nro-docto = c-num-docto
                   AND it-doc-fisico.sequencia = rat-lote.sequencia
                   AND it-doc-fisico.it-codigo = rat-lote.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL it-doc-fisico THEN
               ASSIGN c-cod-refer:SCREEN-VALUE IN FRAME fPage0 = it-doc-fisico.cod-refer.
            ELSE
               ASSIGN c-cod-refer:SCREEN-VALUE IN FRAME fPage0 = "".
               APPLY 'leave':U TO c-cod-item IN FRAME fPage0.
         END.
         ELSE DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Sequˆncia_de_Item" *}
            RUN utp/ut-msgs.p("SHOW":U,
                              56,
                              RETURN-VALUE).
            APPLY 'entry':U TO i-num-seq-item IN FRAME fPage0.
            RETURN "NOK":U.
         END.
      END.
   END.
   ELSE DO:
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Sequˆncia_de_Item" *}
      RUN utp/ut-msgs.p("SHOW":U,
                        56,
                        RETURN-VALUE).
      APPLY 'entry':U TO i-num-seq-item IN FRAME fPage0.
      RETURN "NOK":U.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyInstance wReport 	
PROCEDURE destroyInstance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(h-handleParam) THEN DO:
      RUN piAtualizaChaveReg IN h-handleParam ( INPUT num-seq-item,
                                                INPUT it-codigo,
                                                INPUT lote,
                                                INPUT cod-refer,
                                                INPUT cod-embalagem,
                                                INPUT qtd-item,
                                                INPUT qtd-peso-item,
                                                INPUT qtd-etiqueta,
                                                INPUT qtd-item-embalagem,
                                                INPUT i-tipo-geracao). 
      RUN piAtualizaReg IN h-handleParam.
      RUN piLibWindow IN h-handleParam.
   END.

   IF VALID-HANDLE(h-bosc040) THEN DO:
		RUN destroy IN h-bosc040.
		DELETE OBJECT h-bosc040 NO-ERROR.
		ASSIGN h-bosc040 = ?.
	END.
	
   IF VALID-HANDLE(h-bosc044) THEN DO:
      RUN destroy IN h-bosc044.
      DELETE OBJECT h-bosc044 NO-ERROR.
      ASSIGN h-bosc044 = ?.
   END.
	RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
