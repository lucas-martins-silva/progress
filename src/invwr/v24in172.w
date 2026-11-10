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
{include/i-prgvrs.i V24IN172 2.00.00.008}  /*** 010008 ***/
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item

{cdp/cdcfgdis.i}

/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.ge-codigo item.ind-especifico ~
item.ind-item-fat item.un item.fm-codigo item.baixa-estoq ~
item.loc-unica item.codigo-orig item.fm-cod-com item.horiz-fixo ~
item.deposito-pad item.cod-localiz c-ind-inf-qtf l-ind-inf-qtf
&Scoped-define FIELD-PAIRS~
 ~{&FP1}ge-codigo ~{&FP2}ge-codigo ~{&FP3}~
 ~{&FP1}un ~{&FP2}un ~{&FP3}~
 ~{&FP1}fm-codigo ~{&FP2}fm-codigo ~{&FP3}~
 ~{&FP1}codigo-orig ~{&FP2}codigo-orig ~{&FP3}~
 ~{&FP1}fm-cod-com ~{&FP2}fm-cod-com ~{&FP3}~
 ~{&FP1}horiz-fixo ~{&FP2}horiz-fixo ~{&FP3}~
 ~{&FP1}deposito-pad ~{&FP2}deposito-pad ~{&FP3}~
 ~{&FP1}cod-localiz ~{&FP2}cod-localiz ~{&FP3}
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define DISPLAYED-FIELDS item.ge-codigo item.ind-especifico ~
item.ind-item-fat item.un item.fm-codigo item.baixa-estoq ~
item.loc-unica item.codigo-orig item.fm-cod-com item.horiz-fixo ~
item.deposito-pad item.cod-localiz 
&Scoped-Define DISPLAYED-OBJECTS c-un c-unidade c-ind-imp-desc ~
c-tipo-con-est c-ind-inf-qtf l-ind-inf-qtf

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
DEFINE VARIABLE c-ind-imp-desc AS CHARACTER FORMAT "X(256)":U 
     LABEL "c-ind-imp-desc" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-con-est AS CHARACTER FORMAT "X(256)":U 
     LABEL "c-tipo-con-est" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "X(10)":U 
     LABEL "c-un" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-unidade AS CHARACTER FORMAT "X(20)":U 
     LABEL "c-unidade" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-ind-inf-qtf  AS CHARACTER FORMAT "X(30)":U 
     LABEL "Unidade Faturamento" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.
    
DEFINE VARIABLE l-ind-inf-qtf AS LOGICAL
     LABEL "Fatura Qtd Fam¡lia" 
     VIEW-AS TOGGLE-BOX 
     SIZE 20 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.ge-codigo AT ROW 1 COL 21.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     item.ind-especifico AT ROW 1 COL 61
          VIEW-AS TOGGLE-BOX
          SIZE 16.14 BY .75
     item.ind-item-fat AT ROW 1.75 COL 61
          VIEW-AS TOGGLE-BOX
          SIZE 19.86 BY .75
     item.un AT ROW 2 COL 21.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     &IF DEFINED (bf_dis_versao_ems) &THEN
       &IF '{&bf_dis_versao_ems}'  = '2.04' OR 
           '{&bf_dis_versao_ems}' >= '2.062' &THEN
          item.baixa-estoq AT ROW 2.5 COL 61
               VIEW-AS TOGGLE-BOX
               SIZE 15.86 BY .75
          item.loc-unica AT ROW 3.25 COL 61
               VIEW-AS TOGGLE-BOX
               SIZE 17 BY .75
          c-ind-inf-qtf AT ROW 5 COL 59 COLON-ALIGNED
         item.codigo-orig AT ROW 4 COL 59 COLON-ALIGNED
               VIEW-AS FILL-IN 
               SIZE 2.57 BY .88
       &ELSE
          l-ind-inf-qtf AT ROW 2.5 COL 61
          item.baixa-estoq AT ROW 3.25 COL 61
               VIEW-AS TOGGLE-BOX
               SIZE 15.86 BY .75
          item.loc-unica AT ROW 4 COL 61
               VIEW-AS TOGGLE-BOX
               SIZE 17 BY .75
         item.codigo-orig AT ROW 5 COL 59 COLON-ALIGNED
               VIEW-AS FILL-IN 
               SIZE 2.57 BY .88
       &ENDIF
     &ENDIF
     item.fm-codigo AT ROW 3 COL 21.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-un AT ROW 4 COL 21.43 COLON-ALIGNED
     c-unidade AT ROW 5 COL 21.43 COLON-ALIGNED
     item.fm-cod-com AT ROW 6 COL 21.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .88
     c-ind-imp-desc AT ROW 6 COL 59 COLON-ALIGNED
     item.horiz-fixo AT ROW 7 COL 21.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     item.deposito-pad AT ROW 7 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     item.cod-localiz AT ROW 8 COL 21.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     c-tipo-con-est AT ROW 8 COL 59 COLON-ALIGNED

    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1  .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 8.13
         WIDTH              = 85.57.
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

