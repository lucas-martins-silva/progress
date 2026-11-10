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

USING com.totvs.framework.utp.treelist.*.

{include/i-prgvrs.i V02IN278 2.00.00.003}  /*** "010003" 17/08/2023 09:58:03  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i V02IN278 MUT}
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

def new global shared var gr-ord-manut as rowid no-undo.
def new global shared var gr-ord-taref as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var l-problema    as logical    no-undo.
def var rw-ult-oper   as rowid      no-undo.
def var i-mensagem    as integer    no-undo.

def buffer b-p-ord-esp for p-ord-esp.
def buffer b-ord-taref for ord-taref.

def temp-table tt-nivel-pert no-undo
    field rw-p-ord-esp  as rowid
    field nivel         as integer
    index codigo is primary unique nivel rw-p-ord-esp.

DEFINE VARIABLE oTreeList   AS CLASS TotvsTreeList  NO-UNDO. // Visao

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ord-manut
&Scoped-define FIRST-EXTERNAL-TABLE ord-manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-detalhe bt-detalhe-pre 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cria-chave V-table-Win 
FUNCTION cria-chave RETURNS CHARACTER
  ( input cd-tarefa as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-detalhe 
     LABEL "" 
     SIZE 12 BY 1.13.

DEFINE BUTTON bt-detalhe-pre 
     LABEL "" 
     SIZE 12 BY 1.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bt-detalhe AT ROW 8.21 COL 1
     bt-detalhe-pre AT ROW 8.21 COL 73.86 WIDGET-ID 6
     SPACE(72.86) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-manut
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
         HEIGHT             = 8.5
         WIDTH              = 85.
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

&Scoped-define SELF-NAME bt-detalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhe V-table-Win
ON CHOOSE OF bt-detalhe IN FRAME f-main
DO:
    IF  oTreeList   <>  ?   AND oTreeList:hasNode() THEN    DO:

        ASSIGN  gr-ord-taref    =   TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid-visao")).

        if gr-ord-taref <> ? then do:
           assign {&window-name}:sensitive = no.
           run mip/mi0705a.w.
           assign {&window-name}:sensitive = yes.
        end.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalhe-pre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhe-pre V-table-Win
ON CHOOSE OF bt-detalhe-pre IN FRAME f-main
DO:
    IF  oTreeList   <>  ?   AND oTreeList:hasNode() THEN    DO:

        ASSIGN  gr-ord-taref    =   TO-ROWID(oTreeList:getDataChar(oTreeList:currentCode, "r-rowid")).

        if gr-ord-taref <> ? then do:
           assign {&window-name}:sensitive = no.
           run mip/mi0705a.w.
           assign {&window-name}:sensitive = yes.
        end.
    END.
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
  {src/adm/template/row-list.i "ord-manut"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-manut"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browseEvent V-table-Win 
PROCEDURE browseEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT   PARAMETER   cEvent  AS  CHARACTER   NO-UNDO.
    DEFINE  INPUT   PARAMETER   cNodeId AS  CHARACTER   NO-UNDO.

    IF  (cEvent =   "selected"  OR  cEvent  =   "value-changed")    AND cNodeId <>  ""  THEN    DO:
    END.

    RETURN  "OK".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize-controls V-table-Win 
PROCEDURE initialize-controls :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF  oTreeList   <>  ?   THEN
      DELETE  OBJECT  oTreeList   NO-ERROR.

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
  
  {utp/ut-liter.i Detalhar * l}
  assign bt-detalhe:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Predecessora * l}
  assign bt-detalhe-pre:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Detalhar_Tarefa * l}
  assign bt-detalhe:TOOLTIP in frame {&frame-name} = return-value.

  {utp/ut-liter.i Detalhar_Tarefa_Predecessora * l}
  assign bt-detalhe-pre:TOOLTIP in frame {&frame-name} = return-value.

  /* -------------------------- */
  /* Monta o Browse do TreeList */
  /* -------------------------- */
  IF  oTreeList   =   ?   THEN    DO:
    
      oTreeList               =   NEW TOTVSTreeList().
      oTreeList:parentFrame   =   FRAME   f-main:HANDLE.
      oTreeList:parentProg    =   THIS-PROCEDURE.
    
      oTreeList:setSize(1, 1, 84.5, 6.9).
    
      oTreeList:AddColumn("r-rowid"        , "character", 0, "x(256)", "", "", TRUE).
      oTreeList:AddColumn("r-rowid-visao"  , "character", 0, "x(256)", "", "", TRUE).
      oTreeList:AddColumn("p-image"        , "integer"  , 0, ">9"    , "", "", TRUE).
    
      {utp/ut-liter.i Tarefa *}
      oTreeList:AddColumn("cd-tarefa"      , "character", 0, "x(16)" , "", RETURN-VALUE, FALSE).
      {utp/ut-liter.i Descri‡Æo *}
      oTreeList:AddColumn("desc-tarefa"    , "character", 0, "x(35)" , "", RETURN-VALUE, FALSE).
      {utp/ut-liter.i Tarefa_Predec *}
      oTreeList:AddColumn("cd-tarefa-pre"  , "character", 0, "x(16)" , "", RETURN-VALUE, FALSE).
      {utp/ut-liter.i Descri‡Æo *}
      oTreeList:AddColumn("desc-tarefa-pre", "character", 0, "x(35)" , "", RETURN-VALUE, FALSE).
    
      oTreeList:INITIALIZE().
      oTreeList:emptyTreeList().
    
      ASSIGN  oTreeList:browseTreeList:FIT-LAST-COLUMN    =   TRUE.

      oTreeList:hideColumn("cEstrutura", TRUE).
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE    VARIABLE    i-cont  AS  INTEGER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN set-cursor IN adm-broker-hdl (INPUT "WAIT").
 
  for each tt-nivel-pert:
      delete tt-nivel-pert.
  end.
  
  assign bt-detalhe:sensitive     in frame {&frame-name} = no.
  assign bt-detalhe-pre:sensitive in frame {&frame-name} = no.

  IF  oTreeList   <>  ?   THEN    DO:
  
      oTreeList:emptyTreeList().
    
      if avail ord-manut then do:
         assign gr-ord-manut   = rowid (ord-manut)
                gr-ord-taref   = ?.
              
         find last ord-taref where 
                   ord-taref.nr-ord-produ = ord-manut.nr-ord-produ no-lock no-error.    
           
         assign rw-ult-oper = rowid (ord-taref).
    
         if avail ord-taref then do: 
                 
             for each p-ord-esp where 
                      p-ord-esp.nr-ord-prod = ord-manut.nr-ord-prod and 
                      p-ord-esp.cd-tarefa   = ord-taref.cd-tarefa no-lock:
                      
                 create tt-nivel-pert.
                 assign tt-nivel-pert.rw-p-ord-esp = rowid (p-ord-esp)
                        tt-nivel-pert.nivel         = 0.
                 run pi-navega-rede-pert (buffer p-ord-esp,
                                          input 1).                   
             end.
                    
             ASSIGN i-cont  =   0.

             for each tt-nivel-pert
                 by tt-nivel-pert.nivel DESC:
                 find p-ord-esp where
                      rowid (p-ord-esp) = tt-nivel-pert.rw-p-ord-esp no-lock.                        
                            
                 find ord-taref where
                      ord-taref.nr-ord-prod = ord-manut.nr-ord-prod and
                      ord-taref.cd-tarefa   = p-ord-esp.taref-pred  NO-LOCK no-error.
                           
                 find b-ord-taref where
                      b-ord-taref.nr-ord-prod = ord-manut.nr-ord-prod and
                      b-ord-taref.cd-tarefa   = p-ord-esp.cd-tarefa   no-lock no-error.
    
                 IF  AVAIL  ord-taref   AND AVAIL   b-ord-taref THEN    DO:
                     ASSIGN i-cont  =   i-cont  +   1.

                     oTreeList:addNode(""                  , "i" + STRING(i-cont), STRING(i-cont)).
                     oTreeList:setData("i" + STRING(i-cont), "p-image"           , 0).
                     oTreeList:setData("i" + STRING(i-cont), "r-rowid-visao"     , STRING(ROWID(b-ord-taref))).
                     oTreeList:setData("i" + STRING(i-cont), "r-rowid"           , STRING(ROWID(ord-taref))).

                     oTreeList:SetData("i" + STRING(i-cont), "cd-tarefa"         , b-ord-taref.cd-tarefa).
                     oTreeList:SetData("i" + STRING(i-cont), "desc-tarefa"       , b-ord-taref.descricao).
                     oTreeList:SetData("i" + STRING(i-cont), "cd-tarefa-pre"     , ord-taref.cd-tarefa).
                     oTreeList:SetData("i" + STRING(i-cont), "desc-tarefa-pre"   , ord-taref.descricao).
                 END.
             
                 find ord-taref where rowid (ord-taref) = rw-ult-oper no-lock.                                                
             end.
         end.                   
      end.                                                           
      
      oTreeList:REFRESH().

      IF  oTreeList:hasNode() THEN  DO:
          assign bt-detalhe:sensitive     in frame {&frame-name} = YES.
          assign bt-detalhe-pre:sensitive in frame {&frame-name} = YES.
      END.
  END.

  RUN set-cursor IN adm-broker-hdl (INPUT "").

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-navega-rede-pert V-table-Win 
PROCEDURE pi-navega-rede-pert :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define parameter buffer b1-p-ord-esp for p-ord-esp.
define input parameter  i-nivel       as integer no-undo.

define buffer b2-p-ord-esp for p-ord-esp.
for each  b2-p-ord-esp 
    where b2-p-ord-esp.nr-ord-prod = ord-manut.nr-ord-prod
      and b2-p-ord-esp.cd-tarefa   = b1-p-ord-esp.taref-pred no-lock:   
      
    if not can-find (tt-nivel-pert where
                     tt-nivel-pert.rw-p-ord-esp = rowid (b2-p-ord-esp) and
                     tt-nivel-pert.nivel        = i-nivel) then do:  
      
        create tt-nivel-pert.
        assign tt-nivel-pert.rw-p-ord-esp = rowid (b2-p-ord-esp)
               tt-nivel-pert.nivel        = i-nivel.  
    end.
    
    run pi-navega-rede-pert (buffer b2-p-ord-esp,
                             input  i-nivel + 1).
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
  {src/adm/template/snd-list.i "ord-manut"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cria-chave V-table-Win 
FUNCTION cria-chave RETURNS CHARACTER
  ( input cd-tarefa as char) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

     RETURN lc(cd-tarefa).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

