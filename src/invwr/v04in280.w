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
{include/i-prgvrs.i V04IN280 2.00.00.015}  /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN280 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var c-pasta as char.
def var l-cancelado as logical.
def var i-pendencia as integer.

def var wh-cc0104 as handle    no-undo.
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
&Scoped-define EXTERNAL-TABLES param-compra
&Scoped-define FIRST-EXTERNAL-TABLE param-compra


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-compra.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-compra.log-2 param-compra.nome-ass[1] ~
param-compra.cargo-ass[1] param-compra.limite[1] param-compra.nome-ass[2] ~
param-compra.cargo-ass[2] param-compra.limite[2] param-compra.nome-ass[3] ~
param-compra.cargo-ass[3] 
&Scoped-define ENABLED-TABLES param-compra
&Scoped-define FIRST-ENABLED-TABLE param-compra
&Scoped-Define ENABLED-OBJECTS rt-key-4 rt-mold c-texto fi-limite ~
fi-nome-ass fi-cargo-ass 
&Scoped-Define DISPLAYED-FIELDS param-compra.log-2 param-compra.nome-ass[1] ~
param-compra.cargo-ass[1] param-compra.limite[1] param-compra.nome-ass[2] ~
param-compra.cargo-ass[2] param-compra.limite[2] param-compra.nome-ass[3] ~
param-compra.cargo-ass[3] 
&Scoped-define DISPLAYED-TABLES param-compra
&Scoped-define FIRST-DISPLAYED-TABLE param-compra
&Scoped-Define DISPLAYED-OBJECTS c-diretorio2 c-texto fi-limite fi-nome-ass ~
fi-cargo-ass 

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
DEFINE BUTTON bt-arq2 
     IMAGE-UP FILE "image~\im-fold":U
     IMAGE-INSENSITIVE FILE "image~\ii-fold":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-diretorio2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Diret¢rio" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-texto AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .67 NO-UNDO.

DEFINE VARIABLE fi-cargo-ass AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-limite AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-nome-ass AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE RECTANGLE rt-key-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 3.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 4.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bt-arq2 AT ROW 1.96 COL 78.86 HELP
          "Configura‡Æo da impressora"
     param-compra.log-2 AT ROW 2 COL 2.29
          VIEW-AS TOGGLE-BOX
          SIZE 19.72 BY .83
     c-diretorio2 AT ROW 2 COL 36.72 COLON-ALIGNED
     param-compra.nome-ass[1] AT ROW 5.71 COL 19.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     param-compra.cargo-ass[1] AT ROW 5.71 COL 50.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     param-compra.limite[1] AT ROW 6.71 COL 2.14 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.57 BY .88
     param-compra.nome-ass[2] AT ROW 6.71 COL 19.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     param-compra.cargo-ass[2] AT ROW 6.71 COL 50.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     param-compra.limite[2] AT ROW 7.71 COL 2.14 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.57 BY .88
     param-compra.nome-ass[3] AT ROW 7.71 COL 19.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     param-compra.cargo-ass[3] AT ROW 7.71 COL 50.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     c-texto AT ROW 1 COL 3.14 NO-LABEL
     fi-limite AT ROW 4.42 COL 1.14 COLON-ALIGNED NO-LABEL
     fi-nome-ass AT ROW 4.42 COL 21 COLON-ALIGNED NO-LABEL
     fi-cargo-ass AT ROW 4.42 COL 51.72 COLON-ALIGNED NO-LABEL
     rt-key-4 AT ROW 1.25 COL 1
     rt-mold AT ROW 4.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-compra
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
         HEIGHT             = 11.75
         WIDTH              = 84.14.
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
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON bt-arq2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-diretorio2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN param-compra.limite[1] IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN param-compra.limite[2] IN FRAME f-main
   ALIGN-L                                                              */
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

