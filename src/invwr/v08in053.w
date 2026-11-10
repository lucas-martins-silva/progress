&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V08IN053 2.00.00.018}  /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V08IN053 MUT}
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
 
def buffer b-componente for componente.
 
/* Local Variable Definitions ---                                       */
def new global shared var  r-componente  as rowid          no-undo.
def var c-aliquota-ipi     like componente.aliquota-ipi    no-undo.
 
def var c-nat-operacao     as  character no-undo.
def var c-mudou-nat-oper   as  character no-undo.
 
def var d-ipi-ntrib        as decimal    no-undo.
def var d-base-ipi         as decimal    no-undo.
def var d-ipi-outras       as decimal    no-undo.
 
def var d-icm-ntrib        as decimal    no-undo.
def var d-base-icm         as decimal    no-undo.
def var d-icm-outras       as decimal    no-undo.
 
def var l-pi-icm           as logical    no-undo.
def var l-pi-ipi           as logical    no-undo.
def var l-trib-icm         as logical    no-undo.
def var l-trib-ipi         as logical    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES saldo-terc
&Scoped-define FIRST-EXTERNAL-TABLE saldo-terc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR saldo-terc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS saldo-terc.qtd-ini 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}qtd-ini ~{&FP2}qtd-ini ~{&FP3}
&Scoped-define ENABLED-TABLES saldo-terc
&Scoped-define FIRST-ENABLED-TABLE saldo-terc
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-1 
&Scoped-Define DISPLAYED-FIELDS saldo-terc.qtd-ini 
&Scoped-Define DISPLAYED-OBJECTS c-class-fiscal cb-cd-trib-ipi ~
cb-cd-trib-icm de-aliquota-ipi de-aliquota-icm de-valor-ipi de-valor-icm 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS c-class-fiscal cb-cd-trib-ipi ~
cb-cd-trib-icm de-aliquota-ipi de-aliquota-icm de-valor-ipi de-valor-icm 
&Scoped-define ADM-ASSIGN-FIELDS c-class-fiscal de-aliquota-ipi ~
de-aliquota-icm de-valor-ipi de-valor-icm 
&Scoped-define ADM-MODIFY-FIELDS cb-cd-trib-icm 

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
DEFINE VARIABLE cb-cd-trib-icm AS CHARACTER FORMAT "X(19)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1,","Item 2,","Item 3,","Item 4" 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cd-trib-ipi AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "item 1,","item 2,","item 3,","item 4" 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE c-class-fiscal AS INTEGER FORMAT "9999,99,99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliquota-icm AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliquota-ipi AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-icm AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-ipi AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81.43 BY 5.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.14 BY 7.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-class-fiscal AT ROW 1.25 COL 19 COLON-ALIGNED
     saldo-terc.qtd-ini AT ROW 1.38 COL 73.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     cb-cd-trib-ipi AT ROW 3.5 COL 19 COLON-ALIGNED
     cb-cd-trib-icm AT ROW 3.5 COL 60 COLON-ALIGNED
     de-aliquota-ipi AT ROW 4.63 COL 19 COLON-ALIGNED
     de-aliquota-icm AT ROW 4.63 COL 60.14 COLON-ALIGNED
     de-valor-ipi AT ROW 5.63 COL 19 COLON-ALIGNED
     de-valor-icm AT ROW 5.63 COL 60.14 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
     RECT-1 AT ROW 2.5 COL 1.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.saldo-terc
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
         HEIGHT             = 7.88
         WIDTH              = 84.86.
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

/* SETTINGS FOR FILL-IN c-class-fiscal IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR COMBO-BOX cb-cd-trib-icm IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-cd-trib-ipi IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN de-aliquota-icm IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN de-aliquota-ipi IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN de-valor-icm IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN de-valor-ipi IN FRAME f-main
   NO-ENABLE 1 2                                                        */
ASSIGN 
       saldo-terc.qtd-ini:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-fiscal V-table-Win
