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
{include/i-prgvrs.i V14IN124 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN214 MCQ}
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define DISPLAYED-OBJECTS cod-estabel des-estabel ep-codigo ~
cod-area-produc des-area cod-proces des-proces cod-sub-proces des-subproces 

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
DEFINE VARIABLE cod-area-produc AS CHARACTER FORMAT "x(8)" 
     LABEL "µrea" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE cod-estabel AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE cod-proces AS CHARACTER FORMAT "x(12)" 
     LABEL "Processo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE cod-sub-proces AS CHARACTER FORMAT "x(12)" 
     LABEL "Subprocesso" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE des-area AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 46.43 BY .88 NO-UNDO.

DEFINE VARIABLE des-estabel AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 39.72 BY .88 NO-UNDO.

DEFINE VARIABLE des-proces AS CHARACTER FORMAT "X(250)" 
     VIEW-AS FILL-IN 
     SIZE 46.43 BY .88 NO-UNDO.

DEFINE VARIABLE des-subproces AS CHARACTER FORMAT "x(100)" 
     VIEW-AS FILL-IN 
     SIZE 46.43 BY .88 NO-UNDO.

DEFINE VARIABLE ep-codigo AS CHARACTER FORMAT "x(3)" 
     LABEL "Empresa" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cod-estabel AT ROW 1.96 COL 16 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     des-estabel AT ROW 1.96 COL 22.29 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL
     ep-codigo AT ROW 1.96 COL 71.72 COLON-ALIGNED HELP
          "C¢digo da Empresa"
     cod-area-produc AT ROW 2.96 COL 16 COLON-ALIGNED HELP
          "Area de Produá∆o"
     des-area AT ROW 2.96 COL 29.29 COLON-ALIGNED NO-LABEL
     cod-proces AT ROW 3.96 COL 16 COLON-ALIGNED HELP
          "C¢digo do Processo CQ"
     des-proces AT ROW 3.96 COL 29.29 COLON-ALIGNED HELP
          "Descriá∆o Processo" NO-LABEL
     cod-sub-proces AT ROW 4.96 COL 16 COLON-ALIGNED HELP
          "C¢digo do Processo"
     des-subproces AT ROW 4.96 COL 29.29 COLON-ALIGNED HELP
          "Descriá∆o Sub Processo" NO-LABEL
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
         HEIGHT             = 6.54
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cod-area-produc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-proces IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-sub-proces IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-area IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-proces IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-subproces IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ep-codigo IN FRAME f-main
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

&Scoped-define SELF-NAME cod-area-produc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-area-produc V-table-Win
ON LEAVE OF cod-area-produc IN FRAME f-main /* µrea */
DO:
    FIND FIRST area-produc NO-LOCK
        WHERE area-produc.cod-area-produc = INPUT FRAME {&frame-name} cod-area-produc NO-ERROR.
    IF AVAIL area-produc THEN
        ASSIGN des-area:SCREEN-VALUE IN FRAME {&frame-name} = area-produc.des-area-produc.
    ELSE
        ASSIGN  cod-area-produc:SCREEN-VALUE IN FRAME {&frame-name} = ""
                des-area:SCREEN-VALUE IN FRAME {&frame-name} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-estabel V-table-Win
