&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0121 2.00.00.005 } /*** 010005 ***/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

{afbo/boaf002.i ttAf-familia-contr-old}
{afbo/boaf003.i ttAf-familia-contr-form-old}

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER c-prog      AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER v-table     AS ROWID NO-UNDO.


DEFINE TEMP-TABLE ttAf-item-contr-estab-form-old NO-UNDO
    FIELD nr-controle  like Af-item-contr-estab-form.nr-controle
    field dt-prox-aval like Af-item-contr-estab-form.dt-prox-aval
    field dt-ult-aval  like Af-item-contr-estab-form.dt-ult-aval.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-diferenca        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-cont             AS INTEGER    NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-39 rt-buttom l-exp-itens ~
l-exp-form-itens l-exp-itens-estab l-exp-form-itens-estab bt-ok bt-cancela ~
bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS l-exp-itens l-exp-form-itens ~
l-exp-itens-estab l-exp-form-itens-estab 

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

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54 BY 4.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 54 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-exp-form-itens AS LOGICAL INITIAL no 
     LABEL "Exporta para a formula dos itens?" 
     VIEW-AS TOGGLE-BOX
     SIZE 43 BY .83 NO-UNDO.

DEFINE VARIABLE l-exp-form-itens-estab AS LOGICAL INITIAL no 
     LABEL "Exporta para a formula dos itens/estabelecimento?" 
     VIEW-AS TOGGLE-BOX
     SIZE 52 BY .83 NO-UNDO.

DEFINE VARIABLE l-exp-itens AS LOGICAL INITIAL no 
     LABEL "Exporta para os itens?" 
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .83 NO-UNDO.