/* SETTINGS FOR FILL-IN c-ind-imp-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-con-est IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-unidade IN FRAME f-main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

  {utp/ut-field.i mgind familia un 1}.
  assign c-un:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind classif-fisc unidade 1}.
  assign c-unidade:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind item tipo-con-est 1}.
  assign c-tipo-con-est:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind item ind-imp-desc 1}.
  assign c-ind-imp-desc:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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

  /* Traz a descricao do Radio-set tipo-con-est e ind-imp-desc */ 
  if avail item then do with frame {&frame-name}:
     assign c-tipo-con-est:screen-value = {ininc/i01in122.i 04 item.tipo-con-est}.
     assign c-ind-imp-desc:screen-value = {ininc/i10in122.i 04 item.ind-imp-desc}.
  end.
  else do:
     assign c-tipo-con-est:screen-value = {ininc/i01in122.i 04 1}. 
     assign c-ind-imp-desc:screen-value = {ininc/i10in122.i 04 1}. 
  end.       

  &IF DEFINED (bf_dis_versao_ems) &THEN
    &IF '{&bf_dis_versao_ems}'  = '2.04'  OR 
        '{&bf_dis_versao_ems}' >= '2.062' &THEN
      CASE ITEM.ind-inf-qtf:
        WHEN YES THEN
           ASSIGN c-ind-inf-qtf:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Un. da Fam¡lia Materiais".
        WHEN NO THEN
           ASSIGN c-ind-inf-qtf:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Un. do Item".
        OTHERWISE 
           ASSIGN c-ind-inf-qtf:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Un. do Cliente".
      END CASE.    
    &ELSE
      ASSIGN l-ind-inf-qtf:CHECKED IN FRAME {&frame-name} = ITEM.ind-inf-qtf.
    &ENDIF
  &ENDIF
  
/* Procura Tabela Familia.un */
  find familia where familia.fm-codigo = item.fm-codigo no-lock no-error.
  if avail familia then
     disp familia.un @ c-un with frame {&frame-name}.                     

  /* Procura Tabela Classif-fisc.class-fiscal */
  find classif-fisc where classif-fisc.class-fiscal = item.class-fiscal no-lock no-error.
   if avail classif-fisc then
     disp classif-fisc.unidade @ c-unidade with frame {&frame-name}.           
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

  /* Code placed here will execute AFTER standard behavior.    */

  &IF DEFINED(bf_dis_versao_ems) &THEN
    &IF '{&bf_dis_versao_ems}'  = '2.04'  OR 
        '{&bf_dis_versao_ems}' >= '2.062' &THEN
       ASSIGN l-ind-inf-qtf:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
    &ELSE
       ASSIGN c-ind-inf-qtf:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
    &ENDIF
  &ENDIF
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */


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
  {src/adm/template/snd-list.i "item"}

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


