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
{include/i-prgvrs.i V01IN575 2.00.00.013}  /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN575 MUT}
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

{include/i-vrtab.i contrat-modelo}
{include/i-vrtab.i clausula-mod}
{include/i-vrtab.i anexo-mod}
{cdp/cdcfgmat.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo. 
def new global shared var gr-contrato as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-contrato for contrat-modelo.
def buffer b-clausula for clausula-mod.
def buffer b-anexo    for anexo-mod.

def var i-contrato        as integer no-undo. 
def var c-nr-contrato     like contrato-for.nr-contrato no-undo.
def var c-incluir         as char no-undo.
def var i-opcao           as integer initial 0 no-undo.
DEF VAR c-nr-contrato-aux LIKE contrato-for.nr-contrato NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES contrat-modelo
&Scoped-define FIRST-EXTERNAL-TABLE contrat-modelo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR contrat-modelo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS contrat-modelo.des-contrat ~
contrat-modelo.natureza contrat-modelo.cod-tipo-contrat ~
contrat-modelo.log-libera contrat-modelo.narrat-contrato 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}des-contrat ~{&FP2}des-contrat ~{&FP3}~
 ~{&FP1}cod-tipo-contrat ~{&FP2}cod-tipo-contrat ~{&FP3}
&Scoped-define ENABLED-TABLES contrat-modelo
&Scoped-define FIRST-ENABLED-TABLE contrat-modelo
&Scoped-Define ENABLED-OBJECTS rt-key RECT-2 rt-mold 
&Scoped-Define DISPLAYED-FIELDS contrat-modelo.des-contrat ~
contrat-modelo.natureza contrat-modelo.cod-tipo-contrat ~
contrat-modelo.log-libera contrat-modelo.narrat-contrato 
&Scoped-Define DISPLAYED-OBJECTS i-nr-contrato c-tipo-desc text-1 ~
c-contrato c-tipo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS i-nr-contrato 
&Scoped-define ADM-ASSIGN-FIELDS i-nr-contrato 

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
DEFINE VARIABLE c-contrato AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.14 BY .67 NO-UNDO.

DEFINE VARIABLE c-tipo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-tipo-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-contrato AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Nr Contrato" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7.14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25.43 BY 3.42.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.86 BY 3.42.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.86 BY 8.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-nr-contrato AT ROW 1.63 COL 14.43 COLON-ALIGNED
     contrat-modelo.des-contrat AT ROW 1.63 COL 24.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 33.14 BY .88
     contrat-modelo.natureza AT ROW 2.13 COL 66.57 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Compra", 1,
"Servi‡o", 2,
"Beneficiamento", 3
          SIZE 18.57 BY 1.88
     contrat-modelo.cod-tipo-contrat AT ROW 2.63 COL 14.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-tipo-desc AT ROW 2.63 COL 18.57 COLON-ALIGNED NO-LABEL
     contrat-modelo.log-libera AT ROW 3.63 COL 16.43
          VIEW-AS TOGGLE-BOX
          SIZE 8.14 BY .83
     contrat-modelo.narrat-contrato AT ROW 5.25 COL 5 NO-LABEL
          VIEW-AS EDITOR
          SIZE 77.43 BY 7.17
     text-1 AT ROW 1 COL 60.57 COLON-ALIGNED NO-LABEL
     c-contrato AT ROW 1.75 COL 2.86 NO-LABEL
     c-tipo AT ROW 2.63 COL 7.72 NO-LABEL
     rt-key AT ROW 1.25 COL 1
     RECT-2 AT ROW 1.25 COL 61.43
     rt-mold AT ROW 4.79 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.contrat-modelo
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
         HEIGHT             = 12.04
         WIDTH              = 86.29.
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

/* SETTINGS FOR FILL-IN c-contrato IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-tipo IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-tipo-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-nr-contrato IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN text-1 IN FRAME f-main
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME contrat-modelo.cod-tipo-contrat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contrat-modelo.cod-tipo-contrat V-table-Win
ON F5 OF contrat-modelo.cod-tipo-contrat IN FRAME f-main /* Tp Contr */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in588.w
                     &campo=contrat-modelo.cod-tipo-contrat
                     &campozoom=cod-tipo-contr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contrat-modelo.cod-tipo-contrat V-table-Win
ON LEAVE OF contrat-modelo.cod-tipo-contrat IN FRAME f-main /* Tp Contr */
DO:
  {include/leave.i &tabela=tipo-contrat
                   &atributo-ref=des-tipo-contrat
                   &variavel-ref=c-tipo-desc
                   &where="tipo-contrat.cod-tipo-contr = input frame {&frame-name} contrat-modelo.cod-tipo-contrat"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL contrat-modelo.cod-tipo-contrat V-table-Win
ON MOUSE-SELECT-DBLCLICK OF contrat-modelo.cod-tipo-contrat IN FRAME f-main /* Tp Contr */
DO:
  apply 'F5' to self.
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

   {utp/ut-liter.i N£mero_do_Modelo: * R}
   assign c-contrato = return-value.
   disp c-contrato with frame {&frame-name}.


if contrat-modelo.cod-tipo-contrat:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name}
   then.