ON LEAVE OF cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = INPUT FRAME {&frame-name} cod-estabel NO-ERROR.

    IF AVAIL estabelec THEN DO:
        ASSIGN des-estabel:SCREEN-VALUE IN FRAME {&frame-name} = estabelec.nome.
        IF INPUT FRAME {&frame-name} ep-codigo = "" THEN
            ASSIGN ep-codigo:SCREEN-VALUE IN FRAME {&frame-name} = estabelec.ep-codigo.
    END.
    ELSE
        ASSIGN cod-estabel:SCREEN-VALUE IN FRAME {&frame-name} = ""
               des-estabel:SCREEN-VALUE IN FRAME {&frame-name} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-proces
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-proces V-table-Win
ON LEAVE OF cod-proces IN FRAME f-main /* Processo */
DO:
    FOR FIRST proces-cq FIELDS (ep-codigo cod-estabel cod-area-produc cod-proces des-proces) NO-LOCK
        WHERE proces-cq.ep-codigo       = INPUT FRAME {&frame-name} ep-codigo
        AND   proces-cq.cod-estabel     = INPUT FRAME {&frame-name} cod-estabel
        AND   proces-cq.cod-area-produc = INPUT FRAME {&frame-name} cod-area-produc
        AND   proces-cq.cod-proces      = INPUT FRAME {&frame-name} cod-proces:

        ASSIGN des-proces:SCREEN-VALUE IN FRAME {&frame-name} = proces-cq.des-proces.
    END.
    IF NOT AVAIL proces-cq THEN
        ASSIGN cod-proces:SCREEN-VALUE IN FRAME {&frame-name} = ""
               des-proces:SCREEN-VALUE IN FRAME {&frame-name} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-sub-proces
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-sub-proces V-table-Win
ON LEAVE OF cod-sub-proces IN FRAME f-main /* Subprocesso */
DO:
    FOR FIRST sub-proces-cq FIELDS (ep-codigo cod-estabel cod-area-produc cod-proces cod-sub-proces des-sub-proces) NO-LOCK
        WHERE sub-proces-cq.ep-codigo       = INPUT FRAME {&frame-name} ep-codigo
        AND   sub-proces-cq.cod-estabel     = INPUT FRAME {&frame-name} cod-estabel
        AND   sub-proces-cq.cod-area-produc = INPUT FRAME {&frame-name} cod-area-produc
        AND   sub-proces-cq.cod-proces      = INPUT FRAME {&frame-name} cod-proces 
        AND   sub-proces-cq.cod-sub-proces  = INPUT FRAME {&frame-name} cod-sub-proces:

        ASSIGN des-subproces:SCREEN-VALUE IN FRAME {&frame-name} = sub-proces-cq.des-sub-proces.
    END.
    IF NOT AVAIL  sub-proces-cq THEN
        ASSIGN cod-sub-proces:SCREEN-VALUE IN FRAME {&frame-name} = ""
               des-subproces:SCREEN-VALUE IN FRAME {&frame-name} = "".
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
      {src/adm/template/row-list.i "ficha-cq"}
    
      /* Get the record ROWID's from the RECORD-SOURCE.                  */
      {src/adm/template/row-get.i}
    
      /* FIND each record specified by the RECORD-SOURCE.                */
      {src/adm/template/row-find.i "ficha-cq"}
    
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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  

  RETURN "OK":U.
  
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
  DISABLE cod-estabel
          des-estabel
          ep-codigo
          cod-area-produc
          des-area
          cod-proces
          des-proces
          cod-sub-proces
          des-subproces
      WITH FRAME fpage0.
  

  RETURN "OK":U.
            

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

  IF AVAIL ficha-cq THEN DO WITH FRAME {&frame-name}:
      ASSIGN ep-codigo:SCREEN-VALUE         = ficha-cq.ep-codigo
             cod-estabel:SCREEN-VALUE       = ficha-cq.cod-estabel
             cod-area-produc:SCREEN-VALUE   = ficha-cq.cod-area-produc
             cod-proces:SCREEN-VALUE        = ficha-cq.cod-proces
             cod-sub-proces:SCREEN-VALUE    = ficha-cq.cod-sub-proces.      
  END.
  ELSE
      ASSIGN ep-codigo:SCREEN-VALUE IN FRAME {&frame-name} = "".

  APPLY "LEAVE":U TO cod-estabel      IN FRAME {&frame-name}.
  APPLY "LEAVE":U TO cod-area-produc  IN FRAME {&frame-name}.
  APPLY "LEAVE":U TO cod-proces       IN FRAME {&frame-name}.
  APPLY "LEAVE":U TO cod-sub-proces   IN FRAME {&frame-name}.
  
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
  /*&if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif  */

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
     /*define input parameter v-row-parent-externo as rowid no-undo.

     assign v-row-parent = v-row-parent-externo.*/

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
    /*Se marcar o parÉmetro clicbusiness e experiància de uso 
        aceita ent∆o valida os campos de ambiente.*/
  /*IF tg-clicbusiness:CHECKED IN FRAME {&FRAME-NAME} AND
     tg-experiencia-uso:CHECKED IN FRAME {&FRAME-NAME} THEN DO:    
     IF NOT tg-homologacao:CHECKED IN FRAME {&FRAME-NAME} 
         AND NOT tg-producao:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
    
        /*Se n∆o selecionou nenhum tipo de ambiente n∆o deixa gravar*/ 
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 53701, 
                           INPUT "" ).
        RETURN 'ADM-ERROR':U.
     END.
  END.*/

  RETURN "OK":U.
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
  {src/adm/template/snd-list.i "ficha-cq"}

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

  /*CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

