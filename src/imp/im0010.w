&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-cadpaifilho-ambos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadpaifilho-ambos 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0010 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0010 MIM}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var p-table as rowid.

def var c-param as char no-undo.
def var r-chave as rowid no-undo.

/* Defini‡Æo de Pr‚-Processadores */

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar validação produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-paiamb
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button bt-fir bt-pre bt-nex bt-las bt-go ~
bt-sea bt-add bt-cop bt-del bt-aprov bt-joi bt-pri bt-exi bt-hel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadpaifilho-ambos AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-arquivo 
       MENU-ITEM mi-primeiro    LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM mi-anterior    LABEL "An&terior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM mi-proximo     LABEL "Pr&¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM mi-ultimo      LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       MENU-ITEM mi-va-para     LABEL "&V  para"       ACCELERATOR "CTRL-T"
       MENU-ITEM mi-pesquisa    LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM mi-incluir     LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM mi-copiar      LABEL "C&opiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM mi-alterar     LABEL "A&lterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM mi-eliminar    LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU mi-ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-cadastro MENUBAR
       SUB-MENU  mi-arquivo     LABEL "&Arquivo"      
       SUB-MENU  mi-ajuda       LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_im0010-b01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_im0010-v01 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-add 
     IMAGE-UP FILE "image~\im-add":U
     IMAGE-INSENSITIVE FILE "image~\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-aprov 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Mapa para Aprova‡Æo"
     FONT 4.

DEFINE BUTTON bt-cop 
     IMAGE-UP FILE "image~\im-copy":U
     IMAGE-INSENSITIVE FILE "image~\ii-copy":U
     LABEL "Cop" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image~\im-era":U
     IMAGE-INSENSITIVE FILE "image~\ii-era":U
     LABEL "Del" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-exi 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exi" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-fir 
     IMAGE-UP FILE "image~\im-fir":U
     IMAGE-INSENSITIVE FILE "image~\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-go 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "go" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-hel 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Hel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-joi 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Joi" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-las 
     IMAGE-UP FILE "image~\im-las":U
     IMAGE-INSENSITIVE FILE "image~\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-nex 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-pre 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-pri 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Imp" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-sea 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "sea" 
     SIZE 4 BY 1.25.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.46
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-fir AT ROW 1.17 COL 1.57 HELP
          "Primeira ocorrˆncia"
     bt-pre AT ROW 1.17 COL 5.57 HELP
          "Ocorrˆncia anterior"
     bt-nex AT ROW 1.17 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     bt-las AT ROW 1.17 COL 13.57 HELP
          "éltima ocorrˆncia"
     bt-go AT ROW 1.17 COL 17.57 HELP
          "V  Para"
     bt-sea AT ROW 1.17 COL 21.57 HELP
          "Pesquisa"
     bt-add AT ROW 1.17 COL 29 HELP
          "Inclui nova ocorrˆncia"
     bt-cop AT ROW 1.17 COL 33 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     bt-del AT ROW 1.17 COL 37 HELP
          "Elimina ocorrˆncia corrente"
     bt-aprov AT ROW 1.17 COL 69 HELP
          "Mapa para Aprova‡Æo"
     bt-joi AT ROW 1.17 COL 74.57 HELP
          "Consultas relacionadas"
     bt-pri AT ROW 1.17 COL 78.57 HELP
          "Relat¢rios relacionados"
     bt-exi AT ROW 1.17 COL 82.57 HELP
          "Sair"
     bt-hel AT ROW 1.17 COL 86.57 HELP
          "Ajuda"
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.13.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-paiamb
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadpaifilho-ambos ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 15.88
         WIDTH              = 90
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.21
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-cadastro:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadpaifilho-ambos 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadpaifilho-ambos
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadpaifilho-ambos)
THEN w-cadpaifilho-ambos:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadpaifilho-ambos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadpaifilho-ambos w-cadpaifilho-ambos
ON END-ERROR OF w-cadpaifilho-ambos /* Manuten‡Æo <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadpaifilho-ambos w-cadpaifilho-ambos
ON WINDOW-CLOSE OF w-cadpaifilho-ambos /* Manuten‡Æo <Insira o complemento> */
DO:  
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add w-cadpaifilho-ambos
ON CHOOSE OF bt-add IN FRAME f-cad /* Add */
DO:
  assign c-param = "add".
  run pi-principal in h_im0010-v01 (input c-param).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-aprov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-aprov w-cadpaifilho-ambos
ON CHOOSE OF bt-aprov IN FRAME f-cad
DO:
  assign c-param = "aprova".
  RUN pi-principal in h_im0010-v01(input c-param).   
  assign c-param = "atualiza".
  RUN pi-principal in h_im0010-v01(input c-param).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cop w-cadpaifilho-ambos
