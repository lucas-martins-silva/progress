&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V03IN025 2.00.00.005}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN025 MUT}
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

def var c-hora-ini  like calen-data.hora-ini extent 5.
def var c-hora-fim  like calen-data.hora-fin extent 5.
def var c-turno     like calen-data.turno    extent 5.
def var i-cont      as integer.
def var i-auxiliar  as integer.
def var wh-hora-ini as handle extent 5.     
def var wh-hora-fim as handle extent 5.
def var wh-turno    as handle extent 5. 
def var c-label as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-2 fi-turno-1 fi-hora-ini-1 ~
fi-hora-fim-1 fi-turno-2 fi-hora-ini-2 fi-hora-fim-2 fi-turno-3 ~
fi-hora-ini-3 fi-hora-fim-3 fi-turno-4 fi-hora-ini-4 fi-hora-fim-4 ~
fi-turno-5 fi-hora-ini-5 fi-hora-fim-5 
&Scoped-Define DISPLAYED-OBJECTS fi-turno-1 fi-hora-ini-1 fi-hora-fim-1 ~
fi-turno-2 fi-hora-ini-2 fi-hora-fim-2 fi-turno-3 fi-hora-ini-3 ~
fi-hora-fim-3 fi-turno-4 fi-hora-ini-4 fi-hora-fim-4 fi-turno-5 ~
fi-hora-ini-5 fi-hora-fim-5 

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
DEFINE VARIABLE fi-hora-fim-1 AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-fim-2 AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-fim-3 AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-fim-4 AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-fim-5 AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-ini-1 AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-ini-2 AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-ini-3 AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-ini-4 AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-ini-5 AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-label-hora-fim AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-label-hora-ini AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-label-turno AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .63 NO-UNDO.

DEFINE VARIABLE fi-turno-1 AS CHARACTER FORMAT "9":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE fi-turno-2 AS CHARACTER FORMAT "9":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE fi-turno-3 AS CHARACTER FORMAT "9":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE fi-turno-4 AS CHARACTER FORMAT "9":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE fi-turno-5 AS CHARACTER FORMAT "9":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53 BY 6.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 9.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-turno-1 AT ROW 3.67 COL 22 COLON-ALIGNED NO-LABEL
     fi-hora-ini-1 AT ROW 3.67 COL 37 COLON-ALIGNED NO-LABEL
     fi-hora-fim-1 AT ROW 3.67 COL 56 COLON-ALIGNED NO-LABEL
     fi-turno-2 AT ROW 4.75 COL 22 COLON-ALIGNED NO-LABEL
     fi-hora-ini-2 AT ROW 4.75 COL 37 COLON-ALIGNED NO-LABEL
     fi-hora-fim-2 AT ROW 4.75 COL 56 COLON-ALIGNED NO-LABEL
     fi-turno-3 AT ROW 5.88 COL 22 COLON-ALIGNED NO-LABEL
     fi-hora-ini-3 AT ROW 5.88 COL 37 COLON-ALIGNED NO-LABEL
     fi-hora-fim-3 AT ROW 5.88 COL 56 COLON-ALIGNED NO-LABEL
     fi-turno-4 AT ROW 6.92 COL 22 COLON-ALIGNED NO-LABEL
     fi-hora-ini-4 AT ROW 6.92 COL 37 COLON-ALIGNED NO-LABEL
     fi-hora-fim-4 AT ROW 6.92 COL 56 COLON-ALIGNED NO-LABEL
     fi-turno-5 AT ROW 8 COL 22 COLON-ALIGNED NO-LABEL
     fi-hora-ini-5 AT ROW 8 COL 37 COLON-ALIGNED NO-LABEL
     fi-hora-fim-5 AT ROW 8 COL 56 COLON-ALIGNED NO-LABEL
     fi-label-turno AT ROW 2.63 COL 19 COLON-ALIGNED NO-LABEL
     fi-label-hora-fim AT ROW 2.63 COL 53 COLON-ALIGNED NO-LABEL
     fi-label-hora-ini AT ROW 2.67 COL 33 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
     RECT-2 AT ROW 2.88 COL 17
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 9.96
         WIDTH              = 85.14.
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