ON F5 OF c-class-fiscal IN FRAME f-main
DO:
  assign l-implanta = yes.
 
  {include/zoomvar.i &prog-zoom = inzoom/z01in046.w
                     &campo = c-class-fiscal
                     &campozoom = class-fiscal}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-class-fiscal V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-class-fiscal IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cd-trib-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cd-trib-icm V-table-Win
ON LEAVE OF cb-cd-trib-icm IN FRAME f-main
DO:
  if input frame {&frame-name} cb-cd-trib-icm = {ininc/i10in172.i 04 4} /*"Reduzido"*/ then do:
      RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cod-estabel").
      find estabelec where estabelec.cod-estabel = return-value no-lock no-error.
      RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "de-preco-total").
      if avail estabelec then do:         
         if estabelec.estado = "SP" or estabelec.estado = "RJ" then                   
             assign d-icm-outras = if avail natur-oper then 
                                      dec(return-value) * natur-oper.perc-red-icm / 100
                                   else
                                      0                                                                   
                    d-icm-ntrib  = 0.   
         else          
             assign d-icm-ntrib  = if avail natur-oper then 
                                      dec(return-value)* natur-oper.perc-red-icm / 100
                                   else
                                      0          
                    d-icm-outras = 0.
 
         if avail natur-oper then 
            assign d-base-icm = dec(return-value) * (100 - natur-oper.perc-red-icm) / 100.          
      end.
  end.    
  else do:
    RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "de-preco-total").
    if input frame {&frame-name} cb-cd-trib-icm = {ininc/i10in172.i 04 2} /*"Isento"*/ then do:
       assign d-icm-ntrib  =  dec(return-value).
       disable de-valor-icm    with frame {&frame-name}.
       disable de-aliquota-icm with frame {&frame-name}.
    end.      
    else
       assign d-icm-ntrib  = 0.
       enable de-valor-icm    with frame {&frame-name}.
       enable de-aliquota-icm with frame {&frame-name}.
       if input frame {&frame-name} cb-cd-trib-icm = {ininc/i10in172.i 04 3} /*"Outros"*/ then do:
          assign d-icm-outras = dec(return-value).          
       end.   
       else
           assign d-icm-outras = 0.                          
  end.                           
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "de-preco-total").
 
 
  if input frame {&frame-name} cb-cd-trib-icm = {ininc/i10in172.i 04 2} /*"Isento"*/ then do:
     assign d-base-icm     = 0.
     assign de-valor-icm:screen-value in frame {&frame-name} = string(0).
     disable de-valor-icm    with frame {&frame-name}.
     disable de-aliquota-icm with frame {&frame-name}.
  end.    
  else do:
     assign de-valor-icm:screen-value in frame {&frame-name} = 
     string((dec(return-value) * input frame {&frame-name} de-aliquota-icm) / 100).
     enable de-valor-icm    with frame {&frame-name}.
     enable de-aliquota-icm with frame {&frame-name}.
  end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cd-trib-icm V-table-Win
ON VALUE-CHANGED OF cb-cd-trib-icm IN FRAME f-main
DO:
    apply "LEAVE" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cd-trib-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cd-trib-ipi V-table-Win
