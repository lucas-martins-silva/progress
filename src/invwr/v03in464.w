&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmfg            PROGRESS
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
{include/i-prgvrs.i V03IN464 2.00.01.012}  /*** "010112" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN464 MUT}
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
def new global shared var r-parent as rowid no-undo.

def new shared var l-erro   as logical.         

/* Parameters Definitions ---                                           */

def var i-incremento       as integer no-undo.
def buffer b-modelo-cf     for modelo-cf.
def buffer b1-modelo-cf    for modelo-cf.
def buffer b1-estr-mod-cf  for estr-mod-cf.
def buffer b2-estr-mod-cf  for estr-mod-cf.
def var c-mensagem          as char.
def var c-modelo            like modelo.mo-codigo.
def var c-valor             as char   no-undo.
def var c-handle            as char   no-undo.
def var h-handle            as handle no-undo.
def var v-row-parent        as rowid no-undo.
def var c-msg-erro          as char format "x(2000)"  no-undo.
DEF VAR c-referencia       LIKE estr-mod-cf.cod-refer.
/* Local Variable Definitions ---                                       */

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
&Scoped-define EXTERNAL-TABLES estr-mod-cf
&Scoped-define FIRST-EXTERNAL-TABLE estr-mod-cf


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estr-mod-cf.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estr-mod-cf.cod-refer estr-mod-cf.seq-mandat ~
estr-mod-cf.fantasma 
&Scoped-define ENABLED-TABLES estr-mod-cf
&Scoped-define FIRST-ENABLED-TABLE estr-mod-cf
&Scoped-define DISPLAYED-TABLES estr-mod-cf
&Scoped-define FIRST-DISPLAYED-TABLE estr-mod-cf
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-7 
&Scoped-Define DISPLAYED-FIELDS estr-mod-cf.sequencia estr-mod-cf.it-codigo ~
estr-mod-cf.fm-codigo estr-mod-cf.cod-refer estr-mod-cf.sub-modelo ~
estr-mod-cf.seq-mandat estr-mod-cf.fantasma 
&Scoped-Define DISPLAYED-OBJECTS fi-descricao-1 c-un-it fi-descricao ~
c-un-fm fi-descricao-sm 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS estr-mod-cf.sequencia ~
estr-mod-cf.it-codigo estr-mod-cf.fm-codigo estr-mod-cf.sub-modelo 
&Scoped-define ADM-MODIFY-FIELDS estr-mod-cf.seq-mandat ~
estr-mod-cf.fantasma 

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
DEFINE VARIABLE c-un-fm AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-it AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 36.29 BY .88.

DEFINE VARIABLE fi-descricao-1 AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY .88.

