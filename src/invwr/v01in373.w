&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
*******************************************************************************/
{include/i-prgvrs.i V01IN373 2.00.01.011 } /*** 010111 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN373 MUT}
&ENDIF


/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define buffer b-recurso for recurso.
def var rw-tp-recur as rowid no-undo.

{cdp/cdunif001.i}
{cdp/cdunif001.i1}  

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES recurso
&Scoped-define FIRST-EXTERNAL-TABLE recurso


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR recurso.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS recurso.log-recurso-corp recurso.cd-calen ~
recurso.observacao 
&Scoped-define ENABLED-TABLES recurso
&Scoped-define FIRST-ENABLED-TABLE recurso
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold c-gm-it-eq de-cap-inic ~
de-qtd-capac de-carga-min de-sobrecarga 
&Scoped-Define DISPLAYED-FIELDS tp-recur.tp-recurso tp-recur.descricao ~
recurso.cd-recurso recurso.log-recurso-corp tp-recur.cod-unid-capac ~
recurso.cd-calen recurso.observacao 
&Scoped-define DISPLAYED-TABLES tp-recur recurso
&Scoped-define FIRST-DISPLAYED-TABLE tp-recur
&Scoped-define SECOND-DISPLAYED-TABLE recurso
&Scoped-Define DISPLAYED-OBJECTS c-gm-it-eq c-desc-gm-it-eq de-cap-inic ~
de-qtd-capac c-descricao de-carga-min de-sobrecarga 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS recurso.cd-recurso de-qtd-capac ~
de-carga-min de-sobrecarga 
&Scoped-define ADM-ASSIGN-FIELDS de-qtd-capac de-carga-min de-sobrecarga 

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
DEFINE VARIABLE c-desc-gm-it-eq AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-gm-it-eq AS CHARACTER FORMAT "X(18)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-cap-inic AS DECIMAL FORMAT ">>>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-carga-min AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-capac AS DECIMAL FORMAT ">>>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-sobrecarga AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 10.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tp-recur.tp-recurso AT ROW 1.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     tp-recur.descricao AT ROW 1.17 COL 32.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36.14 BY .88
     recurso.cd-recurso AT ROW 2.17 COL 22.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     recurso.log-recurso-corp AT ROW 2.25 COL 47
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .83
     c-gm-it-eq AT ROW 3.5 COL 23 COLON-ALIGNED
     c-desc-gm-it-eq AT ROW 3.5 COL 41 COLON-ALIGNED NO-LABEL
     de-cap-inic AT ROW 4.5 COL 23 COLON-ALIGNED
     de-qtd-capac AT ROW 5.5 COL 23 COLON-ALIGNED
     tp-recur.cod-unid-capac AT ROW 5.5 COL 41 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     recurso.cd-calen AT ROW 6.5 COL 23 COLON-ALIGNED FORMAT "x(9)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     c-descricao AT ROW 6.5 COL 36.72 COLON-ALIGNED NO-LABEL
     de-carga-min AT ROW 7.5 COL 23 COLON-ALIGNED
     de-sobrecarga AT ROW 8.5 COL 23 COLON-ALIGNED
     recurso.observacao AT ROW 9.5 COL 5 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 80 BY 3.96
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.recurso
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
         HEIGHT             = 12.88
         WIDTH              = 88.57.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-gm-it-eq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN recurso.cd-calen IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN recurso.cd-recurso IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tp-recur.cod-unid-capac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-carga-min IN FRAME f-main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN de-qtd-capac IN FRAME f-main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN de-sobrecarga IN FRAME f-main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN tp-recur.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tp-recur.tp-recurso IN FRAME f-main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME c-gm-it-eq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-gm-it-eq V-table-Win
ON F5 OF c-gm-it-eq IN FRAME f-main
DO:

  l-implanta = yes.
  if tp-recur.cl-recurso = 1 then 
     run pi-zoom-grupo-maquina.
  else
     if tp-recur.cl-recurso = 2 then
        run pi-zoom-item.
     else
        if tp-recur.cl-recurso = 6 then
           run pi-zoom-centro-custo.
        else
           run pi-zoom-equipto. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-gm-it-eq V-table-Win
ON LEAVE OF c-gm-it-eq IN FRAME f-main
DO:

  find tp-recur where rowid(tp-recur) = v-row-parent no-lock no-error.
  if avail tp-recur then do:
    assign c-gm-it-eq = input frame {&frame-name} c-gm-it-eq.
    if tp-recur.cl-recurso = 1 then do:
       find grup-maquina 
            where grup-maquina.gm-codigo = c-gm-it-eq 
            no-lock no-error.
       assign c-desc-gm-it-eq:screen-value in frame {&frame-name} =
          if avail grup-maquina then grup-maquina.descricao else "":U.
       /*Alterado devido a Fo. 1525.874*/
       ASSIGN recurso.cd-calen:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
           if avail grup-maquina then grup-maquina.cd-calen else "":U.
       APPLY 'leave' TO recurso.cd-calen IN FRAME {&FRAME-NAME}.
    end.
    else
       if tp-recur.cl-recurso = 2 then do:
          find item
               where item.it-codigo = c-gm-it-eq 
               no-lock no-error.
          assign c-desc-gm-it-eq:screen-value in frame {&frame-name} =
             if avail item then item.desc-item else "":U.
       end.
       else 
          if tp-recur.cl-recurso = 3 then do:
              find equipto
                   where equipto.cd-equipto = c-gm-it-eq 
                   no-lock no-error.
              assign c-desc-gm-it-eq:screen-value in frame {&frame-name} =
                 if avail equipto then equipto.descricao else "":U.
          end.
          else
             if tp-recur.cl-recurso = 6 then do:

                if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
				run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                           INPUT "",
                                                           INPUT c-gm-it-eq,
                                                           INPUT today,
                                                           OUTPUT v_des_ccusto,
                                                           OUTPUT TABLE tt_log_erro).
                 assign c-desc-gm-it-eq:screen-value in frame {&frame-name} = v_des_ccusto.
                 {utp/ut-liter.i Centro_de_Custo *}
                 c-gm-it-eq:label = return-value.
             END.

  END.

    if valid-handle(h_api_ccusto) then
		delete object h_api_ccusto.
		
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-gm-it-eq V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-gm-it-eq IN FRAME f-main
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME recurso.cd-calen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL recurso.cd-calen V-table-Win
ON F5 OF recurso.cd-calen IN FRAME f-main /* Calend rio */
DO:
   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in026.w"
                     &campo=recurso.cd-calen
                     &campozoom=cd-calen
                     &campo2=c-descricao
                     &campozoom2=descricao}         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL recurso.cd-calen V-table-Win
