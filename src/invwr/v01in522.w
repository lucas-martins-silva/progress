&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V01IN522 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN522 MUT}
&ENDIF


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
def var v-row-parent as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES ctrab-ic
&Scoped-define FIRST-EXTERNAL-TABLE ctrab-ic


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ctrab-ic.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ctrab-ic.dif-data-min ctrab-ic.dif-data-max ~
ctrab-ic.nr-max-esc ctrab-ic.vl-minimo ctrab-ic.vl-maximo ~
ctrab-ic.log-obrigat 
&Scoped-define ENABLED-TABLES ctrab-ic
&Scoped-define FIRST-ENABLED-TABLE ctrab-ic
&Scoped-define DISPLAYED-TABLES ctrab-ic
&Scoped-define FIRST-DISPLAYED-TABLE ctrab-ic
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS ctrab-ic.cod-ctrab ctrab-ic.cod-ic ~
ctrab-ic.dif-data-min ctrab-ic.dif-data-max ctrab-ic.nr-max-esc ~
ctrab-ic.vl-minimo ctrab-ic.vl-maximo ctrab-ic.log-obrigat 
&Scoped-Define DISPLAYED-OBJECTS c-des-ctrab c-des-ic 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ctrab-ic.cod-ic 
&Scoped-define ADM-ASSIGN-FIELDS ctrab-ic.dif-data-min ~
ctrab-ic.dif-data-max ctrab-ic.vl-minimo ctrab-ic.vl-maximo 
&Scoped-define ADM-MODIFY-FIELDS ctrab-ic.dif-data-min ~
ctrab-ic.dif-data-max ctrab-ic.vl-minimo ctrab-ic.vl-maximo 

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
DEFINE VARIABLE c-des-ctrab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-ic AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 6.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ctrab-ic.cod-ctrab AT ROW 1.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-des-ctrab AT ROW 1.17 COL 46.57 COLON-ALIGNED NO-LABEL
     ctrab-ic.cod-ic AT ROW 2.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-des-ic AT ROW 2.17 COL 38.57 COLON-ALIGNED NO-LABEL
     ctrab-ic.dif-data-min AT ROW 3.67 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     ctrab-ic.dif-data-max AT ROW 4.67 COL 29.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     ctrab-ic.nr-max-esc AT ROW 5.67 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     ctrab-ic.vl-minimo AT ROW 6.67 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     ctrab-ic.vl-maximo AT ROW 7.67 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     ctrab-ic.log-obrigat AT ROW 8.67 COL 31.29
          VIEW-AS TOGGLE-BOX
          SIZE 29 BY .83
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ctrab-ic
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
         HEIGHT             = 8.67
         WIDTH              = 85.29.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-ctrab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-ic IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ctrab-ic.cod-ctrab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ctrab-ic.cod-ic IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN ctrab-ic.dif-data-max IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN ctrab-ic.dif-data-min IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN ctrab-ic.vl-maximo IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN ctrab-ic.vl-minimo IN FRAME f-main
   2 3                                                                  */
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

&Scoped-define SELF-NAME ctrab-ic.cod-ic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ctrab-ic.cod-ic V-table-Win
ON F5 OF ctrab-ic.cod-ic IN FRAME f-main /* Item Controle */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in482.w"
                     &campo=ctrab-ic.cod-ic
                     &campozoom=cod-ic}
  apply 'leave' to ctrab-ic.cod-ic in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ctrab-ic.cod-ic V-table-Win
ON LEAVE OF ctrab-ic.cod-ic IN FRAME f-main /* Item Controle */
DO:
  {include/leave.i &tabela=item-controle 
                   &atributo-ref=des-ic
                   &variavel-ref=c-des-ic
                   &where="item-controle.cod-ic = input frame {&frame-name} ctrab-ic.cod-ic"}

  if  avail item-controle then do:
  
      case item-controle.tip-result:
          when 1 then do:
              assign ctrab-ic.vl-minimo:format in frame {&frame-name} = item-controle.formato
                     ctrab-ic.vl-maximo:format in frame {&frame-name} = item-controle.formato.
              if adm-new-record = yes then        
                  assign ctrab-ic.vl-minimo:screen-value in frame {&frame-name} = string(0,item-controle.formato)
                         ctrab-ic.vl-maximo:screen-value in frame {&frame-name} = string(0,item-controle.formato).
              else            
                  assign ctrab-ic.vl-minimo:screen-value in frame {&frame-name} = string(ctrab-ic.vl-minimo,item-controle.formato)
                         ctrab-ic.vl-maximo:screen-value in frame {&frame-name} = string(ctrab-ic.vl-maximo,item-controle.formato).
             
              disable ctrab-ic.dif-data-min
                      ctrab-ic.dif-data-max
                      ctrab-ic.nr-max-esc
                      with frame {&frame-name}.
              enable ctrab-ic.vl-minimo
                     ctrab-ic.vl-maximo
                     with frame {&frame-name}.
              apply 'entry' to ctrab-ic.vl-minimo in frame {&frame-name}.
              RETURN NO-APPLY.
              
          end.
          
          when 2 then do:
              disable ctrab-ic.dif-data-min
                      ctrab-ic.dif-data-max
                      ctrab-ic.vl-minimo
                      ctrab-ic.vl-maximo
                      with frame {&frame-name}.
              enable ctrab-ic.nr-max-esc
                     with frame {&frame-name}.
              apply 'entry' to ctrab-ic.nr-max-esc in frame {&frame-name}.
              RETURN NO-APPLY.
          end.
          
          when 3 then do:
              disable ctrab-ic.dif-data-min
                      ctrab-ic.dif-data-max
                      ctrab-ic.nr-max-esc
                      ctrab-ic.vl-minimo
                      ctrab-ic.vl-maximo
                      with frame {&frame-name}.
          end.      

          when 4 then do:
              disable ctrab-ic.vl-minimo
                      ctrab-ic.vl-maximo
                      ctrab-ic.nr-max-esc
                      with frame {&frame-name}.
              enable ctrab-ic.dif-data-min
                     ctrab-ic.dif-data-max
                     with frame {&frame-name}.
              apply 'entry' to ctrab-ic.dif-data-min in frame {&frame-name}.
              RETURN NO-APPLY.
          end.      
      end case.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ctrab-ic.cod-ic V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ctrab-ic.cod-ic IN FRAME f-main /* Item Controle */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

