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
{include/i-prgvrs.i V02IN513 2.00.00.007} /*** "010007" 22/09/2025 08:31:33  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN513 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def var v-row-parent as rowid no-undo.
def var rw-grup-maq  as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES ctrab
&Scoped-define FIRST-EXTERNAL-TABLE ctrab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ctrab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ctrab.qtd-capac-ctrab ctrab.val-eficien-ctrab 
&Scoped-define ENABLED-TABLES ctrab
&Scoped-define FIRST-ENABLED-TABLE ctrab
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS ctrab.qtd-capac-ctrab ~
ctrab.val-eficien-ctrab 
&Scoped-define DISPLAYED-TABLES ctrab
&Scoped-define FIRST-DISPLAYED-TABLE ctrab
&Scoped-Define DISPLAYED-OBJECTS c-tip-ctrab c-area-produc c-des-area ~
c-cod-turno c-des-turno de-qtd-tempo-util-sem c-cd-calen c-descricao ~
c-cod-unid-capac 

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


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-tip-ctrab-1 V-table-Win  
FUNCTION f-tip-ctrab-1  RETURNS CHARACTER
  ( c-tip-ctrab-aux as CHAR, cAux as char  )  FORWARD. 
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-tip-ctrab-2 V-table-Win  
FUNCTION f-tip-ctrab-2 RETURNS CHARACTER
  ( c-tip-ctrab-aux as CHAR )  FORWARD. 
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-area-produc AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cd-calen AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-turno AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-capac AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-area AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-turno AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-tip-ctrab AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 27.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-tempo-util-sem AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 6.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-tip-ctrab AT ROW 1.17 COL 23 COLON-ALIGNED
     c-area-produc AT ROW 2.17 COL 23 COLON-ALIGNED
     c-des-area AT ROW 2.17 COL 37.57 COLON-ALIGNED NO-LABEL
     c-cod-turno AT ROW 3.17 COL 23 COLON-ALIGNED
     c-des-turno AT ROW 3.17 COL 33.57 COLON-ALIGNED NO-LABEL
     de-qtd-tempo-util-sem AT ROW 3.17 COL 64 COLON-ALIGNED NO-LABEL
     c-cd-calen AT ROW 4.17 COL 23 COLON-ALIGNED
     c-descricao AT ROW 4.17 COL 36.57 COLON-ALIGNED NO-LABEL
     ctrab.qtd-capac-ctrab AT ROW 5.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-cod-unid-capac AT ROW 5.17 COL 40.72 COLON-ALIGNED NO-LABEL
     ctrab.val-eficien-ctrab AT ROW 6.17 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ctrab
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.38
         WIDTH              = 85.86.
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

/* SETTINGS FOR FILL-IN c-area-produc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cd-calen IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-turno IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-unid-capac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-area IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-turno IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tip-ctrab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-tempo-util-sem IN FRAME f-main
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

&Scoped-define SELF-NAME c-area-produc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-area-produc V-table-Win
ON F5 OF c-area-produc IN FRAME f-main
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in511.w"
                       &campo=c-area-produc
                       &campozoom=cod-area-produc
                       &campo2=c-des-area
                       &campozoom2=des-area-produc} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-area-produc V-table-Win
ON LEAVE OF c-area-produc IN FRAME f-main
DO:
  {include/leave.i &tabela=area-produc
                   &atributo-ref=des-area-produc
                   &variavel-ref=c-des-area
                   &where="area-produc.cod-area-produc = input frame {&frame-name} c-area-produc"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-area-produc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-area-produc IN FRAME f-main
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
    
  {utp/ut-field.i mgind grup-maquina cd-calen 01}
  assign c-cd-calen:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind ctrab ind-tip-ctrab 01}
  assign c-tip-ctrab:label in frame {&frame-name} = return-value.

  c-area-produc:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.

  {utp/ut-field.i mgind grup-maquina cod-area-produc 01}
  assign c-area-produc:label in frame {&frame-name} = return-value.
  
  {utp/ut-field.i mgind model-turno-semana cod-model-turno 01}
  assign c-cod-turno:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "ctrab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ctrab"}

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
    
    do  with frame {&frame-name}:
        assign c-tip-ctrab.
    end.     
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    find grup-maquina 
        where grup-maquina.gm-codigo  =  ctrab.gm-codigo no-lock no-error.
    if  avail grup-maquina then
        assign ctrab.ind-tip-ctrab = grup-maquina.ind-tip-ctrab.
    else
        assign ctrab.ind-tip-ctrab = 1.
    /**{ininc/i03in144.i 06 c-tip-ctrab}. **/

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