ON LEAVE OF recurso.cd-calen IN FRAME f-main /* Calend rio */
DO:
  {include/leave.i &tabela=calen-gener
                   &atributo-ref=descricao                  
                   &variavel-ref=c-descricao
                   &where="calen-gener.cd-calen = input frame {&frame-name} recurso.cd-calen"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL recurso.cd-calen V-table-Win
ON MOUSE-SELECT-DBLCLICK OF recurso.cd-calen IN FRAME f-main /* Calend rio */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 if c-gm-it-eq:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then. 
 if recurso.cd-calen:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then. 

if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

 {utp/ut-liter.i Capacidade_Atual * R}
 assign de-qtd-capac:label in frame {&frame-name} = return-value.

 {utp/ut-liter.i Capacidade_Inicial * R}
 assign de-cap-inic:label in frame {&frame-name} = return-value. 

 {utp/ut-liter.i Carga_M¡nima_Atual * R}
 assign de-carga-min:label in frame {&frame-name} = return-value.

 {utp/ut-field.i mgind recurso sobrecarga 01}
 assign de-sobrecarga:label in frame {&frame-name} = return-value.


  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "recurso"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "recurso"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
 ------------------------------------------------------------------------------*/
     assign c-gm-it-eq = input frame {&frame-name} c-gm-it-eq.

   /* Code placed here will execute PRIOR to standard behavior. */
   /*Alterado devido a Fo 1653.056*/
   /*if not frame {&frame-name}:validate() then 
      return 'adm-error'.*/
   {include/i-valid.i}

   run pi-validate.
   if return-value <> 'ok' then
      return 'adm-error':U.

   assign de-cap-inic = input frame {&frame-name} de-cap-inic.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  if adm-new-record then 
     assign recurso.qtd-capac-nominal = input frame {&frame-name} de-qtd-capac
            recurso.carga-minima      = input frame {&frame-name} de-carga-min
            recurso.sobrecarga        = input frame {&frame-name} de-sobrecarga.

  assign recurso.dec-1 = input frame {&frame-name} de-cap-inic.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find tp-recur where rowid(tp-recur) = rw-tp-recur no-lock.
  if avail tp-recur then do:
     assign recurso.tp-recurso = tp-recur.tp-recurso.

     if tp-recur.cl-recurso = 1 then 
        assign recurso.gm-codigo    = input frame {&frame-name} c-gm-it-eq.
     if tp-recur.cl-recurso = 2 then 
        assign recurso.it-codigo    = input frame {&frame-name} c-gm-it-eq.
     if tp-recur.cl-recurso = 3 then 
        assign recurso.cod-alternat = input frame {&frame-name} c-gm-it-eq.
     if tp-recur.cl-recurso = 6 then
        assign recurso.gm-codigo = INPUT FRAME {&FRAME-NAME} c-gm-it-eq.

  end.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

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

  /* Code placed here will execute PRIOR to standard behavior. */

  if avail recurso then do:
     find calen-gener where calen-gener.cd-calen = recurso.cd-calen no-lock no-error.
     assign c-descricao = if avail calen-gener then calen-gener.descricao else "":U. 
  end.

  if avail recurso and not adm-new-record then
       assign de-cap-inic:screen-value in frame {&frame-name} = string(recurso.dec-1).

  assign c-gm-it-eq = input frame {&frame-name} c-gm-it-eq.

  find tp-recur where rowid(tp-recur) = rw-tp-recur no-lock.

  if rowid(recurso) <> ? then do:
     if tp-recur.cl-recurso = 1 then do:
        find grup-maquina where grup-maquina.gm-codigo = recurso.gm-codigo no-lock no-error.
        assign c-gm-it-eq      = if avail grup-maquina then grup-maquina.gm-codigo else "":U
               c-desc-gm-it-eq = if avail grup-maquina then grup-maquina.descricao else "":U.
     end.                  
     if tp-recur.cl-recurso = 2 then do:
        find item where item.it-codigo = recurso.it-codigo no-lock no-error.
        assign c-gm-it-eq      = if avail item then item.it-codigo else "":U
               c-desc-gm-it-eq = if avail item then item.desc-item else "":U.
     end.
     if tp-recur.cl-recurso = 3 then do:
        find equipto where equipto.cd-equipto = recurso.cod-alternat no-lock no-error.
        assign c-gm-it-eq      = if avail equipto then equipto.cd-equipto else "":U
               c-desc-gm-it-eq = if avail equipto then equipto.descricao else "":U.
     end.
     if tp-recur.cl-recurso = 6 then do:
        if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
		run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                   INPUT "",
                                                   INPUT recurso.gm-codigo,
                                                   INPUT today,
                                                   OUTPUT v_des_ccusto,
                                                   OUTPUT TABLE tt_log_erro).

        assign c-gm-it-eq      = recurso.gm-codigo
               c-desc-gm-it-eq = v_des_ccusto.
     end.

  end.                             

  if tp-recur.ind-modo-calculo = 1 then do:
    {utp/ut-liter.i Setup_(%) * R}
    assign de-cap-inic:label in frame {&frame-name} = return-value. 
  end.
  else do:
    {utp/ut-liter.i Capacidade_Inicial * R}
    assign de-cap-inic:label in frame {&frame-name} = return-value. 
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if avail recurso then do:
     find last cap-rec where 
            cap-rec.cd-recurso    = recurso.cd-recurso and
            cap-rec.tp-recurso    = recurso.tp-recurso and
            cap-rec.dt-efetivacao <= today no-lock no-error.
     if avail cap-rec then
         assign de-qtd-capac:screen-value in frame {&frame-name}  = string(cap-rec.capacidade-dia)
                de-carga-min:screen-value in frame {&frame-name}  = string(cap-rec.carga-minima)
                de-sobrecarga:screen-value in frame {&frame-name} = string(cap-rec.sobrecarga).
  end.

  if avail recurso and not adm-new-record then
       assign de-cap-inic:screen-value in frame {&frame-name} = string(recurso.dec-1).

  /* Code placed here will execute AFTER standard behavior.    */

    if valid-handle(h_api_ccusto) then
		delete object h_api_ccusto.
		
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  find tp-recur where rowid(tp-recur) = v-row-parent no-lock no-error.
  if avail tp-recur and tp-recur.cl-recurso = 4 or  tp-recur.cl-recurso = 5 then
     assign c-gm-it-eq:visible        in frame {&frame-name} = no
            c-gm-it-eq:sensitive      in frame {&frame-name} = no.
  else
     assign c-gm-it-eq:visible        in frame {&frame-name} = yes
            c-gm-it-eq:sensitive      in frame {&frame-name} = yes. 

  if avail tp-recur then do:            
    assign recurso.cd-calen:sensitive in frame {&frame-name} = not(tp-recur.cl-recurso = 1 or
                                                                   tp-recur.cl-recurso = 3).   
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  find tp-recur where rowid(tp-recur) = v-row-parent no-lock no-error.
  assign rw-tp-recur = v-row-parent.

     /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if not adm-new-record then 
     assign de-qtd-capac:sensitive in frame {&frame-name}  = no
            de-carga-min:sensitive in frame {&frame-name}  = no
            de-sobrecarga:sensitive in frame {&frame-name} = no.
  else          
     assign de-qtd-capac:sensitive in frame {&frame-name}  = yes
            de-carga-min:sensitive in frame {&frame-name}  = yes
            de-sobrecarga:sensitive in frame {&frame-name} = yes.

  if tp-recur.cl-recurso = 1 then do:
     {utp/ut-field.i mgind recurso gm-codigo 1}
     assign c-gm-it-eq:label in frame {&frame-name} = return-value.
  end.
  else 
     if tp-recur.cl-recurso = 2 then do:
        {utp/ut-field.i mgind recurso it-codigo 1} 
        assign c-gm-it-eq:label in frame {&frame-name} = return-value.
     end.   
     else
        if tp-recur.cl-recurso = 3  then do:
           {utp/ut-field.i mgind recurso cod-alternat 1}             
           assign c-gm-it-eq:label in frame {&frame-name} = return-value.
        end.  
        if tp-recur.cl-recurso = 4  or tp-recur.cl-recurso = 5 then do:             
           assign c-desc-gm-it-eq:hidden in frame {&frame-name} = yes.
        end.  

  if  tp-recur.ind-modo-calculo = 1 or
     (tp-recur.cl-recurso       = 5 and
      tp-recur.ind-modo-calculo = 2) then
       assign de-cap-inic:sensitive in frame {&frame-name} = yes.
  else assign de-cap-inic:sensitive in frame {&frame-name} = no.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N’o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida»„es, pois neste ponto do programa o registro 
  ainda n’o foi criado.       
