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
{include/i-prgvrs.i V04IN414 2.00.00.018}  /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN414 MUT}
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
def new global shared var v-row-parent  as rowid no-undo.                                
def new global shared var gr-manut      as rowid no-undo.
def new global shared var gr-mi-parada  as rowid no-undo.
def new global shared var gr-equipe     as rowid no-undo.
&if defined (bf_mnt_ems203) &then
   def new global shared var gr-mnt-planejador   as rowid no-undo.   
&else
   def new global shared var gr-planejad   as rowid no-undo.
&endif   
def new global shared var gr-ord-manut  as rowid no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var gc-cd-equipto like equipto.cd-equipto     no-undo.
def new global shared var gc-fm-equipto like fam-equipto.fm-equipto no-undo.
def new global shared var gc-cd-tag     like tag.cd-tag             no-undo.

def var de-vl-orcado-mat like solic-serv.vl-orcado-mat no-undo.
def var de-vl-orcado-mob like solic-serv.vl-orcado-mob no-undo.
def var c-table-label    as char format "x(40)".

/* Vari vel definida para utliza‡Æo de thinZooms */
def var hProgramZoom    as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES solic-serv
&Scoped-define FIRST-EXTERNAL-TABLE solic-serv


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR solic-serv.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS solic-serv.dt-inicio solic-serv.dt-termino ~
solic-serv.cd-manut solic-serv.prioridade solic-serv.parada ~
solic-serv.cd-parada solic-serv.cd-equip-res solic-serv.cd-planejado ~
solic-serv.vl-orcado-mat solic-serv.vl-orcado-mob 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dt-inicio ~{&FP2}dt-inicio ~{&FP3}~
 ~{&FP1}dt-termino ~{&FP2}dt-termino ~{&FP3}~
 ~{&FP1}cd-manut ~{&FP2}cd-manut ~{&FP3}~
 ~{&FP1}prioridade ~{&FP2}prioridade ~{&FP3}~
 ~{&FP1}cd-parada ~{&FP2}cd-parada ~{&FP3}~
 ~{&FP1}cd-equip-res ~{&FP2}cd-equip-res ~{&FP3}~
 ~{&FP1}cd-planejado ~{&FP2}cd-planejado ~{&FP3}~
 ~{&FP1}vl-orcado-mat ~{&FP2}vl-orcado-mat ~{&FP3}~
 ~{&FP1}vl-orcado-mob ~{&FP2}vl-orcado-mob ~{&FP3}
&Scoped-define ENABLED-TABLES solic-serv
&Scoped-define FIRST-ENABLED-TABLE solic-serv
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS solic-serv.dt-inicio solic-serv.dt-termino ~
solic-serv.cd-manut solic-serv.prioridade solic-serv.parada ~
solic-serv.cd-parada solic-serv.cd-equip-res solic-serv.cd-planejado ~
solic-serv.vl-orcado-mat solic-serv.vl-orcado-mob 
&Scoped-Define DISPLAYED-OBJECTS c-descricao-manut fi-ordem-solic ~
c-descricao-parada c-descricao-equipe c-descricao-planejado 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS solic-serv.parada 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
nr-soli-serv|y|y|mgind.solic-serv.nr-soli-serv
cd-causa-padr||y|mgind.solic-serv.cd-causa-padr
cc-codigo||y|mgind.solic-serv.cc-codigo
cd-equipto||y|mgind.solic-serv.cd-equipto
fm-equipto||y|mgind.solic-serv.fm-equipto
cd-manut||y|mgind.solic-serv.cd-manut
cd-parada||y|mgind.solic-serv.cd-parada
cd-tag||y|mgind.solic-serv.cd-tag
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "nr-soli-serv",
     Keys-Supplied = "nr-soli-serv,cd-causa-padr,cc-codigo,cd-equipto,fm-equipto,cd-manut,cd-parada,cd-tag"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-descricao-equipe AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-manut AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-parada AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-planejado AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ordem-solic AS INTEGER FORMAT "->>>,>>>,>>9":U INITIAL 0 
     LABEL "Ordem Manuten‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 8.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     solic-serv.dt-inicio AT ROW 1.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     solic-serv.dt-termino AT ROW 1.17 COL 56 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     solic-serv.cd-manut AT ROW 2.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descricao-manut AT ROW 2.17 COL 36 COLON-ALIGNED NO-LABEL
     fi-ordem-solic AT ROW 3.17 COL 5.86
     solic-serv.prioridade AT ROW 4.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     solic-serv.parada AT ROW 4.17 COL 38.14
          VIEW-AS TOGGLE-BOX
          SIZE 24.43 BY .75
     solic-serv.cd-parada AT ROW 5.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descricao-parada AT ROW 5.17 COL 36 COLON-ALIGNED NO-LABEL
     solic-serv.cd-equip-res AT ROW 6.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descricao-equipe AT ROW 6.17 COL 36 COLON-ALIGNED NO-LABEL
     solic-serv.cd-planejado AT ROW 7.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-descricao-planejado AT ROW 7.17 COL 40 COLON-ALIGNED NO-LABEL
     solic-serv.vl-orcado-mat AT ROW 8.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     solic-serv.vl-orcado-mob AT ROW 8.17 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.solic-serv
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
         HEIGHT             = 8.29
         WIDTH              = 82.14.
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