/* SETTINGS FOR FILL-IN fi-label-hora-fim IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-label-hora-ini IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-label-turno IN FRAME f-main
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fi-turno-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-turno-2 V-table-Win
ON ENTRY OF fi-turno-2 IN FRAME f-main
DO:
  /*
      if ((input frame {&frame-name} fi-turno-1    eq "") or 
          (input frame {&frame-name} fi-hora-ini-1 eq ?) or 
          (input frame {&frame-name} fi-hora-fim-1 eq ?)) then do:
  
         run utp/ut-msgs.p (input "show",
                            input 683   ,
                            input ""    ).
         apply "entry" to fi-turno-1 in frame {&frame-name}.
         return no-apply.                    
      end.                            
  */    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-turno-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-turno-3 V-table-Win
ON ENTRY OF fi-turno-3 IN FRAME f-main
DO:
  /*
      if ((input frame {&frame-name} fi-turno-2    eq "") or 
          (input frame {&frame-name} fi-hora-ini-2 eq "") or 
          (input frame {&frame-name} fi-hora-fim-2 eq "")) then do:
  
         run utp/ut-msgs.p (input "show",
                            input 683   ,
                            input ""    ).
         apply "entry" to fi-turno-1 in frame {&frame-name}.
         return no-apply.                    
      end.                            
      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-turno-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-turno-4 V-table-Win
ON ENTRY OF fi-turno-4 IN FRAME f-main
DO:
  /*
      if ((input frame {&frame-name} fi-turno-3    eq "") or
          (input frame {&frame-name} fi-hora-ini-3 eq "") or
          (input frame {&frame-name} fi-hora-fim-3 eq "")) then do:
         run utp/ut-msgs.p (input "show",
                            input 683   ,
                            input ""    ).
         apply "entry" to fi-turno-1 in frame {&frame-name}.
         return no-apply.                    
      end.                      
      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-turno-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-turno-5 V-table-Win
ON ENTRY OF fi-turno-5 IN FRAME f-main
DO:
  /*
      if ((input frame {&frame-name} fi-turno-4    eq "") or
          (input frame {&frame-name} fi-hora-ini-4 eq "") or
          (input frame {&frame-name} fi-hora-fim-4 eq "")) then do:
         run utp/ut-msgs.p (input "show",
                            input 683   ,
                            input ""    ).
         apply "entry" to fi-turno-1 in frame {&frame-name}.
         return no-apply.                    
      end.                         */
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
  
{utp/ut-liter.i "Turno" "*" "L"}
assign fi-label-turno:screen-value in frame {&frame-name} = " " + return-value
       fi-label-turno                                     = " " + return-value.
  
{utp/ut-liter.i "Hora Inicial" "*" "L"}
assign fi-label-hora-ini:screen-value in frame {&frame-name} = " " + return-value
       fi-label-hora-ini                                     = " " + return-value.
       
{utp/ut-liter.i "Hora Final" "*" "L"}
assign fi-label-hora-fim:screen-value in frame {&frame-name} = " " + return-value
       fi-label-hora-fim                                     = " " + return-value.
       
  
/*
{utp/ut-liter.i "Turno" "*" "R"}
assign fi-turno-1:label = return-value
       fi-turno-2:label = return-value
       fi-turno-3:label = return-value
       fi-turno-4:label = return-value
       fi-turno-5:label = return-value.
{utp/ut-liter.i "Hora Inicio" "*" "R"}
assign fi-hora-ini-1:label = return-value       
       fi-hora-ini-2:label = return-value       
       fi-hora-ini-3:label = return-value       
       fi-hora-ini-4:label = return-value       
       fi-hora-ini-5:label = return-value.
{utp/ut-liter.i "Hora Final" "*" "R"}
assign fi-hora-fim-1:label = return-value       
       fi-hora-fim-2:label = return-value       
       fi-hora-fim-3:label = return-value       
       fi-hora-fim-4:label = return-value       
       fi-hora-fim-5:label = return-value.       
*/

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  assign wh-turno[1]    = fi-turno-1:handle      in frame {&frame-name}
         wh-hora-ini[1] = fi-hora-ini-1:handle
         wh-hora-fim[1] = fi-hora-fim-1:handle       
         wh-turno[2]    = fi-turno-2:handle
         wh-hora-ini[2] = fi-hora-ini-2:handle
         wh-hora-fim[2] = fi-hora-fim-2:handle       
         wh-turno[3]    = fi-turno-3:handle
         wh-hora-ini[3] = fi-hora-ini-3:handle
         wh-hora-fim[3] = fi-hora-fim-3:handle       
         wh-turno[4]    = fi-turno-4:handle
         wh-hora-ini[4] = fi-hora-ini-4:handle
         wh-hora-fim[4] = fi-hora-fim-4:handle       
         wh-turno[5]    = fi-turno-5:handle
         wh-hora-ini[5] = fi-hora-ini-5:handle
         wh-hora-fim[5] = fi-hora-fim-5:handle .
         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-consiste-valores V-table-Win 
