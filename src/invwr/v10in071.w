&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V10IN071 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v10in071 MUT}
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
def new global shared var gr-item as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cot-item
&Scoped-define FIRST-EXTERNAL-TABLE cot-item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cot-item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cot-item.val-unit-mat-o[1] ~
cot-item.val-unit-mat-o[2] cot-item.val-unit-mat-o[3] ~
cot-item.val-unit-mob-o[1] cot-item.val-unit-mob-o[2] ~
cot-item.val-unit-mob-o[3] cot-item.val-unit-ggf-o[1] ~
cot-item.val-unit-ggf-o[2] cot-item.val-unit-ggf-o[3] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}val-unit-mat-o[1] ~{&FP2}val-unit-mat-o[1] ~{&FP3}~
 ~{&FP1}val-unit-mat-o[2] ~{&FP2}val-unit-mat-o[2] ~{&FP3}~
 ~{&FP1}val-unit-mat-o[3] ~{&FP2}val-unit-mat-o[3] ~{&FP3}~
 ~{&FP1}val-unit-mob-o[1] ~{&FP2}val-unit-mob-o[1] ~{&FP3}~
 ~{&FP1}val-unit-mob-o[2] ~{&FP2}val-unit-mob-o[2] ~{&FP3}~
 ~{&FP1}val-unit-mob-o[3] ~{&FP2}val-unit-mob-o[3] ~{&FP3}~
 ~{&FP1}val-unit-ggf-o[1] ~{&FP2}val-unit-ggf-o[1] ~{&FP3}~
 ~{&FP1}val-unit-ggf-o[2] ~{&FP2}val-unit-ggf-o[2] ~{&FP3}~
 ~{&FP1}val-unit-ggf-o[3] ~{&FP2}val-unit-ggf-o[3] ~{&FP3}
&Scoped-define ENABLED-TABLES cot-item
&Scoped-define FIRST-ENABLED-TABLE cot-item
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS cot-item.val-unit-mat-o[1] ~
cot-item.val-unit-mat-o[2] cot-item.val-unit-mat-o[3] ~
cot-item.val-unit-mob-o[1] cot-item.val-unit-mob-o[2] ~
cot-item.val-unit-mob-o[3] cot-item.val-unit-ggf-o[1] ~
cot-item.val-unit-ggf-o[2] cot-item.val-unit-ggf-o[3] 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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
DEFINE VARIABLE fi-moeda-0 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE fi-moeda-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE fi-moeda-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.57 BY 5.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cot-item.val-unit-mat-o[1] AT ROW 2.33 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     cot-item.val-unit-mat-o[2] AT ROW 2.33 COL 47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     cot-item.val-unit-mat-o[3] AT ROW 2.33 COL 66 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     cot-item.val-unit-mob-o[1] AT ROW 3.42 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     cot-item.val-unit-mob-o[2] AT ROW 3.42 COL 47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     cot-item.val-unit-mob-o[3] AT ROW 3.42 COL 66 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     cot-item.val-unit-ggf-o[1] AT ROW 4.5 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     cot-item.val-unit-ggf-o[2] AT ROW 4.5 COL 47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     cot-item.val-unit-ggf-o[3] AT ROW 4.5 COL 66 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     fi-moeda-0 AT ROW 1.5 COL 38 COLON-ALIGNED NO-LABEL
     fi-moeda-1 AT ROW 1.5 COL 57 COLON-ALIGNED NO-LABEL
     fi-moeda-2 AT ROW 1.5 COL 76 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.cot-item
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 5.42
         WIDTH              = 87.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-moeda-0 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-moeda-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-moeda-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

   {utp/ut-liter.i Material * L}
   assign val-unit-mat-o[1]:label in frame {&frame-name} = return-value.
   {utp/ut-liter.i MÆo-de-Obra * L}
   assign val-unit-mob-o[1]:label in frame {&frame-name} = return-value.
   {utp/ut-liter.i GGF * L}
   assign val-unit-ggf-o[1]:label in frame {&frame-name} = return-value.

   find first moeda where moeda.mo-codigo = 0 no-lock no-error. 
   if avail moeda then 
      assign fi-moeda-0:screen-value in frame {&frame-name} = moeda.descricao.

   find first param-estoq no-lock no-error.
   if avail param-estoq then do: 
      if param-estoq.tem-moeda1 then do:
         find first moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
         if avail moeda then
            assign fi-moeda-1:screen-value in frame {&frame-name} = moeda.descricao.
      end.
      if param-estoq.tem-moeda2 then do:      
         find first moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
         if avail moeda then
            assign fi-moeda-2:screen-value in frame {&frame-name} = moeda.descricao.
      end.      
   end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "cot-item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cot-item"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  clear frame {&frame-name} no-pause.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

   find first param-cp
      no-lock no-error.

   find first estab-mat
      where estab-mat.cod-estabel = param-cp.cod-estabel
      no-lock no-error.

   if  avail estab-mat 
   and estab-mat.usa-on-line = no then do:
      assign cot-item.val-unit-mat-o[1]:sensitive in frame {&frame-name} = no.
      assign cot-item.val-unit-mat-o[2]:sensitive in frame {&frame-name} = no.
      assign cot-item.val-unit-mat-o[3]:sensitive in frame {&frame-name} = no.
      assign cot-item.val-unit-mob-o[1]:sensitive in frame {&frame-name} = no.
      assign cot-item.val-unit-mob-o[2]:sensitive in frame {&frame-name} = no.
      assign cot-item.val-unit-mob-o[3]:sensitive in frame {&frame-name} = no.
      assign cot-item.val-unit-ggf-o[1]:sensitive in frame {&frame-name} = no.
      assign cot-item.val-unit-ggf-o[2]:sensitive in frame {&frame-name} = no.
      assign cot-item.val-unit-ggf-o[3]:sensitive in frame {&frame-name} = no.
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-valor V-table-Win 
PROCEDURE pi-atualiza-valor :
/*------------------------------------------------------------------------------
  Name: pi-atualiza-valor
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
find item where rowid (item) = gr-item no-lock no-error.
 if avail item then do:
  find first param-cp no-lock no-error.
   if avail param-cp then do:
    find item-estab where item-estab.it-codigo = item.it-codigo 
        and item-estab.cod-estabel = param-cp.cod-estab no-lock no-error.
     if avail item-estab then do:
     assign cot-item.val-unit-mat-o[1]:screen-value in frame {&frame-name} = string(item-estab.val-unit-mat-o[1]) 
            cot-item.val-unit-mat-o[2]:screen-value in frame {&frame-name} = string(item-estab.val-unit-mat-o[2]) 
            cot-item.val-unit-mat-o[3]:screen-value in frame {&frame-name} = string(item-estab.val-unit-mat-o[3]) 
            cot-item.val-unit-mob-o[1]:screen-value in frame {&frame-name} = string(item-estab.val-unit-mob-o[1])
            cot-item.val-unit-mob-o[2]:screen-value in frame {&frame-name} = string(item-estab.val-unit-mob-o[2])
            cot-item.val-unit-mob-o[3]:screen-value in frame {&frame-name} = string(item-estab.val-unit-mob-o[3])
            cot-item.val-unit-ggf-o[1]:screen-value in frame {&frame-name} = string(item-estab.val-unit-ggf-o[1])
            cot-item.val-unit-ggf-o[2]:screen-value in frame {&frame-name} = string(item-estab.val-unit-ggf-o[2])
            cot-item.val-unit-ggf-o[3]:screen-value in frame {&frame-name} = string(item-estab.val-unit-ggf-o[3]).
    end.        
  end. 
end. 
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
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cot-item"}

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