/* SETTINGS FOR FILL-IN c-descricao-equipe IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-planejado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ordem-solic IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR TOGGLE-BOX solic-serv.parada IN FRAME f-main
   3                                                                    */
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

&Scoped-define SELF-NAME solic-serv.cd-equip-res
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-equip-res V-table-Win
ON F5 OF solic-serv.cd-equip-res IN FRAME f-main /* Equipe Respons vel */
DO:
  
  {include/zoomvar.i &prog-zoom=inzoom/z01in094.w
                     &campo=solic-serv.cd-equip-res
                     &campozoom=cd-equipe}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-equip-res V-table-Win
ON LEAVE OF solic-serv.cd-equip-res IN FRAME f-main /* Equipe Respons vel */
DO:
    {include/leave.i &tabela=equipe
                     &atributo-ref=desc-equipe
                     &variavel-ref=c-descricao-equipe
                     &where="equipe.cd-equipe = input frame {&frame-name} solic-serv.cd-equip-res"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-equip-res V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.cd-equip-res IN FRAME f-main /* Equipe Respons vel */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solic-serv.cd-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-manut V-table-Win
ON F5 OF solic-serv.cd-manut IN FRAME f-main /* Manuten‡Æo */
DO:
  {include/zoom.i &prog-zoom="inzoom/z02in205.w"
                  &tabela=solic-serv
                  &atributo=cd-manut} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-manut V-table-Win
ON LEAVE OF solic-serv.cd-manut IN FRAME f-main /* Manuten‡Æo */
DO:
   {include/leave.i &tabela=manut
                    &atributo-ref=descricao
                    &variavel-ref=c-descricao-manut
                    &where="manut.cd-manut = input frame {&frame-name} solic-serv.cd-manut"}

   assign de-vl-orcado-mat = 0
          de-vl-orcado-mob = 0.
   if  input frame {&frame-name} solic-serv.cd-manut <> "" then do:
       run mip/mi9991.p (input solic-serv.cd-manut:screen-value in frame {&frame-name},
                         input "1",
                         input 1,
                         output de-vl-orcado-mat,
                         output de-vl-orcado-mob).
       find manut
           where manut.cd-manut = solic-serv.cd-manut:screen-value in frame {&frame-name}
           no-lock no-error.
       if  avail manut then do:
           if  manut.parada = yes then do:
               enable solic-serv.parada with frame {&frame-name}.
               enable solic-serv.cd-parada with frame {&frame-name}.
               assign solic-serv.parada:checked in frame {&frame-name} = yes
                      solic-serv.cd-parada:screen-value in frame {&frame-name} = manut.cd-parada.
           end.
           else do:
               disable solic-serv.parada with frame {&frame-name}.
               disable solic-serv.cd-parada with frame {&frame-name}.
           end.
       end.
   end.
   assign solic-serv.vl-orcado-mat:screen-value in frame {&frame-name} = string(de-vl-orcado-mat).
          solic-serv.vl-orcado-mob:screen-value in frame {&frame-name} = string(de-vl-orcado-mob).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-manut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.cd-manut IN FRAME f-main /* Manuten‡Æo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solic-serv.cd-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-parada V-table-Win
ON F5 OF solic-serv.cd-parada IN FRAME f-main /* Parada */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in211.w"
                  &tabela=solic-serv
                  &atributo=cd-parada} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-parada V-table-Win
