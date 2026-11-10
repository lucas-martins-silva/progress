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
{include/i-prgvrs.i V02IN624 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN624 MUT}
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES lim-aprov-fam-mat
&Scoped-define FIRST-EXTERNAL-TABLE lim-aprov-fam-mat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lim-aprov-fam-mat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lim-aprov-fam-mat.mo-codigo ~
lim-aprov-fam-mat.lim-solic lim-aprov-fam-mat.lim-requis ~
lim-aprov-fam-mat.lim-cotac lim-aprov-fam-mat.lim-pedido ~
lim-aprov-fam-mat.lim-req-manut lim-aprov-fam-mat.dec-1 ~
lim-aprov-fam-mat.dec-2 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}mo-codigo ~{&FP2}mo-codigo ~{&FP3}~
 ~{&FP1}lim-solic ~{&FP2}lim-solic ~{&FP3}~
 ~{&FP1}lim-requis ~{&FP2}lim-requis ~{&FP3}~
 ~{&FP1}lim-cotac ~{&FP2}lim-cotac ~{&FP3}~
 ~{&FP1}lim-pedido ~{&FP2}lim-pedido ~{&FP3}~
 ~{&FP1}lim-req-manut ~{&FP2}lim-req-manut ~{&FP3}~
 ~{&FP1}dec-1 ~{&FP2}dec-1 ~{&FP3}~
 ~{&FP1}dec-2 ~{&FP2}dec-2 ~{&FP3}
&Scoped-define ENABLED-TABLES lim-aprov-fam-mat
&Scoped-define FIRST-ENABLED-TABLE lim-aprov-fam-mat
&Scoped-Define ENABLED-OBJECTS rt-key rt-key-2 rt-key-3 
&Scoped-Define DISPLAYED-FIELDS lim-aprov-fam-mat.fm-codigo ~
lim-aprov-fam-mat.cod-aprov lim-aprov-fam-mat.mo-codigo ~
lim-aprov-fam-mat.lim-solic lim-aprov-fam-mat.lim-requis ~
lim-aprov-fam-mat.lim-cotac lim-aprov-fam-mat.lim-pedido ~
lim-aprov-fam-mat.lim-req-manut lim-aprov-fam-mat.dec-1 ~
lim-aprov-fam-mat.dec-2 
&Scoped-Define DISPLAYED-OBJECTS c-des-fam c-des-aprov c-des-moeda 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS lim-aprov-fam-mat.mo-codigo ~
lim-aprov-fam-mat.lim-solic lim-aprov-fam-mat.lim-requis ~
lim-aprov-fam-mat.lim-cotac lim-aprov-fam-mat.lim-pedido ~
lim-aprov-fam-mat.lim-req-manut 
&Scoped-define ADM-ASSIGN-FIELDS lim-aprov-fam-mat.mo-codigo ~
lim-aprov-fam-mat.lim-solic lim-aprov-fam-mat.lim-requis ~
lim-aprov-fam-mat.lim-cotac lim-aprov-fam-mat.lim-pedido ~
lim-aprov-fam-mat.lim-req-manut 
&Scoped-define ADM-MODIFY-FIELDS lim-aprov-fam-mat.mo-codigo ~
lim-aprov-fam-mat.lim-solic lim-aprov-fam-mat.lim-requis ~
lim-aprov-fam-mat.lim-cotac lim-aprov-fam-mat.lim-pedido ~
lim-aprov-fam-mat.lim-req-manut 

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
DEFINE VARIABLE c-des-aprov AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88.

DEFINE VARIABLE c-des-fam AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 33.72 BY .88.

DEFINE VARIABLE c-des-moeda AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 16.14 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.43 BY 2.25.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.43 BY 1.38.