DEFINE VARIABLE fi-descricao-sm AS CHARACTER FORMAT "x(36)" 
     VIEW-AS FILL-IN 
     SIZE 37.43 BY .88.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 4.54.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 2.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estr-mod-cf.sequencia AT ROW 1.5 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     estr-mod-cf.it-codigo AT ROW 2.5 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-descricao-1 AT ROW 2.5 COL 32 COLON-ALIGNED NO-LABEL
     c-un-it AT ROW 2.5 COL 77 COLON-ALIGNED NO-LABEL
     estr-mod-cf.fm-codigo AT ROW 3.5 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     estr-mod-cf.cod-refer AT ROW 3.5 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     fi-descricao AT ROW 3.5 COL 27.14 COLON-ALIGNED NO-LABEL
     c-un-fm AT ROW 3.5 COL 64 COLON-ALIGNED NO-LABEL
     estr-mod-cf.sub-modelo AT ROW 4.5 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-descricao-sm AT ROW 4.5 COL 32 COLON-ALIGNED NO-LABEL
     estr-mod-cf.seq-mandat AT ROW 6.25 COL 16
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .75
     estr-mod-cf.fantasma AT ROW 7.25 COL 16
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .67
     RECT-5 AT ROW 1.25 COL 1
     RECT-7 AT ROW 6.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estr-mod-cf
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
         HEIGHT             = 7.29
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-un-fm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX estr-mod-cf.fantasma IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao-sm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estr-mod-cf.fm-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN estr-mod-cf.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX estr-mod-cf.seq-mandat IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN estr-mod-cf.sequencia IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN estr-mod-cf.sub-modelo IN FRAME f-main
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





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME estr-mod-cf.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.cod-refer V-table-Win
ON F5 OF estr-mod-cf.cod-refer IN FRAME f-main /* Referància */
DO:

    assign c-valor = estr-mod-cf.it-codigo:screen-value in frame {&frame-name}.
    {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                       &campo=estr-mod-cf.cod-refer
                       &campozoom=cod-refer
                       &parametros="run pi-seta-inicial in wh-pesquisa (input c-valor)."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estr-mod-cf.cod-refer IN FRAME f-main /* Referància */
DO:

  apply 'f5' to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estr-mod-cf.fm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.fm-codigo V-table-Win
ON F5 OF estr-mod-cf.fm-codigo IN FRAME f-main /* Fam°lia */
DO:
  l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z02in122.w"
                     &campo=estr-mod-cf.fm-codigo
                     &campozoom=fm-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.fm-codigo V-table-Win
ON LEAVE OF estr-mod-cf.fm-codigo IN FRAME f-main /* Fam°lia */
DO:

  if estr-mod-cf.fm-codigo:screen-value in frame {&frame-name} <> "" then do:  
     assign estr-mod-cf.it-codigo:sensitive in frame {&frame-name} = no
            estr-mod-cf.sub-modelo:sensitive in frame {&frame-name} = no.

     find familia where 
          familia.fm-codigo = estr-mod-cf.fm-codigo:screen-value in frame {&frame-name} no-lock no-error.
     if avail familia then 
        assign fi-descricao = familia.descricao
               c-un-fm      = familia.un.
     else   
         assign fi-descricao = ""
                c-un-fm      = "".
     disp fi-descricao c-un-fm with frame {&frame-name}.

     if estr-mod-cf.fm-codigo:screen-value in frame {&frame-name} <> "" then do:
         run get-link-handle in adm-broker-hdl (input this-procedure,
                                                input "group-assign-target",
                                                output c-handle).                                         
         assign h-handle = widget-handle(entry(2,c-handle)).  
         run pi-atu-numeros in h-handle (input yes).
         run new-state in this-procedure ('nenhum':U).
     end.
  end.
  else
     assign estr-mod-cf.it-codigo:sensitive in frame {&frame-name} = yes
            estr-mod-cf.sub-modelo:sensitive in frame {&frame-name} = yes
            fi-descricao:screen-value in frame {&frame-name} = ""
            c-un-fm:screen-value in frame {&frame-name} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.fm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estr-mod-cf.fm-codigo IN FRAME f-main /* Fam°lia */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estr-mod-cf.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.it-codigo V-table-Win
ON F5 OF estr-mod-cf.it-codigo IN FRAME f-main /* Item */
DO:
  l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=estr-mod-cf.it-codigo
                     &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.it-codigo V-table-Win
ON LEAVE OF estr-mod-cf.it-codigo IN FRAME f-main /* Item */
DO:    
  if estr-mod-cf.it-codigo:screen-value in frame {&frame-name} <> "" then do:  
      assign estr-mod-cf.fm-codigo:sensitive in frame {&frame-name} = no.

      run get-link-handle in adm-broker-hdl (input this-procedure,
                                             input "group-assign-target",
                                             output c-handle).                                         
      assign h-handle = widget-handle(entry(2,c-handle)).  
      run pi-atu-numeros in h-handle (input no).

      find item where 
           item.it-codigo = estr-mod-cf.it-codigo:screen-value in frame {&frame-name} no-lock no-error.
      if avail item then do:
         assign h-handle = widget-handle(entry(3,c-handle)).
         run pi-narrativa in h-handle (item.it-codigo).
         find modelo-cf where
              modelo-cf.item-criado = item.it-codigo NO-LOCK no-error.
         if avail modelo-cf then do:
            assign estr-mod-cf.sub-modelo:screen-value = modelo-cf.mo-codigo
                   fi-descricao-sm:screen-value        = modelo-cf.descricao.
         end.
         else do:
            assign estr-mod-cf.sub-modelo:screen-value = ""
                   fi-descricao-sm:screen-value        = "".
         end.
         assign fi-descricao-1 = item.desc-item
                c-un-it        = item.un.
         disp fi-descricao-1 c-un-it with frame {&frame-name}.

         if can-find (first ref-item where
                            ref-item.it-codigo = item.it-codigo NO-LOCK) and
                            item.politica <> 5 then do:
            assign estr-mod-cf.fm-codigo:hidden    in frame {&frame-name} = yes
                   fi-descricao:hidden             in frame {&frame-name} = yes
                   c-un-fm:hidden                  in frame {&frame-name} = yes
                   estr-mod-cf.cod-refer:hidden    in frame {&frame-name} = no
                   estr-mod-cf.cod-refer:sensitive in frame {&frame-name} = yes.
            apply 'entry' to estr-mod-cf.cod-refer.
            return no-apply.
         end.
         else
            assign estr-mod-cf.fm-codigo:hidden       in frame {&frame-name} = no
                   fi-descricao:hidden                in frame {&frame-name} = no
                   c-un-fm:hidden                     in frame {&frame-name} = no
                   estr-mod-cf.cod-refer:screen-value in frame {&frame-name} = ""
                   estr-mod-cf.cod-refer:hidden       in frame {&frame-name} = yes
                   estr-mod-cf.fm-codigo:sensitive    in frame {&frame-name} = no
                   estr-mod-cf.sub-modelo:sensitive   in frame {&frame-name} = yes.         

      end.
      else do:
         assign fi-descricao-1:screen-value in frame {&frame-name} = ""
                c-un-it = "".
         disp fi-descricao-1 c-un-it with frame {&frame-name}.
      end.
  end.
  else do:
      assign estr-mod-cf.fm-codigo:hidden     in frame {&frame-name} = no
             fi-descricao:hidden              in frame {&frame-name} = no
             c-un-fm:hidden                   in frame {&frame-name} = no
             estr-mod-cf.cod-refer:hidden     in frame {&frame-name} = yes
             estr-mod-cf.fm-codigo:sensitive  in frame {&frame-name} = yes
             estr-mod-cf.sub-modelo:sensitive in frame {&frame-name} = yes
             fi-descricao-1:screen-value      in frame {&frame-name} = ""
             c-un-it:screen-value             in frame {&frame-name} = "".
      apply 'entry' to estr-mod-cf.fm-codigo.
      return no-apply.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estr-mod-cf.it-codigo IN FRAME f-main /* Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estr-mod-cf.sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.sequencia V-table-Win
ON F5 OF estr-mod-cf.sequencia IN FRAME f-main /* Seq */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in464.w"
                  &tabela=estr-mod-cf
                  &atributo=sequencia}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.sequencia V-table-Win
