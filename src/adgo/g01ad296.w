&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d-vapara
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d-vapara 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i G01AD296 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i G01AD296 MUT}
&ENDIF


/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Vanei

  Created: 
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

/* Parameters Definitions ---                                           */
define output parameter     p-row-tabela    as rowid    no-undo.

/* Local Variable Definitions ---                                       */

def buffer b-ocor-bcia-bco for ocor-bcia-bco.
def var i-tip-ocor-bcia as integer format "99"    no-undo.
def var c-tip-ocor      as char    format "x(20)" no-undo.
def var i-modulo        as integer format "99"    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME d-vapara

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ocor-bcia-bco

/* Definitions for DIALOG-BOX d-vapara                                  */
&Scoped-define FIELDS-IN-QUERY-d-vapara ocor-bcia-bco.cod-banco ~
ocor-bcia-bco.ind-ocor-bcia 
&Scoped-define ENABLED-FIELDS-IN-QUERY-d-vapara ocor-bcia-bco.cod-banco ~
ocor-bcia-bco.ind-ocor-bcia 
&Scoped-define ENABLED-TABLES-IN-QUERY-d-vapara ocor-bcia-bco
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-d-vapara ocor-bcia-bco

&Scoped-define FIELD-PAIRS-IN-QUERY-d-vapara~
 ~{&FP1}cod-banco ~{&FP2}cod-banco ~{&FP3}
&Scoped-define OPEN-QUERY-d-vapara OPEN QUERY d-vapara FOR EACH ocor-bcia-bco SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-d-vapara ocor-bcia-bco
&Scoped-define FIRST-TABLE-IN-QUERY-d-vapara ocor-bcia-bco


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ocor-bcia-bco.cod-banco ~
ocor-bcia-bco.ind-ocor-bcia 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-banco ~{&FP2}cod-banco ~{&FP3}
&Scoped-define ENABLED-TABLES ocor-bcia-bco
&Scoped-define FIRST-ENABLED-TABLE ocor-bcia-bco
&Scoped-Define ENABLED-OBJECTS RECT-18 rt-button cb-modulo c-tip-ocor-bcia ~
bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-FIELDS ocor-bcia-bco.cod-banco ~
ocor-bcia-bco.ind-ocor-bcia 
&Scoped-Define DISPLAYED-OBJECTS cb-modulo c-tip-ocor-bcia 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 cb-modulo c-tip-ocor-bcia 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


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

DEFINE VARIABLE c-tip-ocor-bcia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Ocor. Bancaria" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE cb-modulo AS CHARACTER FORMAT "X(256)":U 
     LABEL "M¢dulo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 21 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32 BY 1.17.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 52.57 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY d-vapara FOR 
      ocor-bcia-bco SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d-vapara
     ocor-bcia-bco.cod-banco AT ROW 1.29 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     cb-modulo AT ROW 1.25 COL 33 COLON-ALIGNED
     ocor-bcia-bco.ind-ocor-bcia AT ROW 2.75 COL 23 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Remessa", 1,
"Retorno", 2
          SIZE 23.57 BY .83
     c-tip-ocor-bcia AT ROW 4 COL 19 COLON-ALIGNED
     bt-ok AT ROW 5.75 COL 3.29
     bt-cancela AT ROW 5.75 COL 14.14
     bt-ajuda AT ROW 5.71 COL 44
     RECT-18 AT ROW 2.5 COL 21
     rt-button AT ROW 5.5 COL 2
     SPACE(1.85) SKIP(0.36)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "V  Para Ocorrˆncia Banc ria Banco"
         DEFAULT-BUTTON bt-ok CANCEL-BUTTON bt-cancela.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d-vapara
   Custom                                                               */
ASSIGN 
       FRAME d-vapara:SCROLLABLE       = FALSE
       FRAME d-vapara:HIDDEN           = TRUE.

ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME d-vapara       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR COMBO-BOX c-tip-ocor-bcia IN FRAME d-vapara
   1                                                                    */
