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
{include/i-prgvrs.i V33IN245 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V33IN245 MUT}
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
    def buffer b-natur-oper for natur-oper.


    def var l-terceiros    as logical no-undo.

    def var v-row-parent   as rowid   no-undo.
    def var l-novo-reg     as logical initial no.
    def var c-tipo         as char    no-undo.
    def var l-setou-campo  as logical no-undo.

    def var c-lista-itens  as char format "x(150)" no-undo.
    def var i-tp-oper-terc as i no-undo.
    def var l-ind-bipi     as logical no-undo.

    def var c-item1        as char.
    def var c-item2        as char.
    def var c-item3        as char.
    def var c-item4        as char.
    def var c-item5        as char.
    def var c-item6        as char.

    def var c-char-2       as char    no-undo.
    def var c-char-2-aux   as char    no-undo.

    def var l-primeiro  as logical init yes.
    def var c-formato   as character.
    def var c-nat-operacao like natur-oper.nat-operacao no-undo.
    
    {cdp/cdcfgdis.i} /*include para pr‚-processadores*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES natur-oper
&Scoped-define FIRST-EXTERNAL-TABLE natur-oper


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR natur-oper.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS natur-oper.terceiros natur-oper.transf ~
natur-oper.venda-ativo natur-oper.imp-nota natur-oper.dec-1 ~
natur-oper.nat-comp 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dec-1 ~{&FP2}dec-1 ~{&FP3}~
 ~{&FP1}nat-comp ~{&FP2}nat-comp ~{&FP3}
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define ENABLED-OBJECTS rt-mold-2 rt-mold-3 
&Scoped-Define DISPLAYED-FIELDS natur-oper.terceiros natur-oper.transf ~
natur-oper.venda-ativo natur-oper.imp-nota natur-oper.dec-1 ~
natur-oper.nat-comp 
&Scoped-Define DISPLAYED-OBJECTS c-cod-natur-oper-bonif ~
c-desc-natur-oper-bonif l-log-natureza-bonif l-altera-vl-terc ~
cb-tp-oper-terc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS c-cod-natur-oper-bonif ~
l-log-natureza-bonif l-altera-vl-terc cb-tp-oper-terc 

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
DEFINE VARIABLE cb-tp-oper-terc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 21.14 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-natur-oper-bonif AS CHARACTER FORMAT "9.99-xxx":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-natur-oper-bonif AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.57 BY 5.58.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26.86 BY 5.58.

DEFINE VARIABLE l-altera-vl-terc AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83.

DEFINE VARIABLE l-log-natureza-bonif AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-cod-natur-oper-bonif AT ROW 5.13 COL 50.14 COLON-ALIGNED
     c-desc-natur-oper-bonif AT ROW 5.13 COL 61 COLON-ALIGNED NO-LABEL
     l-log-natureza-bonif AT ROW 5.58 COL 2.14
     natur-oper.terceiros AT ROW 1.38 COL 2.14
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .83
     l-altera-vl-terc AT ROW 2.17 COL 2.14
     natur-oper.transf AT ROW 3 COL 2.14
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .83
     natur-oper.venda-ativo AT ROW 3.88 COL 2.14
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .83
     natur-oper.imp-nota AT ROW 4.71 COL 2.14
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .83
     cb-tp-oper-terc AT ROW 2.13 COL 50.14 COLON-ALIGNED
     natur-oper.dec-1 AT ROW 3.13 COL 50.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     natur-oper.nat-comp AT ROW 4.13 COL 50.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     rt-mold-2 AT ROW 1 COL 28.29
     rt-mold-3 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.natur-oper
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
         HEIGHT             = 5.67
         WIDTH              = 84.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-natur-oper-bonif IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       c-cod-natur-oper-bonif:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-natur-oper-bonif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tp-oper-terc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-altera-vl-terc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-log-natureza-bonif IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       l-log-natureza-bonif:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-cod-natur-oper-bonif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-natur-oper-bonif V-table-Win
ON ENTRY OF c-cod-natur-oper-bonif IN FRAME f-main
DO:
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
 
&if defined (bf_dis_desc_bonif) &then
    assign c-cod-natur-oper-bonif:format = "9.99-xxx".
&endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-natur-oper-bonif V-table-Win
ON f5 OF c-cod-natur-oper-bonif IN FRAME f-main
DO:
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
 
&if defined (bf_dis_desc_bonif) &then
  l-implanta = yes.   
     {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=c-cod-natur-oper-bonif
                       &campozoom=nat-operacao}
&endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-natur-oper-bonif V-table-Win
ON LEAVE OF c-cod-natur-oper-bonif IN FRAME f-main
DO:
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
   
 &if defined (bf_dis_desc_bonif) &then
     if substring(self:screen-value,1,1) = '0' or
        substring(self:screen-value,1,1) = ''  then do:
        assign self:format = 'xxxxxx'
               self:screen-value = ''.
     end.
     else do:
        {cdp/cd9998.i}
     end.             
  &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-natur-oper-bonif V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-natur-oper-bonif IN FRAME f-main
DO:
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
 
&if defined (bf_dis_desc_bonif) &then

  apply "F5" to self.

&endif


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tp-oper-terc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-oper-terc V-table-Win
ON VALUE-CHANGED OF cb-tp-oper-terc IN FRAME f-main /* Combo 1 */
DO:
   if l-altera-vl-terc:checked      in frame {&frame-name} = yes     and
      (cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6) 
   then assign natur-oper.dec-1:sensitive in frame {&frame-name} = yes.
   else assign natur-oper.dec-1:sensitive in frame {&frame-name} = no.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-altera-vl-terc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-altera-vl-terc V-table-Win