DEFINE VARIABLE l-exp-itens-estab AS LOGICAL INITIAL no 
     LABEL "Exporta para os itens/estabelecimento?" 
     VIEW-AS TOGGLE-BOX
     SIZE 41 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     l-exp-itens AT ROW 1.5 COL 3
     l-exp-form-itens AT ROW 2.29 COL 3
     l-exp-itens-estab AT ROW 3.08 COL 3
     l-exp-form-itens-estab AT ROW 3.88 COL 3
     bt-ok AT ROW 5.58 COL 3
     bt-cancela AT ROW 5.58 COL 14
     bt-ajuda AT ROW 5.58 COL 44.57
     RECT-39 AT ROW 1.21 COL 2
     rt-buttom AT ROW 5.33 COL 2
     SPACE(0.56) SKIP(0.20)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "<insert SmartDialog title>"
         DEFAULT-BUTTON bt-ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
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
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
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


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
  
  ASSIGN INPUT l-exp-itens.
  ASSIGN INPUT l-exp-form-itens.
  ASSIGN INPUT l-exp-itens-estab.
  ASSIGN INPUT l-exp-form-itens-estab.
    
  IF c-prog = "af0103" THEN 
     RUN pi-exp-itens (INPUT v-table).
  IF c-prog = "af0104" THEN
     RUN pi-exp-itens-estab (INPUT v-table).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

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
  DISPLAY l-exp-itens l-exp-form-itens l-exp-itens-estab l-exp-form-itens-estab 
      WITH FRAME D-Dialog.
  ENABLE RECT-39 rt-buttom l-exp-itens l-exp-form-itens l-exp-itens-estab 
         l-exp-form-itens-estab bt-ok bt-cancela bt-ajuda 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  {utp/ut9000.i "AF0121" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


  IF c-prog = "af0104" THEN
     DISABLE l-exp-itens l-exp-form-itens WITH FRAME D-Dialog.
     


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exp-itens D-Dialog 
PROCEDURE pi-exp-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER r-familia     AS ROWID NO-UNDO.

FIND af-familia-contr 
 WHERE ROWID(af-familia-contr) = r-familia NO-LOCK NO-ERROR.
IF AVAIL af-familia-contr THEN DO:
    IF l-exp-itens THEN DO:
       FOR EACH ITEM
           WHERE ITEM.fm-codigo = af-familia-contr.fm-codigo
           NO-LOCK:
           FOR EACH af-item-contr
               WHERE af-item-contr.ep-codigo    = af-familia-contr.ep-codigo
               AND   af-item-contr.it-codigo    = ITEM.it-codigo
               AND   af-item-contr.cod-emitente = af-familia-contr.cod-emitente
               AND   af-item-contr.nr-versao    = af-familia-contr.nr-versao
               EXCLUSIVE-LOCK:
               BUFFER-COMPARE af-familia-contr USING 
                   data-entrega demerito log-considera-qtd-receb 
                   log-considera-val-receb nr-dia-max nr-dia-min 
                   pct-qtd-max pct-qtd-min pct-val-max pct-val-min 
                   preco qualidade quantidade narrativa
               TO af-item-contr SAVE RESULT IN c-diferenca.
               DO  i-cont = 1 TO NUM-ENTRIES(c-diferenca):
                   CASE TRIM(ENTRY(i-cont, c-diferenca)):
                        WHEN "data-entrega" THEN ASSIGN af-item-contr.data-entrega = af-familia-contr.data-entrega. 
                        WHEN "ativo" THEN ASSIGN af-item-contr.ativo = af-familia-contr.ativo.
                        WHEN "demerito" THEN ASSIGN af-item-contr.demerito = af-familia-contr.demerito. 
                        WHEN "log-considera-qtd-receb" THEN ASSIGN af-item-contr.log-considera-qtd-receb = af-familia-contr.log-considera-qtd-receb. 
                        WHEN "log-considera-val-receb" THEN ASSIGN af-item-contr.log-considera-val-receb = af-familia-contr.log-considera-val-receb. 
                        WHEN "nr-dia-max" THEN ASSIGN af-item-contr.nr-dia-max  = af-familia-contr.nr-dia-max. 
                        WHEN "nr-dia-min" THEN ASSIGN af-item-contr.nr-dia-min  = af-familia-contr.nr-dia-min. 
                        WHEN "pct-qtd-max" THEN ASSIGN af-item-contr.pct-qtd-max = af-familia-contr.pct-qtd-max. 
                        WHEN "pct-qtd-min" THEN ASSIGN af-item-contr.pct-qtd-min = af-familia-contr.pct-qtd-min. 
                        WHEN "pct-val-max" THEN ASSIGN af-item-contr.pct-val-max = af-familia-contr.pct-val-max. 
                        WHEN "pct-val-min" THEN ASSIGN af-item-contr.pct-val-min = af-familia-contr.pct-val-min. 
                        WHEN "preco" THEN ASSIGN af-item-contr.preco = af-familia-contr.preco. 
                        WHEN "qualidade" THEN ASSIGN af-item-contr.qualidade = af-familia-contr.qualidade. 
                        WHEN "quantidade" THEN ASSIGN af-item-contr.quantidade = af-familia-contr.quantidade. 
                        WHEN "narrativa" THEN ASSIGN af-item-contr.narrativa = af-familia-contr.narrativa.
                   END.
               END.
               IF c-diferenca <> "" THEN DO:
                  ASSIGN af-item-contr.dt-alter    = af-familia-contr.dt-alter 
                         af-item-contr.hora-alter  = af-familia-contr.hora-alter
                         af-item-contr.usuar-alter = af-familia-contr.usuar-alter.
               END.
               IF l-exp-form-itens THEN DO:
                  FOR EACH af-item-contr-form
                      WHERE af-item-contr-form.ep-codigo = af-item-contr.ep-codigo
                      AND   af-item-contr-form.it-codigo = af-item-contr.it-codigo
                      AND   af-item-contr-form.cod-emitente = af-item-contr.cod-emitente
                      AND   af-item-contr-form.nr-versao    = af-item-contr.nr-versao
                      EXCLUSIVE-LOCK:
                      DELETE af-item-contr-form.
                  END.
                  FOR EACH af-familia-contr-form
                      WHERE af-familia-contr-form.ep-codigo    = af-familia-contr.ep-codigo
                      AND   af-familia-contr-form.fm-codigo    = af-familia-contr.fm-codigo
                      AND   af-familia-contr-form.cod-emitente = af-familia-contr.cod-emitente
                      AND   af-familia-contr-form.nr-versao   = af-familia-contr.nr-versao
                      NO-LOCK:
                      CREATE af-item-contr-form.
                      ASSIGN af-item-contr-form.ep-codigo        = af-familia-contr-form.ep-codigo
                             af-item-contr-form.it-codigo        = af-item-contr.it-codigo
                             af-item-contr-form.cod-emitente     = af-item-contr.cod-emitente
                             af-item-contr-form.nr-versao        = af-item-contr.nr-versao
                             af-item-contr-form.cod-grp-resp     = af-familia-contr-form.cod-grp-resp
                             af-item-contr-form.log-per-variavel = af-familia-contr-form.log-per-variavel
                             af-item-contr-form.ind-tipo-periodo = af-familia-contr-form.ind-tipo-periodo.

                      BUFFER-COPY af-familia-contr-form EXCEPT ep-codigo cod-emitente TO af-item-contr-form.
                  END.
               END.
               IF l-exp-itens-estab THEN
                  RUN pi-exp-itens-estab (INPUT ROWID(af-item-contr)).

           END.
       END.
    END.
    ELSE IF l-exp-itens-estab THEN DO:
        FOR EACH ITEM FIELDS(it-codigo) NO-LOCK
            WHERE ITEM.fm-codigo = af-familia-contr.fm-codigo:
            FOR EACH item-estab FIELDS(cod-estabel it-codigo) NO-LOCK
                WHERE item-estab.it-codigo = ITEM.it-codigo:
                FOR EACH af-item-contr-estab EXCLUSIVE-LOCK
                    WHERE af-item-contr-estab.ep-codigo    = af-familia-contr.ep-codigo
                    AND   af-item-contr-estab.it-codigo    = item-estab.it-codigo
                    AND   af-item-contr-estab.cod-emitente = af-familia-contr.cod-emitente
                    AND   af-item-contr-estab.nr-versao    = af-familia-contr.nr-versao
                    AND   af-item-contr-estab.cod-estabel  = item-estab.cod-estabel:
                    BUFFER-COMPARE af-familia-contr USING 
                        data-entrega demerito log-considera-qtd-receb 
                        log-considera-val-receb nr-dia-max nr-dia-min 
                        pct-qtd-max pct-qtd-min pct-val-max pct-val-min 
                        preco qualidade quantidade narrativa
                    TO af-item-contr-estab SAVE RESULT IN c-diferenca.
                    DO  i-cont = 1 TO NUM-ENTRIES(c-diferenca):
                        CASE TRIM(ENTRY(i-cont, c-diferenca)):
                             WHEN "data-entrega"            THEN ASSIGN af-item-contr-estab.data-entrega            = af-familia-contr.data-entrega. 
                             WHEN "ativo"                   THEN ASSIGN af-item-contr-estab.ativo                   = af-familia-contr.ativo. 
                             WHEN "demerito"                THEN ASSIGN af-item-contr-estab.demerito                = af-familia-contr.demerito. 
                             WHEN "log-considera-qtd-receb" THEN ASSIGN af-item-contr-estab.log-considera-qtd-receb = af-familia-contr.log-considera-qtd-receb. 
                             WHEN "log-considera-val-receb" THEN ASSIGN af-item-contr-estab.log-considera-val-receb = af-familia-contr.log-considera-val-receb. 
                             WHEN "nr-dia-max"              THEN ASSIGN af-item-contr-estab.nr-dia-max              = af-familia-contr.nr-dia-max. 
                             WHEN "nr-dia-min"              THEN ASSIGN af-item-contr-estab.nr-dia-min              = af-familia-contr.nr-dia-min. 
                             WHEN "pct-qtd-max"             THEN ASSIGN af-item-contr-estab.pct-qtd-max             = af-familia-contr.pct-qtd-max. 
                             WHEN "pct-qtd-min"             THEN ASSIGN af-item-contr-estab.pct-qtd-min             = af-familia-contr.pct-qtd-min. 
                             WHEN "pct-val-max"             THEN ASSIGN af-item-contr-estab.pct-val-max             = af-familia-contr.pct-val-max. 
                             WHEN "pct-val-min"             THEN ASSIGN af-item-contr-estab.pct-val-min             = af-familia-contr.pct-val-min. 
                             WHEN "preco"                   THEN ASSIGN af-item-contr-estab.preco                   = af-familia-contr.preco. 
                             WHEN "qualidade"               THEN ASSIGN af-item-contr-estab.qualidade               = af-familia-contr.qualidade. 
                             WHEN "quantidade"              THEN ASSIGN af-item-contr-estab.quantidade              = af-familia-contr.quantidade. 
                             WHEN "narrativa"               THEN ASSIGN af-item-contr-estab.narrativa               = af-familia-contr.narrativa.
                        END.
                    END.

                    IF c-diferenca <> "" THEN DO:
                       ASSIGN af-item-contr-estab.dt-alter    = af-familia-contr.dt-alter 
                              af-item-contr-estab.hora-alter  = af-familia-contr.hora-alter
                              af-item-contr-estab.usuar-alter = af-familia-contr.usuar-alter.
                    END.

                    IF l-exp-form-itens-estab THEN DO:
                       for each ttAf-item-contr-estab-form-old:
                           delete ttAf-item-contr-estab-form-old.
                       end.
                       FOR EACH af-item-contr-estab-form EXCLUSIVE-LOCK
                           WHERE af-item-contr-estab-form.ep-codigo    = af-item-contr-estab.ep-codigo
                           AND   af-item-contr-estab-form.it-codigo    = af-item-contr-estab.it-codigo
                           AND   af-item-contr-estab-form.cod-emitente = af-item-contr-estab.cod-emitente
                           AND   af-item-contr-estab-form.nr-versao    = af-item-contr-estab.nr-versao
                           AND   af-item-contr-estab-form.cod-estabel  = af-item-contr-estab.cod-estabel:

                           CREATE ttAf-item-contr-estab-form-old.
                           ASSIGN ttAf-item-contr-estab-form-old.nr-controle  = Af-item-contr-estab-form.nr-controle
                                  ttAf-item-contr-estab-form-old.dt-prox-aval = Af-item-contr-estab-form.dt-prox-aval
                                  ttAf-item-contr-estab-form-old.dt-ult-aval  = Af-item-contr-estab-form.dt-ult-aval.

                           DELETE af-item-contr-estab-form.
                       END.

                       FOR EACH af-familia-contr-form NO-LOCK
                           WHERE af-familia-contr-form.ep-codigo    = af-familia-contr.ep-codigo
                           AND   af-familia-contr-form.fm-codigo    = af-familia-contr.fm-codigo
                           AND   af-familia-contr-form.cod-emitente = af-familia-contr.cod-emitente
                           AND   af-familia-contr-form.nr-versao    = af-familia-contr.nr-versao:

                           FIND FIRST ttAf-item-contr-estab-form-old 
                                WHERE ttAf-item-contr-estab-form-old.nr-controle = af-item-contr-form.nr-controle NO-LOCK NO-ERROR.

                           CREATE af-item-contr-estab-form.
                           ASSIGN af-item-contr-estab-form.ep-codigo        = af-item-contr-estab.ep-codigo
                                  af-item-contr-estab-form.it-codigo        = af-item-contr-estab.it-codigo
                                  af-item-contr-estab-form.cod-emitente     = af-item-contr-estab.cod-emitente
                                  af-item-contr-estab-form.nr-versao        = af-item-contr-estab.nr-versao
                                  af-item-contr-estab-form.cod-estabel      = af-item-contr-estab.cod-estabel
                                  af-item-contr-estab-form.dt-prox-aval     = IF AVAIL ttAf-item-contr-estab-form-old THEN ttAf-item-contr-estab-form-old.dt-prox-aval
                                                                              ELSE ?
                                  af-item-contr-estab-form.dt-ult-aval      = IF AVAIL ttAf-item-contr-estab-form-old THEN ttAf-item-contr-estab-form-old.dt-ult-aval
                                                                              ELSE ?
                                  af-item-contr-estab-form.cod-grp-resp     = af-familia-contr-form.cod-grp-resp
                                  af-item-contr-estab-form.log-per-variavel = af-familia-contr-form.log-per-variavel
                                  af-item-contr-estab-form.ind-tipo-periodo = af-familia-contr-form.ind-tipo-periodo.

                           BUFFER-COPY af-familia-contr-form EXCEPT ep-codigo cod-emitente dt-prox-aval dt-ult-aval TO af-item-contr-estab-form.
                       END.
                    END.
                END.
            END.
        END.
    END.
END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exp-itens-estab D-Dialog 
PROCEDURE pi-exp-itens-estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER r-item     AS ROWID NO-UNDO.

FIND af-item-contr 
 WHERE ROWID(af-item-contr) = r-item NO-LOCK NO-ERROR.
IF AVAIL af-item-contr THEN DO:
    IF l-exp-itens-estab THEN DO:
       FOR EACH item-estab FIELDS(cod-estabel) NO-LOCK
           WHERE item-estab.it-codigo = af-item-contr.it-codigo:
           FOR EACH af-item-contr-estab
               WHERE af-item-contr-estab.ep-codigo    = af-item-contr.ep-codigo
               AND   af-item-contr-estab.it-codigo    = af-item-contr.it-codigo
               AND   af-item-contr-estab.cod-emitente = af-item-contr.cod-emitente
               AND   af-item-contr-estab.nr-versao    = af-item-contr.nr-versao
               AND   af-item-contr-estab.cod-estabel  = item-estab.cod-estabel
               EXCLUSIVE-LOCK:
               BUFFER-COMPARE af-item-contr USING 
                   data-entrega demerito log-considera-qtd-receb 
                   log-considera-val-receb nr-dia-max nr-dia-min 
                   pct-qtd-max pct-qtd-min pct-val-max pct-val-min 
                   preco qualidade quantidade narrativa
               TO af-item-contr-estab SAVE RESULT IN c-diferenca.
               DO  i-cont = 1 TO NUM-ENTRIES(c-diferenca):
                   CASE TRIM(ENTRY(i-cont, c-diferenca)):
                        WHEN "data-entrega" THEN ASSIGN af-item-contr-estab.data-entrega = af-item-contr.data-entrega. 
                        WHEN "ativo" THEN ASSIGN af-item-contr-estab.ativo = af-item-contr.ativo. 
                        WHEN "demerito" THEN ASSIGN af-item-contr-estab.demerito = af-item-contr.demerito. 
                        WHEN "log-considera-qtd-receb" THEN ASSIGN af-item-contr-estab.log-considera-qtd-receb = af-item-contr.log-considera-qtd-receb. 
                        WHEN "log-considera-val-receb" THEN ASSIGN af-item-contr-estab.log-considera-val-receb = af-item-contr.log-considera-val-receb. 
                        WHEN "nr-dia-max" THEN ASSIGN af-item-contr-estab.nr-dia-max  = af-item-contr.nr-dia-max. 
                        WHEN "nr-dia-min" THEN ASSIGN af-item-contr-estab.nr-dia-min  = af-item-contr.nr-dia-min. 
                        WHEN "pct-qtd-max" THEN ASSIGN af-item-contr-estab.pct-qtd-max = af-item-contr.pct-qtd-max. 
                        WHEN "pct-qtd-min" THEN ASSIGN af-item-contr-estab.pct-qtd-min = af-item-contr.pct-qtd-min. 
                        WHEN "pct-val-max" THEN ASSIGN af-item-contr-estab.pct-val-max = af-item-contr.pct-val-max. 
                        WHEN "pct-val-min" THEN ASSIGN af-item-contr-estab.pct-val-min = af-item-contr.pct-val-min. 
                        WHEN "preco" THEN ASSIGN af-item-contr-estab.preco = af-item-contr.preco. 
                        WHEN "qualidade" THEN ASSIGN af-item-contr-estab.qualidade = af-item-contr.qualidade. 
                        WHEN "quantidade" THEN ASSIGN af-item-contr-estab.quantidade = af-item-contr.quantidade. 
                        WHEN "narrativa" THEN ASSIGN af-item-contr-estab.narrativa = af-item-contr.narrativa.
                   END.
               END.
               IF c-diferenca <> "" THEN DO:
                  ASSIGN af-item-contr-estab.dt-alter    = af-item-contr.dt-alter 
                         af-item-contr-estab.hora-alter  = af-item-contr.hora-alter
                         af-item-contr-estab.usuar-alter = af-item-contr.usuar-alter.
               END.

               IF l-exp-form-itens-estab THEN DO:
                  for each ttAf-item-contr-estab-form-old:
                      delete ttAf-item-contr-estab-form-old.
                  end.
                  FOR EACH af-item-contr-estab-form
                      WHERE af-item-contr-estab-form.ep-codigo    = af-item-contr.ep-codigo
                      AND   af-item-contr-estab-form.it-codigo    = af-item-contr.it-codigo
                      AND   af-item-contr-estab-form.cod-emitente = af-item-contr.cod-emitente
                      AND   af-item-contr-estab-form.nr-versao    = af-item-contr.nr-versao
                      AND   af-item-contr-estab-form.cod-estabel  = item-estab.cod-estabel
                      EXCLUSIVE-LOCK:

                      CREATE ttAf-item-contr-estab-form-old.
                      ASSIGN ttAf-item-contr-estab-form-old.nr-controle  = Af-item-contr-estab-form.nr-controle
                             ttAf-item-contr-estab-form-old.dt-prox-aval = Af-item-contr-estab-form.dt-prox-aval
                             ttAf-item-contr-estab-form-old.dt-ult-aval  = Af-item-contr-estab-form.dt-ult-aval.

                      DELETE af-item-contr-estab-form.
                  END.
                  FOR EACH af-item-contr-form
                      WHERE af-item-contr-form.ep-codigo    = af-item-contr.ep-codigo
                      AND   af-item-contr-form.it-codigo    = af-item-contr.it-codigo
                      AND   af-item-contr-form.cod-emitente = af-item-contr.cod-emitente
                      AND   af-item-contr-form.nr-versao    = af-item-contr.nr-versao
                      NO-LOCK:

                      FIND FIRST ttAf-item-contr-estab-form-old 
                           WHERE ttAf-item-contr-estab-form-old.nr-controle = af-item-contr-form.nr-controle NO-LOCK NO-ERROR.

                      CREATE af-item-contr-estab-form.
                      ASSIGN af-item-contr-estab-form.ep-codigo    = af-item-contr-form.ep-codigo
                             af-item-contr-estab-form.it-codigo    = af-item-contr-form.it-codigo
                             af-item-contr-estab-form.cod-emitente = af-item-contr-form.cod-emitente
                             af-item-contr-estab-form.ativo        = af-item-contr.ativo
                             af-item-contr-estab-form.nr-versao    = af-item-contr-form.nr-versao
                             af-item-contr-estab-form.cod-estabel  = af-item-contr-estab.cod-estabel
                             af-Item-Contr-Estab-Form.dt-prox-aval = IF AVAIL ttAf-item-contr-estab-form-old THEN ttAf-item-contr-estab-form-old.dt-prox-aval
                                                                     ELSE ?
                             af-Item-Contr-Estab-Form.dt-ult-aval  = IF AVAIL ttAf-item-contr-estab-form-old THEN ttAf-item-contr-estab-form-old.dt-ult-aval
                                                                     ELSE ?
                             af-item-Contr-Estab-Form.cod-grp-resp     = af-item-contr-form.cod-grp-resp
                             af-Item-Contr-Estab-Form.log-per-variavel = af-item-contr-form.log-per-variavel
                             af-Item-Contr-Estab-Form.ind-tipo-periodo = af-item-contr-form.ind-tipo-periodo.

                      BUFFER-COPY af-item-contr-form EXCEPT ep-codigo cod-emitente it-codigo dt-prox-aval dt-ult-aval TO af-item-contr-estab-form.
                  END.
               END.
               ELSE DO:
                     FOR EACH af-item-contr-estab-form
                          WHERE af-item-contr-estab-form.ep-codigo    = af-item-contr.ep-codigo
                          AND   af-item-contr-estab-form.it-codigo    = af-item-contr.it-codigo
                          AND   af-item-contr-estab-form.cod-emitente = af-item-contr.cod-emitente
                          AND   af-item-contr-estab.nr-versao         = af-item-contr.nr-versao
                          AND   af-item-contr-estab-form.cod-estabel  = item-estab.cod-estabel EXCLUSIVE-LOCK:
                            ASSIGN af-item-contr-estab-form.ativo = af-item-contr.ativo.
                     END.
               END.
         END.
       END.
    END.
END.








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