ON LEAVE OF cb-cd-trib-ipi IN FRAME f-main
DO:
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "de-preco-total").           
 
  if input frame {&frame-name} cb-cd-trib-ipi = {ininc/i10in172.i 04 4} /*"Reduzido"*/ then do:    
      assign d-ipi-ntrib = if avail natur-oper then  
                              dec(return-value) * natur-oper.perc-red-ipi / 100
                           else 
                              0
             d-base-ipi  = if avail natur-oper then
                              dec(return-value) * (100 - natur-oper.perc-red-ipi) / 100
                           else
                              0.
      enable de-valor-ipi with frame {&frame-name}.
      enable de-aliquota-ipi with frame {&frame-name}.
  end.                                   
  else do:
       if input frame {&frame-name} cb-cd-trib-ipi = {ininc/i10in172.i 04 2} /*"Isento"*/  then do:       
           assign d-ipi-ntrib    = dec(return-value)
                  d-ipi-outras   = 0.       
           disable de-valor-ipi    with frame {&frame-name}.
           disable de-aliquota-ipi with frame {&frame-name}.
       end.    
       else do:
           assign d-ipi-ntrib    = 0.
           enable de-valor-ipi with frame {&frame-name}.
           enable de-aliquota-ipi with frame {&frame-name}.
           if input frame {&frame-name} cb-cd-trib-ipi = {ininc/i10in172.i 04 3} /*"Outros"*/ then do:
               assign d-ipi-outras   = dec(return-value).               
           end.                                        
           else
               assign d-ipi-outras   = 0.                      
       end.    
  end.           
 
  if input frame {&frame-name} cb-cd-trib-ipi = {ininc/i10in172.i 04 2} /*"Isento"*/ then do:
      assign d-base-ipi     = 0.
      assign de-valor-ipi:screen-value in frame {&frame-name} = string(0).
      disable de-valor-ipi    with frame {&frame-name}.
      disable de-aliquota-ipi with frame {&frame-name}.
  end.    
  else do:
      assign de-valor-ipi:screen-value in frame {&frame-name} = 
              string((dec(return-value) * input frame {&frame-name} de-aliquota-ipi) / 100).
      enable de-valor-ipi with frame {&frame-name}.
      enable de-aliquota-ipi with frame {&frame-name}.
  end.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cd-trib-ipi V-table-Win
ON VALUE-CHANGED OF cb-cd-trib-ipi IN FRAME f-main
DO:
  apply "LEAVE" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-aliquota-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-aliquota-icm V-table-Win
ON LEAVE OF de-aliquota-icm IN FRAME f-main
DO:
   apply "leave" to cb-cd-trib-icm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-aliquota-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-aliquota-ipi V-table-Win
