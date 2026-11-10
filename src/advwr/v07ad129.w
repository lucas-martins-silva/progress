&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V07AD129 2.00.00.007}  /*** 010007 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v07ad129 MUT}
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
def new global shared var v-row-parent as rowid   no-undo.   
def new global shared var l-exporta    as logical no-undo init no.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-cd0701-cad        as char           no-undo.
def var wh-cd0701-cad       as handle         no-undo.
def var wh-handle-cad       as handle         no-undo.
def var h-acomp             as handle         no-undo.
def var c-usuario           as char           no-undo.
def var i-cont              as int            no-undo.
def var l-f5                as log            no-undo.
def var l-ems2fin-x-mg      as log    init no no-undo.
DEF VAR ind-aval-1          AS INTEGER        NO-UNDO.
DEF VAR ind-aval-2          AS INTEGER        NO-UNDO.

{cdp/cdcfgdis.i} /* Include para Pre-Processadores */
{cdp/cdcfgfin.i} /* Definicao de Fun‡äes */
{cdp/cd1234.i} 

define temp-table tt-usuario no-undo
    field user-libcre as char.

for each tt-usuario exclusive-lock:
   delete tt-usuario.
end.

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
&Scoped-define EXTERNAL-TABLES gr-cli
&Scoped-define FIRST-EXTERNAL-TABLE gr-cli


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gr-cli.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gr-cli.user-libcre gr-cli.nr-peratr ~
gr-cli.atraso-max gr-cli.nr-mesina gr-cli.dt-lim-cred ~
gr-cli.nr-cheque-devol gr-cli.moeda-libcre gr-cli.periodo-devol ~
gr-cli.lim-credito gr-cli.vl-max-devol 
&Scoped-define ENABLED-TABLES gr-cli
&Scoped-define FIRST-ENABLED-TABLE gr-cli
&Scoped-Define ENABLED-OBJECTS RECT-19 RECT-20 RECT-21 
&Scoped-Define DISPLAYED-FIELDS gr-cli.user-libcre gr-cli.nr-peratr ~
gr-cli.atraso-max gr-cli.nr-mesina gr-cli.dt-lim-cred ~
gr-cli.nr-cheque-devol gr-cli.moeda-libcre gr-cli.periodo-devol ~
gr-cli.lim-credito gr-cli.vl-max-devol 
&Scoped-define DISPLAYED-TABLES gr-cli
&Scoped-define FIRST-DISPLAYED-TABLE gr-cli
&Scoped-Define DISPLAYED-OBJECTS cb-implantacao-pedido ~
cb-implantacao-embarque tg-considera-ap-lim-cred c-moeda 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-implantacao-pedido ~
cb-implantacao-embarque tg-considera-ap-lim-cred 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-implantacao-embarque AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 38 BY 1 NO-UNDO.

DEFINE VARIABLE cb-implantacao-pedido AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE-PIXELS 266 BY 24 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 3.5.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45 BY 3.5.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 1.38.

DEFINE VARIABLE tg-considera-ap-lim-cred AS LOGICAL INITIAL no 
     LABEL "Considerar AP Limite Cr‚dito" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-implantacao-pedido AT Y 6 X 175 COLON-ALIGNED
     cb-implantacao-embarque AT ROW 2.38 COL 26 COLON-ALIGNED
     gr-cli.user-libcre AT ROW 3.5 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51.14 BY .88
     tg-considera-ap-lim-cred AT ROW 4.75 COL 28
     gr-cli.nr-peratr AT ROW 6.25 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     gr-cli.atraso-max AT ROW 6.25 COL 42 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     gr-cli.nr-mesina AT ROW 6.25 COL 72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     gr-cli.dt-lim-cred AT ROW 7.75 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     gr-cli.nr-cheque-devol AT ROW 8 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     gr-cli.moeda-libcre AT ROW 8.75 COL 19 COLON-ALIGNED
          LABEL "Moeda Lim. Cr‚d.":R24
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .88
     c-moeda AT ROW 8.75 COL 23 COLON-ALIGNED NO-LABEL
     gr-cli.periodo-devol AT ROW 9 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     gr-cli.lim-credito AT ROW 9.75 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     gr-cli.vl-max-devol AT ROW 9.83 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     RECT-19 AT ROW 7.5 COL 46
     RECT-20 AT ROW 7.5 COL 1
     RECT-21 AT ROW 6 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.gr-cli
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
         HEIGHT             = 10.33
         WIDTH              = 88.72.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 10.33
       FRAME f-main:WIDTH            = 88.72.