DEFINE RECTANGLE rt-key-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.43 BY 7.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     lim-aprov-fam-mat.fm-codigo AT ROW 1.17 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-des-fam AT ROW 1.17 COL 32.14 COLON-ALIGNED NO-LABEL
     lim-aprov-fam-mat.cod-aprov AT ROW 2.17 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-des-aprov AT ROW 2.17 COL 36.14 COLON-ALIGNED HELP
          "Nome do Aprovador" NO-LABEL
     lim-aprov-fam-mat.mo-codigo AT ROW 3.58 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c-des-moeda AT ROW 3.58 COL 39 COLON-ALIGNED HELP
          "Descri‡Æo da moeda" NO-LABEL
     lim-aprov-fam-mat.lim-solic AT ROW 5.13 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     lim-aprov-fam-mat.lim-requis AT ROW 6.13 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     lim-aprov-fam-mat.lim-cotac AT ROW 7.13 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     lim-aprov-fam-mat.lim-pedido AT ROW 8.13 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     lim-aprov-fam-mat.lim-req-manut AT ROW 9.13 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     lim-aprov-fam-mat.dec-1 AT ROW 10.13 COL 40.14 COLON-ALIGNED FORMAT "->>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     lim-aprov-fam-mat.dec-2 AT ROW 11.13 COL 40.14 COLON-ALIGNED FORMAT "->>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     rt-key AT ROW 1 COL 1
     rt-key-2 AT ROW 3.38 COL 1
     rt-key-3 AT ROW 4.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.lim-aprov-fam-mat
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
         HEIGHT             = 11.25
         WIDTH              = 83.57.
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

/* SETTINGS FOR FILL-IN c-des-aprov IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-fam IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lim-aprov-fam-mat.cod-aprov IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lim-aprov-fam-mat.dec-1 IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN lim-aprov-fam-mat.dec-2 IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN lim-aprov-fam-mat.fm-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lim-aprov-fam-mat.lim-cotac IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN lim-aprov-fam-mat.lim-pedido IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN lim-aprov-fam-mat.lim-req-manut IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN lim-aprov-fam-mat.lim-requis IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN lim-aprov-fam-mat.lim-solic IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN lim-aprov-fam-mat.mo-codigo IN FRAME f-main
   1 2 3                                                                */
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

&Scoped-define SELF-NAME lim-aprov-fam-mat.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lim-aprov-fam-mat.mo-codigo V-table-Win
ON F5 OF lim-aprov-fam-mat.mo-codigo IN FRAME f-main /* Moeda */
DO:
  {include/zoomvar.i &prog-zoom=unzoom/z01un005.w 
                     &campo=lim-aprov-fam-mat.mo-codigo
                     &campozoom=mo-codigo}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lim-aprov-fam-mat.mo-codigo V-table-Win