ON LEAVE OF de-aliquota-ipi IN FRAME f-main
DO:
  apply "leave" to cb-cd-trib-ipi.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
 
  if c-class-fiscal:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then. 
 
 
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
  {src/adm/template/row-list.i "saldo-terc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "saldo-terc"}

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
 
  def var l-sensitive-emitente as logical no-undo.
 
  assign l-sensitive-emitente = yes.
 
  assign de-aliquota-ipi:screen-value in frame {&frame-name} = string(0)
         de-valor-ipi:screen-value in frame {&frame-name} = string(0)
         de-aliquota-icm:screen-value in frame {&frame-name} = string(0)
         de-valor-icm:screen-value in frame {&frame-name} = string(0).      
 
  assign l-pi-icm = yes.
         l-pi-ipi = yes.       
  run pi-class-fiscal in this-procedure.
 
  run pi-consiste-ipi in this-procedure(input l-sensitive-emitente).
 
  run pi-consiste-icm in this-procedure(input l-sensitive-emitente).
 
  assign l-pi-icm = yes
         l-pi-ipi = yes
         de-aliquota-ipi:sensitive in frame {&frame-name} = yes
         de-aliquota-icm:sensitive in frame {&frame-name} = yes. .
         
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
 
  assign   input frame {&frame-name} cb-cd-trib-icm 
           input frame {&frame-name} cb-cd-trib-ipi.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
 
 
  find b-componente where rowid(b-componente) = r-componente EXCLUSIVE-LOCK NO-ERROR.
 
  if avail b-componente then do:
      assign b-componente.class-fiscal = input frame {&frame-name} c-class-fiscal 
             b-componente.aliquota-ipi = input frame {&frame-name} de-aliquota-ipi
             b-componente.valor-ipi[1] = input frame {&frame-name} de-valor-ipi
             b-componente.aliquota-icm = input frame {&frame-name} de-aliquota-icm
             b-componente.valor-icm[1] = input frame {&frame-name} de-valor-icm
             b-componente.cd-trib-icm = {ininc/i07in122.i 06 cb-cd-trib-icm}
             b-componente.cd-trib-ipi = {ininc/i10in172.i 06 cb-cd-trib-ipi}.
      /* CALCULO DO IPI */
      if b-componente.cd-trib-ipi = 4 then
            assign b-componente.ipi-ntrib[1] = b-componente.base-ipi[1]
                                           * natur-oper.perc-red-IPI / 100
                   b-componente.base-ipi[1]  = b-componente.base-ipi[1]
                                           * (100 - natur-oper.perc-red-IPI) / 100.
      else
            assign b-componente.ipi-ntrib[1] = 
                                            if b-componente.cd-trib-ipi = 2 then 
                                               b-componente.base-ipi[1]
                                             else 0
                   b-componente.ipi-outras[1] =
                                            if b-componente.cd-trib-ipi = 3 then
                                               b-componente.base-ipi[1]
                                            else 0.
      if b-componente.cd-trib-ipi = 2 then
            assign b-componente.base-ipi[1] = 0.
 
 
      /* CALCULO DO ICMS */
      if b-componente.cd-trib-ICM = 4 then do:
            if  estabelec.estado = "SP"
            or  estabelec.estado = "RJ" then
                assign b-componente.icm-outras[1] = b-componente.base-icm[1]
                                                * natur-oper.perc-red-ICM / 100
                       b-componente.icm-ntrib[1] = 0.
            else
                assign b-componente.icm-ntrib[1] = b-componente.base-icm[1]
                                               * natur-oper.perc-red-ICM / 100
                       b-componente.icm-outras[1] = 0.
            assign b-componente.base-icm[1] = b-componente.base-icm[1]
                                          * (100 - natur-oper.perc-red-ICM) / 100.
      end.
      else
            assign b-componente.icm-ntrib[1] = 
                                    if b-componente.cd-trib-icm = 2 then 
                                        b-componente.base-icm[1]
                                    else 0
                   b-componente.icm-outras[1] =
                                    if b-componente.cd-trib-icm = 3 then
                                        b-componente.base-icm[1]
                                    else 0.
  end. 
 
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
  
  def var l-sensitive-emitente as logical no-undo.
 
  assign l-sensitive-emitente = yes.
  
  assign l-pi-icm = no.
         l-pi-ipi = no.       
  run pi-class-fiscal in this-procedure.
 
  run pi-consiste-ipi in this-procedure(input l-sensitive-emitente).
 
  run pi-consiste-icm in this-procedure(input l-sensitive-emitente).
 
  assign l-pi-icm = yes
         l-pi-ipi = yes.
 

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
 
 
if adm-new-record = no then do:
  if avail saldo-terc then 
    find componente where componente.serie-docto = saldo-terc.serie-docto and
                          componente.nro-docto = saldo-terc.nro-docto and
                          componente.cod-emitente = saldo-terc.cod-emitente and
                          componente.nat-operacao = saldo-terc.nat-operacao and
                          componente.it-codigo = saldo-terc.it-codigo and
                          componente.cod-refer = saldo-terc.cod-refer and
                          componente.sequencia = saldo-terc.sequencia 
                          no-lock no-error.

  if avail componente then do with frame {&frame-name}:
      assign c-class-fiscal = int(componente.class-fiscal).
      if i-pais-impto-usuario = 1 then do:
         display c-class-fiscal 
              componente.aliquota-ipi @ de-aliquota-ipi
              componente.valor-ipi[1] @ de-valor-ipi
              componente.aliquota-icm @ de-aliquota-icm
              componente.valor-icm[1] @ de-valor-icm.
      end.        
      assign cb-cd-trib-icm:screen-value = {ininc/i10in172.i 04 componente.cd-trib-icm}
             cb-cd-trib-ipi:screen-value = {ininc/i10in172.i 04 componente.cd-trib-ipi}. 
  end.
  else do:
      assign cb-cd-trib-icm:screen-value = {ininc/i10in172.i 04 1}
             cb-cd-trib-ipi:screen-value = {ininc/i10in172.i 04 1}.
  end.
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
  if adm-new-record = yes then
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
 
 
  {utp/ut-field.i mgind componente cd-trib-ipi 1}  
  assign cb-cd-trib-ipi:label in frame {&frame-name} = trim(return-value).
 
  {utp/ut-field.i mgind componente cd-trib-icm 1}  
  assign cb-cd-trib-icm:label in frame {&frame-name} = trim(return-value).
 
  {utp/ut-field.i mgind componente class-fiscal 1}  
  assign c-class-fiscal:label in frame {&frame-name} = trim(return-value).
 
  {utp/ut-field.i mgind componente aliquota-ipi 1}  
  assign de-aliquota-ipi:label in frame {&frame-name} = trim(return-value).
  
  {utp/ut-field.i mgind componente valor-ipi 1}  
  assign de-valor-ipi:label in frame {&frame-name} = trim(return-value).
 
  {utp/ut-field.i mgind componente aliquota-icm 1}  
  assign de-aliquota-icm:label in frame {&frame-name} = trim(return-value).
 
  {utp/ut-field.i mgind componente valor-icm 1}  
  assign de-valor-icm:label in frame {&frame-name} = trim(return-value).
 
  do  with frame {&frame-name}:
      assign cb-cd-trib-ipi:list-items = {ininc/i10in172.i 03}.
      assign cb-cd-trib-icm:list-items = {ininc/i07in122.i 03}.
  end. 
 
  assign  cb-cd-trib-icm:screen-value in frame {&frame-name} = {ininc/i07in122.i 04 1} 
          cb-cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 1}.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).
 
 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-class-fiscal V-table-Win 
