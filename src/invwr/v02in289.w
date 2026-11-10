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
{include/i-prgvrs.i V02IN289 2.00.00.014}  /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN289 MUT}
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

{cdp/cdcfgmnt.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-equipto for equipto.
def var l-existe   as log  no-undo.
def var c-formato  as char no-undo.
def var c-formato2 as char no-undo.
def var c-label-1  as char no-undo.
def var c-label-2  as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-mi
&Scoped-define FIRST-EXTERNAL-TABLE param-mi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-mi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-mi.aprov-solic ~
param-mi.formato-cd-equipto param-mi.formato-cd-tag 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}formato-cd-equipto ~{&FP2}formato-cd-equipto ~{&FP3}~
 ~{&FP1}formato-cd-tag ~{&FP2}formato-cd-tag ~{&FP3}
&Scoped-define ENABLED-TABLES param-mi
&Scoped-define FIRST-ENABLED-TABLE param-mi
&Scoped-Define ENABLED-OBJECTS rt-mold l-prop-utiliz i-prox-sol-serv ~
l-numer-unica i-cd-turno l-gera-pert 
&Scoped-Define DISPLAYED-FIELDS param-mi.aprov-solic ~
param-mi.formato-cd-equipto param-mi.formato-cd-tag 
&Scoped-Define DISPLAYED-OBJECTS l-prop-utiliz i-prox-sol-serv ~
l-numer-unica i-prim-sol-serv i-ult-sol-serv i-cd-turno c-descricao ~
l-gera-pert 

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
DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88.

DEFINE VARIABLE i-cd-turno AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Turno Padr∆o" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE i-prim-sol-serv AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Prim Solic Serviáo":R22 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88.

DEFINE VARIABLE i-prox-sol-serv AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Prox Solic Serviáo":R22 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88.

DEFINE VARIABLE i-ult-sol-serv AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Ult Solic Serviáo":R22 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80.86 BY 9.75.

DEFINE VARIABLE l-gera-pert AS LOGICAL INITIAL no 
     LABEL "Gera Rede PERT":L16 
     VIEW-AS TOGGLE-BOX
     SIZE 20.29 BY .83.

DEFINE VARIABLE l-numer-unica AS LOGICAL INITIAL no 
     LABEL "Numeraá∆o Ènica" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83.

DEFINE VARIABLE l-prop-utiliz AS LOGICAL INITIAL no 
     LABEL "Propaga Utilizaá∆o Encerramento" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.57 BY .67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-mi.aprov-solic AT ROW 1.5 COL 11
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .67
     l-prop-utiliz AT ROW 1.5 COL 44
     param-mi.formato-cd-equipto AT ROW 2.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
     param-mi.formato-cd-tag AT ROW 3.5 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
     i-prox-sol-serv AT ROW 4.5 COL 30 COLON-ALIGNED
     l-numer-unica AT ROW 5.75 COL 32 HELP
          "N£meraá∆o £nica para as ordens de manutená∆o"
     i-prim-sol-serv AT ROW 6.75 COL 30 COLON-ALIGNED HELP
          "Primeira Solicitaá∆o de Serviáo"
     i-ult-sol-serv AT ROW 7.75 COL 30 COLON-ALIGNED
     i-cd-turno AT ROW 8.75 COL 30 COLON-ALIGNED
     c-descricao AT ROW 8.75 COL 35 COLON-ALIGNED NO-LABEL
     l-gera-pert AT ROW 9.83 COL 32 HELP
          "Gera Rede PERT automaticamente"
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-mi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 9.75
         WIDTH              = 80.86.
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

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-descricao:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       i-cd-turno:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN i-prim-sol-serv IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-prim-sol-serv:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN i-ult-sol-serv IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-ult-sol-serv:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       l-gera-pert:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       l-numer-unica:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME i-cd-turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-turno V-table-Win
ON F5 OF i-cd-turno IN FRAME f-main /* Turno Padr∆o */
DO:
  &if defined (bf_mnt_ems203)  &then 
     assign l-implanta = yes.
     {include/zoomvar.i &prog-zoom="mnzoom/z01mn015.w"
                        &campo=i-cd-turno
                        &campozoom=cd-turno}
  &endif                  
                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-turno V-table-Win