ON LEAVE OF estr-mod-cf.sequencia IN FRAME f-main /* Seq */
DO:
  run get-link-handle in adm-broker-hdl (input this-procedure,
                                         input "group-assign-target",
                                         output c-handle).

  assign h-handle = widget-handle(entry(1,c-handle)).

  if estr-mod-cf.sequencia:sensitive in frame {&frame-name} then do:  
     run pi-atualiza-estado in h-handle (input "Incluir").
  end.
  else do:
     run pi-atualiza-estado in h-handle (input "Modificar").
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.sequencia V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estr-mod-cf.sequencia IN FRAME f-main /* Seq */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estr-mod-cf.sub-modelo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.sub-modelo V-table-Win
ON F5 OF estr-mod-cf.sub-modelo IN FRAME f-main /* Sub-modelo */
DO:
  l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in459.w"
                     &campo=estr-mod-cf.sub-modelo
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.sub-modelo V-table-Win
ON LEAVE OF estr-mod-cf.sub-modelo IN FRAME f-main /* Sub-modelo */
DO:
  if estr-mod-cf.sub-modelo:screen-value in frame {&frame-name} <> "" then do:  
      assign estr-mod-cf.fm-codigo:sensitive in frame {&frame-name} = no.

     find b1-modelo-cf where 
          b1-modelo-cf.mo-codigo = estr-mod-cf.sub-modelo:screen-value in frame {&frame-name} no-lock no-error. 
     if avail b1-modelo-cf then do:
        find item where
             item.it-codigo = b1-modelo-cf.item-criado NO-LOCK no-error.
        if avail item then do:
            assign estr-mod-cf.it-codigo:screen-value = item.it-codigo
                   fi-descricao-1:screen-value        = item.desc-item
                   c-un-it:screen-value              = item.un.
            if can-find (first ref-item where
                               ref-item.it-codigo = item.it-codigo NO-LOCK) and
                               item.politica <> 5 then do:
               assign estr-mod-cf.fm-codigo:hidden    in frame {&frame-name} = yes
                      fi-descricao:hidden             in frame {&frame-name} = yes
                      c-un-fm:hidden                  in frame {&frame-name} = yes
                      estr-mod-cf.cod-refer:hidden    in frame {&frame-name} = no
                      estr-mod-cf.cod-refer:sensitive in frame {&frame-name} = yes.
               apply 'entry' to estr-mod-cf.cod-refer.
               return no-apply.
            end.
            else
               assign estr-mod-cf.fm-codigo:hidden       in frame {&frame-name} = no
                      fi-descricao:hidden                in frame {&frame-name} = no
                      c-un-fm:hidden                     in frame {&frame-name} = no
                      estr-mod-cf.cod-refer:screen-value in frame {&frame-name} = ""
                      estr-mod-cf.cod-refer:hidden       in frame {&frame-name} = yes
                      estr-mod-cf.sub-modelo:sensitive   in frame {&frame-name} = yes.                    
        end.
        else do:
            assign estr-mod-cf.it-codigo:screen-value = ""
                   fi-descricao-1:screen-value        = ""
                   c-un-it:screen-value             = "".
        end.        
        assign fi-descricao-sm = b1-modelo-cf.descricao.
     end.
     else do:
        assign fi-descricao-sm:screen-value in frame {&frame-name} = "".
     end.
     disp fi-descricao-sm with frame {&frame-name}.


     if estr-mod-cf.sub-modelo:screen-value in frame {&frame-name} <> "" then do:
         run get-link-handle in adm-broker-hdl (input this-procedure,
                                                input "group-assign-target",
                                                output c-handle).                                         
         assign h-handle = widget-handle(entry(2,c-handle)).  
         run pi-atu-numeros in h-handle (input yes).
         run new-state in this-procedure ('nenhum':U).