PROCEDURE pi-consiste-valores :
/*------------------------------------------------------------------------------
  Purpose:  Consistir os diversos valores informados pelo usuario.   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   define output parameter p-turno-1      as char format "9".
   define output parameter p-hora-ini-1   as char format "99:99".
   define output parameter p-hora-fim-1   as char format "99:99".
   define output parameter p-turno-2      as char format "9".
   define output parameter p-hora-ini-2   as char format "99:99".
   define output parameter p-hora-fim-2   as char format "99:99".
   define output parameter p-turno-3      as char format "9".
   define output parameter p-hora-ini-3   as char format "99:99".
   define output parameter p-hora-fim-3   as char format "99:99".
   define output parameter p-turno-4      as char format "9".
   define output parameter p-hora-ini-4   as char format "99:99".
   define output parameter p-hora-fim-4   as char format "99:99".
   define output parameter p-turno-5      as char format "9".
   define output parameter p-hora-ini-5   as char format "99:99".
   define output parameter p-hora-fim-5   as char format "99:99".   
   
   if (input frame {&frame-name} fi-turno-1 ne "") and
      (fi-hora-ini-1:screen-value in frame {&frame-name} eq "  :  ") then do:
     {utp/ut-field.i mgind calen-data hora-ini 3}  
      run pi-tratamento-erros (input wh-hora-ini[1],
                               input 688,
                               input return-value).
      return "adm-error".
   end.                                                           

   if (input frame {&frame-name} fi-turno-1 ne "") and
      (fi-hora-fim-1:screen-value in frame {&frame-name} eq "  :  ") then do:
      {utp/ut-field.i mgind calen-data hora-fin 3}  
      run pi-tratamento-erros (input wh-hora-fim[1],
                               input 688,
                               input return-value).   
      return "adm-error".
   end.                                                           

   if (input frame {&frame-name} fi-turno-2 ne "") and
      (fi-hora-ini-2:screen-value in frame {&frame-name} eq "  :  ") then do:
      {utp/ut-field.i mgind calen-data hora-ini 3}  
      run pi-tratamento-erros (input wh-hora-ini[2],
                               input 688,
                               input return-value).   
      return "adm-error".
   end.                                                          

   if (input frame {&frame-name} fi-turno-2 ne "") and
      (fi-hora-fim-2:screen-value in frame {&frame-name} eq "  :  ") then do:
      {utp/ut-field.i mgind calen-data hora-fin 3}   
      run pi-tratamento-erros (input wh-hora-fim[2],
                               input 688,
                               input return-value).   
      return "adm-error".
   end.                            

   if (input frame {&frame-name} fi-turno-3 ne "") and
      (fi-hora-ini-3:screen-value in frame {&frame-name} eq "  :  ") then do:
      {utp/ut-field.i mgind calen-data hora-ini 3}  
      run pi-tratamento-erros (input wh-hora-ini[3],
                               input 688,
                               input return-value).   
      return "adm-error".
   end.                                                           

   if (input frame {&frame-name} fi-turno-3 ne "") and
      (fi-hora-fim-3:screen-value in frame {&frame-name} eq "  :  ") then do:
      {utp/ut-field.i mgind calen-data hora-fin 3}  
      run pi-tratamento-erros (input wh-hora-fim[3],
                               input 688,
                               input return-value).   
      return "adm-error".
   end.                                                           

   if (input frame {&frame-name} fi-turno-4 ne "") and
      (fi-hora-ini-4:screen-value in frame {&frame-name} eq "  :  ") then do:
      {utp/ut-field.i mgind calen-data hora-ini 3}  
      run pi-tratamento-erros (input wh-hora-ini[4],
                               input 688,
                               input return-value).   
      return "adm-error".
   end.                                                           

   if (input frame {&frame-name} fi-turno-4 ne "") and
      (fi-hora-fim-4:screen-value in frame {&frame-name} eq "  :  ") then do:
      {utp/ut-field.i mgind calen-data hora-fin 3}   
      run pi-tratamento-erros (input wh-hora-fim[4],
                               input 688,
                               input return-value).   
      return "adm-error".
   end.                                                           

   if (input frame {&frame-name} fi-turno-5 ne "") and
      (fi-hora-ini-5:screen-value in frame {&frame-name} eq "  :  ") then do:
      {utp/ut-field.i mgind calen-data hora-ini 3}  
      run pi-tratamento-erros (input wh-hora-ini[5],
                               input 688,
                               input return-value).   
      return "adm-error".
   end.                                                           

   if (input frame {&frame-name} fi-turno-5 ne "") and
      (fi-hora-fim-5:screen-value in frame {&frame-name} eq "  :  ") then do:
      {utp/ut-field.i mgind calen-data hora-fin 3}  
      run pi-tratamento-erros (input wh-hora-fim[5],
                               input 688,
                               input return-value).   
      return "adm-error".
   end.                                                           

   if ((input frame {&frame-name} fi-turno-1 eq "") and 
       (input frame {&frame-name} fi-turno-2 eq "") and   
       (input frame {&frame-name} fi-turno-3 eq "") and 
       (input frame {&frame-name} fi-turno-4 eq "") and 
       (input frame {&frame-name} fi-turno-5 eq "")) then do:
      run pi-tratamento-erros (input wh-turno[1],
                              input 695,
                              input "").   
      return "adm-error".
   end.                                                           

  /* Joga os fill-in para vetores para facilitar as consistencias ... */  
  if input frame {&frame-name} fi-turno-1 ne ""
  then 
     assign c-turno[1]    = input frame {&frame-name} fi-turno-1
            c-hora-ini[1] = input frame {&frame-name} fi-hora-ini-1
            c-hora-fim[1] = input frame {&frame-name} fi-hora-fim-1.
  else           
     assign c-turno[1]    = ""
            c-hora-ini[1] = ""
            c-hora-fim[1] = "".

  if input frame {&frame-name} fi-turno-2 ne ""
  then 
     assign c-turno[2]    = input frame {&frame-name} fi-turno-2
            c-hora-ini[2] = input frame {&frame-name} fi-hora-ini-2
            c-hora-fim[2] = input frame {&frame-name} fi-hora-fim-2.
  else           
     assign c-turno[2]    = ""
            c-hora-ini[2] = ""
            c-hora-fim[2] = "".
         
  
  if input frame {&frame-name} fi-turno-3 ne "" 
  then 
     assign c-turno[3]    = input frame {&frame-name} fi-turno-3
            c-hora-ini[3] = input frame {&frame-name} fi-hora-ini-3
            c-hora-fim[3] = input frame {&frame-name} fi-hora-fim-3.
  else           
     assign c-turno[3]    = ""
            c-hora-ini[3] = ""
            c-hora-fim[3] = "".
            
  
  if input frame {&frame-name} fi-turno-4 ne "" 
  then 
     assign c-turno[4]    = input frame {&frame-name} fi-turno-4
            c-hora-ini[4] = input frame {&frame-name} fi-hora-ini-4
            c-hora-fim[4] = input frame {&frame-name} fi-hora-fim-4.
  else           
     assign c-turno[4]    = ""
            c-hora-ini[4] = ""
            c-hora-fim[4] = "".            
  
  if input frame {&frame-name} fi-turno-5 ne "" 
  then 
     assign c-turno[5]    = input frame {&frame-name} fi-turno-5
            c-hora-ini[5] = input frame {&frame-name} fi-hora-ini-5
            c-hora-fim[5] = input frame {&frame-name} fi-hora-fim-5 .   
  else           
     assign c-turno[5]    = ""
            c-hora-ini[5] = ""
            c-hora-fim[5] = "".     


