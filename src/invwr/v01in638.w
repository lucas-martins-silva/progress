&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V01IN638 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in638 MUT}
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

def buffer b-follow-up for texto-follow-up.

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var c-texto-narrat  like texto-follow-up.des-narrativa.

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
&Scoped-define EXTERNAL-TABLES texto-follow-up
&Scoped-define FIRST-EXTERNAL-TABLE texto-follow-up


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR texto-follow-up.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-narrativa rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS texto-follow-up.ind-tip-doc ~
texto-follow-up.nr-requisicao texto-follow-up.numero-ordem ~
texto-follow-up.cod-emitente texto-follow-up.it-codigo ~
texto-follow-up.sequencia texto-follow-up.num-pedido ~
texto-follow-up.parcela texto-follow-up.seq-narra 
&Scoped-Define DISPLAYED-OBJECTS c-narrativa 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS texto-follow-up.ind-tip-doc ~
texto-follow-up.nr-requisicao texto-follow-up.numero-ordem ~
texto-follow-up.cod-emitente texto-follow-up.it-codigo ~
texto-follow-up.sequencia texto-follow-up.num-pedido ~
texto-follow-up.parcela texto-follow-up.seq-narra c-narrativa 

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
DEFINE VARIABLE c-narrativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 74.29 BY 6.75
     BGCOLOR 8 .

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 5.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 8.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     texto-follow-up.ind-tip-doc AT ROW 1.17 COL 2 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Solicitaá∆o", 1,
"Requisiá∆o", 2,
"SC-OC", 3,
"Ord Compra", 4,
"Cotaá∆o", 5,
"Pedido", 6,
"Recebto", 7,
"Devol", 8
          SIZE 86.86 BY .83
     texto-follow-up.nr-requisicao AT ROW 2.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     texto-follow-up.numero-ordem AT ROW 2.17 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     texto-follow-up.cod-emitente AT ROW 3.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     texto-follow-up.it-codigo AT ROW 4.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     texto-follow-up.sequencia AT ROW 4.17 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     texto-follow-up.num-pedido AT ROW 5.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     texto-follow-up.parcela AT ROW 5.17 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     texto-follow-up.seq-narra AT ROW 6.75 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     c-narrativa AT ROW 7.75 COL 14 NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 6.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.texto-follow-up
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
         HEIGHT             = 13.92
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

/* SETTINGS FOR EDITOR c-narrativa IN FRAME f-main
   1                                                                    */
ASSIGN 
       c-narrativa:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN texto-follow-up.cod-emitente IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR RADIO-SET texto-follow-up.ind-tip-doc IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN texto-follow-up.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN texto-follow-up.nr-requisicao IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN texto-follow-up.num-pedido IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN texto-follow-up.numero-ordem IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN texto-follow-up.parcela IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN texto-follow-up.seq-narra IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN texto-follow-up.sequencia IN FRAME f-main
   NO-ENABLE 1                                                          */
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

{utp/ut-liter.i Requisiá∆o * R}
assign texto-follow-up.nr-requisicao:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Emitente * R}
assign texto-follow-up.cod-emitente:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Item * R}
assign texto-follow-up.it-codigo:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Pedido * R}
assign texto-follow-up.num-pedido:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Ord_Compra * R}
assign texto-follow-up.numero-ordem:label in frame {&frame-name} = return-value.

{utp/ut-liter.i SeqÅància * R}
assign texto-follow-up.sequencia:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Parcela * R}
assign texto-follow-up.parcela:label in frame {&frame-name} = return-value.

{utp/ut-liter.i SeqÅància_Narrativa * R}
assign texto-follow-up.seq-narra:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "texto-follow-up"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "texto-follow-up"}

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
        return 'ADM-ERROR':U.
    
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

  /* Code placed here will execute AFTER standard behavior.    */
 
   assign c-narrativa = ""
          c-texto-narrat = "".
   if avail texto-follow-up
   then do:
       assign c-narrativa:screen-value in frame {&frame-name} = texto-follow-up.des-narrativa.
       if texto-follow-up.nr-requisicao > 0 
       then
           for each b-follow-up where b-follow-up.nr-requisicao = texto-follow-up.nr-requisicao 
                and b-follow-up.seq-narra = texto-follow-up.seq-narra
                and b-follow-up.sequencia = texto-follow-up.sequencia 
                AND b-follow-up.numero-ordem  = texto-follow-up.numero-ordem no-lock
                break by b-follow-up.nr-trans descending:

                if b-follow-up.des-narrativa <> ?
                then  
                   assign c-texto-narrat = string(c-texto-narrat + chr(10) + chr(10) + 
                                           "============================= " + b-follow-up.des-narrativa,"x(15000)").

                if last(b-follow-up.nr-trans)
                then 
                    leave.
           end.
       else
           for each b-follow-up where b-follow-up.numero-ordem = texto-follow-up.numero-ordem 
                and b-follow-up.seq-narra = texto-follow-up.seq-narra
                and b-follow-up.sequencia = texto-follow-up.sequencia no-lock
                break by b-follow-up.nr-trans descending:
                if b-follow-up.des-narrativa <> ?
                then
                   assign c-texto-narrat = string(c-texto-narrat + chr(10) + chr(10) + 
                                           "============================== " + b-follow-up.des-narrativa,"x(15000)").
                if last(b-follow-up.nr-trans)
                then
                   leave.
           end.
       if availa b-follow-up
       then
           assign c-narrativa:screen-value in frame {&frame-name} = c-texto-narrat.
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
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    
/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "texto-follow-up"}

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

