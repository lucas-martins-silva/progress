&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i V20IN271 2.00.01.007}  /*** 010107 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V20IN271 MUT}
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

def var wh-browse-hdl as widget-handle no-undo.
def var c-browse-hdl  as char          no-undo.
def var i             as integer       no-undo.

DEFINE VARIABLE hProgramZoom AS HANDLE NO-UNDO.
DEFINE VARIABLE l-habilita AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-OBJECTS fi-nr-ord-prod fi-it-codigo ~
fi-qtde-simulada fi-um fi-cod-refer 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS fi-nr-ord-prod fi-qtde-simulada 

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
DEFINE VARIABLE fi-cod-refer AS CHARACTER FORMAT "X(08)":U 
     LABEL "Referˆncia" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ord-prod AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Ordem" 
     VIEW-AS FILL-IN 
     SIZE 14.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qtde-simulada AS DECIMAL FORMAT ">>>>>,>>9.9999":U INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-um AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 2.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-nr-ord-prod AT ROW 1.5 COL 10 COLON-ALIGNED
     fi-it-codigo AT ROW 1.5 COL 32.57 COLON-ALIGNED
     fi-qtde-simulada AT ROW 1.5 COL 66.14 COLON-ALIGNED
     fi-um AT ROW 1.5 COL 80.43 COLON-ALIGNED NO-LABEL
     fi-cod-refer AT ROW 2.5 COL 32.57 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 2.92
         WIDTH              = 89.14.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-ord-prod IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-qtde-simulada IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-um IN FRAME f-main
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

&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON F5 OF fi-it-codigo IN FRAME f-main /* Item */
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in271.w"
                      &campo     = fi-nr-ord-prod
                      &campozoom = nr-ord-produ   }


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME f-main /* Item */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-ord-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ord-prod V-table-Win
ON ENTRY OF fi-nr-ord-prod IN FRAME f-main /* Ordem */
DO:
   find ord-prod where 
        ord-prod.nr-ord-prod eq input frame {&frame-name} fi-nr-ord-prod 
        no-lock no-error.
   if avail(ord-prod) then 
      assign fi-it-codigo       = ord-prod.it-codigo
             fi-um              = ord-prod.un
             fi-qtde-simulada   = if (ord-prod.qt-ordem gt ord-prod.qt-produzida) 
                                  then ord-prod.qt-ordem - ord-prod.qt-produzida
                                  else 0.
   else              
      assign fi-it-codigo       = ""
             fi-um              = ""
             fi-qtde-simulada   = 0.             
   display   fi-it-codigo       
             fi-um              
             fi-qtde-simulada   with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ord-prod V-table-Win
ON F5 OF fi-nr-ord-prod IN FRAME f-main /* Ordem */
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in271.w"
                      &campo     = fi-nr-ord-prod
                      &campozoom = nr-ord-produ   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ord-prod V-table-Win
ON LEAVE OF fi-nr-ord-prod IN FRAME f-main /* Ordem */
DO:

   assign fi-nr-ord-prod.
   apply "entry":U to fi-it-codigo in frame {&frame-name}. 
   find ord-prod where 
        ord-prod.nr-ord-prod = input frame {&frame-name} fi-nr-ord-prod 
        no-lock no-error.
   if avail(ord-prod) then 
      assign fi-it-codigo:sensitive in frame {&frame-name} = YES
             fi-it-codigo       = ord-prod.it-codigo
             fi-um              = ord-prod.un
             fi-cod-refer       = ord-prod.cod-refer
             fi-qtde-simulada   = if (ord-prod.qt-ordem gt ord-prod.qt-produzida) 
                                  then ord-prod.qt-ordem - ord-prod.qt-produzida
                                  else 0.
   else
       ASSIGN fi-it-codigo:sensitive in frame {&frame-name} = yes 
             fi-nr-ord-prod     = 0
             fi-it-codigo       = ""
             fi-um              = ""
             fi-cod-refer
             fi-qtde-simulada   = 0.

   if input frame {&frame-name} fi-nr-ord-prod = 0 then
      assign fi-it-codigo:sensitive in frame {&frame-name} = yes.



   display   fi-nr-ord-prod
             fi-it-codigo 
             fi-um       
             fi-cod-refer       
             fi-qtde-simulada   with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ord-prod V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-nr-ord-prod IN FRAME f-main /* Ordem */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

{utp/ut-field.i mgind ord-prod nr-ord-produ 2}
assign fi-nr-ord-prod:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind ord-prod it-codigo 1}
assign fi-it-codigo:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Qtde._Simul. MCP R}
assign fi-qtde-simulada:label in frame {&frame-name} = return-value.