PROCEDURE pi-class-fiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "it-codigo").
   find first item where item.it-codigo = return-value no-lock no-error.
   
   if avail item then 
   do with frame {&frame-name}:
      assign c-class-fiscal = int(item.class-fiscal).
      
      if i-pais-impto-usuario =  1 then disp c-class-fiscal.

      apply "leave" to cb-cd-trib-ipi in frame {&frame-name}.
      apply "leave" to cb-cd-trib-icm in frame {&frame-name}.      

      if de-aliquota-ipi:sensitive in frame {&frame-name} = yes then do:
         assign de-aliquota-ipi:screen-value in frame {&frame-name} = string(item.aliquota-ipi). 
         apply "leave" to cb-cd-trib-ipi in frame {&frame-name}.
         apply "leave" to cb-cd-trib-icm in frame {&frame-name}.
      end.   
   end.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-consiste-icm V-table-Win 
PROCEDURE pi-consiste-icm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter l-sensitive-emitente as logical no-undo.
 
IF l-sensitive-emitente = yes THEN DO:
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "nat-operacao").
  assign c-nat-operacao = return-value.
  assign c-nat-operacao = replace(c-nat-operacao,".","").
  assign c-nat-operacao = replace(c-nat-operacao,"-","").
 
  find first natur-oper where natur-oper.nat-operacao = c-nat-operacao no-lock no-error.
 
  if l-pi-icm then do:
    if avail natur-oper then do: 
 
        if can-do("1,4",string(natur-oper.cd-trib-icm)) then do:
            if natur-oper.cd-trib-icm = 1 then do:
 
                 RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "it-codigo").
 
                 find first item where item.it-codigo = return-value no-lock no-error.
                 if avail item then do:
                    if item.cd-trib-icm = 4 then
                        assign cb-cd-trib-icm:screen-value in frame {&frame-name} = {ininc/i07in122.i 04 1}.
                    else    
                        assign cb-cd-trib-icm:screen-value in frame {&frame-name} = {ininc/i07in122.i 04 item.cd-trib-icm}. 
                 end.
                 else
                     assign cb-cd-trib-icm:screen-value in frame {&frame-name} = {ininc/i07in122.i 04 item.cd-trib-icm}.        
            end.            
            else
                assign cb-cd-trib-icm:screen-value in frame {&frame-name} = {ininc/i07in122.i 04 item.cd-trib-icm}.
        end.        
        else
            assign cb-cd-trib-icm:screen-value in frame {&frame-name} = {ininc/i07in122.i 04 natur-oper.cd-trib-icm}.
    end.
  end.
 
  /************ Ap¢s inicializar o valor do cb-cd-trib-icm *************/
 
 
  if l-pi-icm or l-trib-icm then do:
 
    if input frame {&frame-name} cb-cd-trib-icm = {ininc/i07in122.i 04 4} /*"Reduzido"*/ then do:
          RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cod-estabel").
          find estabelec where estabelec.cod-estabel = return-value no-lock no-error.
          RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "de-preco-total").
        if avail estabelec then do:         
             if estabelec.estado = "SP" or estabelec.estado = "RJ" then                   
                 assign d-icm-outras = if avail natur-oper then 
                                          dec(return-value) * natur-oper.perc-red-icm / 100
                                       else
                                          0                                                                   
                        d-icm-ntrib  = 0.   
             else          
                 assign d-icm-ntrib  = if avail natur-oper then 
                                          dec(return-value)* natur-oper.perc-red-icm / 100
                                       else
                                          0          
                        d-icm-outras = 0.
 
             if avail natur-oper then 
                assign d-base-icm = dec(return-value) * (100 - natur-oper.perc-red-icm) / 100.          
        end.
    end.    
    else do:
        RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "de-preco-total").
        if input frame {&frame-name} cb-cd-trib-icm = {ininc/i07in122.i 04 2} /*"Isento"*/ then do:
           assign d-icm-ntrib  =  dec(return-value).
           disable de-valor-icm with frame {&frame-name}.
        end.      
        else
           assign d-icm-ntrib  = 0.
           enable de-valor-icm with frame {&frame-name}.
           if input frame {&frame-name} cb-cd-trib-icm = {ininc/i07in122.i 04 3} /*"Outros"*/ then do:
              assign d-icm-outras = dec(return-value).          
           end.   
           else
               assign d-icm-outras = 0.                          
    end.                           
 
    RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "de-preco-total").
 
    if input frame {&frame-name} cb-cd-trib-icm = {ininc/i07in122.i 04 2} /*"Isento"*/ then do:
        assign d-base-icm     = 0.
        assign de-valor-icm:screen-value in frame {&frame-name} = string(0).
        disable de-valor-icm with frame {&frame-name}.
    end.    
    else do:
        assign de-valor-icm:screen-value in frame {&frame-name} = 
        string((dec(return-value) * input frame {&frame-name} de-aliquota-icm) / 100).
        enable de-valor-icm with frame {&frame-name}.
    end.   
 
    assign l-trib-icm = no.
  end.
  assign l-pi-icm = no.
 
