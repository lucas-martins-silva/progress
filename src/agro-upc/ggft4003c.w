&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT4003C 2.00.00.008 } /*** "010008" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ggft4003c GGP}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF INPUT PARAM wh-wt-docto AS ROWID.

/* Local Variable Definitions ---                                       */
DEF NEW GLOBAL SHARED VAR wh-cidade-cif-ft4003b     AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE i-tara          AS INTEGER    NO-UNDO INIT 0.
DEFINE VARIABLE i-liq           AS INTEGER    NO-UNDO INIT 0.
DEF    VAR      c-end           AS CHAR FORMAT "X(30)".
DEF    VAR      l-tem-permissao AS LOGICAL.
DEF    VAR      l-balanca-tara  AS LOGICAL. 
DEF    VAR      l-balanca-liq   AS LOGICAL.   
DEF    VAR      l-tem-permis    AS LOGICAL. 
def    var      l-permissao     as logical                    no-undo.
DEFINE VARIABLE c-peso-aux      AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-estab         like estabelec.cod-estabel    no-undo.
DEFINE VARIABLE c-lista-aux     AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-cod-balan     like gg-balan-usuar.cod-balan NO-UNDO.

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS log-transito d-p-bruto Bt-Balanca d-p-tara ~
Bt-Balanca-2 bt-ok bt-cancela bt-ajuda c-bruto c-tara cb-balanca RECT-1 ~
RECT-13 RECT-2 rt-buttom 
&Scoped-Define DISPLAYED-OBJECTS log-transito d-p-bruto d-p-tara ~
d-p-liquido c-bruto c-tara cb-balanca 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Bt-Balanca 
     IMAGE-UP FILE "image/im-carg.bmp":U
     LABEL "Button 5" 
     SIZE 4 BY 1.08 TOOLTIP "Balan»a".

DEFINE BUTTON Bt-Balanca-2 
     IMAGE-UP FILE "image/im-carg.bmp":U
     LABEL "Bt balanca 2" 
     SIZE 4 BY 1.08 TOOLTIP "Balan»a".

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 FONT 4.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE cb-balanca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Balanca" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 34.72 BY 1 NO-UNDO.

DEFINE VARIABLE c-bruto AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 2 BY .67 NO-UNDO.

DEFINE VARIABLE c-tara AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 2 BY .67 NO-UNDO.

