&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            ORACLE
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
{include/i-prgvrs.i V02IN671 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN671 MUT}
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
def new global shared var v_cod_unid_negoc   as character  format "x(3)"    
                      label "Unid NegΩcio" column-label "Un Neg"   no-undo.

/* Parameters Definitions ---                                           */

def temp-table tt_unid_negoc no-undo
    field cod_unid_negoc               as character format "x(3)"  label "Unid Neg¢cio" column-label "Un Neg"
    field des_unid_negoc               as character format "x(40)" label "Descriá∆o" column-label "Descriá∆o"
    field cdn_unid_negoc               as Integer   format ">>9"   initial 0 label "N£mero Unidade Negoc" column-label "Numero UN".

def var l-conecta-emsuni as log no-undo.
def var l-conecta-emsbas as log no-undo.
def var l-erro           as log no-undo.

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

{btb/btb009za.i}
{cdp/cdcfgmat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-mat
&Scoped-define FIRST-EXTERNAL-TABLE param-mat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-mat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-mat.ind-unid-neg ~
param-mat.pede-unid-neg-cc param-mat.log-1 
&Scoped-define ENABLED-TABLES param-mat
&Scoped-define FIRST-ENABLED-TABLE param-mat
&Scoped-Define ENABLED-OBJECTS rt-mold-10 rt-mold-9 rt-mold-11 
&Scoped-Define DISPLAYED-FIELDS param-mat.ind-unid-neg ~
param-mat.pede-unid-neg-cc param-mat.log-1 
&Scoped-define DISPLAYED-TABLES param-mat
&Scoped-define FIRST-DISPLAYED-TABLE param-mat
&Scoped-Define DISPLAYED-OBJECTS cod-unid-neg desc-unid-neg 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cod-unid-neg 
&Scoped-define ADM-ASSIGN-FIELDS cod-unid-neg 
&Scoped-define ADM-MODIFY-FIELDS cod-unid-neg 

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
DEFINE VARIABLE cod-unid-neg AS CHARACTER FORMAT "x(3)" 
     LABEL "Unidade Neg¢cio Padr∆o" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE desc-unid-neg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.86 BY 2.13.

DEFINE RECTANGLE rt-mold-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.86 BY 2.13.

DEFINE RECTANGLE rt-mold-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.86 BY 7.21.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-mat.ind-unid-neg AT ROW 1.63 COL 3.14
          VIEW-AS TOGGLE-BOX
          SIZE 19.43 BY .83
     param-mat.pede-unid-neg-cc AT ROW 1.63 COL 31
          VIEW-AS TOGGLE-BOX
          SIZE 47.14 BY .83
     param-mat.log-1 AT ROW 3.92 COL 3
          LABEL "Siscoserv Aquisiá∆o"
          VIEW-AS TOGGLE-BOX
          SIZE 21.86 BY .83
     cod-unid-neg AT ROW 6.08 COL 1.72
     desc-unid-neg AT ROW 6.08 COL 32.14 COLON-ALIGNED NO-LABEL
     rt-mold-10 AT ROW 1 COL 1
     rt-mold-9 AT ROW 5.5 COL 1
     rt-mold-11 AT ROW 3.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-mat
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
         HEIGHT             = 11.88
         WIDTH              = 82.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cod-unid-neg IN FRAME f-main
   NO-ENABLE ALIGN-L 1 2 3                                              */
/* SETTINGS FOR FILL-IN desc-unid-neg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX param-mat.log-1 IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME cod-unid-neg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-unid-neg V-table-Win
ON F5 OF cod-unid-neg IN FRAME f-main /* Unidade Neg¢cio Padr∆o */
DO:
    if  search("prgint/utb/utb011ka.p") <> ? 
    or  search("prgint/utb/utb011ka.r") <> ? 
    and connected("emsbas") then do:

        run prgint/utb/utb011ka.p  persistent set wh-pesquisa.

        if  v_cod_unid_negoc <> " " then 
            assign cod-unid-neg:screen-value in frame {&frame-name} = v_cod_unid_negoc.
    end.        

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-unid-neg V-table-Win
ON LEAVE OF cod-unid-neg IN FRAME f-main /* Unidade Neg¢cio Padr∆o */
DO:
    for each tt_unid_negoc:
        delete tt_unid_negoc.
    end.

    create tt_unid_negoc.
    assign tt_unid_negoc.cod_unid_negoc = input frame {&frame-name} cod-unid-neg.

    if  search("prgint/utb/utb907za.py":U) <> ?
    or  search("prgint/utb/utb907za.r":U) <> ? 
    and connected("emsbas") then do:
        run prgint/utb/utb907za.py ( input 1,
                                     input-output table tt_unid_negoc ).
    end.

    find first tt_unid_negoc no-lock no-error.

    assign desc-unid-neg:screen-value in frame {&frame-name} = tt_unid_negoc.des_unid_negoc.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-unid-neg V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cod-unid-neg IN FRAME f-main /* Unidade Neg¢cio Padr∆o */
DO:
    apply "f5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-mat.ind-unid-neg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mat.ind-unid-neg V-table-Win
ON VALUE-CHANGED OF param-mat.ind-unid-neg IN FRAME f-main /* Unidade Neg¢cio */
DO:

    if  param-mat.ind-unid-neg:checked in frame {&frame-name} = yes then
        assign param-mat.pede-unid-neg-cc:sensitive in frame {&frame-name} = yes.
    else do:
        assign param-mat.pede-unid-neg-cc:checked   in frame {&frame-name} = no
               param-mat.pede-unid-neg-cc:sensitive in frame {&frame-name} = no.        
    end.                   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  find first param-mat EXCLUSIVE-LOCK NO-ERROR .
  if  not avail param-mat then
      create param-mat.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

    {utp/ut-liter.i Sempre_pede_Unidade_Neg¢cio * r}
    assign param-mat.pede-unid-neg-cc:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Unidade_Neg¢cio_Padr∆o * r}
    assign cod-unid-neg:label in frame {&frame-name} = trim(return-value).

    cod-unid-neg:load-mouse-pointer("image/lupa.cur":U) in frame {&frame-name}.

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
  {src/adm/template/row-list.i "param-mat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-mat"}

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

    &if '{&bf_mat_versao_ems}' < '2.062' &then
        if  desc-unid-neg:screen-value in frame {&frame-name} = "" 
        and cod-unid-neg:sensitive in frame {&frame-name} then do:
            {utp/ut-field.i movind unid-neg-nota cod_unid_negoc 1}
            run utp/ut-msgs.p (input "show":U, input 56, input return-value).
            apply "entry":U to cod-unid-neg in frame {&frame-name}.
            return "adm-error":U.
        end.
    &endif

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    &if '{&bf_mat_versao_ems}' < '2.062' &then
        if avail param-mat then
            assign substr(param-mat.char-1,1,3) = string(input frame {&frame-name} cod-unid-neg,"x(3)").
    &else
        find first para-dis exclusive-lock no-error.
        if avail para-dis then
            assign para-dis.log-unid-neg = param-mat.ind-unid-neg.
    &endif

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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

  run pi-conecta-ems5(no,output l-erro).

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
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    find first param-mat EXCLUSIVE-LOCK no-error. 

    if (can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00"
                          and funcao.ativo = yes
                          and funcao.log-1 = yes) or    
        can-find(funcao where funcao.cd-funcao = "adm-cfl-ems-5.00"
                          and funcao.ativo = yes
                          and funcao.log-1 = yes) 
        &if '{&bf_mat_versao_ems}' >= '2.062' &then
            or can-find(funcao where funcao.cd-funcao = "ems2-unidade-negocio"
                          and   funcao.ativo = yes)
        &endif 
        ) then do:

        assign param-mat.ind-unid-neg:sensitive in frame {&frame-name} = yes.

        &if '{&bf_mat_versao_ems}' < '2.062' &then
            if param-mat.ind-unid-neg:checked in frame {&frame-name} = yes then do:
                assign param-mat.pede-unid-neg-cc:sensitive in frame {&frame-name} = yes.
            end.
            else do:
                assign param-mat.pede-unid-neg-cc:checked   in frame {&frame-name} = no
                       param-mat.pede-unid-neg-cc:sensitive in frame {&frame-name} = no.
            end.

            assign cod-unid-neg:sensitive    in frame {&frame-name} = yes
                   cod-unid-neg:screen-value in frame {&frame-name} = if  avail param-mat then
                                                                      substr(param-mat.char-1,1,3)
                                                                      else "".
            apply "leave":U to cod-unid-neg in frame {&frame-name}.                         
        &endif
    end.
    else do:
        assign param-mat.ind-unid-neg                                      = no
               param-mat.ind-unid-neg:checked       in frame {&frame-name} = no
               param-mat.ind-unid-neg:sensitive     in frame {&frame-name} = no
               &if '{&bf_mat_versao_ems}' < '2.062' &then
                   param-mat.pede-unid-neg-cc                                  = no
                   param-mat.pede-unid-neg-cc:checked   in frame {&frame-name} = no
                   param-mat.pede-unid-neg-cc:sensitive in frame {&frame-name} = no
                   cod-unid-neg:sensitive               in frame {&frame-name} = no
                   cod-unid-neg:screen-value            in frame {&frame-name} = ""
               &endif
               .
    end.
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

