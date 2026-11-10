&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i AC1014B 2.00.00.004 } /*** "010004" 28/02/2025 09:42:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AC1014B MAC}
&ENDIF





/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

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

/* Local Variable Definitions ---                                       */

def temp-table tt-ped-venda-br NO-UNDO
        field line as int /* Este campo ‚ obrigat¢rio */
        field rw-ped-venda as rowid
        field nome-abrev   like ped-venda.nome-abrev
        field nr-pedcli    like ped-venda.nr-pedcli
        field no-ab-reppri like ped-venda.no-ab-reppri
        field dt-emissao   like ped-venda.dt-emissao
        field dt-implant   like ped-venda.dt-implant
        field dt-entrega   like ped-venda.dt-entrega
        field cod-sit-com  like ped-venda.cod-sit-com.

/* Parameters Definitions ---                                           */

def input-output parameter table for tt-ped-venda-br.
def input-output parameter l-ok-dig        as logical no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-12 c-nome-abrev c-nr-pedcli rt-buttom ~
bt-ok bt-salva bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-nome-abrev c-nr-pedcli 

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

DEFINE BUTTON bt-salva AUTO-END-KEY 
     LABEL "&Salva" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(12)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-pedcli AS CHARACTER FORMAT "X(12)":U 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 5.08.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 55.72 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     c-nome-abrev AT ROW 2.5 COL 18.29 COLON-ALIGNED
     c-nr-pedcli AT ROW 3.5 COL 18.29 COLON-ALIGNED
     bt-ok AT ROW 8 COL 1.86
     bt-salva AT ROW 8 COL 12.43
     bt-cancela AT ROW 8 COL 23.29
     bt-ajuda AT ROW 8 COL 46
     RECT-12 AT ROW 1.5 COL 2
     rt-buttom AT ROW 7.75 COL 1
     SPACE(0.41) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Parƒmetros Pedido".


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
/* SETTINGS FOR DIALOG-BOX D-Dialog
   L-To-R                                                               */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Parƒmetros Pedido */
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


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela D-Dialog
ON CHOOSE OF bt-cancela IN FRAME D-Dialog /* Cancelar */
DO:
    Assign l-ok-dig = no.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
   find first ped-venda no-lock 
        where ped-venda.nome-abrev = input frame {&frame-name} c-nome-abrev
          and ped-venda.nr-pedcli  = input frame {&frame-name} c-nr-pedcli 
          and ped-venda.log-cotacao  = NO NO-ERROR.
    
    
    if not avail ped-venda then do:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "registro" *}
       run utp/ut-msgs.p (input "SHOW",
                          input 2,
                          input RETURN-VALUE).
       apply 'entry' to c-nome-abrev.
       return no-apply.
    end.
    
    find tt-ped-venda-br
         where tt-ped-venda-br.nome-abrev = input frame {&frame-name} c-nome-abrev
           and tt-ped-venda-br.nr-pedcli  = input frame {&frame-name} c-nr-pedcli no-error.
    if not avail tt-ped-venda-br then do:                             
       create tt-ped-venda-br.
       assign tt-ped-venda-br.nome-abrev   = input frame {&frame-name} c-nome-abrev
              tt-ped-venda-br.nr-pedcli    = input frame {&frame-name} c-nr-pedcli
              tt-ped-venda-br.no-ab-reppri = ped-venda.no-ab-reppri
              tt-ped-venda-br.dt-emissao   = ped-venda.dt-emissao
              tt-ped-venda-br.dt-implant   = ped-venda.dt-implant
              tt-ped-venda-br.dt-entrega   = ped-venda.dt-entrega
              tt-ped-venda-br.cod-sit-com  = ped-venda.cod-sit-com
              tt-ped-venda-br.rw-ped-venda = rowid(ped-venda).
    end.

    Assign l-ok-dig        = yes.
           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva D-Dialog
ON CHOOSE OF bt-salva IN FRAME D-Dialog /* Salva */
DO:
    find first ped-venda no-lock 
         where ped-venda.nome-abrev = input frame {&frame-name} c-nome-abrev
           and ped-venda.nr-pedcli  = input frame {&frame-name} c-nr-pedcli 
           and ped-venda.log-cotacao  = NO NO-ERROR.
    
    
    if not avail ped-venda then do:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "registro" *}
       run utp/ut-msgs.p (input "SHOW",
                          input 2,
                          input RETURN-VALUE).
       apply 'entry' to c-nome-abrev.
       return no-apply.
    end.
                   
    find tt-ped-venda-br
         where tt-ped-venda-br.nome-abrev = input frame {&frame-name} c-nome-abrev
           and tt-ped-venda-br.nr-pedcli  = input frame {&frame-name} c-nr-pedcli no-error.
    if avail tt-ped-venda-br then do:
       run utp/ut-msgs.p (input "SHOW",
                          input 18819,
                          input "").
       apply 'entry' to c-nome-abrev.
       return no-apply.
    end.

    create tt-ped-venda-br.
    assign tt-ped-venda-br.nome-abrev   = input frame {&frame-name} c-nome-abrev
           tt-ped-venda-br.nr-pedcli    = input frame {&frame-name} c-nr-pedcli
           tt-ped-venda-br.no-ab-reppri = ped-venda.no-ab-reppri
           tt-ped-venda-br.dt-emissao   = ped-venda.dt-emissao
           tt-ped-venda-br.dt-implant   = ped-venda.dt-implant
           tt-ped-venda-br.dt-entrega   = ped-venda.dt-entrega
           tt-ped-venda-br.cod-sit-com  = ped-venda.cod-sit-com
           tt-ped-venda-br.rw-ped-venda = rowid(ped-venda).
          
    apply 'entry' to c-nome-abrev.
    return no-apply.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY c-nome-abrev c-nr-pedcli 
      WITH FRAME D-Dialog.
  ENABLE RECT-12 c-nome-abrev c-nr-pedcli rt-buttom bt-ok bt-salva bt-cancela 
         bt-ajuda 
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
{utp/ut9000.i "AC1014B" "2.00.00.004"} /* 28/02/2025 09:42:30 */

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