ON VALUE-CHANGED OF l-altera-vl-terc IN FRAME f-main
DO:
   if l-altera-vl-terc:checked      in frame {&frame-name} = yes     and
      (cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 or 
       cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6) 
   then assign natur-oper.dec-1:sensitive in frame {&frame-name} = yes.
   else assign natur-oper.dec-1:sensitive in frame {&frame-name}    = no
               natur-oper.dec-1:screen-value in frame {&frame-name} = string(0).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.nat-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-comp V-table-Win
ON F5 OF natur-oper.nat-comp IN FRAME f-main /* Natureza Complementar */
DO:
 {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                    &campo=natur-oper.nat-comp
                    &campozoom=nat-operacao}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-comp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.nat-comp IN FRAME f-main /* Natureza Complementar */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.terceiros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.terceiros V-table-Win
ON VALUE-CHANGED OF natur-oper.terceiros IN FRAME f-main /* Opera‡Æo com Terceiros */
DO:
  if input frame {&frame-name} natur-oper.terceiros = no then do:
     assign natur-oper.transf:sensitive   in frame {&frame-name} = yes
            cb-tp-oper-terc:sensitive     in frame {&frame-name} = no
            natur-oper.dec-1:sensitive    in frame {&frame-name} = no
            l-altera-vl-terc:sensitive    in frame {&frame-name} = no
            l-altera-vl-terc:checked      in frame {&frame-name} = no
            natur-oper.dec-1:screen-value in frame {&frame-name} = string(0).

     {utp/ut-liter.i Remessa_Beneficiamento mce R}
     assign cb-tp-oper-terc:screen-value = trim(return-value).
  end.
  else do:
      assign natur-oper.transf:sensitive in frame {&frame-name} = no
             l-altera-vl-terc:sensitive  in frame {&frame-name} = yes
             cb-tp-oper-terc:sensitive   in frame {&frame-name} = yes.
      if l-altera-vl-terc:checked      in frame {&frame-name} = yes and
         (cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 or 
          cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4 or 
          cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 or 
          cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6) 
      then assign natur-oper.dec-1:sensitive in frame {&frame-name} = yes.
      else assign natur-oper.dec-1:sensitive in frame {&frame-name} = no.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.transf V-table-Win