ON LEAVE OF lim-aprov-fam-mat.mo-codigo IN FRAME f-main /* Moeda */
DO:
  
  {include/leave.i &tabela=moeda
                   &atributo-ref=descricao  
                   &variavel-ref=c-des-moeda
                   &where="moeda.mo-codigo = input frame {&frame-name} lim-aprov-fam-mat.mo-codigo"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lim-aprov-fam-mat.mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lim-aprov-fam-mat.mo-codigo IN FRAME f-main /* Moeda */
DO:
  
  {include/zoomvar.i &prog-zoom=unzoom/z01un005.w 
                     &campo=lim-aprov-fam-mat.mo-codigo
                     &campozoom=mo-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  if lim-aprov-fam-mat.mo-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  
  run local-enable-fields.
  
  {utp/ut-liter.i "Limite_Aprov_Processo" * R}
  assign lim-aprov-fam-mat.dec-1:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i "Limite_Aprov_Contrato" * R}
  assign lim-aprov-fam-mat.dec-2:label in frame {&FRAME-NAME} = return-value.
  
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
  {src/adm/template/row-list.i "lim-aprov-fam-mat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lim-aprov-fam-mat"}

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

 if available lim-aprov-fam-mat
  then do:
  
       find first aprovador where
                  aprovador.cod-aprov = lim-aprov-fam-mat.cod-aprov no-lock no-error.
       if available aprovador
       then do:
            assign c-des-aprov = aprovador.des-aprov.
       end.
       
       find first familia where 
                  familia.fm-codigo = lim-aprov-fam-mat.fm-codigo no-lock no-error.
       if available lim-aprov-fam-mat
       then do:
            assign c-des-fam = familia.descricao.
       end.
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
  
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e nem na PI-validate. */ 
   
  /* Dispatch standard ADM method.                             */
  
     if avail lim-aprov-fam-mat then
       find first aprovador where aprovador.cod-aprov = lim-aprov-fam-mat.cod-aprov 
            no-lock no-error.
       if not available aprovador
       then do:
            assign lim-aprov-fam-mat.lim-cotac:screen-value in frame {&frame-name} = "0.00"     
                   lim-aprov-fam-mat.lim-pedido:screen-value in frame {&frame-name} = "0.00"
                   lim-aprov-fam-mat.lim-req-manut:screen-value in frame {&frame-name} = "0.00"  
                   lim-aprov-fam-mat.lim-requis:screen-value in frame {&frame-name} = "0.00" 
                   lim-aprov-fam-mat.lim-solic:screen-value in frame {&frame-name} = "0.00" 
                   lim-aprov-fam-mat.dec-1:screen-value in frame {&frame-name} = "0.00" 
                   lim-aprov-fam-mat.dec-2:screen-value in frame {&frame-name} = "0.00".
       end.
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if  RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.

  
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
   find lim-aprov-fam-mat  where rowid(lim-aprov-fam-mat) = v-row-parent EXCLUSIVE-LOCK no-error.
  /*  if available lim-aprov-fam-mat  
 *     then do:
 *          assign <tabela filho>.<chave pai> = <tabela pai>.<chave pai>.
 *     end.*/

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

 if available lim-aprov-fam-mat
  then do:
  
       find first aprovador where
                  aprovador.cod-aprov = lim-aprov-fam-mat.cod-aprov no-lock no-error.
       if available aprovador
       then do:
            assign c-des-aprov = aprovador.des-aprov
                   lim-aprov-fam-mat.lim-cotac:sensitive in frame {&frame-name} = aprovador.perm-cotac     
                   lim-aprov-fam-mat.lim-pedido:sensitive in frame {&frame-name} = aprovador.perm-pedido  
                   lim-aprov-fam-mat.lim-req-manut:sensitive in frame {&frame-name} = aprovador.perm-manut  
                   lim-aprov-fam-mat.lim-requis:sensitive in frame {&frame-name} = aprovador.perm-requis 
                   lim-aprov-fam-mat.lim-solic:sensitive in frame {&frame-name} = aprovador.perm-solic 
                   lim-aprov-fam-mat.dec-1:sensitive in frame {&frame-name} = aprovador.log-1 
                   lim-aprov-fam-mat.dec-2:sensitive in frame {&frame-name} = aprovador.log-2.
       end.
       
       find first familia where 
                  familia.fm-codigo = lim-aprov-fam-mat.fm-codigo no-lock no-error.
       if available lim-aprov-fam-mat
       then do:
            assign c-des-fam = familia.descricao.
       end.
       
       find moeda where 
            moeda.mo-codigo = lim-aprov-fam-mat.mo-codigo no-lock no-error.
       if available moeda 
       then do:
            assign c-des-moeda = moeda.descricao.
       end. 
  end.              

         

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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
  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

 assign lim-aprov-fam-mat.mo-codigo:sensitive     in frame {&frame-name} = yes
        lim-aprov-fam-mat.lim-solic:sensitive     in frame {&frame-name} = yes    
        lim-aprov-fam-mat.lim-requis:sensitive    in frame {&frame-name} = yes        
        lim-aprov-fam-mat.lim-cotac:sensitive     in frame {&frame-name} = yes        
        lim-aprov-fam-mat.lim-ped:sensitive       in frame {&frame-name} = yes
        lim-aprov-fam-mat.lim-req-manut:sensitive in frame {&frame-name} = yes
        lim-aprov-fam-mat.dec-1:sensitive         in frame {&frame-name} = yes 
        lim-aprov-fam-mat.dec-2:sensitive         in frame {&frame-name} = yes.

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
  
  
  
  find first lim-aprov-fam-mat where
             rowid(lim-aprov-fam-mat) = v-row-parent no-lock no-error.
  if available lim-aprov-fam-mat
  then do:
  
       find first aprovador where
                  aprovador.cod-aprov = lim-aprov-fam-mat.cod-aprov no-lock no-error.
       if available aprovador
       then do:
            assign c-des-aprov = aprovador.des-aprov.
       end.
       
       find first familia where 
                  familia.fm-codigo = lim-aprov-fam-mat.fm-codigo no-lock no-error.
       if available lim-aprov-fam-mat
       then do:
            assign c-des-fam = familia.descricao.
       end.
  end.              

 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
  {src/adm/template/snd-list.i "lim-aprov-fam-mat"}

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