ctrab-ic.cod-ic:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name}.

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
  {src/adm/template/row-list.i "ctrab-ic"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ctrab-ic"}

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

  /* Code placed here will execute AFTER standard behavior.    */
    
    find ctrab
        where rowid(ctrab) = v-row-parent no-lock no-error.
    if  avail ctrab then do:
        assign ctrab-ic.cod-ctrab:screen-value in frame {&frame-name} = ctrab.cod-ctrab
               c-des-ctrab:screen-value in frame {&frame-name} = ctrab.des-ctrab.
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
    
    def var c-aux as char format "x(20)".

    /* Code placed here will execute PRIOR to standard behavior. */
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.
    
    find item-controle
        where item-controle.cod-ic = input frame {&frame-name} ctrab-ic.cod-ic
        no-lock no-error.
    if  not avail item-controle then do:
        {utp/ut-table.i mgind item-controle 1}
        run utp/ut-msgs.p (input "show":U, 
                           input 2, 
                           input return-value).
        apply 'entry' to ctrab-ic.cod-ic in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    
    if  item-controle.log-ic-ctrab = no then do:
        
        {utp/ut-table.i mgind item-controle 1}
        assign c-aux = return-value.
        {utp/ut-table.i mgind ctrab 1}
        
        run utp/ut-msgs.p (input "show":U, 
                           input 17599, 
                           input  c-aux + "~~" + return-value).
        apply 'entry' to ctrab-ic.cod-ic in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    
/*     IF  item-controle.tip-result = 1 AND                                             */
/*            ctrab-ic.log-obrigat:CHECKED IN FRAME {&frame-name} AND                   */
/*            int(ctrab-ic.vl-maximo:SCREEN-VALUE IN frame {&frame-name}) <= 0 THEN DO: */
/*         {utp/ut-table.i mgind ctrab 1}                                               */
/*         run utp/ut-msgs.p (input "show":U,                                           */
/*                            input 4700,                                               */
/*                            input ctrab-ic.vl-maximo:LABEL IN FRAME {&FRAME-NAME}).   */
/*         apply 'entry' to ctrab-ic.vl-maximo in frame {&frame-name}.                  */
/*         return 'ADM-ERROR':U.                                                        */
/*     END.                                                                             */

    if  adm-new-record = yes then do:
        find ctrab-ic
            where ctrab-ic.cod-ctrab = input frame {&frame-name} ctrab-ic.cod-ctrab
              and ctrab-ic.cod-ic    = input frame {&frame-name} ctrab-ic.cod-ic
            no-lock no-error.
        if  avail ctrab-ic then do:
            {utp/ut-table.i mgind ctrab-ic 1}
            run utp/ut-msgs.p (input "show":U, 
                               input 7, 
                               input return-value).
            apply 'entry' to ctrab-ic.cod-ic in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.
    
    if  item-controle.tip-result = 1
    and input frame {&frame-name} ctrab-ic.vl-max < input frame {&frame-name} ctrab-ic.vl-min then do:
        run utp/ut-msgs.p (input "show":U, 
                           input 692, 
                           input  "":U + "~~" + "":U).
        apply 'entry' to ctrab-ic.vl-max in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    if  item-controle.tip-result = 2
    and input frame {&frame-name} ctrab-ic.nr-max-esc <= 0 then do:

        {utp/ut-field.i mgind ctrab-ic nr-max-esc 1}
        run utp/ut-msgs.p (input "show":U, 
                           input 36, 
                           input return-value).
        apply 'entry' to ctrab-ic.nr-max-esc in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

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

  /* Code placed here will execute AFTER standard behavior.    */

  find ctrab
      where rowid(ctrab) = v-row-parent EXCLUSIVE-LOCK no-error.
  if available ctrab then do:
      assign ctrab-ic.cod-ctrab = ctrab.cod-ctrab.
  end.


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

  if   available ctrab-ic then do:
       find ctrab
           where ctrab.cod-ctrab = ctrab-ic.cod-ctrab no-lock no-error.
       assign c-des-ctrab = if  avail ctrab
                            then ctrab.des-ctrab
                            else "":U.
       find item-controle
           where item-controle.cod-ic = ctrab-ic.cod-ic no-lock no-error.
       assign c-des-ic = if  avail item-controle
                         then item-controle.des-ic
                         else "":U.
  end.

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
         if  adm-new-record = yes then
             enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    if  adm-new-record = yes then do:
        disable ctrab-ic.dif-data-min
                ctrab-ic.dif-data-max
                ctrab-ic.nr-max-esc
                ctrab-ic.vl-min
                ctrab-ic.vl-max
                with frame {&frame-name}.
    end.
    else
        apply 'leave' to ctrab-ic.cod-ic in frame {&frame-name}.

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
    
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
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
  {src/adm/template/snd-list.i "ctrab-ic"}

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

