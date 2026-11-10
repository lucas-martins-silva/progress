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
{include/i-prgvrs.i V03IN245 2.00.01.013}  /*** 010113 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN245 MUT}
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


def var c-label-1 as char no-undo.
def var c-label-2 as char no-undo.
{utp/ut-field.i mgind natur-oper nat-vinculada 1}
assign c-label-1 = return-value.
{utp/ut-field.i mgind natur-oper nat-operacao 1}
assign c-label-2 = return-value.

def buffer b-natur-oper for natur-oper.
def buffer b-ped-venda  for ped-venda.
def var i-cont as integer.
def var rw-natur-oper  as rowid.
def var de-desc        as integer no-undo.
def var c-nat-temp     as char    no-undo.
def var c-nat-operacao as char no-undo.

def  var i-round as integer.
def  var i-arred as integer.
{cdp/cd9990.i1}
{cdp/cd4000.i}
{cdp/cdcfgdis.i}

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
&Scoped-Define ENABLED-FIELDS natur-oper.aliquota-icm ~
natur-oper.icms-subs-trib natur-oper.per-des-icms natur-oper.perc-red-icm ~
natur-oper.perc-red-ipi natur-oper.cd-vinc-ipi natur-oper.perc-PIS[1] ~
natur-oper.perc-PIS[2] natur-oper.per-fin-soc[1] natur-oper.per-fin-soc[2] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}aliquota-icm ~{&FP2}aliquota-icm ~{&FP3}~
 ~{&FP1}icms-subs-trib ~{&FP2}icms-subs-trib ~{&FP3}~
 ~{&FP1}per-des-icms ~{&FP2}per-des-icms ~{&FP3}~
 ~{&FP1}perc-red-icm ~{&FP2}perc-red-icm ~{&FP3}~
 ~{&FP1}perc-red-ipi ~{&FP2}perc-red-ipi ~{&FP3}~
 ~{&FP1}cd-vinc-ipi ~{&FP2}cd-vinc-ipi ~{&FP3}~
 ~{&FP1}perc-PIS[1] ~{&FP2}perc-PIS[1] ~{&FP3}~
 ~{&FP1}perc-PIS[2] ~{&FP2}perc-PIS[2] ~{&FP3}~
 ~{&FP1}per-fin-soc[1] ~{&FP2}per-fin-soc[1] ~{&FP3}~
 ~{&FP1}per-fin-soc[2] ~{&FP2}per-fin-soc[2] ~{&FP3}
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define DISPLAYED-FIELDS natur-oper.aliquota-icm ~
natur-oper.icms-subs-trib natur-oper.per-des-icms natur-oper.perc-red-icm ~
natur-oper.perc-red-ipi natur-oper.nat-vinculada natur-oper.cd-vinc-ipi ~
natur-oper.perc-PIS[1] natur-oper.perc-PIS[2] natur-oper.per-fin-soc[1] ~
natur-oper.per-fin-soc[2] 

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

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     natur-oper.aliquota-icm AT ROW 1.21 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     natur-oper.icms-subs-trib AT ROW 2.21 COL 29 COLON-ALIGNED
          LABEL "ICMS Subst":R10
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     natur-oper.per-des-icms AT ROW 3.21 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     natur-oper.perc-red-icm AT ROW 4.21 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     natur-oper.perc-red-ipi AT ROW 5.21 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     natur-oper.nat-vinculada AT ROW 1.21 COL 63.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     natur-oper.cd-vinc-ipi AT ROW 2.21 COL 63.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     natur-oper.perc-PIS[1] AT ROW 3.21 COL 63.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     natur-oper.perc-PIS[2] AT ROW 3.21 COL 72.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     natur-oper.per-fin-soc[1] AT ROW 4.21 COL 63.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     natur-oper.per-fin-soc[2] AT ROW 4.21 COL 72.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


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
         HEIGHT             = 5.42
         WIDTH              = 81.43.
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

/* SETTINGS FOR FILL-IN natur-oper.icms-subs-trib IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN natur-oper.nat-vinculada IN FRAME f-main
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

&Scoped-define SELF-NAME natur-oper.cd-vinc-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cd-vinc-ipi V-table-Win
ON F5 OF natur-oper.cd-vinc-ipi IN FRAME f-main /* C¢digo Vinculaá∆o IPI */
DO: 
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= "dizoom/z01di013.w"
                     &campo= natur-oper.cd-vinc-ipi
                     &campozoom= cd-vin-ipi}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cd-vinc-ipi V-table-Win