/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-implantacao-embarque IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-implantacao-pedido IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN gr-cli.moeda-libcre IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-considera-ap-lim-cred IN FRAME f-main
   NO-ENABLE 3                                                          */
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

&Scoped-define SELF-NAME cb-implantacao-embarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-implantacao-embarque V-table-Win
ON VALUE-CHANGED OF cb-implantacao-embarque IN FRAME f-main
DO:
  assign cb-implantacao-embarque.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-implantacao-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-implantacao-pedido V-table-Win
ON VALUE-CHANGED OF cb-implantacao-pedido IN FRAME f-main
DO:
  assign cb-implantacao-pedido.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gr-cli.moeda-libcre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.moeda-libcre V-table-Win
ON F5 OF gr-cli.moeda-libcre IN FRAME f-main /* Moeda Lim. Cr‚d. */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                     &campo=gr-cli.moeda-libcre
                     &campozoom=mo-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.moeda-libcre V-table-Win
ON LEAVE OF gr-cli.moeda-libcre IN FRAME f-main /* Moeda Lim. Cr‚d. */
DO:
   {include/leave.i &tabela=moeda
                   &atributo-ref=descricao
                   &variavel-ref=c-moeda
                   &where="moeda.mo-codigo = input frame {&frame-name}
                   gr-cli.moeda-libcre"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.moeda-libcre V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gr-cli.moeda-libcre IN FRAME f-main /* Moeda Lim. Cr‚d. */
DO:
  apply 'f5' to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gr-cli.user-libcre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.user-libcre V-table-Win
ON ENTRY OF gr-cli.user-libcre IN FRAME f-main /* Usu rio Lib Cred */
DO:
  for each tt-usuario exclusive-lock:
     delete tt-usuario.
  end.
  if input frame {&frame-name} gr-cli.user-libcre <> "*" and
     l-f5 = yes then do:
     do i-cont = 1 to num-entries(c-usuario,","):
       create tt-usuario.
       assign tt-usuario.user-libcre = trim(entry(i-cont,c-usuario,",")).
     end.

     find first tt-usuario where tt-usuario.user-libcre = input frame {&frame-name} gr-cli.user-libcre no-lock no-error.
     if not avail tt-usuario then do:
        if c-usuario <> "" then 
           assign c-usuario = c-usuario + "," + input frame {&frame-name} gr-cli.user-libcre.
        else assign c-usuario = input frame {&frame-name} gr-cli.user-libcre.   
        assign gr-cli.user-libcre:screen-value in frame {&frame-name} = c-usuario.
     end.       
     else gr-cli.user-libcre:screen-value in frame {&frame-name} = c-usuario.          

     assign l-f5 = no.
  end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.user-libcre V-table-Win
ON F5 OF gr-cli.user-libcre IN FRAME f-main /* Usu rio Lib Cred */
DO:
  assign c-usuario = input frame {&frame-name} gr-cli.user-libcre.

  assign l-implanta = yes
         l-f5       = yes.
  {include/zoomvar.i &prog-zoom="dizoom/z01di211.w"
                     &campo=gr-cli.user-libcre
                     &campozoom=usuario}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gr-cli.user-libcre V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gr-cli.user-libcre IN FRAME f-main /* Usu rio Lib Cred */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */



  &if defined(BF_FIN_EMS2_X_MG) &then
      if can-find(first funcao where funcao.cd-funcao = "spp-ems2fin-x-mg"
                               and funcao.ativo = yes) then assign l-ems2fin-x-mg = yes.
  &endif

  if not l-ems2fin-x-mg then do:
     &if defined(bf_dis_usu_moeda_cred) &then
         assign gr-cli.user-libcre:hidden = yes.
     &else
         if  gr-cli.user-libcre:load-mouse-pointer  ("image~\lupa.cur") in frame {&FRAME-NAME} then.
     &endif
  end.

  {utp/ut-liter.i Implanta‡Æo_do_Pedido MCR L}
  assign cb-implantacao-pedido:label in frame {&Frame-name} = trim(return-value).
  {utp/ut-liter.i Implanta‡Æo_do_Embarque MCR L}
  assign cb-implantacao-embarque:label in frame {&Frame-name}  = trim(return-value).

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "gr-cli"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gr-cli"}

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

  FIND FIRST para-ped NO-LOCK NO-ERROR .
  if  avail para-ped then do:

      &IF "{&bf_dis_versao_ems}" >= "2.062" &then
      FIND FIRST cm-param 
           WHERE cm-param.cod-estabel = para-ped.estab-padrao NO-LOCK NO-ERROR.
      &ENDIF

      assign gr-cli.moeda-libcre:screen-value    in frame {&frame-name} = string(para-ped.moeda-libcre)
             gr-cli.vl-max-devol:screen-value    in frame {&frame-name} = string(para-ped.vl-max-devol)
             gr-cli.nr-cheque-devol:screen-value in frame {&frame-name} = string(para-ped.nr-cheque-devol)
             gr-cli.periodo-devol:screen-value   in frame {&frame-name} = string(para-ped.periodo-devol)
             gr-cli.atraso-max:screen-value      in frame {&frame-name} = &IF "{&bf_dis_versao_ems}" >= "2.062" &then 
                                                                              if  AVAIL cm-param AND cm-param.num-dia-atraso <= 999 then string(cm-param.num-dia-atraso)
                                                                              else "999".  
                                                                          &ELSE 
                                                                               if  para-ped.dias-maxatr <= 999 then string(para-ped.dias-maxatr)
                                                                               else "999".
                                                                          &endif
     find moeda where moeda.mo-codigo = int(gr-cli.moeda-libcre:screen-value in frame {&frame-name}) no-lock no-error.
     if  avail moeda then
         assign c-moeda:screen-value in frame {&frame-name} = moeda.descricao.
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

  {include/i-valid.i}


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  assign gr-cli.ind-aval[1] = {adinc/i09ad098.i 06 cb-implantacao-pedido}.
  assign gr-cli.ind-aval[2] = {adinc/i09ad098.i 06 cb-implantacao-embarque}.       

  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &Then 
     &if "{&BF_DIS_VERSAO_EMS}" < "2.05" &THEN 
        IF tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "YES" THEN
           ASSIGN OVERLAY(gr-cli.char-1,1,1) = "".
        ELSE 
           ASSIGN OVERLAY(gr-cli.char-1,1,1) = "2".
    &ENDIF
  &ENDIF        

  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &then
       IF tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "YES" THEN
          ASSIGN gr-cli.log-consid-ap-lim-cr = YES.
       ELSE
          ASSIGN gr-cli.log-consid-ap-lim-cr = NO.
  &ENDIF


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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if  avail gr-cli then do:
      find first moeda 
           where moeda.mo-codigo = int(gr-cli.moeda-libcre:screen-value in frame {&frame-name}) no-lock no-error.
      assign c-moeda:screen-value = if  avail moeda then 
                                        moeda.descricao 
                                    else 
                                        "":U.

      &IF "{&BF_DIS_VERSAO_EMS}" >= "2.04" &Then 
         &if "{&BF_DIS_VERSAO_EMS}" < "2.05" &THEN 
            IF substring(gr-cli.char-1,1,1) = "" THEN
               ASSIGN tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "YES".
            ELSE IF substring(gr-cli.char-1,1,1) = "2" THEN
               ASSIGN tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "NO".
        &ENDIF
      &ENDIF        

      &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &then
           IF gr-cli.log-consid-ap-lim-cr = YES THEN
              ASSIGN tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "YES".
           ELSE
              ASSIGN tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "NO".
      &ENDIF

      assign cb-implantacao-embarque:screen-value in frame {&frame-name} = {adinc/i09ad098.i 04 gr-cli.ind-aval[2]}.
      assign cb-implantacao-pedido:screen-value in frame {&frame-name}   = {adinc/i09ad098.i 04 gr-cli.ind-aval[1]}.      

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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &IF "{&BF_DIS_VERSAO_EMS}" < "2.04" &Then 
     ASSIGN tg-considera-ap-lim-cred:VISIBLE IN FRAME f-main = no.
  &ENDIF


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
  do with frame {&frame-name}:
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao001 = {adinc/i09ad098.i 03}.
          RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
          ASSIGN  cb-implantacao-pedido:LIST-ITEM-PAIRS = cAuxTraducao001.
      &else
          ASSIGN cb-implantacao-pedido:list-items = {adinc/i09ad098.i 03}.
      &endif
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao002 = {adinc/i09ad098.i 03}.
          RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
          ASSIGN  cb-implantacao-embarque:LIST-ITEM-PAIRS = cAuxTraducao002.
      &else
          ASSIGN cb-implantacao-embarque:list-items = {adinc/i09ad098.i 03}.
      &endif
  end.               

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &IF "{&BF_DIS_VERSAO_EMS}" < "2.04" &Then 
     ASSIGN tg-considera-ap-lim-cred:VISIBLE IN FRAME f-main = no.
  &ENDIF

  &IF "{&BF_DIS_VERSAO_EMS}" >= "2.05" &then
      ASSIGN tg-considera-ap-lim-cred:SCREEN-VALUE IN FRAME f-main = "YES".
  &ENDIF

  assign l-f5 = no.

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/



    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

   /***************************************************
    * Pre-processador de Usuario e Moeda de Credito   *
    ***************************************************/
    &if  defined (bf_dis_usu_moeda_cred)  &then
    &else
        /*****************************************/
        /** Valida usu rio libera‡Æo de cr‚dito **/
        /*****************************************/

        for each tt-usuario exclusive-lock:
           delete tt-usuario.
        end.

        assign c-usuario = "".
        assign c-usuario = input frame {&frame-name} gr-cli.user-libcre.

        if input frame {&frame-name} gr-cli.user-libcre <> "*" then do:
           do i-cont = 1 to num-entries(c-usuario,","):
              create tt-usuario.
              assign tt-usuario.user-libcre = trim(entry(i-cont,c-usuario,",")).
           end.


           for each tt-usuario no-lock:
              find first user-coml
                   where user-coml.usuario = tt-usuario.user-libcre no-lock no-error.
              if not avail user-coml then do:
                {include/i-vldprg.i}   
                run utp/ut-msgs.p (input "show":U, 
                                   input 16618, 
                                   input tt-usuario.user-libcre).
                apply 'entry' to gr-cli.user-libcre in frame {&FRAME-NAME}.
                return 'ADM-ERROR':U.
              end.     
           end.
        end.   
    &endif.


    /** Moeda **/

    find first moeda where moeda.mo-codigo = input frame {&frame-name} gr-cli.moeda-libcre
    no-lock no-error.
    if not avail moeda then do:
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "message",
                          input 495,
                          input "").
       apply 'entry' to gr-cli.moeda-libcre in frame {&frame-name}.                   
       return 'adm-error'.
    end.


    assign l-rejeita-dec = no
           gr-cli.lim-credito:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(
                                         input frame {&frame-name} gr-cli.lim-credito,
                                         input frame {&frame-name} gr-cli.moeda-libcre)).

    if l-rejeita-dec then do:                                                                           
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Limite_Credito" *}
       run utp/ut-msgs.p (input "show",
                          input 18130,
                          input RETURN-VALUE).
       apply 'entry' to gr-cli.lim-credito in frame {&frame-name}.                   
       return 'adm-error'.
    end. 

    assign l-rejeita-dec = no                                      
           gr-cli.vl-max-devol:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(
                                         input frame {&frame-name} gr-cli.vl-max-devol,0)).
    if l-rejeita-dec then do:                                                                           
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Vl_Max_Ch_Devol" *}
       run utp/ut-msgs.p (input "show",
                          input 18130,
                          input RETURN-VALUE).
       apply 'entry' to gr-cli.vl-max-devol in frame {&frame-name}.                   
       return 'adm-error'.
    end. 

    assign input frame {&frame-name} cb-implantacao-pedido
           input frame {&frame-name} cb-implantacao-embarque
           ind-aval-1 = {adinc/i09ad098.i 06 cb-implantacao-pedido}
           ind-aval-2 = {adinc/i09ad098.i 06 cb-implantacao-embarque}. 

    if   INPUT gr-cli.lim-credito = 0 then do:
         if  int(ind-aval-1) = 3 or /*3 - Limite e Atrasos Duplicatas*/
             int(ind-aval-2) = 3 then do:
              run utp/ut-msgs.p (input "show", input 710, input "").
              apply "entry" to gr-cli.lim-credito.
              return 'adm-error'.
          end.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "gr-cli"}

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