do i-cont = 1 to 5:  
  if c-turno[i-cont] ne "" then do:  
    if c-hora-fim[i-cont] gt "2400" then do:
          /* Erro 725 -> hora final deve ser menor ou igual a 24:00 */
          run pi-tratamento-erros (input wh-hora-fim[i-cont],
                                   input 725,
                                   input "" ).
          return "adm-error".
    end.                                                               
 
    if (substr(string(c-hora-ini[i-cont]),1,2) > "24" or
        substr(string(c-hora-ini[i-cont]),3,2) > "59") or  
     /*gt*/
       (substr(string(c-hora-fim[i-cont]),1,2) > "24" or
        substr(string(c-hora-fim[i-cont]),3,2) > "59") then do:
       /* Erro 4786 -> Hora esta incorreta */ 
       {utp/ut-field.i mgind calen-data hora-fin 1} 
        assign c-label = return-value.  
       {utp/ut-field.i mgind calen-data hora-ini 1}  
       run pi-tratamento-erros (input wh-hora-ini[i-cont],
                                input 4786,
                                input "" /*return-value + "~~" + c-label*/).
       return "adm-error".
    end.                                                            

     if c-hora-ini[i-cont] gt c-hora-fim[i-cont] then do:
       /* Erro 8747 -> Hora inicial maior que a final. Confirma? */ 
       {utp/ut-field.i mgind calen-data hora-fin 1} 
        assign c-label = return-value.  
       {utp/ut-field.i mgind calen-data hora-ini 1}  
       run pi-tratamento-erros (input wh-hora-ini[i-cont],
                                input 8747,
                                input return-value).
                                
      if return-value = "no" then 
        return "adm-error".
                           
    end.                                                            

    if (i-cont gt 1) and (c-hora-ini[i-cont] lt c-hora-fim[i-cont - 1]) then do:
       /* Erro 726 -> O horario inicial do turno deve ser maior que o horario
                      final do turno anterior.                                */
       run pi-tratamento-erros (input wh-hora-ini[i-cont],
                                input 726,
                                input "" ).
       return "adm-error".
    end.                            
  end.
