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
{include/i-prgvrs.i V06IN215 2.00.00.002} /*** "010002" 01/11/2023 13:32:29 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06IN215 MUT}
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

{include/i_fncrowid.i}

/* global variable definitions */

def new global shared var v-row-parent as rowid  no-undo.

&IF {&ROWID_READY} = YES &THEN
    def new global shared var v_rec_video  as rowid  no-undo.
    def new global shared var v_rec_imagem as rowid  no-undo.
&ELSE
    def new global shared var v_rec_video  as recid  no-undo.
    def new global shared var v_rec_imagem as recid  no-undo.
&ENDIF

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-nome like mi-taref.descricao no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES mi-taref
&Scoped-define FIRST-EXTERNAL-TABLE mi-taref


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mi-taref.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mi-taref.cod-video mi-taref.cod-imagem 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-video ~{&FP2}cod-video ~{&FP3}~
 ~{&FP1}cod-imagem ~{&FP2}cod-imagem ~{&FP3}
&Scoped-define ENABLED-TABLES mi-taref
&Scoped-define FIRST-ENABLED-TABLE mi-taref
&Scoped-Define ENABLED-OBJECTS rt-mold BUTTON-4 BUTTON-5 
&Scoped-Define DISPLAYED-FIELDS mi-taref.cod-video mi-taref.cod-imagem 

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
DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "image\im-show":U
     LABEL "Button 4" 
     SIZE 4 BY .88.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "image\im-show":U
     LABEL "Button 5" 
     SIZE 4 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     mi-taref.cod-video AT ROW 1.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 32 BY .88
     BUTTON-4 AT ROW 1.5 COL 56
     mi-taref.cod-imagem AT ROW 2.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 32 BY .88
     BUTTON-5 AT ROW 2.5 COL 56
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.mi-taref
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 3
         WIDTH              = 85.72.
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

&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 V-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME f-main /* Button 4 */
DO:
    if  (mi-taref.cod-video:screen-value in frame {&frame-name} <> "":U) then do:
        find video
            where video.cod_video = mi-taref.cod-video:screen-value in frame {&frame-name}
            no-lock no-error.
        if  avail video then do:
            find catal_video of video
                no-lock no-error.
            if  avail catal_video then do:
                run btb/btb917zz.p (input string(catal_video.cod_path_catal + "/":U + video.vid_video)).
            end.
        end.
    end.
    else do:
        run utp/ut-msgs.p (input "show":U, input 7174, input "").
        apply 'entry' to mi-taref.cod-video.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 V-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME f-main /* Button 5 */
DO: 
    if  (mi-taref.cod-imagem:screen-value in frame {&frame-name} <> "":U) then do:
        find imagem
            where imagem.cod_imagem = mi-taref.cod-imagem:screen-value in frame {&frame-name}
            no-lock no-error.
        if  avail imagem then do:
            find catal_img of imagem
                no-lock no-error.
            if avail catal_img then 
               run btb/btb917zy.p(input string(catal_img.cod_path_catal + "/" + imagem.img_imagem)).  
        end.
        else do:
              run utp/ut-msgs.p (input "show":U, 
                                 input 3154,
                                 input "").
              apply 'entry' to mi-taref.cod-imagem in frame {&frame-name}.
              return no-apply.
        end.
    end.
    else do:
          run utp/ut-msgs.p (input "show":U, 
                             input 3154,
                             input "").
          apply 'entry' to mi-taref.cod-imagem.
          return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-taref.cod-imagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.cod-imagem V-table-Win
ON F5 OF mi-taref.cod-imagem IN FRAME f-main /* Imagem */
DO:
   run btb/btb104ka.p (param-mi.cod-catal-img).

   &IF {&ROWID_READY} = YES &THEN
       find imagem no-lock where
            rowid(imagem)  = v_rec_imagem no-error.
   &ELSE
       find imagem no-lock where
            recid(imagem)  = v_rec_imagem no-error.
   &ENDIF
   if avail imagem then
      assign mi-taref.cod-imagem:screen-value = string(imagem.cod_imagem).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.cod-imagem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mi-taref.cod-imagem IN FRAME f-main /* Imagem */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-taref.cod-video
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.cod-video V-table-Win
ON F5 OF mi-taref.cod-video IN FRAME f-main /* V¡deo */
DO:
    run btb/btb020ka.p (input param-mi.cod-catal-video).

    &IF {&ROWID_READY} = YES &THEN
        find video where rowid(video) = v_rec_video no-lock no-error.
    &ELSE
        find video where recid(video) = v_rec_video no-lock no-error.
    &ENDIF
    if  avail video then
        assign mi-taref.cod-video:screen-value = string(video.cod_video).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.cod-video V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mi-taref.cod-video IN FRAME f-main /* V¡deo */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  find first param-mi no-lock no-error.
  find first param-global no-lock no-error.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  if  mi-taref.cod-video:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.
  if  mi-taref.cod-imagem:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.


  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "mi-taref"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mi-taref"}

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
 
 if  input frame {&frame-name} mi-taref.cod-video <> "":U then do:
     find video where
          video.cod_video = input frame {&frame-name} mi-taref.cod-video
          no-lock no-error.
     if  avail video then do:
         if  param-mi.cod-catal-video <> "" then do:
             if  video.cod_catal_video <> param-mi.cod-catal-video then do:             
                 run utp/ut-msgs.p (input "show",
                                    input 6854,
                                   input "").
                 apply 'entry' to mi-taref.cod-video in frame {&frame-name}.                  
                 return 'adm-error'.
             end.
         end.
     end.
     else do:
         run utp/ut-msgs.p (input "show",
                            input 3154,
                            input "").
         apply 'entry' to mi-taref.cod-video in frame {&frame-name}.                   
         return 'adm-error'.
     end.
 end. 
 
 find first param-mi no-lock no-error.
    if  input frame {&frame-name} mi-taref.cod-imagem <> "":U then do:
        find imagem
             where imagem.cod_imagem = input frame {&frame-name} mi-taref.cod-imagem
             no-lock no-error.
        if avail imagem then do:
           if param-mi.cod-catal-img <> "" then do:
              if  imagem.cod_catal_img <> param-mi.cod-catal-img then do:             
                  run utp/ut-msgs.p (input "show",
                                     input 6854,
                                     input "").
                  apply 'entry' to mi-taref.cod-imagem in frame {&frame-name}.                   
                  return 'adm-error'.
              end.
           end.
        end.
        else do:
            {utp/ut-table.i mguni imagem 1}
             run utp/ut-msgs.p( input "show",
                                input 2,
                                input return-value).
             apply 'entry' to mi-taref.cod-imagem in frame {&frame-name}.                   
             return 'adm-error'.
         end.
    end.

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
  {src/adm/template/snd-list.i "mi-taref"}

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