ON LEAVE OF solic-serv.cd-parada IN FRAME f-main /* Parada */
DO:
  {include/leave.i &tabela=mi-parada
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao-parada
                   &where="mi-parada.cd-parada = input frame {&frame-name} solic-serv.cd-parada"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-parada V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.cd-parada IN FRAME f-main /* Parada */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solic-serv.cd-planejado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-planejado V-table-Win
ON F5 OF solic-serv.cd-planejado IN FRAME f-main /* Planejador */
DO:
  &if defined (bf_mnt_ems203) &then
     {method/zoomfields.i 
           &ProgramZoom="mnzoom~\z01mn060.w"
           &FieldZoom1="cd-planejado"
           &FieldScreen1="solic-serv.cd-planejado"
           &Frame1="f-main"
           &FieldZoom2="nome"
           &FieldScreen2="c-descricao-planejado"
           &Frame2="f-main"} 
  &else
     {include/zoom.i &prog-zoom="inzoom/z01in321.w"
                     &tabela=solic-serv
                     &atributo=cd-planejado}
  &endif                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-planejado V-table-Win
ON LEAVE OF solic-serv.cd-planejado IN FRAME f-main /* Planejador */
DO:
  &if defined (bf_mnt_ems203) &then
     {include/leave.i &tabela=mnt-planejador
                     &atributo-ref=nome
                     &variavel-ref=c-descricao-planejado
                     &where="mnt-planejador.cd-planejado = input frame {&frame-name} solic-serv.cd-planejado"}
  &else
     {include/leave.i &tabela=planejad
                     &atributo-ref=nome
                     &variavel-ref=c-descricao-planejado
                     &where="planejad.cd-planejado = input frame {&frame-name} solic-serv.cd-planejado"}  
  &endif                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-planejado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.cd-planejado IN FRAME f-main /* Planejador */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solic-serv.parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.parada V-table-Win
ON VALUE-CHANGED OF solic-serv.parada IN FRAME f-main /* Manuten‡Æo Parada */
DO:
    if  input frame {&frame-name} solic-serv.parada = no then do:
        enable solic-serv.cd-parada   with frame {&frame-name}.
        assign solic-serv.cd-parada:screen-value = ""
               c-descricao-parada                = "".
        disable solic-serv.cd-parada with frame {&frame-name}.
        display c-descricao-parada   with frame {&frame-name}.        
    end.
    else do:
          enable  solic-serv.cd-parada with frame {&frame-name}.
          display c-descricao-parada   with frame {&frame-name}.         
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
  
  /************************ INTERNAL PROCEDURES ********************/

   if solic-serv.cd-manut:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
   if solic-serv.cd-parada:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
   if solic-serv.cd-equip-res:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
   if solic-serv.cd-planejado:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

   {utp/ut-liter.i Ordem_Manuten‡Æo *}
   assign fi-ordem-solic:label in frame {&frame-name} = return-value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'nr-soli-serv':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = solic-serv
           &WHERE = "WHERE solic-serv.nr-soli-serv eq INTEGER(key-value)"
       }
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "solic-serv"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "solic-serv"}

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

  assign solic-serv.dt-inicio:screen-value in frame {&frame-name}  = string(today)
         solic-serv.dt-termino:screen-value in frame {&frame-name} = string(today).
  
  if  avail solic-serv then do with frame {&frame-name}:
      if  solic-serv.parada = yes then
          enable solic-serv.cd-parada.
  end.


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
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */
                 
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

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
    if  available solic-serv then do:
        find manut
            where manut.cd-manut = solic-serv.cd-manut
            no-lock no-error.
        assign c-descricao-manut = if avail manut then manut.descricao else "":U
               gr-manut          = if avail manut then rowid(manut) else ?.
        find mi-parada
            where mi-parada.cd-parada = solic-serv.cd-parada
            no-lock no-error.
        assign c-descricao-parada = if avail mi-parada then mi-parada.descricao else "":U
               gr-mi-parada       = if avail mi-parada then rowid(mi-parada) else ?.
        find equipe
            where equipe.cd-equipe = solic-serv.cd-equip-res
            no-lock no-error.
        assign c-descricao-equipe = if avail equipe then equipe.desc-equipe else "":U
               gr-equipe          = if avail equipe then rowid(equipe) else ?.      
        &if defined (bf_mnt_ems203) &then        
           find mnt-planejador
               where mnt-planejador.cd-planejado = solic-serv.cd-planejado
               no-lock no-error.
           assign c-descricao-planejado = if avail mnt-planejador then mnt-planejador.nome else "":U
                  gr-mnt-planejador     = if avail mnt-planejador then rowid(mnt-planejador) else ?.
        &else
           find planejad
               where planejad.cd-planejado = solic-serv.cd-planejado
               no-lock no-error.
           assign c-descricao-planejado = if avail planejad then planejad.nome else "":U
                  gr-planejad           = if avail planejad then rowid(planejad) else ?.         
        &endif          
    end.
                                
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
        if  avail solic-serv then do: 
            find first ordem-solic 
                 where ordem-solic.nr-soli-serv = solic-serv.nr-soli-serv 
                 no-lock no-error.
            if avail ordem-solic then do:
               assign fi-ordem-solic:screen-value in frame {&frame-name} = string(ordem-solic.nr-ord-produ)
                      gr-ord-manut = ?.
               for first ord-manut fields (nr-ord-produ) 
                   where ord-manut.nr-ord-produ = ordem-solic.nr-ord-produ no-lock:
                   assign gr-ord-manut = rowid(ord-manut).
               end.    
            end.       
        if  solic-serv.parada = no then do:
            assign solic-serv.cd-parada:screen-value in frame {&frame-name} = ""
                   c-descricao-parada                = "".
            disable solic-serv.cd-parada with frame {&frame-name}.
            display c-descricao-parada   with frame {&frame-name}.        
        end.
        else do:
            disp solic-serv.cd-parada
                 c-descricao-parada   with frame {&frame-name}.         
        end.  
        disable solic-serv.cd-parada with frame {&frame-name}.
        
    /* Code placed here will execute AFTER standard behavior.    */
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
  
  if avail solic-serv then do:
     if  solic-serv.parada = no then
         disable solic-serv.cd-parada with frame {&frame-name}.
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-planeja2 V-table-Win 
PROCEDURE pi-planeja2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var c-tag      like solic-serv.cd-tag     no-undo.
def var c-equipto  like solic-serv.cd-equipto no-undo.
def var c-familia  like solic-serv.fm-equipto no-undo.    

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "cd-tag").