ON CHOOSE OF bt-cop IN FRAME f-cad /* Cop */
DO:
  assign c-param = "cop".
  run pi-principal in h_im0010-v01 (input c-param).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del w-cadpaifilho-ambos
ON CHOOSE OF bt-del IN FRAME f-cad /* Del */
DO:
  assign c-param = "del".
  RUN pi-principal in h_im0010-v01 (input c-param).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exi w-cadpaifilho-ambos
ON CHOOSE OF bt-exi IN FRAME f-cad /* Exi */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fir w-cadpaifilho-ambos
ON CHOOSE OF bt-fir IN FRAME f-cad /* First */
DO:
  assign c-param = "pri".
  run pi-principal in h_im0010-v01 (input c-param).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-go
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-go w-cadpaifilho-ambos
ON CHOOSE OF bt-go IN FRAME f-cad /* go */
DO:
  assign c-param = "go".
  RUN pi-principal in h_im0010-v01 (input c-param).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-las
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-las w-cadpaifilho-ambos
ON CHOOSE OF bt-las IN FRAME f-cad /* Last */
DO:
  assign c-param = "ult".
  run pi-principal in h_im0010-v01 (input c-param).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nex w-cadpaifilho-ambos
ON CHOOSE OF bt-nex IN FRAME f-cad /* Next */
DO:
  assign c-param = "pos".
  run pi-principal in h_im0010-v01 (input c-param).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pre w-cadpaifilho-ambos
ON CHOOSE OF bt-pre IN FRAME f-cad /* Prev */
DO:
  assign c-param = "pre".
  run pi-principal in h_im0010-v01 (input c-param).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-sea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sea w-cadpaifilho-ambos
ON CHOOSE OF bt-sea IN FRAME f-cad /* sea */
DO:
  assign c-param = "zoom".
  run pi-principal in h_im0010-v01(input c-param).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadpaifilho-ambos 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */

{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadpaifilho-ambos  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'imp/im0010-v01.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_im0010-v01 ).
       RUN set-position IN h_im0010-v01 ( 2.75 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.50 , 90.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/folder.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Despesas' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 7.50 , 1.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 9.25 , 90.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'imp/im0010-b01.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_im0010-b01 ).
       RUN set-position IN h_im0010-b01 ( 8.88 , 2.29 ) NO-ERROR.
       /* Size in UIB:  ( 7.50 , 88.00 ) */

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_im0010-v01 ,
             bt-hel:HANDLE IN FRAME f-cad , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             h_im0010-v01 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_im0010-b01 ,
             h_folder , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadpaifilho-ambos  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadpaifilho-ambos  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadpaifilho-ambos)
  THEN DELETE WIDGET w-cadpaifilho-ambos.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadpaifilho-ambos  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE rt-button bt-fir bt-pre bt-nex bt-las bt-go bt-sea bt-add bt-cop 
         bt-del bt-aprov bt-joi bt-pri bt-exi bt-hel 
      WITH FRAME f-cad IN WINDOW w-cadpaifilho-ambos.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadpaifilho-ambos.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadpaifilho-ambos 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadpaifilho-ambos 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/ 
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadpaifilho-ambos 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

{utp/ut9000.i "IM0010" "2.00.00.009"}
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .  
  
  assign c-param = "pri".
  RUN pi-passa-handle in h_im0010-v01 (input h_im0010-b01, input this-procedure).  
  RUN pi-principal    in h_im0010-v01 (input c-param).
  RUN pi-passa-handle IN h_im0010-b01 (INPUT h_im0010-v01, INPUT THIS-PROCEDURE).

  &IF '{&mgdis_version}' < '2.06f' &THEN
      /*Tecnica para implementar valida‡Æo produto Estendido*/
      {cdp/cdapi558.i1}
  &endif
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disable-panel w-cadpaifilho-ambos 
PROCEDURE pi-disable-panel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-aprovado as logical no-undo.

    if p-aprovado = yes then
       disable bt-aprov with frame f-cad.
    else
       enable bt-aprov with frame f-cad.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disable-panel2 w-cadpaifilho-ambos 
PROCEDURE pi-disable-panel2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    disable bt-aprov bt-cop bt-del with frame f-cad.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-enable-panel w-cadpaifilho-ambos 
PROCEDURE pi-enable-panel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     ENABLE bt-aprov bt-cop bt-del with frame f-cad.

     RETURN "ok":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-cadpaifilho-ambos 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN imp/im0010-v01.w.
  RUN adm/objects/folder.w.
  RUN imp/im0010-b01.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadpaifilho-ambos  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-paiamb, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

