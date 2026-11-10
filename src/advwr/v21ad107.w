&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V21AD107 2.00.00.015}  /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v21ad107 MUT}
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

def var l-inclui         as logical initial no.
def var da-iniper-x      like param-estoq.ult-fech-dia no-undo.
def var da-fimper-x      like param-estoq.ult-fech-dia no-undo.
def var i-per-corrente   as integer no-undo format "99".
def var i-ano-corrente   as integer no-undo format "9999".
def var i-per-fiscal     as integer no-undo format "99".
def var i-ano-fiscal     as integer no-undo format "9999".
def var da-iniper-fech   as date format "99/99/9999"   no-undo.
def var da-fimper-fech   as date format "99/99/9999"   no-undo.
def var l-avail          as logical initial no no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estabelec.custo-contab estabelec.usa-on-line ~
estabelec.usa-padrao 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-2 RECT-1 
&Scoped-Define DISPLAYED-FIELDS estabelec.custo-contab ~
estabelec.usa-on-line estabelec.usa-padrao 
&Scoped-Define DISPLAYED-OBJECTS c-medio c-tipo-custo 

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
DEFINE VARIABLE c-medio AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.72 BY .67 NO-UNDO.

DEFINE VARIABLE c-tipo-custo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.86 BY 4.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.86 BY 4.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.14 BY 8.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.custo-contab AT ROW 4.5 COL 19 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Mensal", 1,
"On-line", 2,
"PadrÆo", 3
          SIZE 10.43 BY 2.5
     estabelec.usa-on-line AT ROW 4.5 COL 54
          VIEW-AS TOGGLE-BOX
          SIZE 17.86 BY .83
     estabelec.usa-padrao AT ROW 6.25 COL 54
          VIEW-AS TOGGLE-BOX
          SIZE 17.86 BY .83
     c-medio AT ROW 3.13 COL 44.43 COLON-ALIGNED NO-LABEL
     c-tipo-custo AT ROW 3.17 COL 7.43 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
     RECT-2 AT ROW 3.38 COL 44.14
     RECT-1 AT ROW 3.42 COL 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.estabelec
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
         HEIGHT             = 8.33
         WIDTH              = 86.14.
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