/*         find modelo-cf where modelo-cf.mo-codigo = estr-mod-cf.sub-modelo:screen-value 
 *           in frame {&frame-name} no-lock no-error.
 *           if avail modelo-cf then do:
 *              assign h-handle = widget-handle(entry(3,c-handle)).
 *              run pi-modelo in h-handle (modelo-cf.mo-codigo).
 *          end.   */

     end.
  end.
  else do:
    assign fi-descricao-sm:screen-value in frame {&frame-name} = "".
    if estr-mod-cf.it-codigo:screen-value in frame {&frame-name} = "" then do:
        assign estr-mod-cf.fm-codigo:sensitive in frame {&frame-name} = yes
               estr-mod-cf.it-codigo:sensitive in frame {&frame-name} = yes.
    end.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estr-mod-cf.sub-modelo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estr-mod-cf.sub-modelo IN FRAME f-main /* Sub-modelo */
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
  do with frame {&frame-name}:  
     estr-mod-cf.sequencia:load-mouse-pointer ("image/lupa.cur"). 
     estr-mod-cf.it-codigo:load-mouse-pointer ("image/lupa.cur"). 
     estr-mod-cf.fm-codigo:load-mouse-pointer ("image/lupa.cur"). 
     estr-mod-cf.sub-modelo:load-mouse-pointer ("image/lupa.cur").
     estr-mod-cf.cod-refer:load-mouse-pointer ("image/lupa.cur").
  end.
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
  {src/adm/template/row-list.i "estr-mod-cf"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estr-mod-cf"}

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
  if i-incremento = 0 then 
     assign i-incremento = 10. 
  find b-modelo-cf where 
       rowid(b-modelo-cf) = v-row-parent no-lock no-error.
  find last b1-estr-mod-cf where 
            b1-estr-mod-cf.mo-codigo = b-modelo-cf.mo-codigo no-lock no-error.
  assign estr-mod-cf.sequencia:screen-value in frame {&frame-name} = 
                           if not avail b1-estr-mod-cf 
                           then string(i-incremento)
                           else string(b1-estr-mod-cf.sequencia + i-incremento).

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  find b1-modelo-cf where rowid(b1-modelo-cf) = v-row-parent no-lock no-error.
  if avail b1-modelo-cf then assign estr-mod-cf.mo-codigo = b1-modelo-cf.mo-codigo
                                    c-modelo              = b1-modelo-cf.mo-codigo.

  find b2-estr-mod-cf where b2-estr-mod-cf.sequencia  = input frame {&frame-name}
                                                        estr-mod-cf.sequencia 
                        and b2-estr-mod-cf.it-codigo  = input frame {&frame-name}
                                                        estr-mod-cf.it-codigo                           
                        and b2-estr-mod-cf.sub-modelo = input frame {&frame-name}
                                                        estr-mod-cf.sub-modelo 
                        and b2-estr-mod-cf.fm-codigo  = input frame {&frame-name}
                                                        estr-mod-cf.fm-codigo 
                        and b2-estr-mod-cf.mo-codigo  = c-modelo                                                       
                        and b2-estr-mod-cf.seq-mandat = yes no-lock no-error.

  if avail b2-estr-mod-cf then 
     assign estr-mod-cf.seq-mandat = yes.

   do on error undo, leave:
      validate estr-mod-cf.
   end.
   if return-value <> 'ok' then run pi-identifica-erro.

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

if avail estr-mod-cf then do:

    /** Colocada validaá∆o para depois do dispatch, para corrigir erro do find no
        primeiro registro, causando problemas com o campo referància **/
/*    if estr-mod-cf.cod-refer <> "" then                                       */
/*        assign estr-mod-cf.fm-codigo:hidden     in frame {&frame-name} = yes  */
/*               fi-descricao:hidden              in frame {&frame-name} = yes  */
/*               c-un-fm:hidden                   in frame {&frame-name} = yes  */
/*               estr-mod-cf.cod-refer:hidden     in frame {&frame-name} = no.  */
/*   else                                                                       */
/*        assign estr-mod-cf.fm-codigo:hidden     in frame {&frame-name} = no   */
/*               fi-descricao:hidden              in frame {&frame-name} = no   */
/*               c-un-fm:hidden                   in frame {&frame-name} = no   */
/*               estr-mod-cf.cod-refer:hidden     in frame {&frame-name} = yes. */


  for first item fields( it-codigo desc-item un) where 
       item.it-codigo = estr-mod-cf.it-codigo no-lock: end.
  if avail item and item.it-codigo <> "" then 
     assign fi-descricao-1 = item.desc-item
            c-un-it        = item.un.

  for first familia fields ( fm-codigo descricao un) where 
       familia.fm-codigo = estr-mod-cf.fm-codigo no-lock: end.
  if avail familia and familia.fm-codigo <> "" then 
     assign fi-descricao = familia.descricao
            c-un-fm      = familia.un.

  find b1-modelo-cf where 
       b1-modelo-cf.mo-codigo = estr-mod-cf.sub-modelo  no-lock no-error. 
  if avail b1-modelo-cf and b1-modelo-cf.mo-codigo <> "" then
     assign fi-descricao-sm = b1-modelo-cf.descricao.
  else 
     assign fi-descricao-sm = "".

  if estr-mod-cf.it-codigo <> "" then
     if can-find( first operacao where 
                        operacao.it-codigo = estr-mod-cf.it-codigo NO-LOCK) then
        run new-state in this-procedure ('operacao':U).
     else 
         if can-find(first rot-item   where 
                               rot-item.it-codigo = estr-mod-cf.it-codigo NO-LOCK) then
            run new-state in this-procedure ('roteiro':U).
         else 
            run new-state in this-procedure ('nenhum':U).
  else 
     run new-state in this-procedure ('nenhum':U).

  if estr-mod-cf.it-codigo:screen-value in frame {&frame-name} <> "" then do:  
      run get-link-handle in adm-broker-hdl (input this-procedure,
                                             input "group-assign-target",
                                             output c-handle).                                         
      assign h-handle = widget-handle(entry(2,c-handle)).  
      run pi-atu-numeros in h-handle (input no).
  end.

end.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .    
  /* Code placed here will execute AFTER standard behavior.    */


  /** Modificaá∆o para erro de find do primeiro registro **/
if avail estr-mod-cf then do:

   if estr-mod-cf.cod-refer <> "" THEN DO:
       assign estr-mod-cf.fm-codigo:hidden     in frame {&frame-name}   = yes
              fi-descricao:hidden              in frame {&frame-name}   = yes
              c-un-fm:hidden                   in frame {&frame-name}   = yes
              estr-mod-cf.cod-refer:hidden     in frame {&frame-name}   = NO
              c-referencia                                              = estr-mod-cf.cod-refer.
       ASSIGN estr-mod-cf.cod-refer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-referencia.
   END.
   else
       assign estr-mod-cf.fm-codigo:hidden     in frame {&frame-name} = no
              fi-descricao:hidden              in frame {&frame-name} = no
              c-un-fm:hidden                   in frame {&frame-name} = no
              estr-mod-cf.cod-refer:screen-value in frame {&frame-name} = ""
              estr-mod-cf.cod-refer:hidden     in frame {&frame-name} = yes.
END.


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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .   

  assign estr-mod-cf.cod-refer:hidden in frame {&frame-name} = yes.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-incremento V-table-Win 
PROCEDURE pi-atualiza-incremento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-incremento as integer no-undo.

assign i-incremento = p-incremento.

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
def input parameter v-row-parent-externo as rowid no-undo.
assign v-row-parent = v-row-parent-externo
       r-parent     = v-row-parent.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-identifica-erro V-table-Win 
PROCEDURE pi-identifica-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  assign c-msg-erro = ''. 

{enp/en0105.i "show" 
                 estr-mod-cf.mo-codigo
                 estr-mod-cf.sequencia
                 estr-mod-cf.it-codigo
                 0}  


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
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */


     /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/


 if estr-mod-cf.cod-refer:sensitive in frame {&frame-name} then do:
    if estr-mod-cf.cod-refer:screen-value in frame {&frame-name} = "" then do:
       run utp/ut-msgs.p (input "show",
                          input 1399,
                          input "").     
       apply "ENTRY" to estr-mod-cf.cod-refer  in frame {&frame-name}.
       return "ADM-ERROR":U.
    end.
    else 
       if not can-find (first ref-item where
              ref-item.it-codigo = estr-mod-cf.it-codigo:screen-value in frame {&frame-name} and
              ref-item.cod-refer = estr-mod-cf.cod-refer:screen-value in frame {&frame-name} NO-LOCK) then do:
          run utp/ut-msgs.p (input "show",
                             input 1235,
                             input "").     
          apply "ENTRY" to estr-mod-cf.cod-refer  in frame {&frame-name}.
          return "ADM-ERROR":U.
       end.
 end.




 if estr-mod-cf.sequencia:sensitive in frame {&frame-name} then do:    
    find b-modelo-cf where 
         rowid(b-modelo-cf) = v-row-parent no-lock no-error.
    if avail b-modelo-cf then 
       assign c-modelo = b-modelo-cf.mo-codigo. 

    find b2-estr-mod-cf where 
         b2-estr-mod-cf.sequencia = input frame {&frame-name} 
                                            estr-mod-cf.sequencia and 
         b2-estr-mod-cf.it-codigo  = input frame {&frame-name} 
                                            estr-mod-cf.it-codigo and 
         b2-estr-mod-cf.sub-modelo = input frame {&frame-name} 
                                            estr-mod-cf.sub-modelo and 
         b2-estr-mod-cf.fm-codigo  = input frame {&frame-name} 
                                           estr-mod-cf.fm-codigo  and 
         b2-estr-mod-cf.mo-codigo  = c-modelo no-lock no-error.
    if avail b2-estr-mod-cf then do:
       {include/i-vldprg.i}        
       run utp/ut-msgs.p (input "show",
                          input 6669,
                          input "").     
       apply "ENTRY" to estr-mod-cf.sequencia  in frame {&frame-name}.
       return "ADM-ERROR":U.       
    end.

    if input frame {&frame-name} estr-mod-cf.it-codigo  = "" and
       input frame {&frame-name} estr-mod-cf.fm-codigo  = "" and
       input frame {&frame-name} estr-mod-cf.sub-modelo = "" then do:
       {include/i-vldprg.i}        
       run utp/ut-msgs.p (input "show",
                          input 6574,
                          input "").     
       apply "ENTRY" to estr-mod-cf.it-codigo  in frame {&frame-name}.
       return "ADM-ERROR":U.  
    end.

    if (input frame {&frame-name} estr-mod-cf.it-codigo  <> "" and
        input frame {&frame-name} estr-mod-cf.fm-codigo  <> "" )
        or
/***   (input frame {&frame-name} estr-mod-cf.it-codigo  <> "" and
        input frame {&frame-name} estr-mod-cf.sub-modelo <> "") 
        or ***/
       (input frame {&frame-name} estr-mod-cf.fm-codigo  <> "" and
        input frame {&frame-name} estr-mod-cf.sub-modelo <> "") 
        or 
       (input frame {&frame-name} estr-mod-cf.it-codigo  <> "" and
        input frame {&frame-name} estr-mod-cf.fm-codigo  <> "" and
        input frame {&frame-name} estr-mod-cf.sub-modelo <> "") then do:

       {include/i-vldprg.i}        
       run utp/ut-msgs.p (input "show",
                          input 6574,
                          input "").     
       apply "ENTRY" to estr-mod-cf.it-codigo  in frame {&frame-name}.
       return "ADM-ERROR":U.  
    end.

    if input frame {&frame-name} estr-mod-cf.it-codigo  <> "" then do:
       for first item fields (it-codigo tipo-con-est cod-obsoleto tipo-contr) where 
            item.it-codigo = input frame {&frame-name} estr-mod-cf.it-codigo 
            no-lock: end.
       if not avail item then do:
          {include/i-vldprg.i}        
          run utp/ut-msgs.p (input "show",
                             input 56,
                             input frame {&frame-name} estr-mod-cf.it-codigo).     
          apply "ENTRY" to estr-mod-cf.it-codigo  in frame {&frame-name}.
          return "ADM-ERROR":U.    
       end.
       else do:
           if item.cod-obsoleto = 4 then do:
               run utp/ut-msgs.p(input "show",
                                 input 17472,
                                 input "").
               return 'ADM-ERROR':U.
           end.
/*           if item.tipo-contr = 4 then do:
 *                run utp/ut-msgs.p(input "show",
 *                                  input 1673,
 *                                  input "").
 *                return 'ADM-ERROR':U.
 *            end.*/
       end.
       if input frame {&frame-name} estr-mod-cf.it-codigo = b-modelo-cf.item-criado THEN DO:

          run utp/ut-msgs.p (input "show",
                             input 26278,
                             input "").   

          apply "ENTRY" to estr-mod-cf.it-codigo  in frame {&frame-name}.
          return "ADM-ERROR":U. 
       END.
    end.

    if input frame {&frame-name} estr-mod-cf.fm-codigo  <> "" and 
       not can-find(first familia where 
            familia.fm-codigo = input frame {&frame-name} estr-mod-cf.fm-codigo NO-LOCK) then do:
        {include/i-vldprg.i}        
        run utp/ut-msgs.p (input "show",
                           input 56,
                           input input frame {&frame-name} estr-mod-cf.fm-codigo).     
        apply "ENTRY" to estr-mod-cf.fm-codigo  in frame {&frame-name}.
        return "ADM-ERROR":U.    

    end.

    if input frame {&frame-name} estr-mod-cf.sub-modelo <> "" and
       input frame {&frame-name} estr-mod-cf.sub-modelo <> ? then do:
       find b-modelo-cf where 
            b-modelo-cf.mo-codigo = input frame {&frame-name} estr-mod-cf.sub-modelo no-lock no-error.

       if not avail b-modelo-cf then do:
          {include/i-vldprg.i}        
          run utp/ut-msgs.p (input "show",
                             input 56,
                             input input frame {&frame-name} estr-mod-cf.sub-modelo).     
          apply "ENTRY" to estr-mod-cf.sub-modelo  in frame {&frame-name}.
          return "ADM-ERROR":U.    
       end. 

       find b-modelo-cf where 
           rowid(b-modelo-cf) = v-row-parent no-lock no-error.
       if input frame {&frame-name} estr-mod-cf.sub-modelo = b-modelo-cf.mo-codigo
       then do:
          {utp/ut-liter.i Inclus∆o MCF R}  
          assign  c-mensagem = return-value.
          {include/i-vldprg.i}        
          run utp/ut-msgs.p (input "show",
                             input 6548,
                             input c-mensagem).     
          apply "ENTRY" to estr-mod-cf.sub-modelo  in frame {&frame-name}.
          return "ADM-ERROR":U. 
       end.
       assign l-erro = no.
       run cfp/cf0101h.p (input b-modelo-cf.mo-codigo,
                          input (input frame {&frame-name} estr-mod-cf.sub-modelo),
                          input yes).

       {utp/ut-liter.i Inclus∆o * R}

       assign  c-mensagem = return-value.

       if l-erro then do:  
          {include/i-vldprg.i}        
          run utp/ut-msgs.p (input "show",
                             input 6548,
                             input c-mensagem).
          apply "ENTRY" to estr-mod-cf.sub-modelo in frame {&frame-name}.
          return "ADM-ERROR":U.  
       end.
       assign l-erro = no.
       run cfp/cf0101h.p (input b-modelo-cf.mo-codigo,
                          input (input frame {&frame-name} estr-mod-cf.sub-modelo),
                          input no).

       if l-erro then do:  
          {include/i-vldprg.i}        
          run utp/ut-msgs.p (input "show",
                             input 6548,
                             input c-mensagem).

          apply "ENTRY" to estr-mod-cf.sub-modelo  in frame {&frame-name}.
          return "ADM-ERROR":U.  
      end.                                                  
    end.
 end.
 find b-modelo-cf where 
      rowid(b-modelo-cf) = v-row-parent no-lock no-error.
 if avail b-modelo-cf then 
    assign c-modelo = b-modelo-cf.mo-codigo. 

 if not input frame {&frame-name} estr-mod-cf.seq-mandat then do:
    find first b2-estr-mod-cf where 
               b2-estr-mod-cf.sequencia  = input frame {&frame-name} 
                                                estr-mod-cf.sequencia and 
               b2-estr-mod-cf.mo-codigo  = c-modelo and 
               b2-estr-mod-cf.seq-mandat = yes no-lock no-error.

    if avail b2-estr-mod-cf then do:
       {utp/ut-liter.i N∆o_Obrigat¢ria MCF R}  
       assign  c-mensagem = return-value.
       {include/i-vldprg.i}        
       run utp/ut-msgs.p (input "show",
                          input 6790,
                          input c-mensagem).

       if return-value = "yes" then   
          for each b2-estr-mod-cf where 
                   b2-estr-mod-cf.sequencia  = input frame {&frame-name} 
                                                        estr-mod-cf.sequencia  and 
                   b2-estr-mod-cf.mo-codigo  = c-modelo :
              assign b2-estr-mod-cf.seq-mandat = no.
          end.                  
       else do:
          apply "ENTRY" to estr-mod-cf.sequencia  in frame {&frame-name}.
          return "ADM-ERROR":U.
       end.        
    end.
 end.
 else do:
    find first b2-estr-mod-cf where 
               b2-estr-mod-cf.sequencia  = input frame {&frame-name} 
                                                estr-mod-cf.sequencia and 
               b2-estr-mod-cf.mo-codigo  = c-modelo and 
               b2-estr-mod-cf.seq-mandat = no no-lock no-error.

    if avail b2-estr-mod-cf then do:
       {utp/ut-liter.i Obrigat¢ria MCF R}  
       assign  c-mensagem = return-value.
       {include/i-vldprg.i}        
       run utp/ut-msgs.p (input "show",
                          input 6790,
                          input c-mensagem).

       if return-value = "yes" then   
          for each b2-estr-mod-cf where 
                   b2-estr-mod-cf.sequencia  = input frame {&frame-name}
                                                 estr-mod-cf.sequencia and 
                   b2-estr-mod-cf.mo-codigo  = c-modelo :
              assign b2-estr-mod-cf.seq-mandat = yes.
          end.                
       else do:
          apply "ENTRY" to estr-mod-cf.sequencia  in frame {&frame-name}.
          return "ADM-ERROR":U.
       end.          
    end. 
 end.

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
  {src/adm/template/snd-list.i "estr-mod-cf"}

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