END.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-consiste-ipi V-table-Win 
PROCEDURE pi-consiste-ipi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
def input parameter l-sensitive-emitente as logical no-undo.
 
IF l-sensitive-emitente = yes THEN DO:
 
  if l-pi-ipi then do:
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "nat-operacao").
  assign c-nat-operacao = return-value.
  assign c-nat-operacao = replace(c-nat-operacao,".","").
  assign c-nat-operacao = replace(c-nat-operacao,"-","").
 
  find first natur-oper where natur-oper.nat-operacao = c-nat-operacao no-lock no-error.
  if avail natur-oper then do: 
 
     if can-do("1,4",string(natur-oper.cd-trib-ipi)) then do:
 
         if natur-oper.cd-trib-ipi = 1 then do:
 
             RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "it-codigo").
 
             find first item where item.it-codigo = return-value no-lock no-error.
             if avail item then do:
 
                if item.cd-trib-ipi = 4 then
                    assign cb-cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 1}.
                else
                    assign cb-cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 item.cd-trib-ipi}. 
             end.
             else do:             
                 assign cb-cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 item.cd-trib-ipi}.
             end.    
        end.            
        else do:
            assign cb-cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 item.cd-trib-ipi}.
        end.    
     end.        
     else do:
         assign cb-cd-trib-ipi:screen-value in frame {&frame-name} = {ininc/i10in172.i 04 natur-oper.cd-trib-ipi}.
     end.    
  end.
 
  end.
 
 
  /************ Ap¢s inicializar o valor do cb-cd-trib-ipi *************/
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "de-preco-total").           
 
  if l-pi-ipi or l-trib-ipi then do:
 
  if input frame {&frame-name} cb-cd-trib-ipi = {ininc/i10in172.i 04 4} /*"Reduzido"*/ then do:    
      assign d-ipi-ntrib = if avail natur-oper then  
                              dec(return-value) * natur-oper.perc-red-ipi / 100
                           else 
                              0
             d-base-ipi  = if avail natur-oper then
                              dec(return-value) * (100 - natur-oper.perc-red-ipi) / 100
                           else
                              0.
      enable de-valor-ipi with frame {&frame-name}.                            
  end.                                   
  else do:
 
       if input frame {&frame-name} cb-cd-trib-ipi = {ininc/i10in172.i 04 2} /*"Isento"*/  then do:       
           assign d-ipi-ntrib    = dec(return-value)
                  d-ipi-outras   = 0.       
           disable de-valor-ipi with frame {&frame-name}.
       end.    
       else do:
 
           assign d-ipi-ntrib    = 0.
           enable de-valor-ipi with frame {&frame-name}.
 
           if input frame {&frame-name} cb-cd-trib-ipi = {ininc/i10in172.i 04 3} /*"Outros"*/ then do:
               assign d-ipi-outras   = dec(return-value).               
           end.                                        
           else    
               assign d-ipi-outras   = 0.                      
       end.
  end.           
 
  if input frame {&frame-name} cb-cd-trib-ipi = {ininc/i10in172.i 04 2} /*"Isento"*/ then do:
      assign d-base-ipi     = 0.
      assign de-valor-ipi:screen-value in frame {&frame-name} = string(0).
      disable de-valor-ipi with frame {&frame-name}.
  end.
  else do:
      assign de-valor-ipi:screen-value in frame {&frame-name} = 
              string((dec(return-value) * input frame {&frame-name} de-aliquota-ipi) / 100).
      enable de-valor-ipi with frame {&frame-name}.
  end.
   
  assign l-trib-ipi = no.
  end.
  assign l-pi-ipi = no. 
 