DEFINE VARIABLE cAux	        AS CHARACTER NO-UNDO.
	
  /* Code placed here will execute PRIOR to standard behavior. */

  if  avail ctrab then do:
  
      find grup-maquina
          where grup-maquina.gm-codigo = ctrab.gm-codigo no-lock no-error.

      if  avail grup-maquina then do:
          
          find calen-gener
              where calen-gener.cd-calen = grup-maquina.cd-calen no-lock no-error.
          if avail ctrab  then
              assign cAux = {ininc/i03in144.i 04 ctrab.ind-tip-ctrab}.
          else	
              assign cAux = {ininc/i03in144.i 04 1}.
	      
          assign c-cd-calen  = grup-maquina.cd-calen
                 c-descricao = if  avail calen-gener
                               then calen-gener.descricao
                               else ""
                 c-tip-ctrab = f-tip-ctrab-1(c-tip-ctrab,cAux)
                 c-cod-unid-capac = grup-maquina.cod-unid-capac.
      end.
      
      find first area-produc-ctrab
          where area-produc-ctrab.cod-ctrab       = ctrab.cod-ctrab
            and area-produc-ctrab.dat-inic-valid <= today
            and area-produc-ctrab.dat-fim-valid  >  today
          no-lock no-error.
      if  avail area-produc-ctrab then
          find area-produc
              where area-produc.cod-area-produc = area-produc-ctrab.cod-area-produc
              no-lock no-error.
              
      assign c-area-produc = if  avail area-produc-ctrab
                             then area-produc-ctrab.cod-area-produc
                             else ""
             c-des-area    = if  avail area-produc
                             then area-produc.des-area-produc
                             else "".
      run pi-mostra-turno (input ctrab.gm-codigo,
                           input ctrab.cod-ctrab).
  end.
  else 
      run pi-mostra-turno (input "":U,
                           input "":U).

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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
   /** if adm-new-record = yes then **/
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados V-table-Win 
PROCEDURE pi-atualiza-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param rw-grup-maquina as rowid no-undo.

assign rw-grup-maq = rw-grup-maquina.

find grup-maquina
    where rowid(grup-maquina) = rw-grup-maquina no-lock no-error.
if  avail grup-maquina then do:
    find calen-gener
        where calen-gener.cd-calen = grup-maquina.cd-calen no-lock no-error.

    find area-produc
        where area-produc.cod-area-produc = grup-maquina.cod-area-produc
        no-lock no-error.

	assign c-tip-ctrab:screen-value in frame {&frame-name} = f-tip-ctrab-2(c-tip-ctrab)
		   c-cd-calen:screen-value  in frame {&frame-name} = grup-maquina.cd-calen
           c-descricao:screen-value in frame {&frame-name} = if  avail calen-gener
                                                             then calen-gener.descricao
                                                             else ""
           c-area-produc:screen-value in frame {&frame-name} = grup-maquina.cod-area-produc
           c-des-area:screen-value    in frame {&frame-name} = if  avail area-produc
                                                               then area-produc.cod-area-produc
                                                               else ""
                                                               
           ctrab.qtd-capac-ctrab:screen-value in frame {&frame-name} = if  grup-maquina.num-maquinas > 0
                                                                       then string(grup-maquina.qtd-capac-ctrab / 
                                                                                   grup-maquina.num-maquinas, 
                                                                                   ">,>>>,>>9.9999")
                                                                       else string(grup-maquina.qtd-capac-ctrab,
                                                                                   ">,>>>,>>9.9999").
    if  avail ctrab then
        run pi-mostra-turno (input grup-maquina.gm-codigo,
                             input ctrab.cod-ctrab).
    else
        run pi-mostra-turno (input grup-maquina.gm-codigo,
                             input "":U).
    
    assign c-cod-turno:screen-value in frame {&frame-name} = c-cod-turno
           c-des-turno:screen-value in frame {&frame-name} = c-des-turno
           de-qtd-tempo-util-sem:screen-value in frame {&frame-name} = string(de-qtd-tempo-util-sem,">>9,99").
