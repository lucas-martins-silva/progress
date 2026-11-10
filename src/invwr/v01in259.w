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
{include/i-prgvrs.i V01IN259 2.00.00.013 } /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN259 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var v-row-parent as rowid no-undo.
def buffer b-oper-exam for oper-exam.

/**************************** Multi-Planta *****************************/
def var i-tipo-movto as integer no-undo.
def var l-cria       as logical no-undo.

{cdp/cd7300.i1}
/******************************* Fim ***********************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES oper-exam
&Scoped-define FIRST-EXTERNAL-TABLE oper-exam


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR oper-exam.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS oper-exam.frequencia oper-exam.perc-nqa ~
oper-exam.nivel oper-exam.situacao oper-exam.responsavel 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}frequencia ~{&FP2}frequencia ~{&FP3}~
 ~{&FP1}perc-nqa ~{&FP2}perc-nqa ~{&FP3}~
 ~{&FP1}nivel ~{&FP2}nivel ~{&FP3}~
 ~{&FP1}responsavel ~{&FP2}responsavel ~{&FP3}
&Scoped-define ENABLED-TABLES oper-exam
&Scoped-define FIRST-ENABLED-TABLE oper-exam
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 c-label-situacao 
&Scoped-Define DISPLAYED-FIELDS oper-exam.cod-exame oper-exam.frequencia ~
oper-exam.perc-nqa oper-exam.nivel oper-exam.situacao oper-exam.responsavel 
&Scoped-Define DISPLAYED-OBJECTS c-des-exame c-nome-resp c-label-situacao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS oper-exam.cod-exame 

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
DEFINE VARIABLE c-des-exame AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-situacao AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE c-nome-resp AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 22 BY 1.33.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     oper-exam.cod-exame AT ROW 1.17 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-des-exame AT ROW 1.17 COL 34.57 COLON-ALIGNED HELP
          "Descricao do Exame" NO-LABEL
     oper-exam.frequencia AT ROW 2.67 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     oper-exam.perc-nqa AT ROW 3.67 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     oper-exam.nivel AT ROW 4.67 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.57 BY .88
     oper-exam.situacao AT ROW 6.38 COL 32 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Ativo", 1,
"Inativo", 2
          SIZE 18.29 BY .75
     oper-exam.responsavel AT ROW 7.75 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-nome-resp AT ROW 7.75 COL 45 COLON-ALIGNED HELP
          "Nome Completo do Responsavel" NO-LABEL
     c-label-situacao AT ROW 5.83 COL 29 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
     RECT-1 AT ROW 6.13 COL 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.oper-exam
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
         HEIGHT             = 7.79
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-exame IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-resp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN oper-exam.cod-exame IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME oper-exam.cod-exame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-exam.cod-exame V-table-Win
ON F5 OF oper-exam.cod-exame IN FRAME f-main /* Exame */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom=inzoom/z01in114.w
                  &tabela=oper-exam
                  &atributo=cod-exame}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-exam.cod-exame V-table-Win
ON LEAVE OF oper-exam.cod-exame IN FRAME f-main /* Exame */
DO:
  {include/leave.i &tabela=exame
                   &atributo-ref=descricao
                   &variavel-ref=c-des-exame
                   &where="exame.cod-exame = input frame {&FRAME-NAME} oper-exam.cod-exame and exame.cdn-sit-vers = 2"}
                   
  find exame no-lock
     where exame.cod-exame = integer(oper-exam.cod-exame:screen-value in frame {&FRAME-NAME}) 
       AND exame.cdn-sit-vers = 2 /* Liberado */ no-error.
  if avail exame then do:
     assign oper-exam.responsavel:screen-value in frame {&FRAME-NAME} = exame.cod-resp.
     apply 'leave' to oper-exam.responsavel.     
     if  not adm-new-record then     
         assign oper-exam.frequencia:screen-value in frame {&FRAME-NAME} = string(exame.frequencia)
                oper-exam.perc-nqa:screen-value   in frame {&FRAME-NAME} = string(exame.perc-nqa)
                oper-exam.nivel:screen-value      in frame {&FRAME-NAME} = string(exame.nivel).
  end.
                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-exam.cod-exame V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-exam.cod-exame IN FRAME f-main /* Exame */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-exam.nivel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-exam.nivel V-table-Win