if /*contrat-modelo.nr-contrato*/ i-nr-contrato:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name}
   then.

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
  {src/adm/template/row-list.i "contrat-modelo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "contrat-modelo"}

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

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i N£mero_do_Modelo: * R}
  assign c-contrato = return-value.
  disp c-contrato with frame {&frame-name}.

  {utp/ut-liter.i Modalidade: * R}
  assign c-tipo = return-value.
  disp c-tipo with frame {&frame-name}.   
  {utp/ut-rtlbl.i mgind contrat-modelo natureza text-1}

  assign i-opcao = 0. /* inclui */

     if i-nr-contrato:sensitive in frame {&frame-name} = yes then do: 
        find last b-contrato NO-LOCK no-error.
        if avail b-contrato then 
           assign i-contrato = int(b-contrato.nr-contrato) + 1.
        else
           assign i-contrato = 1.

        repeat:
          &if defined(bf_mat_contratos) &then
              find b-contrato where b-contrato.nr-contrato = i-contrato no-lock no-error.
          &else
              find b-contrato where b-contrato.nr-contrato = string(i-contrato) no-lock no-error.
          &endif
          if avail b-contrato then 
             assign i-contrato = int(b-contrato.nr-contrato) + 1.
          else leave.
        end.                  
     end. 
     assign i-nr-contrato:screen-value in frame {&frame-name} = string(i-contrato).                        


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

 if /*contrat-modelo.nr-contrato*/ i-nr-contrato:sensitive in frame {&frame-name} = yes then do:
    find first contrat-modelo where 
         contrat-modelo.nr-contrato = input frame {&frame-name} 
                 /*contrat-modelo.nr-contrato*/ i-nr-contrato no-lock no-error.
    if avail contrat-modelo then do:
       run utp/ut-msgs.p (input "show",
                          input 7708,
                          input "").
       return 'adm-error':U.
    end.

    if input frame {&frame-name} /*contrat-modelo.nr-contrato*/ i-nr-contrato = 0 then do:
       run utp/ut-msgs.p (input "show",
                          input 7829,
                          input "").
       return 'adm-error':U.
    end.
 end.

 if input frame {&frame-name} contrat-modelo.des-contrat = "" then do:
    run utp/ut-msgs.p (input "show",
                       input 7830,
                       input "").
    return 'adm-error':U.
 end.                       

 find tipo-contrat where tipo-contrat.cod-tipo-contr = input frame {&frame-name}
           contrat-modelo.cod-tipo-contr no-error.
 if not avail tipo-contrat then do:
    run utp/ut-msgs.p (input "show",
                       input 7831,  
                       input "").
    return 'adm-error':U.
 end.     

 if input frame {&frame-name} contrat-modelo.narrat-contrato = "" then do:
    run utp/ut-msgs.p (input "show",
                       input 8299,
                       input "").
    return 'adm-error':U.
 end.      

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  assign contrat-modelo.dat-revisao = today.

  &if defined(bf_mat_contratos) &then
      assign contrat-modelo.nr-contrato = i-nr-contrato.
  &else
      assign contrat-modelo.nr-contrato = string(i-nr-contrato).  
  &endif   
  if i-opcao = 1 then do: /* copia */
     for each b-clausula where 
         b-clausula.nr-contrato = c-nr-contrato no-lock :
         create clausula-mod.
         assign clausula-mod.nr-contrato    = input frame {&frame-name} i-nr-contrato /*contrat-modelo.nr-contrato*/ 
                clausula-mod.num-seq-clausula-model = b-clausula.num-seq-clausula-model 
                clausula-mod.des-clausula   = b-clausula.des-clausula
                clausula-mod.narrat-clausul = b-clausula.narrat-clausul.
     end.

     for each b-anexo where
         b-anexo.nr-contrato = c-nr-contrato no-lock :
         create anexo-mod.
         assign anexo-mod.nr-contrato   = input frame {&frame-name} i-nr-contrato /*contrat-modelo.nr-contrato*/
                anexo-mod.num-seq-anexo-model = b-anexo.num-seq-anexo-model
                anexo-mod.des-anexo     = b-anexo.des-anexo
                anexo-mod.narrat-anexo  = b-anexo.narrat-anexo.
     end.          
  end.               

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  assign i-opcao = 1 /* copia */
         c-nr-contrato = contrat-modelo.nr-contrato.

  IF c-nr-contrato <> c-nr-contrato-aux THEN
      ASSIGN c-nr-contrato = c-nr-contrato-aux.


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

  if avail contrat-modelo then do:
      IF i-opcao = 0 THEN
          ASSIGN c-nr-contrato-aux = contrat-modelo.nr-contrato.

      if not  adm-new-record then 
      assign i-nr-contrato = int(contrat-modelo.nr-contrato).


     find first tipo-contrat where
        tipo-contrat.cod-tipo-contr = contrat-modelo.cod-tipo-contrat no-lock no-error.
     assign c-tipo-desc = if avail tipo-contrat then tipo-contrat.des-tipo-contrat else "":U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  {utp/ut-rtlbl.i mgind contrat-modelo natureza text-1}



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

  if adm-new-record then do:
     find last contrat-modelo use-index codigo no-lock no-error.
     if avail contrat-modelo then
        assign i-contrato = int(contrat-modelo.nr-contrato) + 1.
     else i-contrato = 1.  
     assign /*contrat-modelo.nr-contrat*/ i-nr-contrato:screen-value in frame {&frame-name} = string(i-contrato).
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

  /* Code placed here will execute AFTER standard behavior.    */

   {utp/ut-liter.i N£mero_do_Modelo: * R}
   assign c-contrato = return-value.
   disp c-contrato with frame {&frame-name}.

   {utp/ut-liter.i Modalidade: * R}
   assign c-tipo = return-value.
   disp c-tipo with frame {&frame-name}.       
   {utp/ut-rtlbl.i mgind contrat-modelo natureza text-1}

   find first contrat-modelo no-lock no-error.
   assign gr-contrato = rowid(contrat-modelo).

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
  {src/adm/template/snd-list.i "contrat-modelo"}

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


