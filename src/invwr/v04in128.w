&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V04IN128 2.00.00.022} /*** "010022" 09/01/2026 14:41:40  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04in128 MUT}
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
def new global shared var v-row-parent   as rowid no-undo.
def new global shared var gr-movto-estoq as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var i-medio as integer no-undo.
def new global shared var i-cenar-fech as integer no-undo.

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
&Scoped-define EXTERNAL-TABLES movto-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-OBJECTS de-valor1 de-valor4 de-valor7 de-valor2 ~
de-valor5 de-valor8 de-valor3 de-valor6 de-valor9 c-tit-mat c-tit-mob ~
c-tit-ggf 

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
DEFINE VARIABLE c-tit-ggf AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE c-tit-mat AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.43 BY .67 NO-UNDO.

DEFINE VARIABLE c-tit-mob AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.57 BY .67 NO-UNDO.

DEFINE VARIABLE de-valor1 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99" INITIAL 0 
     LABEL "fill-1" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor2 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "fill-2" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor3 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "fill-3" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor4 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor5 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor6 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor7 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor8 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor9 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.86 BY 9.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-valor1 AT ROW 3.75 COL 14.86 COLON-ALIGNED HELP
          "Valor Material Mensal"
     de-valor4 AT ROW 3.75 COL 36.72 COLON-ALIGNED NO-LABEL
     de-valor7 AT ROW 3.75 COL 58.57 COLON-ALIGNED NO-LABEL
     de-valor2 AT ROW 4.75 COL 14.86 COLON-ALIGNED
     de-valor5 AT ROW 4.75 COL 36.72 COLON-ALIGNED NO-LABEL
     de-valor8 AT ROW 4.75 COL 58.57 COLON-ALIGNED NO-LABEL
     de-valor3 AT ROW 5.75 COL 14.86 COLON-ALIGNED
     de-valor6 AT ROW 5.75 COL 36.72 COLON-ALIGNED NO-LABEL
     de-valor9 AT ROW 5.75 COL 58.57 COLON-ALIGNED NO-LABEL
     c-tit-mat AT ROW 2.5 COL 20.86 COLON-ALIGNED NO-LABEL
     c-tit-mob AT ROW 2.5 COL 41 COLON-ALIGNED NO-LABEL
     c-tit-ggf AT ROW 2.5 COL 66.72 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-estoq
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 9.04
         WIDTH              = 84.86.
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

/* SETTINGS FOR FILL-IN c-tit-ggf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-mat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor7 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor8 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor9 IN FRAME f-main
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "movto-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}

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
  {include/i-valid.i}
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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

  find first param-estoq no-lock no-error.
  find estab-mat where estab-mat.cod-estabel = movto-estoq.cod-estabel no-lock no-error.
  if avail estab-mat and i-medio = ? then do:
     assign i-medio = estab-mat.custo-contab.
  end.
  run pi-mostra-valores.

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

  {utp/ut-liter.i Material * C}
  assign c-tit-mat = return-value.
  {utp/ut-liter.i M∆o-de-Obra * C}
  assign c-tit-mob = return-value.
  {utp/ut-liter.i GGF * C}
  assign c-tit-ggf = return-value.
  display c-tit-mat
          c-tit-mob
          c-tit-ggf with frame {&frame-name}.

  find first param-estoq no-lock no-error.
  find moeda where moeda.mo-codigo = 0 no-lock no-error.
  if avail moeda then do:
     assign de-valor1:label in frame {&frame-name} = moeda.descricao.
  end.

  if param-estoq.tem-moeda1 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
     if avail moeda then do:
        assign de-valor2:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else do:
      assign de-valor2:visible in frame {&frame-name} = no.
      assign de-valor5:visible in frame {&frame-name} = no.
      assign de-valor8:visible in frame {&frame-name} = no.
  end.

  if param-estoq.tem-moeda2 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
     if avail moeda then do:
        assign de-valor3:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else do:
      assign de-valor3:visible in frame {&frame-name} = no.
      assign de-valor6:visible in frame {&frame-name} = no.
      assign de-valor9:visible in frame {&frame-name} = no.
  end.

  run pi-mostra-valores in this-procedure.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-valores V-table-Win 
PROCEDURE pi-mostra-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF i-cenar-fech = 1 THEN DO: //fiscal
 
      if i-medio = 1 then do:
         assign de-valor1 = movto-estoq.valor-mat-m[1]   
                de-valor2 = movto-estoq.valor-mat-m[2]  
                de-valor3 = movto-estoq.valor-mat-m[3]  
                de-valor4 = movto-estoq.valor-mob-m[1]  
                de-valor5 = movto-estoq.valor-mob-m[2]  
                de-valor6 = movto-estoq.valor-mob-m[3]  
                de-valor7 = movto-estoq.valor-ggf-m[1]  
                de-valor8 = movto-estoq.valor-ggf-m[2]  
                de-valor9 = movto-estoq.valor-ggf-m[3].
         if param-estoq.tem-moeda1 = yes and 
            param-estoq.tem-moeda2 = yes then do:
            display de-valor1 
                    de-valor2
                    de-valor3
                    de-valor4
                    de-valor5
                    de-valor6
                    de-valor7
                    de-valor8
                    de-valor9 with frame {&frame-name}.
         end.
         if param-estoq.tem-moeda1 = no and 
            param-estoq.tem-moeda2 = no then do:
            display de-valor1 
                    de-valor4
                    de-valor7 with frame {&frame-name}.
         end.
         if param-estoq.tem-moeda1 = no and
            param-estoq.tem-moeda2 = yes then do:
            display de-valor1 
                    de-valor3
                    de-valor4
                    de-valor6
                    de-valor7
                    de-valor9 with frame {&frame-name}.
         end.
         if param-estoq.tem-moeda1 = yes and
            param-estoq.tem-moeda2 = no then do:
            display de-valor1 
                    de-valor2
                    de-valor4
                    de-valor5
                    de-valor7
                    de-valor8
                    with frame {&frame-name}.
         end.
      end.
    
      if i-medio = 2 then do:
         assign de-valor1 = movto-estoq.valor-mat-o[1]   
                de-valor2 = movto-estoq.valor-mat-o[2]  
                de-valor3 = movto-estoq.valor-mat-o[3]  
                de-valor4 = movto-estoq.valor-mob-o[1]  
                de-valor5 = movto-estoq.valor-mob-o[2]  
                de-valor6 = movto-estoq.valor-mob-o[3]  
                de-valor7 = movto-estoq.valor-ggf-o[1]  
                de-valor8 = movto-estoq.valor-ggf-o[2]  
                de-valor9 = movto-estoq.valor-ggf-o[3].
         if param-estoq.tem-moeda1 = yes and 
            param-estoq.tem-moeda2 = yes then do:
            display de-valor1 
                    de-valor2
                    de-valor3
                    de-valor4
                    de-valor5
                    de-valor6
                    de-valor7
                    de-valor8
                    de-valor9 with frame {&frame-name}.
         end.
         if param-estoq.tem-moeda1 = no and 
            param-estoq.tem-moeda2 = no then do:
            display de-valor1 
                    de-valor4
                    de-valor7 with frame {&frame-name}.
         end.
         if param-estoq.tem-moeda1 = no and
            param-estoq.tem-moeda2 = yes then do:
            display de-valor1 
                    de-valor3
                    de-valor4
                    de-valor6
                    de-valor7
                    de-valor9 with frame {&frame-name}.
         end.
         if param-estoq.tem-moeda1 = yes and
            param-estoq.tem-moeda2 = no then do:
            display de-valor1 
                    de-valor2
                    de-valor4
                    de-valor5
                    de-valor7
                    de-valor8
                    with frame {&frame-name}.
         end.
      end.
    
      if i-medio = 3 then do:
    
         assign de-valor1 = movto-estoq.valor-mat-p[1]   
                de-valor2 = movto-estoq.valor-mat-p[2]  
                de-valor3 = movto-estoq.valor-mat-p[3]  
                de-valor4 = movto-estoq.valor-mob-p[1]  
                de-valor5 = movto-estoq.valor-mob-p[2]  
                de-valor6 = movto-estoq.valor-mob-p[3]  
                de-valor7 = movto-estoq.valor-ggf-p[1]  
                de-valor8 = movto-estoq.valor-ggf-p[2]  
                de-valor9 = movto-estoq.valor-ggf-p[3].
    
         if param-estoq.tem-moeda1 = yes and 
            param-estoq.tem-moeda2 = yes then do:
            display de-valor1 
                    de-valor2
                    de-valor3
                    de-valor4
                    de-valor5
                    de-valor6
                    de-valor7
                    de-valor8
                    de-valor9 with frame {&frame-name}.
         end.
         if param-estoq.tem-moeda1 = no and 
            param-estoq.tem-moeda2 = no then do:
            display de-valor1 
                    de-valor4
                    de-valor7 with frame {&frame-name}.
         end.
         if param-estoq.tem-moeda1 = no and
            param-estoq.tem-moeda2 = yes then do:
            display de-valor1 
                    de-valor3
                    de-valor4
                    de-valor6
                    de-valor7
                    de-valor9 with frame {&frame-name}.
         end.
         if param-estoq.tem-moeda1 = yes and
            param-estoq.tem-moeda2 = no then do:
            display de-valor1 
                    de-valor2
                    de-valor4
                    de-valor5
                    de-valor7
                    de-valor8
                    with frame {&frame-name}.
         end.
      end.

      if param-estoq.tem-moeda1 = no then do:
         assign de-valor2:visible in frame {&frame-name} = no.
         assign de-valor5:visible in frame {&frame-name} = no.
         assign de-valor8:visible in frame {&frame-name} = no.
      end.
    
      if param-estoq.tem-moeda2 = no then do:
         assign de-valor3:visible in frame {&frame-name} = no.
         assign de-valor6:visible in frame {&frame-name} = no.
         assign de-valor9:visible in frame {&frame-name} = no.
      end.

  END.
  ELSE DO: //gerencial

      /*busca extens∆o da movto-estoq para buscar os valores do custo gerencial*/ 
      find first ext-movto-estoq
           where ext-movto-estoq.nr-transacao    = movto-estoq.nr-trans
             and ext-movto-estoq.seq-custeio = 0 no-lock no-error.

      IF AVAIL ext-movto-estoq THEN    
          assign de-valor1 = ext-movto-estoq.val-mater[1]   
                 de-valor2 = ext-movto-estoq.val-mater[2]  
                 de-valor3 = ext-movto-estoq.val-mater[3]  
                 de-valor4 = ext-movto-estoq.val-mob[1]  
                 de-valor5 = ext-movto-estoq.val-mob[2]  
                 de-valor6 = ext-movto-estoq.val-mob[3]  
                 de-valor7 = ext-movto-estoq.val-ggf[1]  
                 de-valor8 = ext-movto-estoq.val-ggf[2]  
                 de-valor9 = ext-movto-estoq.val-ggf[3].

      if param-estoq.log-tem-moed-geren-1 = yes and 
         param-estoq.log-tem-moed-geren-2 = yes then do:
         display de-valor1 
                 de-valor2
                 de-valor3
                 de-valor4
                 de-valor5
                 de-valor6
                 de-valor7
                 de-valor8
                 de-valor9 with frame {&frame-name}.
      end.
      if param-estoq.log-tem-moed-geren-1 = no and 
         param-estoq.log-tem-moed-geren-2 = no then do:
         display de-valor1 
                 de-valor4
                 de-valor7 with frame {&frame-name}.
      end.
      if param-estoq.log-tem-moed-geren-1 = no and
         param-estoq.log-tem-moed-geren-2 = yes then do:
         display de-valor1 
                 de-valor3
                 de-valor4
                 de-valor6
                 de-valor7
                 de-valor9 with frame {&frame-name}.
      end.
      if param-estoq.log-tem-moed-geren-1 = yes and
         param-estoq.log-tem-moed-geren-2 = no then do:
         display de-valor1 
                 de-valor2
                 de-valor4
                 de-valor5
                 de-valor7
                 de-valor8
                 with frame {&frame-name}.
      end.

      if param-estoq.log-tem-moed-geren-1 = no then do:
         assign de-valor2:visible in frame {&frame-name} = no.
         assign de-valor5:visible in frame {&frame-name} = no.
         assign de-valor8:visible in frame {&frame-name} = no.
      end.
    
      if param-estoq.log-tem-moed-geren-2 = no then do:
         assign de-valor3:visible in frame {&frame-name} = no.
         assign de-valor6:visible in frame {&frame-name} = no.
         assign de-valor9:visible in frame {&frame-name} = no.
      end.

  END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-valores V-table-Win 
PROCEDURE pi-seta-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-medio as integer.

assign i-medio = p-medio.
run pi-mostra-valores in this-procedure.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "movto-estoq"}

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