ON VALUE-CHANGED OF natur-oper.transf IN FRAME f-main /* Opera‡äes Transferˆncia */
DO:

  if input frame {&frame-name} natur-oper.transf = no then do with frame {&frame-name}:
      enable  natur-oper.terceiros.
  end.
  else do with frame {&FRAME-NAME}:
      disable natur-oper.terceiros.
              
  end.    

  if input frame {&frame-name} natur-oper.transf = yes and
     param-global.modulo-mp then do with frame {&frame-name}:
     enable  natur-oper.nat-comp.
     assign natur-oper.nat-comp:format in frame {&FRAME-NAME} = "x.xx-xxx". 

  end.
  else do with frame {&FRAME-NAME}:
      disable natur-oper.nat-comp.
      display "" @ natur-oper.nat-comp.
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
  
  /***Ponteiros do Mouse***/
  if natur-oper.nat-comp:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then.

  /***Formatos***/
  assign natur-oper.dec-1:format in frame {&frame-name} = ">>9.99":U.

  /***Labels***/
  {utp/ut-field.i mgind natur-oper tp-oper-terc 1}
  assign cb-tp-oper-terc:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Varia‡Æo_Vl_Itens_Terc * L}
  assign natur-oper.dec-1:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Altera_Vl_Itens_Terc * L}
  assign l-altera-vl-terc:label in frame {&frame-name} = trim(return-value).  
    
  {utp/ut-liter.i Compra/Venda_Ativo * L}
  assign natur-oper.venda-ativo:label in frame {&frame-name} = trim(return-value)
         natur-oper.venda-ativo:help in frame {&frame-name} = trim(return-value).