DEFINE VARIABLE d-p-bruto AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso Bruto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-p-liquido AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso L¡quido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-p-tara AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso Tara" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54 BY 1.38.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54 BY 1.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54 BY 3.38.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 54 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE log-transito AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal Controla Trƒnsito?" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .58 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     log-transito AT ROW 1.21 COL 13
     d-p-bruto AT ROW 3.42 COL 11 COLON-ALIGNED
     Bt-Balanca AT ROW 3.29 COL 29.29
     d-p-tara AT ROW 4.42 COL 11 COLON-ALIGNED
     Bt-Balanca-2 AT ROW 4.38 COL 29.29
     d-p-liquido AT ROW 5.92 COL 11 COLON-ALIGNED
     bt-ok AT ROW 7.42 COL 2
     bt-cancela AT ROW 7.42 COL 13
     bt-ajuda AT ROW 7.42 COL 43
     c-bruto AT ROW 2.63 COL 33 COLON-ALIGNED NO-LABEL
     c-tara AT ROW 3.63 COL 33 COLON-ALIGNED NO-LABEL
     cb-balanca AT ROW 2.42 COL 11 COLON-ALIGNED WIDGET-ID 2
     RECT-1 AT ROW 5.67 COL 1
     RECT-13 AT ROW 1 COL 1
     RECT-2 AT ROW 2.17 COL 1
     rt-buttom AT ROW 7.17 COL 1
     SPACE(0.00) SKIP(0.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Pesagem"
         DEFAULT-BUTTON bt-ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN d-p-liquido IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Pesagem */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda D-Dialog
ON CHOOSE OF bt-ajuda IN FRAME D-Dialog /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Bt-Balanca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Balanca D-Dialog
ON CHOOSE OF Bt-Balanca IN FRAME D-Dialog /* Button 5 */
DO:
    ASSIGN c-peso-aux = d-p-bruto:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    
    DEF VAR h-gg6000     AS HANDLE NO-UNDO.
    DEF VAR pdePeso        AS DEC    NO-UNDO.
    
    IF  NOT VALID-HANDLE(h-gg6000) THEN
        RUN ggp/ggapi6000.p PERSISTENT SET h-gg6000.

    RUN piRetornarPeso IN h-gg6000(c-seg-usuario,       
                                   c-estab,      
                                   input frame {&FRAME-NAME} cb-balanca,
                                   OUTPUT pdePeso).                                      

    IF  VALID-HANDLE(h-gg6000) THEN
        DELETE PROCEDURE h-gg6000.

    ASSIGN h-gg6000 = ?.
    ASSIGN d-p-bruto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(pdePeso).

    APPLY "leave" TO d-p-bruto IN FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Bt-Balanca-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Balanca-2 D-Dialog
ON CHOOSE OF Bt-Balanca-2 IN FRAME D-Dialog /* Bt balanca 2 */
DO:
    ASSIGN c-peso-aux = d-p-tara:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    DEF VAR h-gg6000     AS HANDLE NO-UNDO.
    DEF VAR pdePeso        AS DEC    NO-UNDO.
    
    IF  NOT VALID-HANDLE(h-gg6000) THEN
        RUN ggp/ggapi6000.p PERSISTENT SET h-gg6000.

    RUN piRetornarPeso IN h-gg6000(c-seg-usuario,       
                                   c-estab,      
                                   input frame {&FRAME-NAME} cb-balanca,
                                   OUTPUT pdePeso).                                      

    IF  VALID-HANDLE(h-gg6000) THEN
        DELETE PROCEDURE h-gg6000.

     ASSIGN h-gg6000 = ?
            d-p-tara:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(pdePeso).

     APPLY "leave" TO d-p-tara IN FRAME {&FRAME-NAME}. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:

   IF  VALID-HANDLE(wh-cidade-cif-ft4003b) THEN DO:
       IF  wh-cidade-cif-ft4003b:SCREEN-VALUE <> "" AND INPUT FRAME {&FRAME-NAME} log-transito = NO THEN DO:

           RUN utp/ut-msgs.p (INPUT "SHOW":U,
                              INPUT 34900,
                              INPUT RETURN-VALUE).

           APPLY "Entry" TO log-transito IN FRAME {&FRAME-NAME}.
           RETURN NO-APPLY.
       END.
   END.

  /*Pesagem*/                                                               
  FIND FIRST gg-ext-wt-docto EXCLUSIVE-LOCK                                 
      WHERE gg-ext-wt-docto.seq-wt-docto = wt-docto.seq-wt-docto NO-ERROR.  
  IF  NOT AVAIL gg-ext-wt-docto THEN DO:                                    
      CREATE gg-ext-wt-docto.                                               
      ASSIGN gg-ext-wt-docto.seq-wt-docto    = wt-docto.seq-wt-docto        
             gg-ext-wt-docto.cod-estabel     = wt-docto.cod-estabel         
             gg-ext-wt-docto.serie           = wt-docto.serie               
             gg-ext-wt-docto.nr-nota-fis     = wt-docto.nr-nota             
             gg-ext-wt-docto.qtd-peso-tara   = INPUT FRAME {&FRAME-NAME} d-p-tara        
             gg-ext-wt-docto.qtd-peso-bruto  = INPUT FRAME {&FRAME-NAME} d-p-bruto       
             gg-ext-wt-docto.qtd-peso-liq    = INPUT FRAME {&FRAME-NAME} d-p-liquido
             gg-ext-wt-docto.log-transito    = INPUT FRAME {&FRAME-NAME} log-transito.     

      /*Gerado Eletronico */ 
      IF  INPUT FRAME {&FRAME-NAME} d-p-bruto = i-liq THEN
          ASSIGN gg-ext-wt-docto.log-liq = YES.   
      
      IF  INPUT FRAME {&FRAME-NAME} d-p-tara  = i-tara    THEN
          ASSIGN gg-ext-wt-docto.log-tara = YES.  

      
  END.                                                                      
  ELSE DO:
      
      /*Bruto*/

      IF  i-liq <> 0 THEN DO:
          IF  INPUT FRAME {&FRAME-NAME} d-p-bruto = i-liq THEN DO:
              ASSIGN gg-ext-wt-docto.log-liq = YES.  
          END.
      END.
      ELSE DO: 
          IF  INPUT FRAME {&FRAME-NAME} d-p-bruto <> gg-ext-wt-docto.qtd-peso-bruto THEN
              ASSIGN gg-ext-wt-docto.log-liq = NO.  
      END.


      /*Tara*/
      IF  i-tara <> 0 THEN DO:
          IF  INPUT FRAME {&FRAME-NAME} d-p-tara  = i-tara    THEN
              ASSIGN gg-ext-wt-docto.log-tara = YES.  
      END.
      ELSE DO:
              IF  INPUT FRAME {&FRAME-NAME} d-p-tara  <> gg-ext-wt-docto.qtd-peso-tara    THEN
                  ASSIGN gg-ext-wt-docto.log-tara = NO.  
      END.
                                                  
      
      ASSIGN gg-ext-wt-docto.qtd-peso-tara   = INPUT FRAME {&FRAME-NAME} d-p-tara        
             gg-ext-wt-docto.qtd-peso-bruto  = INPUT FRAME {&FRAME-NAME} d-p-bruto       
             gg-ext-wt-docto.qtd-peso-liq    = INPUT FRAME {&FRAME-NAME} d-p-liquido
             gg-ext-wt-docto.log-transito    = INPUT FRAME {&FRAME-NAME} log-transito   .  
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-p-bruto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-p-bruto D-Dialog
ON F5 OF d-p-bruto IN FRAME D-Dialog /* Peso Bruto */
DO:
  APPLY "choose" TO Bt-Balanca IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-p-bruto D-Dialog
ON LEAVE OF d-p-bruto IN FRAME D-Dialog /* Peso Bruto */
DO:
  ASSIGN d-p-liquido:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(INPUT FRAME {&FRAME-NAME} d-p-bruto - INPUT FRAME {&FRAME-NAME} d-p-tara).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-p-tara
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-p-tara D-Dialog
ON F5 OF d-p-tara IN FRAME D-Dialog /* Peso Tara */
DO:
  APPLY "choose" TO Bt-Balanca-2 IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-p-tara D-Dialog
ON LEAVE OF d-p-tara IN FRAME D-Dialog /* Peso Tara */
DO:
  ASSIGN d-p-liquido:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(INPUT FRAME {&FRAME-NAME} d-p-bruto - INPUT FRAME {&FRAME-NAME} d-p-tara).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */


ASSIGN l-tem-permis = YES.

/** INICIALMENTE NÇO Hµ PERMISSÇO **/
ASSIGN l-permissao = NO.

RUN ggp/ggapi017.p (INPUT c-seg-usuario,
                    INPUT "Mov;Cod_Balanca",
                    INPUT "",
                    OUTPUT l-permissao).

if not l-permissao then do:

    Bt-Balanca-2:sensitive = no.
    Bt-Balanca:sensitive   = no.
    assign l-tem-permis    = no.

end.

ASSIGN    d-p-tara    = 0
          d-p-bruto   = 0
          d-p-liquido = 0.
 

 FIND FIRST wt-docto NO-LOCK                                                           
      WHERE ROWID(wt-docto) = wh-wt-docto  NO-ERROR.  
 IF  AVAIL wt-docto THEN DO:                                                    
     FIND FIRST gg-ext-wt-docto NO-LOCK                                         
         WHERE gg-ext-wt-docto.seq-wt-docto = wt-docto.seq-wt-docto NO-ERROR.   
     IF  AVAIL gg-ext-wt-docto THEN DO:                                     
         ASSIGN    d-p-tara     = gg-ext-wt-docto.qtd-peso-tara 
                   d-p-bruto    = gg-ext-wt-docto.qtd-peso-bruto
                   d-p-liquido  = gg-ext-wt-docto.qtd-peso-liq  
                   log-transito = gg-ext-wt-docto.log-transito
                   c-tara       = IF gg-ext-wt-docto.log-tara = YES THEN "B" ELSE "M"
                   c-bruto      = IF gg-ext-wt-docto.log-liq  = YES THEN "B" ELSE "M".
     END.

     IF  wt-docto.cidade-cif = "" THEN DO:
         ASSIGN log-transito = NO.
                log-transito:SENSITIVE = NO  .
     END.

     IF  wh-cidade-cif-ft4003b:SCREEN-VALUE <> "" THEN
         ASSIGN log-transito = YES.
                log-transito:SENSITIVE = YES.

 END.

 {src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY log-transito d-p-bruto d-p-tara d-p-liquido c-bruto c-tara cb-balanca 
      WITH FRAME D-Dialog.
  ENABLE log-transito d-p-bruto Bt-Balanca d-p-tara Bt-Balanca-2 bt-ok 
         bt-cancela bt-ajuda c-bruto c-tara cb-balanca RECT-1 RECT-13 RECT-2 
         rt-buttom 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy D-Dialog 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable D-Dialog 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  IF  d-p-bruto:SENSITIVE IN FRAME {&FRAME-NAME} = YES THEN DO:  
      ASSIGN l-tem-permissao = NO.                                            
      run ggp/ggapi017.p (input c-seg-usuario,                              
                          input "Mov;peso",                                 
                          input "",                                         
                          output l-tem-permissao).                          
      IF l-tem-permissao = YES  THEN DO:                                         
         ENABLE d-p-bruto d-p-tara WITH FRAME {&FRAME-NAME}.            
      END.                                                                  
      ELSE DO:                                                              
          disable d-p-bruto d-p-tara WITH FRAME {&FRAME-NAME}.            
      END.                                                                  
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

{utp/ut9000.i "GGFT4003C" "2.00.00.008"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  FIND FIRST wt-docto NO-LOCK                                                           
      WHERE ROWID(wt-docto) = wh-wt-docto  NO-ERROR.  
  if wh-cidade-cif-ft4003b:SCREEN-VALUE = ""  THEN DO:
      ASSIGN log-transito = NO.
             log-transito:SENSITIVE IN FRAME {&FRAME-NAME} = NO  .
  END.

  /* Code placed here will execute AFTER standard behavior.    */

  assign cb-balanca:list-item-pairs in frame {&frame-name} = ?.

  find first wt-docto
      where rowid(wt-docto) = wh-wt-docto no-lock no-error.
  if avail wt-docto then
      assign c-estab = wt-docto.cod-estabel.

  FOR EACH gg-balan-usuar NO-LOCK
      where gg-balan-usuar.cod-prog-dtsul = c-estab
        and gg-balan-usuar.cod-usuar      = c-seg-usuario
      break by gg-balan-usuar.cod-usuar:

      if first-of(gg-balan-usuar.cod-usuar) then
          assign c-cod-balan = gg-balan-usuar.cod-balan.

      find first gg-balanca no-lock 
          where gg-balanca.cod-balanca = gg-balan-usuar.cod-balan no-error.
      if avail gg-balanca then
          assign c-lista-aux = string(gg-balan-usuar.cod-balan, "x(12)") + " -- " +  gg-balanca.nome-balanca.
      else
          assign c-lista-aux =  string(gg-balan-usuar.cod-balan, "x(12)") + " -- ".

      cb-balanca:add-last (c-lista-aux,string(gg-balan-usuar.cod-balan, "x(12)")).
  end.  

  assign cb-balanca:screen-value in frame {&frame-name} = c-cod-balan. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