/* SETTINGS FOR FILL-IN c-medio IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-custo IN FRAME f-main
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

&Scoped-define SELF-NAME estabelec.custo-contab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.custo-contab V-table-Win
ON VALUE-CHANGED OF estabelec.custo-contab IN FRAME f-main /* Custo Cont bil */
DO:
  if l-inclui = yes then do:
     if input frame {&frame-name} estabelec.custo-contab = 1 then do:
        assign estabelec.usa-padrao:checked in frame {&frame-name}  = no.
        assign estabelec.usa-on-line:checked in frame {&frame-name} = no.
        enable estabelec.usa-on-line
               estabelec.usa-padrao with frame {&frame-name}.     
     end.
     if input frame {&frame-name} estabelec.custo-contab = 2 then do:
        assign estabelec.usa-on-line:checked in frame {&frame-name} = yes.
        assign estabelec.usa-padrao:checked in frame {&frame-name}  = no.
        disable estabelec.usa-on-line with frame {&frame-name}.
        enable estabelec.usa-padrao with frame {&frame-name}. 
     end.
     if input frame {&frame-name} estabelec.custo-contab = 3 then do:
        assign estabelec.usa-padrao:checked in frame {&frame-name}  = yes.
        assign estabelec.usa-on-line:checked in frame {&frame-name} = no.
        disable estabelec.usa-padrao with frame {&frame-name}.
        enable estabelec.usa-on-line with frame {&frame-name}.     
     end.   
  end. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
     RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF
            
 {utp/ut-rtlbl.i mgadm estabelec custo-contab c-tipo-custo}

 {utp/ut-liter.i Tipo_Custo mcd r}
 assign  c-medio  = return-value.


  
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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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

 {utp/ut-rtlbl.i mgadm estabelec custo-contab c-tipo-custo}

 {utp/ut-liter.i Tipo_Custo mcd r}
 assign  c-medio:screen-value in frame {&frame-name}  = return-value.
 
 find first param-estoq no-lock no-error.
 if avail param-estoq then do:

    assign l-inclui = yes.

    enable estabelec.custo-contab 
           estabelec.usa-on-line
           estabelec.usa-padrao with frame {&frame-name}.

    apply 'value-changed' to estabelec.custo-contab in frame {&frame-name}.
 end.
 else do:
    disable estabelec.custo-contab 
            estabelec.usa-on-line
            estabelec.usa-padrao with frame {&frame-name}.
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
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

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
  enable estabelec.custo-contab
         estabelec.usa-on-line
         estabelec.usa-padrao with frame {&frame-name}.
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

   {utp/ut-rtlbl.i mgadm estabelec custo-contab c-tipo-custo}

 {utp/ut-liter.i Tipo_Custo mcd r}
 assign c-medio:screen-value in frame {&frame-name}  = return-value.


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

  if avail param-estoq then do:  
     run cdp/cdapi005.p (input  param-estoq.ult-per-fech,
                         output da-iniper-x,
                         output da-fimper-x,
                         output i-per-corrente,
                         output i-ano-corrente,
                         output da-iniper-fech,
                         output da-fimper-fech).     
     assign l-inclui = yes.
     if avail estabelec then do:
        
        if estabelec.custo-contab = 2 then do:
           disable estabelec.usa-on-line with frame {&frame-name}.
        end.
        else do:
           enable estabelec.usa-on-line with frame {&frame-name}.
        end. 

        if estabelec.custo-contab = 3 then do:
           disable estabelec.usa-padrao with frame {&frame-name}.
        end.
        else do:
           enable estabelec.usa-padrao with frame {&frame-name}.
        end. 
                
        assign l-avail = no.     

        if estabelec.custo-contab = 1 then do:
           find first item-estab where item-estab.cod-estabel = estabelec.cod-estabel and
                     (item-estab.val-unit-mat-m[1] <> 0 or
                      item-estab.val-unit-mob-m[1] <> 0 or
                      item-estab.val-unit-ggf-m[1] <> 0) no-lock no-error.
           if not avail item-estab then
              if param-estoq.tem-moeda1 then
                 find first item-estab where item-estab.cod-estabel = estabelec.cod-estabel and
                           (item-estab.val-unit-mat-m[2] <> 0 or
                            item-estab.val-unit-mob-m[2] <> 0 or
                            item-estab.val-unit-ggf-m[2] <> 0) no-lock no-error.
           if not avail item-estab then
              if param-estoq.tem-moeda2 then
                 find first item-estab where item-estab.cod-estabel = estabelec.cod-estabel and
                           (item-estab.val-unit-mat-m[3] <> 0 or
                            item-estab.val-unit-mob-m[3] <> 0 or
                            item-estab.val-unit-ggf-m[3] <> 0) no-lock no-error.
                         
           if not avail item-estab then do:                          
              enable estabelec.custo-contab with frame {&frame-name}.
              enable estabelec.usa-on-line  with frame {&frame-name}.
              enable estabelec.usa-padrao   with frame {&frame-name}.
           end.    
        end.
        if estabelec.custo-contab = 2 then do:
           find first item-estab where item-estab.cod-estabel = estabelec.cod-estabel and
                     (item-estab.val-unit-mat-o[1] <> 0 or
                      item-estab.val-unit-mob-o[1] <> 0 or
                      item-estab.val-unit-ggf-o[1] <> 0) no-lock no-error.
           if not avail item-estab then
              if param-estoq.tem-moeda1 then
                 find first item-estab where item-estab.cod-estabel = estabelec.cod-estabel and
                           (item-estab.val-unit-mat-o[2] <> 0 or
                            item-estab.val-unit-mob-o[2] <> 0 or
                            item-estab.val-unit-ggf-o[2] <> 0) no-lock no-error.
           if not avail item-estab then
              if param-estoq.tem-moeda2 then
                 find first item-estab where item-estab.cod-estabel = estabelec.cod-estabel and
                           (item-estab.val-unit-mat-o[3] <> 0 or
                            item-estab.val-unit-mob-o[3] <> 0 or
                            item-estab.val-unit-ggf-o[3] <> 0) no-lock no-error.
           if not avail item-estab then do:                         
              enable estabelec.custo-contab with frame {&frame-name}.
              enable estabelec.usa-on-line  with frame {&frame-name}.
              enable estabelec.usa-padrao   with frame {&frame-name}.
           end.
           if estabelec.custo-contab = 3 then do:
              find first item-estab where item-estab.cod-estabel = estabelec.cod-estabel and
                        (item-estab.val-unit-mat-p[1] <> 0 or
                         item-estab.val-unit-mob-p[1] <> 0 or
                         item-estab.val-unit-ggf-p[1] <> 0) no-lock no-error.
              if not avail item-estab then
                 if param-estoq.tem-moeda1 then
                    find first item-estab where item-estab.cod-estabel = estabelec.cod-estabel and
                              (item-estab.val-unit-mat-p[2] <> 0 or
                               item-estab.val-unit-mob-p[2] <> 0 or
                               item-estab.val-unit-ggf-p[2] <> 0 ) no-lock no-error.
              if not avail item-estab then
                 if param-estoq.tem-moeda2 then
                    find first item-estab where item-estab.cod-estabel = estabelec.cod-estabel and
                              (item-estab.val-unit-mat-p[3] <> 0 or
                               item-estab.val-unit-mob-p[3] <> 0 or
                               item-estab.val-unit-ggf-p[3] <> 0) no-lock no-error.
                            
              if not avail item-estab then do:                        
                 enable estabelec.custo-contab with frame {&frame-name}.
                 enable estabelec.usa-on-line  with frame {&frame-name}.
                 enable estabelec.usa-padrao   with frame {&frame-name}.
              end.
           end.                      
        end.
        
        if estabelec.custo-contab = 2 then do:
            disable estabelec.usa-on-line with frame {&frame-name}.
        end.
        if estabelec.custo-contab = 3 then do:
            disable estabelec.usa-padrao with frame {&frame-name}.
        end.
     end.   
  end.
  else do:
     disable mgadm.estabelec.custo-contab
             mgadm.estabelec.usa-on-line 
             mgadm.estabelec.usa-padrao with frame {&frame-name}.
  end.
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
  find first param-global no-lock no-error.
  find first param-estoq  no-lock no-error.
  find first empresa
    where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
  if avail param-estoq then
     assign l-inclui = yes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

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
   
  find first param-estoq no-lock no-error.
  if avail param-estoq then do:
     assign l-inclui = yes.
     if input frame {&frame-name} estabelec.custo-contab = 1 and
        param-estoq.log-1 = no then do :
     /* Para utilizar a contabiliza‡Æo pelo m‚dio mensal, o estoque deve
        estar parametrizado para utilizar o "m‚dio batch".            */
        run utp/ut-msgs.p (input "show",
                           input 15035 ,
                           input ""    ).
        apply "entry" to mgadm.estabelec.custo-contab in frame {&frame-name}.
        return "adm-error".
     end.
  end.
  
  if (estabelec.custo-contab:modified in frame {&frame-name} = yes or
      estabelec.usa-on-line:modified in frame {&frame-name}  = yes or
      estabelec.usa-padrao:modified in frame {&frame-name}   = yes) and
     CAN-FIND(first movto-estoq where movto-estoq.cod-estabel = estabelec.cod-estabel no-lock) then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show",
                            input 5020,
                            input string(c-medio + " /" + c-tipo-custo)).
         disp estabelec.custo-contab with frame {&frame-name}.
         assign estabelec.usa-on-line:checked in frame {&frame-name}   = estabelec.usa-on-line
                estabelec.usa-padrao:checked in frame {&frame-name}    = estabelec.usa-padrao
                estabelec.custo-contab:modified in frame {&frame-name} = no
                estabelec.usa-on-line:modified in frame {&frame-name}  = no
                estabelec.usa-padrao:modified in frame {&frame-name}   = no.
         disable estabelec.custo-contab with frame {&frame-name}.
         disable estabelec.usa-on-line  with frame {&frame-name}.
         disable estabelec.usa-padrao   with frame {&frame-name}. 
         return "adm-error".         
  end.

 
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
  {src/adm/template/snd-list.i "estabelec"}

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