&Scoped-define SELF-NAME bt-arq2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq2 V-table-Win
ON CHOOSE OF bt-arq2 IN FRAME f-main
DO:
   run utp/ut-dir.p (input return-value, output c-pasta, output l-cancelado).

   if l-cancelado = no then do:
        assign c-diretorio2 = c-pasta.
        disp c-diretorio2 with frame {&frame-name}.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-compra.log-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-compra.log-2 V-table-Win
ON VALUE-CHANGED OF param-compra.log-2 IN FRAME f-main /* log-2 */
DO:
  if param-compra.log-2:checked in frame {&frame-name} = yes then do:
     assign c-diretorio2:sensitive in frame {&frame-name} = yes
            bt-arq2:sensitive in frame {&frame-name} = yes.
/*
      assign cb-pendencia:sensitive in frame {&frame-name} = yes.
      apply "value-changed" to cb-pendencia in frame {&frame-name}.
*/
  end.    
  else 
      assign /* cb-pendencia:sensitive in frame {&frame-name} = no */
             c-diretorio2:sensitive    in frame {&frame-name} = no
             c-diretorio2:screen-value in frame {&frame-name} = ""             
             bt-arq2:sensitive         in frame {&frame-name} = no.
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

{utp/ut-rtlbl.i mgind param-compra limite    fi-limite}
{utp/ut-rtlbl.i mgind param-compra nome-ass  fi-nome-ass}
{utp/ut-rtlbl.i mgind param-compra cargo-ass fi-cargo-ass}

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
  {src/adm/template/row-list.i "param-compra"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-compra"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

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

if param-compra.log-2:checked in frame {&frame-name} = yes then do:

    assign file-info:file-name = trim(input frame {&frame-name} c-diretorio2).
    if file-info:file-type = ? then do:
        run utp/ut-msgs.p (input "show", input 3943, input input frame {&frame-name} c-diretorio2).
        apply "entry" to c-diretorio2.
        return "adm-error".
    end.
end.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.

  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  def var c-char-1 as char no-undo.

  if avail param-compra then do:
    if param-compra.log-2:checked in frame {&frame-name} = yes then do:

        assign c-char-1 = 
              fill(" ",(50 - length(input frame {&frame-name} c-diretorio2))).

            assign OVERLAY(param-compra.char-1, 51, 50) = 
                      (input frame {&frame-name} c-diretorio2
                      + c-char-1).

    end.
    else assign OVERLAY(param-compra.char-1,51,50) = "".
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
  &endif.


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

  if avail param-compra then do with frame {&frame-name}:
   assign c-diretorio2:screen-value = substring(param-compra.char-1, 51, 50).
   end. 
  else do:
   assign c-diretorio2:screen-value = "".
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

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*if adm-new-record = yes then*/
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  if  avail param-compra 
  and param-compra.log-2 then do:       
     assign c-diretorio2:sensitive in frame {&frame-name} = yes
            bt-arq2:sensitive      in frame {&frame-name} = yes.
  end.
  else do:
     assign c-diretorio2:sensitive in frame {&frame-name} = no
            bt-arq2:sensitive      in frame {&frame-name} = no.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-liter.i Envia_E-mail * r}
  assign param-compra.log-2:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i E-mail * r}
  assign c-texto:screen-value in frame {&frame-name} = return-value.

  {utp/ut-liter.i Diret¢rio_E-mail_Pedido * l}
  assign c-diretorio2:label in frame {&frame-name} = trim(return-value).

  if avail param-compra then do:
        assign c-diretorio2 = substring(param-compra.char-1,51,50).
  end.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     define input parameter v-row-parent-externo as rowid no-undo.

     assign v-row-parent = v-row-parent-externo.

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

  if input param-compra.limite[2] <= input param-compra.limite[1] then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show", input 258, input "").        
      RUN select-page IN wh-cc0104 (3).                    
      apply "entry":U to param-compra.limite[2].                   
      RETURN 'ADM-ERROR':U.                     
  end.
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
  {src/adm/template/snd-list.i "param-compra"}

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