if (can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00"
                      and funcao.ativo = yes
                      and funcao.log-1 = yes) or    
    can-find(funcao where funcao.cd-funcao = "adm-cfl-ems-5.00"
                      and funcao.ativo = yes
                      and funcao.log-1 = yes)) then do:
  run pi-conecta-ems5(yes,output l-erro).
  if  l-erro then
      apply "close":U to this-procedure.
end.    

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
 
  /*UNIDADE DE NEG‡CIO - 206B*/
  &if '{&bf_mat_versao_ems}' >= '2.062' &then
      param-mat.pede-unid-neg-cc:hidden in frame f-main = yes.
      cod-unid-neg:hidden               in frame f-main = yes.
      desc-unid-neg:hidden              in frame f-main = yes.
      rt-mold-9:hidden                  in frame f-main = yes.
  &endif
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conecta-ems5 V-table-Win 
PROCEDURE pi-conecta-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param  l-conecta as logical no-undo.
    def output param l-erro    as logical no-undo.
    DEF VAR h-btb009za AS HANDLE.

    RUN btb/btb009za.p PERSISTENT SET h-btb009za.    

    assign l-erro = no.

    find first param-global no-lock no-error.

    if  l-conecta then do:
        if  not connected("emsuni") or 
            not connected("emsbas")  then do:
            run pi-conecta-bco IN h-btb009za (Input 1,          /*versao api */
                                              Input 1,          /* 1 - conex∆o, 2 - desconex∆o */
                                              Input param-global.empresa-prin,  /* cod empresa*/
                                              Input "all", 
                                              Output Table tt_erros_conexao).            
            if return-value <> "OK":U then do:
               assign l-erro = yes.
               for each tt_erros_conexao:
                   run utp/ut-msgs.p ( input "show",
                                       input tt_erros_conexao.cd-erro,
                                       input tt_erros_conexao.param-1).
               end.
            end.                   
            else                                
               assign l-conecta-emsuni = yes
                      l-conecta-emsbas = yes.
        end. 
    end.

    if  not l-conecta or l-erro then do:
        if  connected("emsuni") and l-conecta-emsuni or 
            connected("emsbas") and l-conecta-emsbas then do:
            run pi-conecta-bco IN h-btb009za (Input 1,          /*versao api */
                                              Input 2,         /* 1 - conex∆o, 2 - desconex∆o */
                                              Input param-global.empresa-prin,  /* cod empresa*/
                                              Input "all", 
                                              Output Table tt_erros_conexao).            
            if return-value <> "OK":U then do:
               assign l-erro = yes.
               for each tt_erros_conexao:
                   run utp/ut-msgs.p ( input "show",
                                       input tt_erros_conexao.cd-erro,
                                       input tt_erros_conexao.param-1).
               end.
            end.                                                  
        end.    
    end.                

    DELETE PROCEDURE h-btb009za.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

/*/*    Segue um exemplo de validaá∆o de programa */
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
  {src/adm/template/snd-list.i "param-mat"}

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