END.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-icm V-table-Win 
PROCEDURE pi-icm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
def input param c-nat-operacao like natur-oper.nat-operacao no-undo.

find first natur-oper 
     where natur-oper.nat-operacao = c-nat-operacao no-lock no-error.
     
if avail natur-oper then do:
   if de-aliquota-icm:sensitive in frame {&frame-name} = yes then
      assign de-aliquota-icm:screen-value in frame {&frame-name} = string(natur-oper.aliquota-icm).
   apply "leave" to cb-cd-trib-icm in frame {&frame-name}.
   
   RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "it-codigo").
   find item where item.it-codigo = return-value no-lock no-error.  
   if avail item and de-aliquota-ipi:sensitive in frame {&frame-name} = yes then 
      assign de-aliquota-ipi:screen-value in frame {&frame-name} = string(item.aliquota-ipi).
   apply "leave" to cb-cd-trib-ipi in frame {&frame-name}.
end.


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
 
 if i-pais-impto-usuario = 1 then do:
    find first classif-fisc where
         int(classif-fisc.class-fiscal) = input frame {&frame-name} c-class-fiscal no-lock no-error.
 
    if not avail classif-fisc then do:                  
       {include/i-vldprg.i}
       {utp/ut-table.i mgind classif-fisc 1} 
       run utp/ut-msgs.p (input "show":U, input 2, input return-value).
       apply 'entry' to input frame {&frame-name} c-class-fiscal.       
       return 'ADM-ERROR':U.
    end.
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
  {src/adm/template/snd-list.i "saldo-terc"}

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