/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
          
  &if defined (bf_dis_desc_bonif) &then
        {utp/ut-liter.i Natureza_Bonifica‡Æo * R}
        assign l-log-natureza-bonif:label in frame {&frame-name} = return-value.
        {utp/ut-liter.i Natur_Oper_Bonif * R}
        assign c-cod-natur-oper-bonif:label in frame {&frame-name} = return-value.
        if c-cod-natur-oper-bonif:load-mouse-pointer("image/lupa.cur")
        in frame {&frame-name} then.
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
  {src/adm/template/row-list.i "natur-oper"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "natur-oper"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
   
  &if defined (bf_dis_desc_bonif) &then
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = no
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = no
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = no
             c-cod-natur-oper-bonif:screen-value in frame {&frame-name} = ""
             c-cod-natur-oper-bonif:format in frame {&frame-name} = "xxxxxx"
             l-log-natureza-bonif:checked in frame {&frame-name}    = no.
 &else
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = yes
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = yes
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = yes.
 &endif

  
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
  
  if input frame {&frame-name} cb-tp-oper-terc = c-item1 then assign i-tp-oper-terc = 1.
  if input frame {&frame-name} cb-tp-oper-terc = c-item2 then assign i-tp-oper-terc = 2.
  if input frame {&frame-name} cb-tp-oper-terc = c-item3 then assign i-tp-oper-terc = 3.
  if input frame {&frame-name} cb-tp-oper-terc = c-item4 then assign i-tp-oper-terc = 4.
  if input frame {&frame-name} cb-tp-oper-terc = c-item5 then assign i-tp-oper-terc = 5.
  if input frame {&frame-name} cb-tp-oper-terc = c-item6 then assign i-tp-oper-terc = 6. 

/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
  
 &if defined (bf_dis_desc_bonif) &then
   assign input frame {&frame-name} l-log-natureza-bonif
          input frame {&frame-name} c-cod-natur-oper-bonif.
  &endif
/************************************************************/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
   
   &if defined (bf_dis_desc_bonif) &then
    assign natur-oper.log-natureza-bonif   = l-log-natureza-bonif
           natur-oper.cod-natur-oper-bonif = c-cod-natur-oper-bonif.
   &endif 
                         
/************************************************************/

  assign substr(natur-oper.char-2,36,5) = if l-altera-vl-terc:checked in frame {&frame-name}
                                             then "1    "
                                             else "2    ".

  assign substr(natur-oper.char-2,11,5) = if l-ind-bipi then "1    "
                                                        else "2    ".

  assign natur-oper.tp-oper-terc = i-tp-oper-terc.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  
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

  /* Code placed here will execute AFTER standard behavior.    */
  
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
   
  &if defined (bf_dis_desc_bonif) &then
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = no
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = no
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = no.
 &else
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = yes
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = yes
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = yes.
      
 &endif


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
     
  if avail natur-oper then do with frame {&frame-name}:

     /***Altera Saldos Terceiros***/
     if substr(natur-oper.char-2,36,5) = "1    "
        then assign l-altera-vl-terc:checked in frame {&frame-name} = yes.
        else assign l-altera-vl-terc:checked in frame {&frame-name} = no.
  
     /***Tipo Opera‡Æo Terceiros***/
     if natur-oper.tp-oper-terc = 1 then do:
        {utp/ut-liter.i Remessa_Beneficiamento mce R}
        assign cb-tp-oper-terc:screen-value = trim(return-value).
     end.
     
     if natur-oper.tp-oper-terc = 2 then do:
        {utp/ut-liter.i Retorno_Beneficiamento mce R}
        assign cb-tp-oper-terc:screen-value = trim(return-value).
     end.
     
     if natur-oper.tp-oper-terc = 3 then do:
        {utp/ut-liter.i Remessa_Consigna‡Æo mce R}
        assign cb-tp-oper-terc:screen-value = trim(return-value).
     end.
     
     if natur-oper.tp-oper-terc = 4 then do:
        {utp/ut-liter.i Faturamento_Consigna‡Æo mce R}
        assign cb-tp-oper-terc:screen-value = trim(return-value).
     end.
     
     if natur-oper.tp-oper-terc = 5 then do:
        {utp/ut-liter.i Devolu‡Æo_Consigna‡Æo mce R}
        assign cb-tp-oper-terc:screen-value = trim(return-value).
     end.
     
     if natur-oper.tp-oper-terc = 6 then do:
        {utp/ut-liter.i Reajuste_Pre‡o mce R}
        assign cb-tp-oper-terc:screen-value = trim(return-value).
     end.
  end.
  else do with frame {&frame-name}:
       {utp/ut-liter.i Remessa_Beneficiamento mce R}
       assign cb-tp-oper-terc:screen-value = trim(return-value).
  end.
  
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
   
  &if defined (bf_dis_desc_bonif) &then
      if avail natur-oper then do:
         do with frame {&frame-name}:
            assign l-log-natureza-bonif:checked    = natur-oper.log-natureza-bonif
                   c-cod-natur-oper-bonif:screen-value  = natur-oper.cod-natur-oper-bonif.
         end.          
      end.
      assign c-cod-natur-oper-bonif:format in frame {&frame-name} = "9.99-xxx".
      find b-natur-oper where 
       b-natur-oper.nat-operacao = input frame {&frame-name} c-cod-natur-oper-bonif no-lock no-error.
       assign c-desc-natur-oper-bonif:screen-value in frame {&frame-name} = if available b-natur-oper 
                                                                       then b-natur-oper.denominacao
                                                                       else "":U.
  &endif

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  if input frame {&frame-name} natur-oper.terceiros:checked = yes
     then assign natur-oper.transf:sensitive in frame {&frame-name} = no
                 l-altera-vl-terc:sensitive  in frame {&frame-name} = yes
                 cb-tp-oper-terc:sensitive   in frame {&frame-name} = yes.
     else assign natur-oper.transf:sensitive in frame {&frame-name} = yes
                 l-altera-vl-terc:sensitive  in frame {&frame-name} = no
                 l-altera-vl-terc:checked    in frame {&frame-name} = no
                 cb-tp-oper-terc:sensitive   in frame {&frame-name} = no.

  if input frame {&frame-name} natur-oper.transf:checked = yes
     then assign natur-oper.terceiros:sensitive in frame {&frame-name} = no.

  if input frame {&frame-name} natur-oper.transf = yes and
     param-global.modulo-mp
  then assign natur-oper.nat-comp:sensitive in frame {&frame-name} = yes.
  else assign natur-oper.nat-comp:sensitive in frame {&frame-name} = no.

  if l-altera-vl-terc:checked      in frame {&frame-name} = yes     and
     (cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 or
      cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4 or
      cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 or
      cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6)
  then assign natur-oper.dec-1:sensitive in frame {&frame-name} = yes.
  else assign natur-oper.dec-1:sensitive in frame {&frame-name} = no.
  
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
   
  &if defined (bf_dis_desc_bonif) &then
       assign l-log-natureza-bonif:sensitive in frame {&frame-name} = yes.
       assign c-cod-natur-oper-bonif:sensitive in frame {&frame-name} = yes.
       if natur-oper.cod-natur-oper-bonif = "" then do:
          assign c-cod-natur-oper-bonif:screen-value in frame {&frame-name} = ""
                 c-cod-natur-oper-bonif:format in frame {&frame-name} = "xxxxxx".
       end.
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
  {utp/ut-liter.i Remessa_Beneficiamento mce R}
  assign c-lista-itens = return-value + ","
         c-item1 = return-value.

  {utp/ut-liter.i Retorno_Beneficiamento mce R}
  assign c-lista-itens = c-lista-itens + return-value + ","
         c-item2 = return-value.

  {utp/ut-liter.i Remessa_Consigna‡Æo mce R}
  assign c-lista-itens = c-lista-itens + return-value + ","
         c-item3 = return-value.

  {utp/ut-liter.i Faturamento_Consigna‡Æo mce R}
  assign c-lista-itens = c-lista-itens + return-value + ","
         c-item4 = return-value.

  {utp/ut-liter.i Devolu‡Æo_Consigna‡Æo mce R}
  assign c-lista-itens = c-lista-itens + return-value + ","
         c-item5 = return-value.

  {utp/ut-liter.i Reajuste_Pre‡o mce R}
  assign c-lista-itens = c-lista-itens + return-value
         c-item6 = return-value.

  do with frame {&frame-name}:
      assign cb-tp-oper-terc:list-items = c-lista-itens.
  end.        
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
   
  &if defined (bf_dis_desc_bonif) &then
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = no
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = no
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = no.
 &else
      assign l-log-natureza-bonif:hidden in frame {&frame-name}    = yes
             c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = yes
             c-desc-natur-oper-bonif:hidden in frame {&frame-name} = yes.
      
 &endif
  
  find first param-global no-lock no-error.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-esconde-campo-tela V-table-Win 
PROCEDURE pi-esconde-campo-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Esta procedure somente ‚ executada por um pr‚-processador "desc_bonif".
         NÆo eliminar esta procedure.      
------------------------------------------------------------------------------*/

assign l-log-natureza-bonif:hidden in frame {&frame-name}    = yes
       c-cod-natur-oper-bonif:hidden in frame {&frame-name}  = yes
       c-desc-natur-oper-bonif:hidden in frame {&frame-name} = yes.

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

 
   if natur-oper.transf:checked in frame {&frame-name} = yes and param-global.modulo-mp then do:
        
      if input frame {&frame-name} natur-oper.nat-comp = "" then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U, input 5260, input return-value).
         apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
         return 'ADM-ERROR':U.
      end.

      find first b-natur-oper where
                 b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-comp no-lock no-error.
      RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT THIS-PROCEDURE, INPUT "tipo":U).
      assign c-tipo = return-value.

      if not avail b-natur-oper then do:
         {include/i-vldprg.i} 
         run utp/ut-msgs.p (input "show":U, input 5260, input return-value).
         apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
         return 'ADM-ERROR':U.
      end.
        
      if avail b-natur-oper and 
               b-natur-oper.tipo = {ininc/i06in245.i 06 c-tipo} then do:
         {include/i-vldprg.i} 
         run utp/ut-msgs.p (input "show":U, input 15408, input return-value).
         apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
         return 'ADM-ERROR':U.
      end.
    end.
    
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
     
    &if defined (bf_dis_desc_bonif) &then
        RUN Get-Field-Screen-Value IN adm-broker-hdl 
        (INPUT THIS-PROCEDURE, INPUT "nat-operacao":U).
        assign c-nat-operacao = trim(return-value).
        assign c-nat-operacao = replace(c-nat-operacao,".","").
        assign c-nat-operacao = replace(c-nat-operacao,"-","").
        if l-log-natureza-bonif:checked in frame {&frame-name} = yes and
           substring(input frame {&frame-name} c-cod-natur-oper-bonif,1,1) <> '' then do :        
            {include/i-vldprg.i} 
           /* mensagem: Indicador e C¢digo de Natureza Bonifica‡Æo nÆo podem ser preenchidos simultaneamentes */
                run utp/ut-msgs.p (input "show":U, input 17739, input return-value).
                apply "entry" to c-cod-natur-oper-bonif in frame {&frame-name}.
                return 'ADM-ERROR':U.
        end.
        else
           if l-log-natureza-bonif:checked in frame {&frame-name} = no and
              substring(input frame {&frame-name} c-cod-natur-oper-bonif,1,1) <> '' then do :
              find first b-natur-oper where
                   b-natur-oper.nat-operacao = input frame {&frame-name} c-cod-natur-oper-bonif
                   no-lock no-error.
              if not available b-natur-oper then do:    
                  {include/i-vldprg.i} 
                  /* mensagem: Natureza de Opera‡Æo invalida */
                  {utp/ut-field.i mgind natur-oper cod-natur-oper-bonif 1}
                  run utp/ut-msgs.p (input "show":U, input 56, input return-value).
                  apply "entry" to c-cod-natur-oper-bonif in frame {&frame-name}.
                  return 'ADM-ERROR':U.
              end.
              if available b-natur-oper then do:
                 if b-natur-oper.log-natureza-bonif = no then do:
                    {include/i-vldprg.i} 
                    /* mensagem: Natureza de Opera‡Æo informado nÆo ‚ de Bonifica‡Æo */
                    run utp/ut-msgs.p (input "show":U, input 17740, input return-value).
                    apply "entry" to c-cod-natur-oper-bonif in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                 end.
              end.
           end.
           if natur-oper.log-natureza-bonif = yes and
              l-log-natureza-bonif:checked in frame {&frame-name} = no then do:
              find first b-natur-oper where
                   b-natur-oper.cod-natur-oper-bonif = c-nat-operacao
                                   no-lock no-error.
              if avail b-natur-oper then do:
                 {include/i-vldprg.i} 
                 /* mensagem: Natureza de Operacao referenciada com natureza de bonificacao em outra natureza de operacao */
                 run utp/ut-msgs.p (input "show":U, input 17805, input return-value).
                 apply "entry" to l-log-natureza-bonif in frame {&frame-name}.
                 assign l-log-natureza-bonif:checked in frame {&frame-name} = yes.
                 return 'ADM-ERROR':U.
              end.
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
  {src/adm/template/snd-list.i "natur-oper"}

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
  
/************************************************************ 
 *  Pr‚-Processador para o m¢dulo de Descontos e Bonifica‡Æo
 ************************************************************/
   
&if defined (bf_dis_desc_bonif) &then
 
&else 
  if p-state = "update-begin" then 
     run pi-esconde-campo-tela.
&endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