ON LEAVE OF natur-oper.cd-vinc-ipi IN FRAME f-main /* C¢digo Vinculaá∆o IPI */
DO:  
   if  replace(replace(self:screen-value,".",""),"-","") <> "" then 
   do i-cont = 1 to 5:
      if  substr(self:screen-value,i-cont,1) = "" then do:
        assign self:screen-value = ?.
      end.
   end.  
   else 
   assign self:screen-value = ?.

  if  input frame {&frame-name} natur-oper.cd-vinc-ipi <> ? and
      not can-find (cod-vin-ipi where cod-vin-ipi.cd-vin-ipi =
          input frame {&frame-name} natur-oper.cd-vinc-ipi)    then do:
      {utp/ut-field.i mgind natur-oper cd-vinc-ipi 1}
      run utp/ut-msgs.p (input "show",
                        input 2,
                        input return-value).
      assign self:screen-value = ?.
  end.
              
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cd-vinc-ipi V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.cd-vinc-ipi IN FRAME f-main /* C¢digo Vinculaá∆o IPI */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.nat-vinculada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-vinculada V-table-Win
ON F5 OF natur-oper.nat-vinculada IN FRAME f-main /* Natureza Vinculada */
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom= "inzoom/z01in245.w"
                     &campo= natur-oper.nat-vinculada
                     &campozoom= nat-operacao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-vinculada V-table-Win
ON LEAVE OF natur-oper.nat-vinculada IN FRAME f-main /* Natureza Vinculada */
DO:
   if  replace(replace(self:screen-value,".",""),"-","") <> "" then 
   do i-cont = 1 to 5:
      if  substr(self:screen-value,i-cont,1) = "" then do:
        assign self:screen-value = ?.
      end.
   end.  
   else 
   assign self:screen-value = ?.
   
   if input frame {&frame-name} natur-oper.nat-vinculada = ? or
      not can-find (natur-oper where natur-oper.nat-operacao =
          input frame {&frame-name} natur-oper.nat-vinculada) then do:
      {utp/ut-table.i mgind natur-oper 1}
      run utp/ut-msgs.p (input "show",
                        input 2,
                        input return-value).
      assign self:screen-value = ?.
  end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-vinculada V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.nat-vinculada IN FRAME f-main /* Natureza Vinculada */
DO:
  apply "f5" to self.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
   {include/i-valid.i}

  /* Dispatch standard ADM method.   */         

  assign c-nat-temp = input frame {&frame-name} natur-oper.nat-vinculada.
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  assign natur-oper.nat-vinculada = c-nat-temp. 

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  define variable i-exporta as integer no-undo.
 
 /* Code placed here will execute PRIOR to standard behavior. */
  
  assign de-desc = input frame {&frame-name} natur-oper.per-des-icms.
  
  RUN get-attribute ('ADM-NEW-RECORD'). /* Retorna yes se for uma inclus∆o */
  if return-value = "no" then do: 
     if natur-oper.per-des-icms <> de-desc then do:
        run cdp/cd0604b.w (output i-exporta).
        if i-exporta <> 1 then do:
           if session:set-wait-state ("general") then.
           for each b-ped-venda no-lock 
               where b-ped-venda.cod-sit-ped = 1
               and   b-ped-venda.nat-oper = natur-oper.nat-operacao:
               
               find ped-venda
                    where rowid(ped-venda) = rowid(b-ped-venda)
                    exclusive-lock no-error.
               if  (i-exporta = 2 and ped-venda.per-des-icms = de-desc)
               or  i-exporta = 3 then do:
                   assign ped-venda.per-des-icms = de-desc. 
                   for each ped-item of ped-venda exclusive-lock:
                       {pdp/pd4000a.i1 "ped-venda.nr-tab-finan"
                                       "ped-venda.nr-ind-finan"}
                       {pdp/pd4000b.i1 "ped-venda.perc-desco1"
                                       "ped-venda.perc-desco2"}                
                   end.
                  run cdp/cd4323.p (input rowid(ped-venda),
                                    input yes).
                                    
               end.
           end.
           if session:set-wait-state ("") then.    
        end.   
     end. 
  end.
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  find first param-global no-lock no-error.
  if param-global.modulo-of = no then do:
     assign natur-oper.cd-vinc-ipi = "". 
     disable natur-oper.cd-vinc-ipi with frame {&frame-name}.
  end.
  else do:
     enable natur-oper.cd-vinc-ipi with frame {&frame-name}.
  end. 