------------------------------------------------------------------------------*/
     def var rw-recurso  as rowid no-undo.
     def var c-label-aux as char  no-undo.


     find tp-recur where rowid(tp-recur) = v-row-parent no-lock.


      /*** Valida»’o de chave duplicada ***/  
     if recurso.cd-recurso:sensitive in frame {&frame-name} = yes
     and can-find(b-recurso
                   where b-recurso.tp-recurso = tp-recur.tp-recurso
                   and   b-recurso.cd-recurso = input frame {&frame-name} recurso.cd-recurso) 
                   then do:      
        {utp/ut-table.i mgind recurso 1} 
        run utp/ut-msgs.p (input "show",
                           input 1,
                           input return-value).
        apply 'entry' to recurso.cd-recurso in frame {&frame-name}.
        return 'adm-error'.
     end.          


     /*** Outras Valida»„es ***/
     if tp-recur.cl-recurso = 1 then do:         
        find grup-maquina 
             where grup-maquina.gm-codigo = input frame {&frame-name} c-gm-it-eq 
             no-lock no-error.
        if not avail grup-maquina then do:                  
           {utp/ut-table.i mgind grup-maquina 1}
           run utp/ut-msgs.p (input "show",
                              input 56,
                              input return-value).                         
           apply 'entry' to c-gm-it-eq in frame {&frame-name}.
           return 'adm-error'.     
        end.   
     end.

     /*** Quando tipo recurso for "material" ***/ 
     if tp-recur.cl-recurso = 2 then do:         
           find item 
                where item.it-codigo = input frame {&frame-name} c-gm-it-eq 
                no-lock no-error.
           if not avail item then do:         
              {utp/ut-table.i mgind item 1}
              run utp/ut-msgs.p (input "show",
                                 input 56,
                                 input return-value).     
              apply 'entry' to c-gm-it-eq in frame {&frame-name}.
              return 'adm-error'.         
           end. 

           if adm-new-record = yes then do:

              /*** material n’o pode ser de d²bito direto ***/
              if item.tipo-contr = 4 then do: 
                 run utp/ut-msgs.p (input "show",
                                    input 1673,
                                    input return-value).     
                 apply 'entry' to c-gm-it-eq in frame {&frame-name}.
                 return 'adm-error'.
              end.

              /*** o material n’o pode estar obsoleto ***/         
              if item.cod-obsoleto <> 1 then do:
                 {utp/ut-table.i mgind recurso 1}
                 run utp/ut-msgs.p (input "show",
                                    input 2585,
                                    input item.it-codigo + "  " + return-value).     
                 apply 'entry' to c-gm-it-eq in frame {&frame-name}.
                 return 'adm-error'.  
              end.        
           end.
     end.                     

     if tp-recur.cl-recurso = 3 then do:
        find equipto where 
                     equipto.cd-equipto = input frame {&frame-name} c-gm-it-eq 
                     no-lock no-error.
        if not avail equipto then do:       
           {utp/ut-table.i  mgind equipto 1}
           run utp/ut-msgs.p (input "show",
                              input 56,
                              input return-value).
           apply 'entry' to c-gm-it-eq in frame {&frame-name}.
           return 'adm-error'.
        end.  
     end.                       

 /*** Verifica se jÿ existe algum recurso com o mesmo grupo de mÿquina informado na tela ***/
     if tp-recur.cl-recurso = 1 
     and recurso.cd-recurso:sensitive in frame {&frame-name} = yes 
     and can-find(b-recurso 
                  where b-recurso.gm-codigo = input frame {&frame-name} c-gm-it-eq
                  and   rowid(b-recurso)   <> rw-recurso) then do:
        {utp/ut-table.i mgind grup-maquina 1}
        assign c-label-aux = return-value.
        {utp/ut-table.i mgind tp-recur 1}
        run utp/ut-msgs.p (input 'show', 
                           input 428,
                           input c-label-aux  + ' ' + c-gm-it-eq:screen-value in frame {&frame-name} + '~~' +
                                 return-value + ' ' + tp-recur.tp-recurso).
        apply 'entry' to c-gm-it-eq in frame {&frame-name}.
        return 'adm-error':U.
     end.

 /*** Verifica se jÿ existe algum recurso com o mesmo item informado na tela ***/
     if tp-recur.cl-recurso = 2
     and recurso.cd-recurso:sensitive in frame {&frame-name} = yes 
     and can-find(b-recurso 
                  where b-recurso.it-codigo = input frame {&frame-name} c-gm-it-eq
                  and   rowid(b-recurso)   <> rw-recurso) then do:
        {utp/ut-table.i mgind item 1}
        assign c-label-aux = return-value.
        {utp/ut-table.i mgind tp-recur 1}
        run utp/ut-msgs.p (input 'show', 
                           input 428,
                           input c-label-aux  + ' ' + input frame {&frame-name} c-gm-it-eq + '~~' +
                                 return-value + ' ' + tp-recur.tp-recurso).    
        apply 'entry' to c-gm-it-eq in frame {&frame-name}.
        return 'adm-error':U.
     end.

  /*** Verifica se jÿ existe algum recurso com o mesmo equipamento informado na tela ***/
     if tp-recur.cl-recurso = 3 
     and recurso.cd-recurso:sensitive in frame {&frame-name} = yes 
     and can-find(b-recurso 
                  where b-recurso.cod-alternat = input frame {&frame-name} c-gm-it-eq
                  and   rowid(b-recurso)   <> rw-recurso) then do:
        {utp/ut-table.i mgind equipto 1}
        assign c-label-aux = return-value.
        {utp/ut-table.i mgind tp-recur 1}
        run utp/ut-msgs.p (input 'show', 
                           input 428,
                           input c-label-aux  + ' ' + input frame {&frame-name} c-gm-it-eq + '~~' +
                                 return-value + ' ' + tp-recur.tp-recurso).
        apply 'entry' to c-gm-it-eq in frame {&frame-name}.
        return 'adm-error':U.
     end.
     
     if tp-recur.cl-recurso = 6 then do:
        EMPTY TEMP-TABLE tt_log_erro.
        if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
		run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                   INPUT "",
                                                   INPUT input frame {&FRAME-NAME} c-gm-it-eq,
                                                   INPUT today,
                                                   OUTPUT v_des_ccusto,
                                                   OUTPUT TABLE tt_log_erro).

        IF CAN-FIND(first tt_log_erro) THEN DO:
           {cdp/cdunif001b.i1}
           apply 'entry' to c-gm-it-eq in frame {&frame-name}.
           return 'adm-error':U.
        end.
     end.
    
     if tp-recur.ind-modo-calculo = 1 and
        input frame {&frame-name} de-cap-inic >= 100 then do:
          run utp/ut-liter.p (input "Fator_de_Setup", "*", "").
          run utp/ut-msgs.p (input "show",
                             input 25495,
                             input  Return-value + "~~100%" ).
          apply "entry" to de-cap-inic in frame {&frame-name}.
          return 'ADM-ERROR':U.
     end.

     /*   {include/i-vldfrm.i} /* Valida»’o de dicionÿrio */ */

    if valid-handle(h_api_ccusto) then
		delete object h_api_ccusto.
		
     assign rw-recurso = if avail recurso then rowid(recurso) else ?.
     return 'ok'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-centro-custo V-table-Win 