fi-nr-ord-prod:load-mouse-pointer("image\lupa.cur":U) in frame {&frame-name}.
fi-it-codigo:load-mouse-pointer("image\lupa.cur":U)   in frame {&frame-name}.

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

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-ordem V-table-Win 
PROCEDURE pi-get-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define output param p-nr-ord-prod like ord-prod.nr-ord-prod.

    assign p-nr-ord-prod = input frame {&frame-name} fi-nr-ord-prod.

    return "ok":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita V-table-Win 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF fi-nr-ord-prod:SENSITIVE IN FRAME {&FRAME-NAME} = YES THEN
   ASSIGN l-habilita = YES.
ELSE
   ASSIGN l-habilita = NO.

RETURN string(l-habilita).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-ord-prod V-table-Win 
PROCEDURE pi-zoom-ord-prod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign fi-it-codigo = input frame {&frame-name} fi-it-codigo.

    select count(*) into i from ord-prod  where 
                                ord-prod.it-codigo = fi-it-codigo.
    IF i = 0 THEN do:
       run utp/ut-msgs.p(input "show":U,
                         input 26773,
                         input input frame {&frame-name} fi-it-codigo).
       apply 'entry':U to fi-it-codigo in frame {&frame-name} .
       return no-apply.
    end.

/*             {method/ZoomFields.i &ProgramZoom="inzoom/z08in271.w"                                                              */
/*                                  &FieldZoom1="nr-ord-produ"                                                                    */
/*                                  &FieldScreen1="fi-nr-ord-prod"                                                                */
/*                                  &Frame1="f-main"                                                                              */
/*                                  &RunMethod="RUN pi-seta-item IN hProgramZoom (INPUT input frame {&frame-name} fi-it-codigo)." */
/*                                  &EnableImplant="NO"}                                                                          */
/*                                                                                                                                */


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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

      when "desabilita-campos" then do:
         clear frame {&frame-name}.
         disable {&adm-modify-fields} with frame {&frame-name}.
         ASSIGN fi-it-codigo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      end.   

      when "habilita-campos"   then do:
         enable {&adm-modify-fields} with frame {&frame-name}.
         enable fi-it-codigo with frame {&frame-name}.
         apply "entry" to fi-nr-ord-prod in frame {&frame-name}.
      end.    

      when "consiste-viewer" then do:
         find ord-prod where 
              ord-prod.nr-ord-prod eq input frame {&frame-name} fi-nr-ord-prod
              no-lock no-error.
         if not avail(ord-prod) then do :
            {utp/ut-table.i mgind ord-prod 1}
            run utp/ut-msgs.p (input "show":U      ,
                               input 56          ,
                               input return-value).
            apply "entry":U to fi-nr-ord-prod in frame {&frame-name}.                   
            return ERROR.                   
         end.                        
         else do:

            if ord-prod.origem = "MV":U then do:
               run utp/ut-msgs.p (input "show":U,
                                  input 29505 ,
                                  input ""    ).               
               apply "entry":U to fi-nr-ord-prod in frame {&frame-name}.
               return error.
            end.            

            if ((ord-prod.estado eq 7) or (ord-prod.estado eq 8)) then do:
               run utp/ut-msgs.p (input "show":U,
                                  input 1311  ,
                                  input ""    ).               
               apply "entry":U to fi-nr-ord-prod in frame {&frame-name}.
               return error.
            end.                     
            else do:                      
               {utp/ut-field.i mgind movto-mat quantidade 1}
               if input frame {&frame-name} fi-qtde-simulada le 0 then do:
                  run utp/ut-msgs.p (input "show":U      ,
                                     input 822         ,
                                     input return-value).
                  apply "entry":U to fi-qtde-simulada in frame {&frame-name}.                   
                  return error.                   
               end.          
               else do:
                  /*disable {&adm-modify-fields} with frame {&frame-name}.*/

                  /* Descobre a handle do browse */
                  run get-link-handle in adm-broker-hdl 
                     (input  this-procedure,
                      input  "State-Target",
                     output c-browse-hdl).
                  assign wh-browse-hdl    = widget-handle(c-browse-hdl)
                         fi-qtde-simulada = input frame {&frame-name} fi-qtde-simulada.                 
                  run pi-processa-calculo IN wh-browse-hdl (input ord-prod.nr-ord-prod,
                                                            input fi-qtde-simulada    ).                                                       
               end.
            end.         
          end. 
       end.       

      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