end.                      

do i-auxiliar = 1 to 5:
   do i-cont = 1 to 5:
      if ( (i-cont ne i-auxiliar ) and
           (c-turno[i-cont] ne "") and 
           (c-turno[i-cont] eq c-turno[i-auxiliar]) ) then do:
         /* Erro 728 -> Nao podem haver turnos iguais */
         run pi-tratamento-erros (input wh-turno[i-cont],
                                  input 728,
                                  input "" ). 
         return "adm-error".                         
      end.   
   end.
end.  


   assign p-turno-1       = c-turno[1] 
          p-hora-ini-1    = c-hora-ini[1] 
          p-hora-fim-1    = c-hora-fim[1]
          p-turno-2       = c-turno[2]  
          p-hora-ini-2    = c-hora-ini[2]  
          p-hora-fim-2    = c-hora-fim[2]
          p-turno-3       = c-turno[3]  
          p-hora-ini-3    = c-hora-ini[3]      
          p-hora-fim-3    = c-hora-fim[3]      
          p-turno-4       = c-turno[4]
          p-hora-ini-4    = c-hora-ini[4]  
          p-hora-fim-4    = c-hora-fim[4]  
          p-turno-5       = c-turno[5]
          p-hora-ini-5    = c-hora-ini[5]  
          p-hora-fim-5    = c-hora-fim[5].     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-tratamento-erros V-table-Win 
PROCEDURE pi-tratamento-erros :
/*------------------------------------------------------------------------------
  Purpose: Simplificar a emissao de msg. de erro e retorno ao campo incorreto.    
  Parameters:  Handle do campo incorreto, numero da msg, parametro da msg.
  Notes:       
------------------------------------------------------------------------------*/
   define input parameter wh-campo-erro  as handle.
   define input parameter i-numero-erro  as integer.
   define input parameter c-msg-erro     as character.

   run utp/ut-msgs.p (input "show",
                      input i-numero-erro,
                      input c-msg-erro   ).
   apply "entry" to wh-campo-erro.

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
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