PROCEDURE pi-zoom-centro-custo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /** Utilizar Centro de Custo Produtivo **/
 {include/zoomvar.i &prog-zoom=inzoom/z01in042.w                        
                    &campo=c-gm-it-eq
                    &campozoom=cc-codigo
                    &campo2=c-desc-gm-it-eq
                    &campozoom2=descricao}  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-equipto V-table-Win 
PROCEDURE pi-zoom-equipto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 if tp-recur.cl-recurso = 3 then do:
 {include/zoomvar.i &prog-zoom=inzoom/z01in095.w                        
                    &campo=c-gm-it-eq
                    &campozoom=cd-equipto
                    &campo2=c-desc-gm-it-eq
                    &campozoom2=descricao}                                    
   end.                      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-grupo-maquina V-table-Win 
PROCEDURE pi-zoom-grupo-maquina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{include/zoomvar.i &prog-zoom=inzoom/z01in144.w                        
                   &campo=c-gm-it-eq
                   &campozoom=gm-codigo
                   &campo2=c-desc-gm-it-eq
                   &campozoom2=descricao} 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-item V-table-Win 
PROCEDURE pi-zoom-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                     &campo=c-gm-it-eq
                     &campozoom=it-codigo}

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
  {src/adm/template/snd-list.i "recurso"}

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

