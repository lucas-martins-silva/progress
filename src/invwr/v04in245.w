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
{include/i-prgvrs.i V04IN245 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN245 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var i-cont as int initial 0 no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES natur-oper
&Scoped-define FIRST-EXTERNAL-TABLE natur-oper


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR natur-oper.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS natur-oper.manut-icm natur-oper.manut-ipi ~
natur-oper.ind-imprenda natur-oper.consum-final natur-oper.venda-ativo ~
natur-oper.aliq-icm-com 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}aliq-icm-com ~{&FP2}aliq-icm-com ~{&FP3}
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define DISPLAYED-FIELDS natur-oper.manut-icm natur-oper.manut-ipi ~
natur-oper.ind-imprenda natur-oper.consum-final natur-oper.venda-ativo ~
natur-oper.aliq-icm-com 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 COMBO-BOX-2 COMBO-BOX-3 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS COMBO-BOX-1 COMBO-BOX-2 COMBO-BOX-3 
&Scoped-define ADM-ASSIGN-FIELDS COMBO-BOX-1 COMBO-BOX-2 COMBO-BOX-3 
&Scoped-define ADM-MODIFY-FIELDS COMBO-BOX-1 COMBO-BOX-2 COMBO-BOX-3 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "ITEM 1" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "item 1" 
     SIZE 20.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 20.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 20.57 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     natur-oper.manut-icm AT ROW 1 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 17.43 BY .79
     natur-oper.manut-ipi AT ROW 1.79 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .75
     natur-oper.ind-imprenda AT ROW 2.63 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 23.72 BY .75
     natur-oper.consum-final AT ROW 1 COL 31
          VIEW-AS TOGGLE-BOX
          SIZE 24.86 BY .75
     natur-oper.venda-ativo AT ROW 1.75 COL 31
          VIEW-AS TOGGLE-BOX
          SIZE 16.29 BY .75
     natur-oper.aliq-icm-com AT ROW 3.71 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY 1
     COMBO-BOX-1 AT ROW 4.79 COL 34 COLON-ALIGNED
     COMBO-BOX-2 AT ROW 5.88 COL 34 COLON-ALIGNED
     COMBO-BOX-3 AT ROW 6.92 COL 34 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.natur-oper
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
         HEIGHT             = 7.38
         WIDTH              = 60.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-1 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-3 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME natur-oper.consum-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.consum-final V-table-Win