end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-turno V-table-Win 
PROCEDURE pi-mostra-turno :
def input param c-gm-codigo as char no-undo.
def input param c-cod-ctrab as char no-undo.

find first gm-turno-crp
    where gm-turno-crp.gm-codigo   = c-gm-codigo 
      and gm-turno-crp.dt-inicio  <= today
      and gm-turno-crp.dt-termino >  today no-lock no-error.
if  avail gm-turno-crp then
    find model-turno-semana
        where model-turno-semana.cod-model-turno = gm-turno-crp.cod-model-turno
        no-lock no-error.
else do:
    find first area-produc-ctrab
        where area-produc-ctrab.cod-ctrab       = c-cod-ctrab
          and area-produc-ctrab.dat-inic-valid <= today
          and area-produc-ctrab.dat-fim-valid  >  today no-lock no-error.
    if  avail area-produc-ctrab then do:

        find area-produc
            where area-produc.cod-area-produc = area-produc-ctrab.cod-area-produc
            no-lock no-error.
        if avail area-produc and area-produc.cod-model-turno <> "":U then
            find model-turno-semana
                where model-turno-semana.cod-model-turno = area-produc.cod-model-turno
                no-lock no-error.
        else do:
            find last param-sfc no-lock no-error.
            find model-turno-semana
                where model-turno-semana.cod-model-turno = param-sfc.cod-model-turno
                no-lock no-error.
        end.
    end.
    else do:
        find last param-sfc no-lock no-error.
        find model-turno-semana
            where model-turno-semana.cod-model-turno = param-sfc.cod-model-turno
            no-lock no-error.
    end.
end.

if  avail model-turno-semana then
    assign c-cod-turno           = model-turno-semana.cod-model-turno
           c-des-turno           = model-turno-semana.des-model-turno
           de-qtd-tempo-util-sem = model-turno-semana.qtd-tempo-util-sem.

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
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *      Este include deve ser colocado sempre antes do ut-msgs.p 
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "ctrab"}

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


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-tip-ctrab-1 B-table-Win 
FUNCTION f-tip-ctrab-1 RETURNS CHARACTER
  (c-tip-ctrab-aux as CHAR, cAux as char) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
ASSIGN cAuxTraducao001 = cAux .
RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
ASSIGN c-tip-ctrab-aux   = cAuxTraducao001.
&else
ASSIGN c-tip-ctrab-aux   = cAux .
&endif
  
RETURN c-tip-ctrab-aux.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-tip-ctrab-2 B-table-Win 
FUNCTION f-tip-ctrab-2 RETURNS CHARACTER
  ( c-tip-ctrab-aux as CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
ASSIGN cAuxTraducao001 = {ininc/i03in144.i 04 grup-maquina.ind-tip-ctrab}.
RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
ASSIGN c-tip-ctrab-aux    = cAuxTraducao001.
&else
ASSIGN c-tip-ctrab-aux    = {ininc/i03in144.i 04 grup-maquina.ind-tip-ctrab}.
&endif
  
RETURN c-tip-ctrab-aux.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