ON LEAVE OF i-cd-turno IN FRAME f-main /* Turno Padr∆o */
DO:
   &if defined (bf_mnt_ems203)  &then 
       {include/leave.i &tabela=mi-turno
                        &atributo-ref=descricao
                        &variavel-ref=c-descricao
                        &where="mi-turno.cd-turno = input frame {&frame-name} i-cd-turno"}
   &endif                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-turno V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cd-turno IN FRAME f-main /* Turno Padr∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-numer-unica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-numer-unica V-table-Win
ON VALUE-CHANGED OF l-numer-unica IN FRAME f-main /* Numeraá∆o Ènica */
DO:
   &if defined (bf_mnt_ems203) &then
     assign i-prim-sol-serv:sensitive in frame {&FRAME-NAME} = input frame {&FRAME-NAME} l-numer-unica
            i-ult-sol-serv:sensitive  in frame {&FRAME-NAME} = input frame {&FRAME-NAME} l-numer-unica. 
   &endif  
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

  {utp/ut-liter.i Aprovaá∆o_Eletrìnica * R}
  assign param-mi.aprov-solic:label in frame {&FRAME-NAME} = return-value.
  
  {utp/ut-liter.i Propaga_Utilizaá∆o_Encerramento * R}
  assign l-prop-utiliz:label in frame {&FRAME-NAME} = return-value.
  
  {utp/ut-field.i mgind param-mi prox-sol-serv 1}
  assign i-prox-sol-serv:label in frame {&frame-name} = trim(return-value).
  
  &if defined (bf_mnt_ems203)  &then  
 
     {utp/ut-field.i mgind param-mi prim-sol-serv 1}
     assign i-prim-sol-serv:label in frame {&frame-name} = trim(return-value).
    
     {utp/ut-field.i mgind param-mi ult-sol-serv 1}
     assign i-ult-sol-serv:label in frame {&frame-name} = trim(return-value).

     {utp/ut-field.i mgind param-mi numer-unica 1}
     assign l-numer-unica:label in frame {&frame-name} = trim(return-value).
  
     {utp/ut-field.i mgind param-mi gera-pert 1}
     assign l-gera-pert:label in frame {&frame-name} = trim(return-value).
     
     {utp/ut-field.i mgind param-mi cd-turno 1}
     assign i-cd-turno:label in frame {&frame-name} = trim(return-value).

     if i-cd-turno:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.
  
  &endif

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
  {src/adm/template/row-list.i "param-mi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-mi"}

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
  
  find first param-mi exclusive-lock no-error.
  if avail param-mi then do:
     assign param-mi.prox-sol-serv = input frame {&FRAME-NAME} i-prox-sol-serv.
     
     &if defined (bf_mnt_ems203)  &then  
        assign param-mi.prop-utiliz = input frame {&FRAME-NAME} l-prop-utiliz   
               param-mi.cd-turno    = input frame {&FRAME-NAME} i-cd-turno
               param-mi.gera-pert   = input frame {&FRAME-NAME} l-gera-pert
               param-mi.numer-unica = input frame {&FRAME-NAME} l-numer-unica. 
     &else
        assign param-mi.log-1   = input frame {&FRAME-NAME} l-prop-utiliz.   
     &endif
  end.   
     
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
   if avail param-mi then
      assign c-formato  = param-mi.formato-cd-equipto
             c-formato2 = param-mi.formato-cd-tag.

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
  
  &if defined (bf_mnt_ems203)  &then
  
     assign    l-numer-unica:hidden   in frame {&FRAME-NAME}  = no
               l-gera-pert:hidden     in frame {&FRAME-NAME}  = no
               i-prim-sol-serv:hidden in frame {&FRAME-NAME}  = no
               i-ult-sol-serv:hidden  in frame {&FRAME-NAME}  = no
               l-prop-utiliz:hidden   in frame {&FRAME-NAME}  = no
               i-cd-turno:hidden      in frame {&FRAME-NAME}  = no
               c-descricao:hidden     in frame {&FRAME-NAME}  = no.
               
  &endif             
  
  find first param-mi no-lock no-error.
  if avail param-mi then do:
     assign i-prox-sol-serv = param-mi.prox-sol-serv.
     
     &if defined (bf_mnt_ems203)  &then 
        assign l-numer-unica   = param-mi.numer-unica
               l-gera-pert     = param-mi.gera-pert
               i-prim-sol-serv = param-mi.prim-sol-serv
               i-ult-sol-serv  = param-mi.ult-sol-serv
               l-prop-utiliz   = param-mi.prop-utiliz
               i-cd-turno      = param-mi.cd-turno   
               i-prim-sol-serv:sensitive in frame {&FRAME-NAME} = param-mi.numer-unica
               i-ult-sol-serv:sensitive  in frame {&FRAME-NAME} = param-mi.numer-unica .
               
     &else
         assign l-prop-utiliz   = param-mi.log-1   
                i-prox-sol-serv:format in frame {&FRAME-NAME} = ">>>,>>9"
                rt-mold:height in frame {&FRAME-NAME} = 5.27. 
     &endif             
  end.          

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    apply "leave" to i-cd-turno.         

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-faixa-solic V-table-Win 
PROCEDURE pi-faixa-solic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 &if defined (bf_mnt_ems203)  &then  
 
     def output parameter l-numer-aut       as logical                  no-undo.
     def output parameter i-prim-solic-serv like param-mi.prim-sol-serv no-undo.
     def output parameter i-ult-solic-serv  like param-mi.ult-sol-serv  no-undo.
   
     if input frame {&FRAME-NAME} l-numer-unica = yes then do:
       
        {include/i-vldfrm.i} 
    
        IF  (INPUT FRAME {&frame-name} i-prim-sol-serv) > (INPUT FRAME {&frame-name} i-ult-sol-serv) 
        THEN DO:
            {include/i-vldprg.i}
            RUN utp/ut-msgs.p (input "show",
                               input 252,
                               input "").
            APPLY "entry" TO i-prim-sol-serv IN FRAME {&frame-name}.
            RETURN "adm-error".
        END.  
    
        IF  (INPUT FRAME {&frame-name} i-prox-sol-serv) < (INPUT FRAME {&frame-name} i-prim-sol-serv)
        or  (INPUT FRAME {&frame-name} i-prox-sol-serv) > (INPUT FRAME {&frame-name} i-ult-sol-serv)
        THEN DO:
            {include/i-vldprg.i}
            {utp/ut-table.i mgind solic-serv 1}
            RUN utp/ut-msgs.p (input "show",
                               input 18022,
                               input return-value).
            APPLY "entry" TO i-prox-sol-serv IN FRAME {&frame-name}.
            RETURN "adm-error".
        END.
    
        if can-find(first solic-serv where
           solic-serv.nr-soli-serv < INPUT FRAME {&frame-name} i-prim-sol-serv or
           solic-serv.nr-soli-serv > INPUT FRAME {&frame-name} i-ult-sol-serv) then do:
            {include/i-vldprg.i}
            RUN utp/ut-msgs.p (input "show",
                               input 18028,
                               input return-value).
            APPLY "entry" TO i-prim-sol-serv IN FRAME {&frame-name}.
            RETURN "adm-error".
        end.  
                   
          
        assign  i-prim-solic-serv = INPUT FRAME {&frame-name} i-prim-sol-serv
                i-ult-solic-serv  = INPUT FRAME {&frame-name} i-ult-sol-serv.
                l-numer-aut         = yes.
                  
     end.
     else 
        assign l-numer-aut = no.           
&endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} 
  
  find first equipto no-lock no-error.
  if input frame {&frame-name} param-mi.formato-cd-equipto <> ' ' then
     if  c-formato <> input frame {&frame-name} param-mi.formato-cd-equipto
         and avail equipto then do:
         {include/i-vldprg.i}
         {utp/ut-field.i mgind equipto cd-equipto 1}
         assign c-label-1 = trim(return-value).
         {utp/ut-liter.i Equipamentos * r} 
         assign c-label-2 = trim(return-value).
         run utp/ut-msgs.p (input "show",
                            input 15973,
                            input c-label-1 + "~~" + c-label-2). 
         apply "entry" to param-mi.formato-cd-equipto in frame {&frame-name}.
         assign param-mi.formato-cd-equipto:screen-value in frame {&frame-name} = c-formato.
         RETURN "adm-error".
     end.
        
  find first tag  no-lock no-error.
  if input frame {&frame-name} param-mi.formato-cd-tag <> ' ' then
     if  c-formato2 <> input frame {&frame-name} param-mi.formato-cd-tag
         and avail tag then do:
         {include/i-vldprg.i}
         {utp/ut-field.i mgind tag cd-tag 1}
         assign c-label-1 = trim(return-value).
         {utp/ut-liter.i Tags * r} 
         assign c-label-2 = trim(return-value).
         run utp/ut-msgs.p (input "show",
                            input 15973,
                            input c-label-1 + "~~" + c-label-2). 
         apply "entry" to param-mi.formato-cd-tag in frame {&frame-name}.
         assign param-mi.formato-cd-tag:screen-value in frame {&frame-name} = c-formato2.     
         RETURN "adm-error".                           
      end.
  
  &if defined (bf_mnt_ems203)  &then  
     
     find first param-mnt no-lock no-error.
     if  avail param-mnt and 
         param-mnt.produto-cp = 1 then do:
               
         if input frame {&frame-name} l-numer-unica and
             length(i-prim-sol-serv:screen-value in frame {&frame-name}) > 7 or
             length(i-ult-sol-serv:screen-value in frame {&frame-name})  > 7 then do:
             
             {include/i-vldprg.i}
             RUN utp/ut-msgs.p (input "show",
                                input 19297,
                                input "").
             APPLY "entry" TO i-prim-sol-serv IN FRAME {&frame-name}.
             RETURN "adm-error".
         end.
     end.
  
     find first mi-turno where mi-turno.cd-turno = 
          input frame {&FRAME-NAME} i-cd-turno no-lock no-error.
     if not avail mi-turno then do:
        {include/i-vldprg.i} 
        {utp/ut-table.i mgmnt mi-turno 1} 
        RUN utp/ut-msgs.p (input "show",
                             input 2,
                             input trim(return-value)).
          
        apply "entry" to i-cd-turno in frame {&frame-name}.
        RETURN "adm-error".
     end.   
  &endif 
         
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
  {src/adm/template/snd-list.i "param-mi"}

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