assign c-tag = return-value.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "cd-equipto").

assign c-equipto = return-value.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "fm-equipto").
     
assign c-familia = return-value.

if  c-equipto <> "" then do:
    find equipto 
        where equipto.cd-equipto = gc-cd-equipto no-lock no-error.
    if  avail equipto then
        assign solic-serv.cd-planejado:screen-value in frame {&frame-name} = equipto.cd-planejado.
end.
else do:
   if  c-tag <> "" then do:
       find tag
           where tag.cd-tag = c-tag no-lock no-error.
        if  avail tag then
            assign solic-serv.cd-planejado:screen-value in frame {&frame-name} = tag.cd-planejado.
   end.
   else do:
     /*faz fam¡lia*/
       
      find fam-equipto
         where fam-equipto.fm-equipto = c-familia no-lock no-error.
      if  avail fam-equipto then
          assign solic-serv.cd-planejado:screen-value in frame {&frame-name} = fam-equipto.cd-planejado.
   end.
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    {include/i-vldfrm.i} /* antigo frame:validate() */

    if  date(solic-serv.dt-inicio:screen-value in frame {&frame-name}) >
        date(solic-serv.dt-termino:screen-value in frame {&frame-name}) then do:
        {include/i-vldprg.i} /*posiciona p gina*/
        run utp/ut-msgs.p (input "show",
                           input 137,
                           input "").
        apply 'entry' to solic-serv.dt-inicio in frame {&frame-name}.
        return 'adm-error':U.
    end.

    if  solic-serv.cd-manut:screen-value in frame {&frame-name} <> "" then do:
        find manut
            where manut.cd-manut = solic-serv.cd-manut:screen-value in frame {&frame-name}
            no-lock no-error.
        if  not avail manut then do:
            {include/i-vldprg.i} /*posiciona p gina*/
            {utp/ut-table.i mgind manut 1}
            run utp/ut-msgs.p( input "show",
                               input 3549,
                               input return-value).
            apply 'entry' to solic-serv.cd-equip-res in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.

        find man-equip
            where man-equip.cd-equipto = gc-cd-equipto
            and   man-equip.cd-manut   = solic-serv.cd-manut:screen-value in frame {&frame-name}
            no-lock no-error.
        find man-fam
            where man-fam.fm-equipto = gc-fm-equipto
            and   man-fam.cd-manut   = solic-serv.cd-manut:screen-value in frame {&frame-name}
            no-lock no-error.
        find man-eq-tag
            where man-eq-tag.cd-equipto = gc-cd-equipto
            and   man-eq-tag.cd-tag     = gc-cd-tag
            and   man-eq-tag.cd-manut   = solic-serv.cd-manut:screen-value in frame {&frame-name}
            no-lock no-error.
        find man-tag-fam
            where man-tag-fam.fm-equipto = gc-fm-equipto
            and   man-tag-fam.cd-tag     = gc-cd-tag
            and   man-tag-fam.cd-manut   = solic-serv.cd-manut:screen-value in frame {&frame-name}
            no-lock no-error.
        if  not avail man-equip
        and not avail man-fam
        and not avail man-eq-tag
        and not avail man-tag-fam then do:
            {include/i-vldprg.i} /*posiciona p gina*/
            {utp/ut-table.i mgind equipto 1}
            assign c-table-label = return-value.
            {utp/ut-table.i mgind manut 1}
            run utp/ut-msgs.p( input "show",
                               input 2864,
                               input return-value + "~~" + c-table-label).
            apply 'entry' to solic-serv.cd-manut in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.

    if  input frame {&frame-name} solic-serv.parada = yes then do:
        find mi-parada
            where mi-parada.cd-parada = solic-serv.cd-parada:screen-value in frame {&frame-name}
            no-lock no-error.
        if  not avail mi-parada then do:
            {include/i-vldprg.i} /*posiciona p gina*/
            {utp/ut-table.i mgind mi-parada 1}
            run utp/ut-msgs.p( input "show",
                               input 3549,
                               input return-value).
            apply 'entry' to solic-serv.cd-parada in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.

    find equipe
        where equipe.cd-equipe = input frame {&frame-name} solic-serv.cd-equip-res
        no-lock no-error.
    if  not avail equipe then do:
        {include/i-vldprg.i} /*posiciona p gina*/
        {utp/ut-table.i mgind equipe 1}
        run utp/ut-msgs.p( input "show",
                           input 3549,
                           input return-value).
        apply 'entry' to solic-serv.cd-equip-res in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    &if defined (bf_mnt_ems203) &then
       find first mnt-planejador
           where mnt-planejador.cd-planejado = input frame {&frame-name} solic-serv.cd-planejado
           no-lock no-error.
       if  not avail mnt-planejador then do:
           {include/i-vldprg.i} /*posiciona p gina*/
           {utp/ut-table.i mgmnt mnt-planejador 1}
    &else
       find planejad
           where planejad.cd-planejado = input frame {&frame-name} solic-serv.cd-planejado
           no-lock no-error.
       if  not avail planejad then do:
           {include/i-vldprg.i} /*posiciona p gina*/
           {utp/ut-table.i mgind planejad 1}
    &endif       
        
        run utp/ut-msgs.p( input "show",
                           input 3549,
                           input return-value).
        apply 'entry' to solic-serv.cd-planejado in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "nr-soli-serv" "solic-serv" "nr-soli-serv"}
  {src/adm/template/sndkycas.i "cd-causa-padr" "solic-serv" "cd-causa-padr"}
  {src/adm/template/sndkycas.i "cc-codigo" "solic-serv" "cc-codigo"}
  {src/adm/template/sndkycas.i "cd-equipto" "solic-serv" "cd-equipto"}
  {src/adm/template/sndkycas.i "fm-equipto" "solic-serv" "fm-equipto"}
  {src/adm/template/sndkycas.i "cd-manut" "solic-serv" "cd-manut"}
  {src/adm/template/sndkycas.i "cd-parada" "solic-serv" "cd-parada"}
  {src/adm/template/sndkycas.i "cd-tag" "solic-serv" "cd-tag"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "solic-serv"}

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