ON VALUE-CHANGED OF natur-oper.consum-final IN FRAME f-main /* Consumidor Final */
DO:

 if input frame {&frame-name} natur-oper.consum-final = no then do:
     assign natur-oper.aliq-icm-com:screen-value = "0".
     disable natur-oper.aliq-icm-com with frame {&frame-name}.
     assign natur-oper.venda-ativo:checked = no.
     disable natur-oper.venda-ativo with frame {&frame-name}.
 end.
 else do:
     enable natur-oper.aliq-icm-com with frame {&frame-name}.
     enable natur-oper.venda-ativo with frame {&frame-name}.
 end.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF 
  
  {UTP/UT-FIELD.I MGIND NATUR-OPER CD-TRIB-ICM 1}  
  ASSIGN COMBO-BOX-1:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.  
  
  {UTP/UT-FIELD.I MGIND NATUR-OPER CD-TRIB-IPI 1}  
  ASSIGN COMBO-BOX-2:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
  
  {UTP/UT-FIELD.I MGIND NATUR-OPER CD-TRIB-ISS 1}  
  ASSIGN COMBO-BOX-3:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.               
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "natur-oper"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "natur-oper"}

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
  
  do with frame {&frame-name}:
   assign combo-box-1:screen-value = {ininc/i01in245.i 04 1}
          combo-box-2:screen-value = {ininc/i10in172.i 04 1}
          combo-box-3:screen-value = {ininc/i11in172.i 04 1}.
  end. 
   
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
          
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
 
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
  
 assign input frame {&frame-name} combo-box-1 
        input frame {&frame-name} combo-box-2
        input frame {&frame-name} combo-box-3.
         
 if natur-oper.consum-final = no then do:
     assign natur-oper.aliq-icm-com = 0.
     disable natur-oper.aliq-icm-com with frame {&frame-name}.
     assign natur-oper.venda-ativo = no.
     disable natur-oper.venda-ativo with frame {&frame-name}.
 end.
 else do:
     enable natur-oper.aliq-icm-com with frame {&frame-name}.
     enable natur-oper.venda-ativo with frame {&frame-name}.
 end.
     
 assign natur-oper.cd-trib-icm  = {ininc/i01in245.i 06 combo-box-1}
        natur-oper.cd-trib-ipi  = {ininc/i10in172.i 06 combo-box-2}
        natur-oper.cd-trib-iss  = {ininc/i11in172.i 06 combo-box-3}.

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
  assign i-cont = 0.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
    /* Code placed here will execute AFTER standard behavior. */
    
    if avail natur-oper then do with frame {&frame-name}:
       assign combo-box-1:screen-value = {ininc/i01in245.i 04
              natur-oper.cd-trib-icm}
              combo-box-2:screen-value = {ininc/i10in172.i 04
              natur-oper.cd-trib-ipi}
              combo-box-3:screen-value = {ininc/i11in172.i 04
              natur-oper.cd-trib-iss}.         
    end.
    else do:
       assign combo-box-1:screen-value = {ininc/i01in245.i 04 1}
              combo-box-2:screen-value = {ininc/i10in172.i 04 1}
              combo-box-3:screen-value = {ininc/i11in172.i 04 1}.
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
  assign i-cont = i-cont + 1.
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  if avail natur-oper then do with frame {&frame-name}:
     assign combo-box-1:screen-value = {ininc/i01in245.i 04
            natur-oper.cd-trib-icm}
            combo-box-2:screen-value = {ininc/i10in172.i 04
            natur-oper.cd-trib-ipi}
            combo-box-3:screen-value = {ininc/i11in172.i 04
            natur-oper.cd-trib-iss}.         
  end.
  else do: 
       assign combo-box-1:screen-value = {ininc/i01in245.i 04 1}
              combo-box-2:screen-value = {ininc/i10in172.i 04 1}
              combo-box-3:screen-value = {ininc/i11in172.i 04 1}.
  end.  
               
  if  input frame {&frame-name} natur-oper.consum-final = yes then do:
      enable natur-oper.venda-ativo with frame {&frame-name}.
      enable natur-oper.aliq-icm-com with frame {&frame-name}.
  end.
  else do:    
      assign natur-oper.venda-ativo:checked = no.
      disable natur-oper.venda-ativo with frame {&frame-name}. 
      assign natur-oper.aliq-icm-com:screen-value = "0".
      disable natur-oper.aliq-icm-com with frame {&frame-name}.    
  end. 
  
  if i-cont = 2 then do:
      assign natur-oper.venda-ativo:checked = no.
      disable natur-oper.venda-ativo with frame {&frame-name}. 
      assign natur-oper.aliq-icm-com:screen-value = "0".
      disable natur-oper.aliq-icm-com with frame {&frame-name}.    
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

 do with frame {&frame-name}:
    assign combo-box-1:list-items = {ininc/i01in245.i 03}
           combo-box-2:list-items = {ininc/i10in172.i 03}
           combo-box-3:list-items = {ininc/i11in172.i 03}. 
 end.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
   disable natur-oper.aliq-icm-com with frame {&frame-name}.
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
              
   /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 /*{include/i-vldfrm.i}*/

 /*assign input frame {&frame-name} combo-box-1 
 *         input frame {&frame-name} combo-box-2
 *         input frame {&frame-name} combo-box-3.
 *          
 *  if natur-oper.consum-final = no then do:
 *      assign natur-oper.aliq-icm-com = 0.
 *      disable natur-oper.aliq-icm-com with frame {&frame-name}.
 *      assign natur-oper.venda-ativo = no.
 *      disable natur-oper.venda-ativo with frame {&frame-name}.
 *  end.
 *  else do:
 *      enable natur-oper.aliq-icm-com with frame {&frame-name}.
 *      enable natur-oper.venda-ativo with frame {&frame-name}.
 *  end.
 *      
 *  assign natur-oper.cd-trib-icm  = {ininc/i01in245.i 06 combo-box-1}
 *         natur-oper.cd-trib-ipi  = {ininc/i10in172.i 06 combo-box-2}
 *         natur-oper.cd-trib-iss  = {ininc/i11in172.i 06 combo-box-3}.*/
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "natur-oper"}

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