if input frame {&frame-name} natur-oper.nat-vinculada <> ? then
     assign natur-oper.nat-vinculada =  input frame {&frame-name} natur-oper.nat-vinculada.   
   
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
  disable mgind.natur-oper.nat-vinculada with frame {&frame-name}. 
  
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
  
  find first param-global no-lock no-error.
  if param-global.modulo-of = no then do:
     assign natur-oper.cd-vinc-ipi:screen-value in frame {&frame-name} = "". 
     disable natur-oper.cd-vinc-ipi with frame {&frame-name}.
  end.
  else do:
     enable natur-oper.cd-vinc-ipi with frame {&frame-name}.
  end. 
         
  &if  defined(ADM-MODIFY-FIELDS) &then
       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  if natur-oper.cd-vinc-ipi:load-mouse-pointer   ("image\lupa.cur") in frame {&frame-name} then.
  if natur-oper.nat-vinculada:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
  
  run pi-habilita-campo.

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
  
  {utp/ut-liter.i %_PIS * L}
  assign natur-oper.perc-PIS[1]:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i %_COFINS * L}
  assign natur-oper.per-fin-soc[1]:label in frame {&frame-name} = return-value. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campo V-table-Win 
PROCEDURE pi-habilita-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "tipo").
  if integer(return-value) <> 3 then do:
     assign natur-oper.nat-vinculada:screen-value in frame {&frame-name} = "?".
     disable natur-oper.nat-vinculada with frame {&frame-name}.
  end.   
  else do:
     enable natur-oper.nat-vinculada with frame {&frame-name}.
/*     display natur-oper.nat-vinculada with frame {&frame-name}.
 *     assign natur-oper.nat-vinculada:screen-value in frame {&frame-name} = "?".     */
  end.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-natureza V-table-Win 
PROCEDURE pi-valida-natureza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 def input param c-nat-vinc as char.
 def buffer b-natur-oper for natur-oper. 
 
 {include/i-vldfrm.i}
 
 RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "tipo").
   
 if integer(return-value) = 3 and
    input frame {&frame-name} natur-oper.nat-vinculada <> ? then do:
    if  substring(c-nat-vinc,1,1) <>
        substring(input frame {&frame-name} natur-oper.nat-vinculada,1,1)
    or  c-nat-vinc = input frame {&frame-name} natur-oper.nat-vinculada then do:
        {include/i-vldprg.i}
        {utp/ut-table.i mgind natur-oper 1}
        run utp/ut-msgs.p (input "show",
                           input 773,
                           input return-value).
        apply 'entry' to natur-oper.nat-vinculada.                   
        return 'adm-error'.
    end.
   
    find first b-natur-oper use-index natureza 
         where b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-vinculada 
         no-lock no-error. 
    if not avail b-natur-oper then do: 
       {include/i-vldprg.i}     
       {utp/ut-table.i mgind natur-oper 1}
       run utp/ut-msgs.p (input "show",
                          input 2,
                          input return-value).
       apply 'entry' to natur-oper.nat-vinculada.                   
       return 'adm-error'. 
    end.
 end.                          
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 /*{include/i-vldfrm.i} este include passou a ser chamado na p°-valida-natureza */
  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "nat-operacao").
  assign c-nat-operacao = return-value.
  assign c-nat-operacao = replace(c-nat-operacao,".","").
  assign c-nat-operacao = replace(c-nat-operacao,"-","").

  
  /* testa se natureza vinculada n∆o Ç igual a que est† sendo cadastrada. */
  if natur-oper.nat-vinculada:screen-value in frame {&frame-name} = c-nat-operacao then do:
     {include/i-vldfrm.i}  
      run utp/ut-msgs.p (input "show",
                         input 7483,
                         input c-label-1 + "~~" +
                               c-label-2).
      apply 'entry' to natur-oper.nat-vinculada.                   
      return 'adm-error'. 
  end.
  /* fim teste. */   
     
  
  run pi-valida-natureza (return-value).
     
  if  return-value = "adm-error" then
      return "adm-error".
 
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

  /* There are no foreign keys supplied by this SmartObject. */

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
  
  if natur-oper.cd-vinc-ipi:load-mouse-pointer   ("image\lupa.cur") in frame {&frame-name} then.
  if natur-oper.nat-vinculada:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
 
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */

      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