ON F5 OF oper-exam.nivel IN FRAME f-main /* N°vel */
DO:
  {include/zoomvar.i &prog-zoom=inzoom\z01in249.w
                     &campo=oper-exam.nivel
                     &campozoom=nivel}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-exam.nivel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-exam.nivel IN FRAME f-main /* N°vel */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-exam.responsavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-exam.responsavel V-table-Win
ON F5 OF oper-exam.responsavel IN FRAME f-main /* Respons†vel */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom\z01in391.w
                     &campo=oper-exam.responsavel
                     &campozoom=cod-resp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-exam.responsavel V-table-Win
ON LEAVE OF oper-exam.responsavel IN FRAME f-main /* Respons†vel */
DO:
  {include/leave.i &tabela=responsavel
                   &atributo-ref=nome-resp
                   &variavel-ref=c-nome-resp
                   &where="responsavel.cod-resp = input frame {&FRAME-NAME} oper-exam.responsavel"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-exam.responsavel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-exam.responsavel IN FRAME f-main /* Respons†vel */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if oper-exam.cod-exame:load-mouse-pointer   ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if oper-exam.responsavel:load-mouse-pointer ("image\lupa.cur") in frame {&FRAME-NAME} then.  
  if oper-exam.nivel:load-mouse-pointer       ("image\lupa.cur") in frame {&FRAME-NAME} then.  
  {utp/ut-rtlbl.i mgind oper-exam situacao c-label-situacao}
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF           
    
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
  {src/adm/template/row-list.i "oper-exam"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "oper-exam"}

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
  {utp/ut-rtlbl.i mgind oper-exam situacao c-label-situacao}
  /* Code placed here will execute AFTER standard behavior.    */

  find operacao
       where rowid(operacao) = v-row-parent no-error.

  find item where item.it-codigo = operacao.it-codigo no-lock no-error.
             
  assign oper-exam.perc-nqa:screen-value in frame {&FRAME-NAME} = string(item.perc-nqa). 
  assign oper-exam.nivel:screen-value    in frame {&FRAME-NAME} = string(item.nivel). 

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */
  find operacao where rowid(operacao) = v-row-parent  no-error.
  if oper-exam.cod-exame:sensitive in frame {&FRAME-NAME} = yes and
     can-find (b-oper-exam where b-oper-exam.it-codigo   = operacao.it-codigo
                          and    b-oper-exam.cod-roteiro = operacao.cod-roteiro
                          and    b-oper-exam.op-codigo   = operacao.op-codigo
                          and    b-oper-exam.cod-exame   = input frame {&FRAME-NAME} oper-exam.cod-exame)
                          then do:
     run utp/ut-msgs.p (input "show",
                        input 970,
                        input "").
     apply 'entry' to oper-exam.cod-exame.
     return 'adm-error'.
  end.

  /* Ponha aqui as demais validaá‰es */
  /* validaá∆o do exame */
  if  adm-new-record = yes then do:

      /* Verifica se existe exame com o c¢digo informado */
      FIND FIRST exame where exame.cod-exame = input frame {&FRAME-NAME} oper-exam.cod-exame NO-LOCK NO-ERROR.
      if not avail exame then do:
         {utp/ut-field.i mgind oper-exam cod-exame 1}
         run utp/ut-msgs.p (input "show",
                            input 2,
                            input return-value).
         apply 'entry' to oper-exam.cod-exame.
         return 'adm-error'.
      end.

      /* Verifica se existe vers∆o liberada para o exame informado */
      FIND FIRST exame NO-LOCK 
           WHERE exame.cod-exame = INPUT FRAME {&frame-name} oper-exam.cod-exame 
             AND exame.cdn-sit-vers = 2 /* Liberada */ NO-ERROR.
      IF NOT AVAILABLE exame then do:
          RUN utp/ut-msgs.p (INPUT "show", 
                             INPUT 55445,  /* Exame n∆o possui vers∆o liberada! */
                             INPUT '').
          APPLY 'entry' to oper-exam.cod-exame.
          RETURN 'adm-error'.
      END.
  END.

  /* validaá∆o do n°vel de inspeá∆o*/
  if oper-exam.nivel:screen-value in frame {&FRAME-NAME} <> "" then do:
     if exame.amostragem = yes and exame.homogeneo = no then do:
        find first nivel-insp no-lock
           where nivel-insp.nivel = input frame {&FRAME-NAME} oper-exam.nivel no-error.
        if not avail nivel-insp then do:
           run utp/ut-msgs.p (input "show",
                              input 971,
                              input oper-exam.nivel:screen-value in frame {&FRAME-NAME}).
           apply 'entry' to oper-exam.nivel.
           return 'adm-error'.
        end.
     end.
  end.
   
  /* validaá∆o do responsavel */
  find responsavel no-lock
     where responsavel.cod-resp = input frame {&FRAME-NAME} oper-exam.responsavel no-error.
  if not avail responsavel then do:
     {utp/ut-field.i mgind oper-exam responsavel 1}
     run utp/ut-msgs.p (input "show",
                        input 2,
                        input return-value).
     apply 'entry' to oper-exam.responsavel.
     return 'adm-error'.
  end.
  
  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */
  /* gravaá∆o dos valores da tabela pai na tabela filho */
  find operacao
     where rowid(operacao) = v-row-parent no-error.
  if avail operacao then do:
     assign oper-exam.it-codigo   = operacao.it-codigo
            oper-exam.cod-roteiro = operacao.cod-roteiro
            oper-exam.op-codigo   = operacao.op-codigo
            oper-exam.dt-inclusao = today.
  end.

  /***************************** Multi-Planta *******************************/
  
  assign c-transacao = "MAT043".
  {cdp/cd7300.i5 "001" c-transacao}
  
  assign i-tipo-movto = if oper-exam.cod-exame:sensitive in frame {&FRAME-NAME} = yes
                           then 1 else 2.
                          
  run pi-cria-tt-dados (input i-tipo-movto).

  {cdp/cd7300.i6 "001" c-transacao}
  
  /********************************** Fim ************************************/  
                            
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
  
    
  find operacao where rowid(operacao) = v-row-parent no-error.
   if avail operacao then do:
    assign mgind.oper-exam.it-codigo   = mgind.operacao.it-codigo
           mgind.oper-exam.cod-roteiro = mgind.operacao.cod-roteiro
           mgind.oper-exam.op-codigo   = mgind.operacao.op-codigo.
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
  if avail oper-exam then do:
     find exame no-lock
        where exame.cod-exame = oper-exam.cod-exam 
          AND exame.cdn-sit-vers = 2 /* Liberado */ no-error.
     assign c-des-exame = if avail exame then exame.descricao else "":U.
     
     find responsavel no-lock
        where responsavel.cod-resp = oper-exam.responsavel no-error.
     assign c-nome-resp = if avail responsavel then responsavel.nome-resp else "":U.     
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-rtlbl.i mgind oper-exam situacao c-label-situacao}  
  
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

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-rtlbl.i mgind oper-exam situacao c-label-situacao}  
  

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
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter i-tipo-movto as integer.
if  param-global.modulo-mp 
and tt-replica-msg.log-replica-msg = yes then do:
    create tt-dados-env.
    assign tt-dados-env.num-sequencia  = i-seq
           tt-dados-env.cod-tipo-reg   = 131
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = oper-exam.it-codigo   + " , " +
                                         oper-exam.cod-roteiro + " , " +
                                         string(oper-exam.op-codigo) + " , " +
                                         string(oper-exam.cod-exame).
    raw-transfer oper-exam to tt-dados-env.conteudo-msg.
    assign i-seq = i-seq + 1.
end.                                     
                                         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvar_chave V-table-Win 
PROCEDURE salvar_chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN oper-exam.it-codigo   = operacao.it-codigo
           oper-exam.cod-roteiro = operacao.cod-roteiro
           oper-exam.op-codigo   = operacao.op-codigo
           oper-exam.cod-exame   = input frame {&FRAME-NAME} oper-exam.cod-exame.

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
  {src/adm/template/snd-list.i "oper-exam"}

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