/* SETTINGS FOR COMBO-BOX cb-modulo IN FRAME d-vapara
   1                                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX d-vapara
/* Query rebuild information for DIALOG-BOX d-vapara
     _TblList          = "mgadm.ocor-bcia-bco"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX d-vapara */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB d-vapara 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-vapara.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d-vapara
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-vapara d-vapara
ON GO OF FRAME d-vapara /* V  Para Ocorrˆncia Banc ria Banco */
DO:
  assign input frame {&frame-name} cb-modulo i-modulo = {adinc/i04ad296.i 06 cb-modulo}.

  if i-modulo = 1 and
     input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then do:
     assign input frame {&frame-name} c-tip-ocor-bcia 
            i-tip-ocor-bcia = {adinc/i02ad296.i 06 c-tip-ocor-bcia}.
   end.  
   else do:
      if i-modulo = 1 and 
         input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then do:
         assign input frame {&frame-name} c-tip-ocor-bcia 
                i-tip-ocor-bcia = {adinc/i03ad296.i 06 c-tip-ocor-bcia}.
       end.  
       else do:
           if  i-modulo = 2 and 
               input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then do:
               assign input frame {&frame-name} c-tip-ocor-bcia 
                      i-tip-ocor-bcia = {adinc/i05ad296.i 06 c-tip-ocor-bcia}.
           end.     
           else do:                  
               if i-modulo = 2 and 
                  input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then do:
                  assign input frame {&frame-name} c-tip-ocor-bcia 
                         i-tip-ocor-bcia = {adinc/i06ad296.i 06 c-tip-ocor-bcia}.
               end.   
           end.
        end.    
   end.     

  find b-ocor-bcia-bco no-lock
      where b-ocor-bcia-bco.cod-banco         = input frame {&FRAME-NAME} ocor-bcia-bco.cod-banco 
      and   b-ocor-bcia-bco.ind-modul-dtsul   = i-modulo
      and   b-ocor-bcia-bco.ind-ocor-bcia     = input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia 
      and   b-ocor-bcia-bco.ind-tip-ocor-bcia = i-tip-ocor-bcia no-error.

   if  not available b-ocor-bcia-bco then do:    
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Ocorrˆncia_Banc ria_Banco" *}
       run utp/ut-msgs.p(input "show",
                         input 2,
                         input RETURN-VALUE).
        return no-apply.
   end.
   assign p-row-tabela = rowid(b-ocor-bcia-bco).
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-vapara d-vapara
ON WINDOW-CLOSE OF FRAME d-vapara /* V  Para Ocorrˆncia Banc ria Banco */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda d-vapara
ON CHOOSE OF bt-ajuda IN FRAME d-vapara /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tip-ocor-bcia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tip-ocor-bcia d-vapara
ON VALUE-CHANGED OF c-tip-ocor-bcia IN FRAME d-vapara /* Tipo Ocor. Bancaria */
do:
assign input frame {&FRAME-NAME} c-tip-ocor-bcia. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-modulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-modulo d-vapara
ON VALUE-CHANGED OF cb-modulo IN FRAME d-vapara /* M¢dulo */
DO:
assign input frame {&FRAME-NAME} cb-modulo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ocor-bcia-bco.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ocor-bcia-bco.cod-banco d-vapara
ON LEAVE OF ocor-bcia-bco.cod-banco IN FRAME d-vapara /* Banco */
DO:
   assign cb-modulo:list-items   = {adinc/i04ad296.i 03}
          cb-modulo:screen-value = {adinc/i04ad296.i 04 1}
          c-tip-ocor-bcia:list-items   = {adinc/i02ad296.i 03}
          c-tip-ocor-bcia:screen-value = {adinc/i02ad296.i 04 1}.
       
    
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ocor-bcia-bco.ind-ocor-bcia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ocor-bcia-bco.ind-ocor-bcia d-vapara
ON TAB OF ocor-bcia-bco.ind-ocor-bcia IN FRAME d-vapara /* Remessa/Retorno */
DO:
    assign c-tip-ocor-bcia:screen-value = {adinc/i02ad296.i 04 1}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ocor-bcia-bco.ind-ocor-bcia d-vapara
ON VALUE-CHANGED OF ocor-bcia-bco.ind-ocor-bcia IN FRAME d-vapara /* Remessa/Retorno */
DO:
    do  with frame {&FRAME-NAME}:
       assign input frame {&frame-name} cb-modulo i-modulo = {adinc/i04ad296.i 06 cb-modulo}.
       if  i-modulo = 1
           and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then
            assign c-tip-ocor-bcia:list-items   = {adinc/i02ad296.i 03}
                   c-tip-ocor-bcia:screen-value = {adinc/i02ad296.i 04 1}
                   cb-modulo:list-items         = {adinc/i04ad296.i 03}
                   cb-modulo:screen-value       = {adinc/i04ad296.i 04 1}.
                   
        else do: 
            if  i-modulo = 1
                and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then 
                assign c-tip-ocor-bcia:list-items   = {adinc/i03ad296.i 03}
                       c-tip-ocor-bcia:screen-value = {adinc/i03ad296.i 04 1}
                       cb-modulo:list-items         = {adinc/i04ad296.i 03}
                       cb-modulo:screen-value       = {adinc/i04ad296.i 04 1}.
            else do:         
                if  i-modulo = 2
                    and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then 
                    assign c-tip-ocor-bcia:list-items   = {adinc/i05ad296.i 03}
                           c-tip-ocor-bcia:screen-value = {adinc/i05ad296.i 04 1}
                           cb-modulo:list-items         = {adinc/i04ad296.i 03}
                           cb-modulo:screen-value       = {adinc/i04ad296.i 04 1}.
                           
 
                else do:
                  if  i-modulo = 2
                      and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then
                      assign c-tip-ocor-bcia:list-items   = {adinc/i06ad296.i 03}
                             c-tip-ocor-bcia:screen-value = {adinc/i06ad296.i 04 1}
                             cb-modulo:list-items         = {adinc/i04ad296.i 03}
                             cb-modulo:screen-value       = {adinc/i04ad296.i 04 1}.
                          
                end.
            end.
        end.
    end.             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre d-vapara
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d-vapara 


/* ***************************  Main Block  *************************** */
  
assign p-row-tabela = ?.

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects d-vapara _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available d-vapara _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d-vapara _DEFAULT-DISABLE
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
  HIDE FRAME d-vapara.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d-vapara _DEFAULT-ENABLE
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
  DISPLAY cb-modulo c-tip-ocor-bcia 
      WITH FRAME d-vapara.
  IF AVAILABLE ocor-bcia-bco THEN 
    DISPLAY ocor-bcia-bco.cod-banco ocor-bcia-bco.ind-ocor-bcia 
      WITH FRAME d-vapara.
  ENABLE RECT-18 rt-button ocor-bcia-bco.cod-banco cb-modulo 
         ocor-bcia-bco.ind-ocor-bcia c-tip-ocor-bcia bt-ok bt-cancela bt-ajuda 
      WITH FRAME d-vapara.
  VIEW FRAME d-vapara.
  {&OPEN-BROWSERS-IN-QUERY-d-vapara}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy d-vapara 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize d-vapara 
PROCEDURE local-initialize :
{utp/ut9000.i "G01AD296" "2.00.00.005"}

/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
      
    /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

 /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records d-vapara _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ocor-bcia-bco"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed d-vapara 
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


