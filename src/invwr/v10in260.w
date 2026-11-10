&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 

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
{include/i-prgvrs.i V10IN260 2.00.01.024 } /*** "010124" 09/09/2025 09:39:57 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v10in260 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgman.i}   /* Variÿvel preprocessador bf_man_sfc_lc */ 

/* global variable definitions */
def new global shared var gr-ord-prod as rowid no-undo.
def new global shared var gr-oper-ord as rowid no-undo.
def new global shared var gr-grup-maquina as rowid no-undo.
def new global shared var gr-ctrab as rowid no-undo.

{include/i-vrtab.i split-operac}
{include/i-vrtab.i area-produc-ctrab}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent   as rowid         no-undo.
def var i-tipo         as int initial 1 no-undo.
def var i-un           as int  no-undo.
def var i-nr-unidades  as int  no-undo.
def var i-numero-homem as int  no-undo.
def var c-mob-dir      as char no-undo.
def var l-flag         as log  no-undo.
def var de-qtde        like ord-prod.qt-ordem no-undo.
def var c-un           as char format "x(2)"  no-undo.
def var p-ctrab        as char format "x(16)" no-undo.
def var p-tempo-sig    as log no-undo.

define buffer b-oper-ord for oper-ord.
DEF BUFFER b-item FOR ITEM.
DEFINE VARIABLE l-mudancas-sfc AS LOGICAL INIT NO  NO-UNDO.
DEFINE VARIABLE h-pag1 AS HANDLE     NO-UNDO.
{method/dbotterr.i} /*rowErrors*/
DEFINE VARIABLE hShowMsg AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boin535 AS HANDLE     NO-UNDO.
DEF NEW GLOBAL SHARED VAR glob-estabel-zoom AS CHAR INIT ? NO-UNDO.

DEFINE VARIABLE hProgramZoom AS HANDLE     NO-UNDO.

DEFINE VARIABLE l-add-record AS LOGICAL INIT NO NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES oper-ord
&Scoped-define FIRST-EXTERNAL-TABLE oper-ord


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR oper-ord.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS oper-ord.numero-homem oper-ord.cd-mob-dir ~
oper-ord.emite-ficha oper-ord.oper-cq oper-ord.ferramenta oper-ord.revisao ~
oper-ord.fator-sobrep oper-ord.proporcao oper-ord.nr-unidades ~
oper-ord.val-perc-avanco oper-ord.cod-item-refugo ~
oper-ord.val-relac-refugo-item oper-ord.cod-grp-setup 
&Scoped-define ENABLED-TABLES oper-ord
&Scoped-define FIRST-ENABLED-TABLE oper-ord
&Scoped-Define ENABLED-OBJECTS fi-ctrab tg-tempo-sig fi-un-operac fi-perc ~
RECT-refugo rt-mold 
&Scoped-Define DISPLAYED-FIELDS oper-ord.numero-homem oper-ord.cd-mob-dir ~
oper-ord.emite-ficha oper-ord.oper-cq oper-ord.ferramenta oper-ord.revisao ~
oper-ord.fator-sobrep oper-ord.proporcao oper-ord.nr-unidades ~
oper-ord.val-perc-avanco oper-ord.cod-item-refugo ~
oper-ord.val-relac-refugo-item oper-ord.cod-grp-setup 
&Scoped-define DISPLAYED-TABLES oper-ord
&Scoped-define FIRST-DISPLAYED-TABLE oper-ord
&Scoped-Define DISPLAYED-OBJECTS fi-ctrab tg-tempo-sig fi-qtde-previs ~
fi-un-operac c-desc-item fi-perc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS oper-ord.emite-ficha oper-ord.oper-cq ~
oper-ord.cod-item-refugo oper-ord.val-relac-refugo-item 
&Scoped-define ADM-MODIFY-FIELDS oper-ord.emite-ficha oper-ord.oper-cq 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-ferramenta 
       MENU-ITEM m_Ferramentas_do_Centro_de_Tr LABEL "Ferramentas do Centro de Trabalho"
       MENU-ITEM m_Ferramentas  LABEL "Ferramentas"   
       MENU-ITEM m_Equipamento  LABEL "Equipamento"   .

DEFINE MENU POPUP-MENU-fi-ctrab 
       MENU-ITEM m_CTs_do_Grupo_de_Mquina LABEL "CTs do Grupo de Mÿquina"
       MENU-ITEM m_Centros_de_Trabalho LABEL "Centros de Trabalho".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-text-refugo AS CHARACTER FORMAT "X(256)":U INITIAL "Refugo" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 TOOLTIP "Refugo" NO-UNDO.

DEFINE VARIABLE fi-ctrab AS CHARACTER FORMAT "X(16)":U 
     LABEL "Centro de Trabalho" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-perc AS CHARACTER FORMAT "X(1)":U INITIAL "%" 
      VIEW-AS TEXT 
     SIZE 3 BY .67 NO-UNDO.

DEFINE VARIABLE fi-qtde-previs AS DECIMAL FORMAT ">,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtde Previs" 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-un-operac AS CHARACTER FORMAT "X(2)":U 
     LABEL "Un Oper" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-refugo
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.14 BY 2.38.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 10.5.

DEFINE VARIABLE tg-tempo-sig AS LOGICAL INITIAL no 
     LABEL "Tempo Significativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     oper-ord.numero-homem AT ROW 1.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     oper-ord.cd-mob-dir AT ROW 2.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     oper-ord.emite-ficha AT ROW 3.38 COL 22.14
          LABEL "":L24
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .67
     oper-ord.oper-cq AT ROW 4.38 COL 22.14
          LABEL "":L22
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .67
     fi-ctrab AT ROW 5.25 COL 20 COLON-ALIGNED
     oper-ord.ferramenta AT ROW 6.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     tg-tempo-sig AT ROW 8.25 COL 22
     oper-ord.revisao AT ROW 1.25 COL 56.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     oper-ord.fator-sobrep AT ROW 2.25 COL 56.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     oper-ord.proporcao AT ROW 3.25 COL 56.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     oper-ord.nr-unidades AT ROW 4.25 COL 56.14 COLON-ALIGNED FORMAT ">>>>>>>>>9"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     fi-qtde-previs AT ROW 5.25 COL 56.14 COLON-ALIGNED
     fi-un-operac AT ROW 6.25 COL 56.14 COLON-ALIGNED
     oper-ord.val-perc-avanco AT ROW 7.25 COL 56.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .88
     oper-ord.cod-item-refugo AT ROW 9.29 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     c-desc-item AT ROW 9.29 COL 35 COLON-ALIGNED NO-LABEL
     oper-ord.val-relac-refugo-item AT ROW 10.29 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-text-refugo AT ROW 8.79 COL 2.14 NO-LABEL
     fi-perc AT ROW 7.33 COL 66.86 COLON-ALIGNED NO-LABEL
     oper-ord.cod-grp-setup AT ROW 7.25 COL 20 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     RECT-refugo AT ROW 9.04 COL 1.57
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.oper-ord
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
         HEIGHT             = 10.5
         WIDTH              = 88.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-refugo IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       c-text-refugo:PRIVATE-DATA IN FRAME f-main     = 
                "Refugo".

/* SETTINGS FOR FILL-IN oper-ord.cod-item-refugo IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR TOGGLE-BOX oper-ord.emite-ficha IN FRAME f-main
   2 3 EXP-LABEL                                                        */
ASSIGN 
       oper-ord.ferramenta:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-ferramenta:HANDLE.

ASSIGN 
       fi-ctrab:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-fi-ctrab:HANDLE.

/* SETTINGS FOR FILL-IN fi-qtde-previs IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-qtde-previs:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       fi-un-operac:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN oper-ord.nr-unidades IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR TOGGLE-BOX oper-ord.oper-cq IN FRAME f-main
   2 3 EXP-LABEL                                                        */
/* SETTINGS FOR FILL-IN oper-ord.val-relac-refugo-item IN FRAME f-main
   2                                                                    */
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

&Scoped-define SELF-NAME oper-ord.cd-mob-dir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.cd-mob-dir V-table-Win
ON F5 OF oper-ord.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in566.w"
                     &campo=oper-ord.cd-mob-dir
                     &campozoom=cd-mob-dir}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.cd-mob-dir V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-ord.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.cod-grp-setup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.cod-grp-setup V-table-Win
ON F5 OF oper-ord.cod-grp-setup IN FRAME f-main /* Grupo Setup */
DO:
    {method/ZoomFields.i &ProgramZoom="mfzoom/z01mf631.w"
                         &FieldZoom1="cod-reduc-prepar"
                         &FieldScreen1="oper-ord.cod-grp-setup"
                         &Frame1="f-main"
                         &EnableImplant="no"}
           

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.cod-grp-setup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-ord.cod-grp-setup IN FRAME f-main /* Grupo Setup */
DO:
  APPLY 'F5':U TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.cod-item-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.cod-item-refugo V-table-Win
ON F5 OF oper-ord.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                       &campo=oper-ord.cod-item-refugo
                       &campozoom=it-codigo
                       &campo2=c-desc-item
                       &campozoom2=desc-item} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.cod-item-refugo V-table-Win
ON LEAVE OF oper-ord.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
    find b-item
        where b-item.it-codigo = input frame {&frame-name} oper-ord.cod-item-refugo no-lock no-error.
    if  avail b-item then
        assign c-desc-item:screen-value in frame {&frame-name} = string(b-item.desc-item).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.cod-item-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-ord.cod-item-refugo IN FRAME f-main /* Item Refugo */
DO:
    APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.ferramenta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.ferramenta V-table-Win
ON F5 OF oper-ord.ferramenta IN FRAME f-main /* Ferramenta */
DO:
    &IF DEFINED(bf_man_204) &THEN
    
        IF CAN-FIND(FIRST ctrab-ferram                                                           
                    WHERE ctrab-ferram.cod-ctrab = fi-ctrab:SCREEN-VALUE IN FRAME f-main NO-LOCK) THEN DO:
            IF l-mudancas-sfc THEN DO:                                                                                   
                                                                                                                         
                {method/zoomfields.i &ProgramZoom="mfzoom/z01mf514.w"                                                    
                                     &FieldZoom1="cod-ferr-prod"                                                         
                                     &FieldScreen1="oper-ord.ferramenta"                                                 
                                     &Frame1="f-main"                                                                    
                                     &RunMethod="RUN recebeCtrabOper IN hProgramZoom (INPUT input frame f-main fi-ctrab, 
                                                                                      INPUT IF AVAIL oper-ord THEN oper-ord.num-id-operacao ELSE ?,    
                                                                                      INPUT IF AVAIL oper-ord THEN oper-ord.op-altern ELSE ?)."        
                                     &EnableImplant="NO"}                                                                
            END.  
            ELSE DO:

                IF AVAIL oper-ord AND 
                    oper-ord.num-id-operacao <> 0 AND 
                    oper-ord.num-id-operacao <> ? AND 
                    fi-ctrab:SCREEN-VALUE IN FRAME f-main <> "":U AND  
                    CAN-FIND(FIRST ctrab-ferram                                                                           
                             WHERE ctrab-ferram.cod-ctrab = fi-ctrab:SCREEN-VALUE IN FRAME f-main AND                     
                                   CAN-FIND(FIRST op-ferram                                                               
                                            WHERE op-ferram.num-id-operacao = oper-ord.num-id-operacao                    
                                              AND op-ferram.op-altern       = oper-ord.op-altern                          
                                              AND op-ferram.ferramenta      = ctrab-ferram.cod-ferr-prod NO-LOCK) NO-LOCK) THEN DO:
        
                    /*Caso haja registros para carregar no zoom de Ferramentas do Ctrab, abre este*/
                    FIND FIRST ctrab WHERE ctrab.cod-ctrab = fi-ctrab:SCREEN-VALUE IN FRAME f-main NO-LOCK NO-ERROR.
                    IF AVAIL ctrab THEN
                        ASSIGN gr-ctrab = ROWID(ctrab).
        
                    assign l-implanta  = NO
                           gr-oper-ord = ROWID(oper-ord)
                           gr-split-operac      = ?
                           gr-area-produc-ctrab = ?.
        
                    {include/zoomvar.i &prog-zoom="inzoom/z01in514.w"        
                                       &campo=oper-ord.ferramenta     
                                       &campozoom=cod-ferr-prod}  
                END.
                ELSE
                    /*Caso contrÿrio, abre o zoom de Ferramentas simples*/     
                    APPLY "CHOOSE":U TO MENU-ITEM m_Ferramentas IN MENU POPUP-MENU-ferramenta.   
            END.
        END.
        ELSE 
    &ENDIF
            /*Caso contrÿrio, ou abaixo da 204, abre o zoom de Ferramentas simples*/    
            APPLY "CHOOSE":U TO MENU-ITEM m_Ferramentas IN MENU POPUP-MENU-ferramenta.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.ferramenta V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-ord.ferramenta IN FRAME f-main /* Ferramenta */
DO:
  APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ctrab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ctrab V-table-Win
ON F5 OF fi-ctrab IN FRAME f-main /* Centro de Trabalho */
DO:
    &IF DEFINED(bf_man_204) &THEN
        /*Zoom de Centros de Trabalho do Grupo Mÿquina*/
        IF VALID-HANDLE(h-pag1) THEN
            RUN leaveGrpMaq IN h-pag1.
    
        IF gr-grup-maquina <> ? THEN DO:

            find ord-prod where                                            
                      rowid(ord-prod) = gr-ord-prod NO-LOCK NO-ERROR.      
                                                                           
            ASSIGN glob-estabel-zoom = ord-prod.cod-estabel.

            assign l-implanta = no.
            {include/zoomvar.i &prog-zoom="inzoom/z02in513.w"
                               &campo=fi-ctrab
                               &campozoom=cod-ctrab}.
                               
            wait-for close of wh-pesquisa.
            ASSIGN glob-estabel-zoom = ?. 

        END.
        ELSE
            APPLY "CHOOSE" TO MENU-ITEM m_Centros_de_Trabalho IN MENU POPUP-MENU-fi-ctrab.     
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ctrab V-table-Win
ON LEAVE OF fi-ctrab IN FRAME f-main /* Centro de Trabalho */
DO:

    &IF DEFINED(bf_man_204) &THEN
        /*Atualiza o grupo de maquina com o grupo do centro de trabalho.*/
    
        IF valid-handle(h-pag1) and
           fi-ctrab:SCREEN-VALUE IN FRAME f-main <> "":U AND
           fi-ctrab:SENSITIVE IN FRAME f-main THEN DO:

            FIND FIRST ctrab WHERE ctrab.cod-ctrab = fi-ctrab:SCREEN-VALUE IN FRAME f-main NO-LOCK NO-ERROR.

            IF AVAIL ctrab THEN
                RUN atualizaGrpMaq IN h-pag1(INPUT ctrab.gm-codigo).

        END.
    &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ctrab V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ctrab IN FRAME f-main /* Centro de Trabalho */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Centros_de_Trabalho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Centros_de_Trabalho V-table-Win
ON CHOOSE OF MENU-ITEM m_Centros_de_Trabalho /* Centros de Trabalho */
DO:
    &IF DEFINED(bf_man_204) &THEN
        /*Zoom simples de centros de trabalho*/

        find ord-prod where                                         
                  rowid(ord-prod) = gr-ord-prod NO-LOCK NO-ERROR.

        ASSIGN glob-estabel-zoom = ord-prod.cod-estabel.

        assign l-implanta = no.
        {include/zoomvar.i &prog-zoom="inzoom/z01in513.w"
                           &campo=fi-ctrab
                           &campozoom=cod-ctrab}     
                           
        wait-for close of wh-pesquisa.                
        ASSIGN glob-estabel-zoom = ?.
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_CTs_do_Grupo_de_Mquina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_CTs_do_Grupo_de_Mquina V-table-Win
ON CHOOSE OF MENU-ITEM m_CTs_do_Grupo_de_Mquina /* CTs do Grupo de Mÿquina */
DO:
    &IF DEFINED(bf_man_204) &THEN
        /*Zoom de Centros de Trabalho do Grupo Mÿquina*/

        IF VALID-HANDLE(h-pag1) THEN
            RUN leaveGrpMaq IN h-pag1.        

        find ord-prod where                                        
                  rowid(ord-prod) = gr-ord-prod NO-LOCK NO-ERROR.  
                                                                   
        ASSIGN glob-estabel-zoom = ord-prod.cod-estabel.           

        assign l-implanta = no.
        {include/zoomvar.i &prog-zoom="inzoom/z02in513.w"
                           &campo=fi-ctrab
                           &campozoom=cod-ctrab}
                           
        wait-for close of wh-pesquisa.                
        ASSIGN glob-estabel-zoom = ?.

    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Equipamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Equipamento V-table-Win
ON CHOOSE OF MENU-ITEM m_Equipamento /* Equipamento */
DO:
  assign l-implanta = no.
    {include/zoomvar.i &prog-zoom=inzoom/z01in095.w
                       &campo=oper-ord.ferramenta
                       &campozoom=cd-equipto}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ferramentas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ferramentas V-table-Win
ON CHOOSE OF MENU-ITEM m_Ferramentas /* Ferramentas */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="inzoom/z02in465.w"
                       &campo=oper-ord.ferramenta
                       &campozoom=cod-ferr-prod}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ferramentas_do_Centro_de_Tr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ferramentas_do_Centro_de_Tr V-table-Win
ON CHOOSE OF MENU-ITEM m_Ferramentas_do_Centro_de_Tr /* Ferramentas do Centro de Trabalho */
DO:
    &IF DEFINED(bf_man_204) &THEN /*204*/
        IF l-mudancas-sfc THEN DO:
            {method/zoomfields.i &ProgramZoom="mfzoom/z01mf514.w"                                                             
                                 &FieldZoom1="cod-ferr-prod"                                                                  
                                 &FieldScreen1="oper-ord.ferramenta"                                                          
                                 &Frame1="f-main"                                                                             
                                 &RunMethod="RUN recebeCtrabOper IN hProgramZoom (INPUT input frame f-main fi-ctrab,          
                                                                                  INPUT IF AVAIL oper-ord THEN oper-ord.num-id-operacao ELSE ?,
                                                                                  INPUT IF AVAIL oper-ord THEN oper-ord.op-altern ELSE ?)."
                                 &EnableImplant="NO"}                                                                         
        END.
        ELSE DO:
            FIND FIRST ctrab WHERE ctrab.cod-ctrab = fi-ctrab:SCREEN-VALUE IN FRAME f-main NO-LOCK NO-ERROR.
            IF AVAIL ctrab THEN
                ASSIGN gr-ctrab = ROWID(ctrab).
            ELSE
                ASSIGN gr-ctrab = ?.
    
            assign l-implanta           = NO
                   gr-oper-ord          = IF AVAIL oper-ord THEN ROWID(oper-ord) ELSE ?
                   gr-split-operac      = ?
                   gr-area-produc-ctrab = ?.
    
            {include/zoomvar.i &prog-zoom="inzoom/z01in514.w"        
                               &campo=oper-ord.ferramenta     
                               &campozoom=cod-ferr-prod}   
        END.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.nr-unidades
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.nr-unidades V-table-Win
ON LEAVE OF oper-ord.nr-unidades IN FRAME f-main /* Unidades */
DO:
  assign i-nr-unidades = input frame {&frame-name} oper-ord.nr-unidades.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-ord.numero-homem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-ord.numero-homem V-table-Win
ON LEAVE OF oper-ord.numero-homem IN FRAME f-main /* N£mero Homens */
DO:
  /*assign i-numero-homem = input frame {&frame-name} oper-ord.numero-homem.*/
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

{utp/ut-field.i mgind oper-ord emite-ficha 1}.
assign oper-ord.emite-ficha:label in frame {&frame-name} = trim(return-value).
{utp/ut-field.i mgind oper-ord oper-cq 1}.
assign oper-ord.oper-cq:label in frame {&frame-name} = trim(return-value).

oper-ord.cd-mob-dir:load-mouse-pointer ("image/lupa.cur").
oper-ord.cod-item-refugo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.
oper-ord.cod-grp-setup:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.

if fi-ctrab:load-mouse-pointer ("image/rbm.cur") then.
if oper-ord.ferramenta:load-mouse-pointer ("image/rbm.cur") then.

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
  {src/adm/template/row-list.i "oper-ord"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "oper-ord"}

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
  find ord-prod where 
          rowid(ord-prod) = gr-ord-prod NO-LOCK no-error  .
     if avail ord-prod then do :
        /*if ord-prod.estado = 1 then*/
           assign fi-qtde-previs:screen-value in frame {&FRAME-NAME} = string(ord-prod.qt-ordem)
                  fi-un-operac:screen-value in frame {&FRAME-NAME} =  "".
     end.  
      &IF DEFINED (bf_man_sfc_ref_oper) &THEN
        DO WITH FRAME {&frame-name}:
          find first item-uni-estab 
               where item-uni-estab.cod-estabel = ord-prod.cod-estabel
                 and item-uni-estab.it-codigo   = ord-prod.it-codigo
                 no-lock no-error.
          IF  AVAIL item-uni-estab
          AND item-uni-estab.log-control-estoq-refugo THEN DO:
              assign oper-ord.cod-item-refugo:screen-value in frame {&FRAME-NAME}       = item-uni-estab.cod-item-refugo
                     oper-ord.val-relac-refugo-item:screen-value in frame {&FRAME-NAME} = string(item-uni-estab.val-relac-refugo-item).
              apply "LEAVE":U TO oper-ord.cod-item-refugo in frame {&FRAME-NAME}.

          END.
        END.
    &ENDIF
     {utp/ut-liter.i Refugo *}
     ASSIGN c-text-refugo:screen-value in frame {&frame-name} = return-value.

  IF adm-new-record = YES THEN DO:  
      ASSIGN oper-ord.nr-unidades:SENSITIVE IN FRAME {&FRAME-NAME}     = NO
             oper-ord.nr-unidades:screen-value  in frame {&frame-name} = if avail ord-prod then string(round(ord-prod.qt-ordem,0))
                                                                         else "100"
             l-add-record = YES.                                                                              

  END.

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
    &if {&bf_man_204} &then
        assign p-ctrab     = input frame {&frame-name} fi-ctrab
               p-tempo-sig = input frame {&frame-name} tg-tempo-sig.
    &endif

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /* Ponha na pi-validate todas as valida»„es */
    /* N’o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assign‹s n’o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    find ord-prod where ord-prod.nr-ord-produ = oper-ord.nr-ord-prod NO-LOCK no-error.

    if  avail ord-prod then DO:
       IF adm-new-record THEN
          ASSIGN oper-ord.nr-unidades:screen-value  in frame {&frame-name} = IF AVAIL ord-prod THEN
                                                                                  string(round(ord-prod.qt-ordem,0))
                                                                            ELSE STRING(100). 
       &IF DEFINED (bf_man_sfc_lc) &THEN
    
       IF ADM-NEW-RECORD = NO and
          (INPUT FRAME {&FRAME-NAME} fi-qtde-previs <> oper-ord.qtd-previs-operac OR
          /*Fun‡Æo para alterar o grupo de m quina do split, sem alterar quando existir mais de um split para a OPER
          Por isso, o can-find nÆo tem first*/
          (fi-ctrab:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> STRING(oper-ord.cod-recurso) AND
          CAN-FIND(split-operac WHERE
                   split-operac.nr-ord-produ = oper-ord.nr-ord-produ AND
                   split-operac.num-operac-sfc = oper-ord.num-operac-sfc))) THEN DO:

            FOR EACH split-operac EXCLUSIVE-LOCK
               WHERE split-operac.nr-ord-produ = oper-ord.nr-ord-produ 
                 AND split-operac.num-operac-sfc = oper-ord.num-operac-sfc:
                                                                                                   
                IF fi-qtde-previs:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> STRING(oper-ord.qtd-previs-operac) THEN
                    ASSIGN split-operac.qtd-previs    = input frame  {&FRAME-NAME} fi-qtde-previs * split-operac.val-perc-operac / 100.             

                IF split-operac.ind-estado-split > 3 THEN NEXT.

                IF fi-ctrab:SCREEN-VALUE IN FRAME f-main <> STRING(oper-ord.cod-recurso) THEN
                    ASSIGN split-operac.gm-codigo = oper-ord.gm-codigo 
                           split-operac.cod-ctrab = fi-ctrab:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

            END.
       END.

       assign oper-ord.qtd-previs-operac = input frame  {&FRAME-NAME} fi-qtde-previs.
                /* aqui */
       Assign oper-ord.val-operac-item = Truncate(oper-ord.qtd-previs-operac / ord-prod.qt-ordem,4).
 
       Assign oper-ord.cod-un-operac     = input frame {&FRAME-NAME} fi-un-operac .
       &ENDIF
       

    END.

    &if {&bf_man_204} &then
        &if {&bf_man_205} &then
            assign oper-ord.cod-recurso = p-ctrab
                   oper-ord.tempo-sig   = p-tempo-sig.
        &else
            assign OVERLAY(oper-ord.char-1,60,16) = string(p-ctrab,"x(16)":U)
                   OVERLAY(oper-ord.char-1,41,1)  = if p-tempo-sig = true then "S":U else "N":U.
        &endif
    &endif
        /**Aloca o Centro de Trabalho / Ferramenta de todos os splits que estiverem com esses dados em branco**/

        IF oper-ord.estado = 1 /*nao iniciada*/ AND
           (oper-ord.ferramenta <> "":U
        &if DEFINED(bf_man_205) &then
            OR oper-ord.cod-recurso <> "":U
        &ELSEIF DEFINED(bf_man_204) &then
            OR SUBSTRING(oper-ord.char-1,60,16) <> "":U
        &ENDIF )
         THEN DO:

            FOR EACH split-operac WHERE split-operac.nr-ord-produ   = oper-ord.nr-ord-produ
                                    AND split-operac.num-operac-sfc = oper-ord.num-operac-sfc NO-LOCK:

                /*Se o split estiver em estado adequado e o centro de trabalho estiver branco 
                 ou o centro de trabalho for igual ao ctrab da operacao ent’o:*/
                IF split-operac.ind-estado-split < 4 AND
                   (split-operac.cod-ctrab = "":U OR 
                    (&if DEFINED(bf_man_205) &then
                         split-operac.cod-ctrab = oper-ord.cod-recurso
                     &ELSEIF DEFINED(bf_man_204) &then
                          split-operac.cod-ctrab = SUBSTRING(oper-ord.char-1,60,16)
                     &ENDIF )) THEN DO:
                            
                    IF NOT VALID-HANDLE(h-boin535) THEN
                        RUN inbo/boin535.p PERSISTENT SET h-boin535.

                    EMPTY TEMP-TABLE rowErrors.
                    RUN alocarCtrab IN h-boin535(INPUT ROWID(split-operac),
                                                 INPUT oper-ord.gm-codigo,
                                                 INPUT
                                                    &if DEFINED(bf_man_205) &then
                                                        oper-ord.cod-recurso
                                                    &ELSEIF DEFINED(bf_man_204) &then
                                                        SUBSTRING(oper-ord.char-1,60,16)
                                                    &ENDIF ,
                                                 INPUT (IF (split-operac.cod-ctrab =  "":U OR
                                                           oper-ord.ferramenta    <> "":U) THEN oper-ord.ferramenta ELSE ?),
                                                 OUTPUT TABLE rowErrors).

                    IF CAN-FIND(FIRST rowErrors) THEN DO:
                            
                        /** Instancia aplicativo **/
                        {method/showmessage.i1}
                        /** Mostra caixa com erros **/
                        {method/showmessage.i2 &Modal="YES"}
                        /** Limpa temp-tables de erros **/
                        empty temp-table RowErrors.  

                        RETURN "adm-error":U.

                    END.
                END.
            END. /*FOR EACH split-operac*/
        END.
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
  
  IF VALID-HANDLE(h-boin535) THEN
      DELETE PROCEDURE h-boin535.

   {method/showmessage.i3}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
    FIND FIRST ord-prod WHERE ROWID(ord-prod) = gr-ord-prod NO-LOCK NO-ERROR.

       if avail ord-prod /*and ord-prod.estado < 6*/  then do :

          IF  ord-prod.qt-ordem <> input frame {&frame-name} fi-qtde-previs then 
             assign  de-qtde = input frame {&frame-name} fi-qtde-previs.
          else 
             assign  de-qtde = ord-prod.qt-ordem.

          if NOT AVAIL oper-ord OR (oper-ord.cod-un-operac <> input frame {&frame-name} fi-un-operac) then
             assign c-un = input frame {&frame-name} fi-un-operac .
          else
             assign c-un = oper-ord.cod-un-operac .

          assign fi-qtde-previs  = if adm-new-record OR NOT AVAIL oper-ord then de-qtde
                                   else oper-ord.qtd-previs-operac
                 fi-un-operac    = if ADM-NEW-RECORD OR NOT AVAIL oper-ord then c-un
                                   else oper-ord.cod-un-operac.
       end.

    {utp/ut-liter.i Refugo *}
    ASSIGN c-text-refugo:screen-value in frame {&frame-name} = return-value.


    IF avail oper-ord and oper-ord.cod-item-refugo <> " " THEN
      FOR FIRST b-ITEM FIELDS(it-codigo desc-item) 
          WHERE b-item.it-codigo = oper-ord.cod-item-refugo NO-LOCK:
          ASSIGN c-desc-item = b-ITEM.desc-item.
      END.
    ELSE
      ASSIGN c-desc-item = " ".


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF NOT AVAIL ord-prod THEN
      FIND FIRST ord-prod WHERE ROWID(ord-prod) = gr-ord-prod NO-LOCK NO-ERROR.

  assign fi-ctrab:hidden in frame {&frame-name} = yes
         tg-tempo-sig:hidden in frame {&frame-name} = yes.
  IF adm-new-record = YES THEN DO:
      ASSIGN oper-ord.nr-unidades:SENSITIVE IN FRAME {&FRAME-NAME}     = NO
             oper-ord.nr-unidades:screen-value  in frame {&frame-name} = if avail ord-prod then string(round(ord-prod.qt-ordem,0))
                                                                         else "100".
  END.

  &if {&bf_man_204} &then
      if  avail oper-ord then do:
          &if {&bf_man_205} &then
              assign fi-ctrab     = oper-ord.cod-recurso
                     tg-tempo-sig = oper-ord.tempo-sig.
          &else
              assign fi-ctrab     = substr(oper-ord.char-1,60,16)
                     tg-tempo-sig = if substr(oper-ord.char-1,41,1) = "S":U then true else false.
          &endif
      end.

      find first param-global no-lock no-error.
      if  param-global.modulo-sws = no then do:
          assign fi-ctrab:hidden in frame {&frame-name} = no
                 tg-tempo-sig:hidden in frame {&frame-name} = no.
          disp tg-tempo-sig fi-ctrab with frame {&frame-name}.
      end.
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
    /*** Habilita os campos centro de trabalho, Tempo Significativo e Ferramenta se a operação não estiver iniciada e for interna ****/
    if adm-new-record = YES OR (AVAIL oper-ord AND oper-ord.estado = 1 and oper-ord.tipo-oper = 1) THEN DO:
       assign fi-ctrab:sensitive  in frame {&frame-name}     = yes
              tg-tempo-sig:sensitive  in frame {&frame-name} = yes
              oper-ord.ferramenta:SENSITIVE  IN FRAME {&frame-name} = yes.
    END.
    ELSE DO:
         assign fi-ctrab:sensitive  in frame {&frame-name}     = NO
                tg-tempo-sig:sensitive  in frame {&frame-name} = NO
                oper-ord.ferramenta:SENSITIVE  IN FRAME {&frame-name} = NO.
    END.
    if  l-flag = no then
        assign oper-ord.cd-mob-dir:sensitive   in frame {&frame-name} = no
               oper-ord.nr-unidades:sensitive  in frame {&frame-name} = no
               oper-ord.numero-homem:sensitive in frame {&frame-name} = no.
    else
        assign oper-ord.cd-mob-dir:sensitive   in frame {&frame-name} = yes
               oper-ord.nr-unidades:sensitive  in frame {&frame-name} = yes
               oper-ord.numero-homem:sensitive in frame {&frame-name} = yes.

    if  ADM-NEW-RECORD then
        assign oper-ord.nr-unidades:sensitive  in frame {&frame-name} = yes.
    else
        assign oper-ord.nr-unidades:sensitive  in frame {&frame-name} = no.   
    /*assign fi-qtde-previs:sensitive  in frame {&frame-name} = no.*/


     /*Ativ.164787 - Habilatar Campo Quantidade Prevista na modifica»’o para OP n’o iniciada.*/
    &IF DEFINED (bf_man_sfc_lc) &THEN
        IF CAN-FIND (split-operac NO-LOCK 
              WHERE split-operac.nr-ord-produ = oper-ord.nr-ord-produ 
                AND split-operac.num-operac-sfc = oper-ord.num-operac-sfc) 
                 OR ADM-NEW-RECORD 
                 OR NOT CAN-FIND (FIRST split-operac NO-LOCK
                       WHERE split-operac.nr-ord-produ = oper-ord.nr-ord-produ 
                       AND split-operac.num-operac-sfc = oper-ord.num-operac-sfc) THEN 

            ASSIGN fi-qtde-previs:sensitive  in frame {&frame-name} = YES. 

           ASSIGN oper-ord.nr-unidades:sensitive  in frame {&frame-name} = ADM-NEW-RECORD.    
    &ELSE
        assign oper-ord.nr-unidades:sensitive  in frame {&frame-name} = yes.
               fi-qtde-previs:sensitive  in frame {&frame-name} = yes.
    &ENDIF 
                                                                              
    &IF DEFINED (bf_man_sfc_ref_oper) &THEN
    find ord-prod where 
          rowid(ord-prod) = gr-ord-prod NO-LOCK no-error  .
    FIND ITEM
        WHERE ITEM.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.
        IF  param-global.modulo-ch
            AND AVAIL ITEM THEN DO:
             /* fo:9.927 atividade:202.178 tarefa:253.745 */
            IF ord-prod.rep-prod = 2 OR ord-prod.rep-prod = 3 THEN DO:
                IF  ITEM.log-control-estoq-refugo THEN
                    ASSIGN oper-ord.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = YES
                           oper-ord.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
                ELSE
                    ASSIGN oper-ord.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
                           oper-ord.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
            END.
            ELSE
                    ASSIGN oper-ord.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
                           oper-ord.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
         END.
         ELSE
   &ENDIF
      ASSIGN oper-ord.cod-item-refugo:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
             oper-ord.val-relac-refugo-item:SENSITIVE IN FRAME {&FRAME-NAME} = NO.


   IF l-mudancas-sfc = NO THEN DO:
       /*Mudancas sfc nao implantado, esconde campo perc avanco*/
       ASSIGN oper-ord.cod-grp-setup:HIDDEN IN FRAME {&FRAME-NAME}   = YES
              oper-ord.val-perc-avanco:HIDDEN IN FRAME {&FRAME-NAME} = YES
              fi-perc:HIDDEN IN FRAME {&FRAME-NAME}                  = YES.

       ASSIGN tg-tempo-sig:ROW IN FRAME {&FRAME-NAME} = 7.25.
   END.
   ELSE DO:
       {utp/ut-liter.i Perc._Avan»o *}
       ASSIGN oper-ord.val-perc-avanco:HIDDEN IN FRAME {&FRAME-NAME}    = NO
              oper-ord.val-perc-avanco:SENSITIVE IN FRAME {&FRAME-NAME} = NO
              oper-ord.val-perc-avanco:LABEL  IN FRAME {&FRAME-NAME}    = RETURN-VALUE
              oper-ord.cod-grp-setup:HIDDEN IN FRAME {&FRAME-NAME}      = NO
              oper-ord.cod-grp-setup:SENSITIVE IN FRAME {&FRAME-NAME}   = IF AVAILABLE oper-ord THEN oper-ord.estado = 1 ELSE YES
              fi-perc:HIDDEN IN FRAME {&FRAME-NAME}                     = NO.
   END.

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
    FIND FIRST param-global NO-LOCK NO-ERROR.

   RUN sfc/sf9999.p(OUTPUT l-mudancas-sfc).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

   IF l-mudancas-sfc = NO THEN
       /*Mudancas sfc nao implantado, esconde campo perc avanco*/
       ASSIGN oper-ord.val-perc-avanco:HIDDEN IN FRAME {&FRAME-NAME} = YES
              fi-perc:HIDDEN IN FRAME {&FRAME-NAME}                  = YES
              oper-ord.cod-grp-setup:HIDDEN IN FRAME {&FRAME-NAME}   = YES
              tg-tempo-sig:ROW IN FRAME {&FRAME-NAME}                = 7.25.

    
   ELSE DO:
       {utp/ut-liter.i Perc._Avan»o *}
       ASSIGN oper-ord.val-perc-avanco:HIDDEN IN FRAME {&FRAME-NAME}    = NO
              oper-ord.val-perc-avanco:SENSITIVE IN FRAME {&FRAME-NAME} = NO
              oper-ord.val-perc-avanco:LABEL  IN FRAME {&FRAME-NAME}    = RETURN-VALUE
              fi-perc:HIDDEN IN FRAME {&FRAME-NAME}                     = NO
              oper-ord.cod-grp-setup:HIDDEN IN FRAME {&FRAME-NAME}      = NO
              oper-ord.cod-grp-setup:SENSITIVE IN FRAME {&FRAME-NAME}   = NO.
   END.

    assign  fi-qtde-previs:hidden  in frame {&FRAME-NAME} = no
            fi-un-operac:hidden    in frame {&FRAME-NAME} = no
            fi-un-operac:sensitive in frame {&FRAME-NAME} = yes.
    find ord-prod where 
         ord-prod.nr-ord-prod = oper-ord.nr-ord-produ NO-LOCK no-error .
    if  avail ord-prod then do :
        IF  ord-prod.estado = 1 then 
            assign fi-qtde-previs:screen-value in frame {&FRAME-NAME} = if adm-new-record then string(ord-prod.qt-ordem)
                                                                        else string(oper-ord.qtd-previs-operac)
                   fi-un-operac:screen-value in frame {&FRAME-NAME} = if ADM-NEW-RECORD then ""
                                                                      else oper-ord.cod-un-operac .
        FIND ITEM
            WHERE ITEM.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.
     end.

  &IF defined(bf_man_sfc_ref_oper) &THEN
      assign c-Text-Refugo:hidden in frame {&frame-name} = no
             rect-refugo:hidden in frame {&frame-name} = no
             oper-ord.cod-item-refugo:hidden in frame {&frame-name} = no
             c-desc-item:hidden in frame {&frame-name} = no
             oper-ord.val-relac-refugo-item:hidden in frame {&frame-name} = no.
  &else
      assign c-Text-Refugo:hidden in frame {&frame-name} = yes
             rect-refugo:hidden in frame {&frame-name} = yes
             oper-ord.cod-item-refugo:hidden in frame {&frame-name} = yes
             c-desc-item:hidden in frame {&frame-name} = yes
             oper-ord.val-relac-refugo-item:hidden in frame {&frame-name} = yes.
  &endif  
       
  {utp/ut-liter.i Ferramentas_do_Centro_de_Trabalho *}
  ASSIGN MENU-ITEM m_Ferramentas_do_Centro_de_Tr:LABEL IN MENU popup-menu-ferramenta = RETURN-VALUE.
  {utp/ut-liter.i Ferramentas *}
  ASSIGN MENU-ITEM m_Ferramentas:LABEL IN MENU popup-menu-ferramenta = RETURN-VALUE.
  {utp/ut-liter.i CTs_do_Grupo_de_Mÿquina *}
  ASSIGN MENU-ITEM m_CTs_do_Grupo_de_Mquina:LABEL IN MENU popup-menu-fi-ctrab = RETURN-VALUE.
  {utp/ut-liter.i Centros_de_Trabalho *}
  ASSIGN MENU-ITEM m_Centros_de_Trabalho:LABEL IN MENU popup-menu-fi-ctrab = RETURN-VALUE.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mudancaTipoOper V-table-Win 
PROCEDURE mudancaTipoOper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-tipo-oper AS INT NO-UNDO.

IF NOT(oper-ord.ferramenta:HIDDEN IN FRAME f-main) THEN DO:
    IF p-tipo-oper = 2 THEN
        /*Oper externa*/
        ASSIGN oper-ord.ferramenta:SCREEN-VALUE IN FRAME f-main = "":U
               fi-ctrab:SCREEN-VALUE            IN FRAME f-main = "":U
               oper-ord.ferramenta:SENSITIVE    IN FRAME f-main = NO               
               fi-ctrab:SENSITIVE               IN FRAME f-main = NO. 
    ELSE
        ASSIGN oper-ord.ferramenta:SENSITIVE    IN FRAME f-main = YES               
               fi-ctrab:SENSITIVE               IN FRAME f-main = YES. 
END.

RETURN "OK":U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valor V-table-Win 
PROCEDURE pi-busca-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "cb-tipo-oper").

assign i-tipo = {ininc/i01in261.i 06 return-value}.
if  i-tipo = 1 then do:
    IF  avail oper-ord then
        assign oper-ord.nr-unidades:screen-value in frame {&frame-name}  = string(oper-ord.nr-unidades)
               oper-ord.numero-homem:screen-value in frame {&frame-name} = string(oper-ord.numero-homem)
               oper-ord.cd-mob-dir:screen-value in frame {&frame-name}   = oper-ord.cd-mob-dir.

    assign oper-ord.cd-mob-dir:sensitive   in frame {&frame-name} = yes
           oper-ord.numero-homem:sensitive in frame {&frame-name} = yes
           oper-ord.nr-unidades:sensitive  in frame {&frame-name} = yes
           l-flag = yes.
end.
else 
    assign oper-ord.nr-unidades:screen-value  in frame {&frame-name} =
           IF AVAIL ORD-PROD THEN STRING(ORD-PROD.QT-ORDEM) ELSE "0"
           oper-ord.numero-homem:screen-value in frame {&frame-name} = "0"
           oper-ord.cd-mob-dir:screen-value   in frame {&frame-name} = ""
           oper-ord.cd-mob-dir:sensitive      in frame {&frame-name} = no
           oper-ord.nr-unidades:sensitive     in frame {&frame-name} = no
           oper-ord.numero-homem:sensitive    in frame {&frame-name} = no
           l-flag = no.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia-op-padrao V-table-Win 
PROCEDURE pi-copia-op-padrao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "fi-oper-pad").
find oper-pad where oper-pad.nr-oper-pad = integer(return-value) no-lock no-error.

if avail oper-pad then do:

   assign oper-ord.numero-homem:screen-value in frame {&frame-name} = string(oper-pad.numero-homem)
          oper-ord.cd-mob-dir:screen-value   in frame {&frame-name} = string(oper-pad.cd-mob-dir)
          oper-ord.revisao:screen-value      in frame {&frame-name} = string(oper-pad.revisao)
          oper-ord.proporcao:screen-value    in frame {&frame-name} = string(oper-pad.proporcao).
          /*oper-ord.nr-unidades:screen-value  in frame {&frame-name} = string(oper-pad.nr-unidades).*/

end.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-valor V-table-Win 
PROCEDURE pi-mostra-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var i-oper-pad like oper-pad.nr-oper-pad no-undo.

RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT "fi-oper-pad").
find oper-pad 
    where oper-pad.nr-oper-pad = i-oper-pad no-lock no-error.
if  avail oper-pad then      
    assign oper-ord.revisao:screen-value in frame {&frame-name}      = oper-pad.revisao
           oper-ord.nr-unidades:screen-value in frame {&frame-name}  = string(oper-pad.nr-unidades)
           oper-ord.cd-mob-dir:screen-value in frame {&frame-name}   = oper-pad.cd-mob-dir
           oper-ord.emite-ficha:checked in frame {&frame-name}       = oper-pad.emite-ficha
           oper-ord.oper-cq:checked in frame {&frame-name}           = oper-pad.contr-qualidade
           oper-ord.numero-homem:screen-value in frame {&frame-name} = string(oper-pad.numero-homem)
           oper-ord.ferramenta:screen-value in frame {&frame-name}   = oper-pad.ferramenta
           oper-ord.fator-sobrep:screen-value in frame {&frame-name} = string(oper-pad.fator-sobrep)
           oper-ord.proporcao:screen-value in frame {&frame-name}    = string(oper-pad.proporcao).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N’o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida»„es, pois neste ponto do programa o registro 
  ainda n’o foi criado.       
------------------------------------------------------------------------------*/

    {include/i-vldfrm.i} /* Valida»’o de dicionÿrio */

    DEFINE VARIABLE c-aux       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-gm-codigo AS CHARACTER   NO-UNDO.

    if  i-tipo = 1 THEN DO:
        IF  input frame {&frame-name} oper-ord.numero-homem = 0 then do:
            {include/i-vldprg.i} 
            run utp/ut-msgs.p (input "show",
                               input 2448,
                               input "").
            apply 'entry' to oper-ord.numero-homem.
            return 'ADM-ERROR':U.
        end.

        if  input frame {&frame-name} oper-ord.nr-unidades = 0 then do:
            {include/i-vldprg.i} 
            run utp/ut-msgs.p (input "show",
                               input 115,
                               input "").
            apply 'entry' to oper-ord.nr-unidades.
            return 'ADM-ERROR':U.
        end.
    END.

    find tab-mob-dir
        where tab-mob-dir.cd-mob-dir = input frame {&frame-name} oper-ord.cd-mob-dir no-lock no-error.
    if  not avail tab-mob-dir
    and oper-ord.cd-mob-dir:sensitive in frame {&frame-name} = yes
    and input frame {&frame-name} oper-ord.cd-mob-dir <> "" then do:
        {include/i-vldprg.i} 
        {utp/ut-field.i mgind oper-ord cd-mob-dir 1}
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input return-value).
        apply 'entry' to oper-ord.cd-mob-dir.
        return 'ADM-ERROR':U.
    end.

    IF oper-ord.ferramenta:SCREEN-VALUE IN FRAME f-main <> "":U THEN DO: 
        IF NOT CAN-FIND(FIRST ferr-prod WHERE 
                                                  ferr-prod.cod-ferr-prod = oper-ord.ferramenta:SCREEN-VALUE IN FRAME f-main) THEN DO:
                run utp/ut-msgs.p (input "show",
                                                   input 28022,
                                                   input "").
                IF RETURN-VALUE = "yes" THEN DO:
                   IF NOT CAN-FIND(FIRST equipto WHERE 
                                                                 equipto.cd-equipto = oper-ord.ferramenta:SCREEN-VALUE IN FRAME f-main) THEN DO:
                           {utp/ut-liter.i "Equipamento"}
                           run utp/ut-msgs.p (input "show",
                                                                 input 56,
                                                                 input RETURN-VALUE).
                           apply "entry" to oper-ord.ferramenta.
                           return 'ADM-ERROR':U.                       
                   END.
                END.
                ELSE DO:
                   apply "entry" to oper-ord.ferramenta.
                   return 'ADM-ERROR':U.                       
                END.
        END.
        &if DEFINED(bf_man_204) &then
            ELSE DO:
                IF fi-ctrab:screen-value in frame {&frame-name} <> "" AND
                   NOT CAN-FIND(FIRST ctrab-ferr 
                                WHERE ctrab-ferr.cod-ferr-prod = oper-ord.ferramenta:SCREEN-VALUE IN FRAME f-main     
                                  AND ctrab-ferr.cod-ctrab     = fi-ctrab:screen-value in frame {&frame-name} NO-LOCK) THEN DO:     
                    {utp/ut-liter.i Ferramenta *}                                                   
                    ASSIGN c-aux = RETURN-VALUE.                                                    
                    {utp/ut-liter.i Centro_de_Trabalho *}                                           
                    RUN utp/ut-msgs.p (INPUT "show":U,                                              
                                       INPUT 17899,                                                 
                                       INPUT c-aux + "~~":U + RETURN-VALUE).                        
                    apply 'entry' to oper-ord.ferramenta.               
                    return 'adm-error':U.                                                                  
                END.                                                                                
                ELSE DO:
    
                    IF l-add-record AND AVAIL oper-ord THEN DO:
                        /*Se a opera»’o tiver pelo menos uma ferramenta, ent’o a ferramenta que estÿ sendo colocada tem que estar relacionada*/
                        IF CAN-FIND(FIRST op-ferram WHERE op-ferram.num-id-operacao = oper-ord.num-id-operacao
                                                      AND op-ferram.op-altern       = oper-ord.op-altern NO-LOCK) THEN DO:
    
                            IF NOT CAN-FIND(FIRST op-ferram 
                                            WHERE op-ferram.num-id-operacao = oper-ord.num-id-operacao
                                              AND op-ferram.op-altern       = oper-ord.op-altern
                                              AND op-ferram.ferramenta      = oper-ord.ferramenta:SCREEN-VALUE IN FRAME f-main) THEN DO:
    
                                {utp/ut-liter.i Ferramenta *}                           
                                ASSIGN c-aux = RETURN-VALUE.                            
                                {utp/ut-liter.i Opera»’o_da_Ordem *}                   
                                RUN utp/ut-msgs.p (INPUT "show":U,                      
                                                   INPUT 17899,                         
                                                   INPUT c-aux + "~~":U + RETURN-VALUE).
                                apply 'entry' to oper-ord.ferramenta.                   
                                return 'adm-error':U.    
                            END.
                        END.
                    END.
                END.
            END.
        &ENDIF /*204*/
    END.

    &if DEFINED(bf_man_204) &then
        IF fi-ctrab:HIDDEN in frame {&frame-name} = NO THEN
            if  fi-ctrab:screen-value in frame {&frame-name} <> "" then do:
                FIND FIRST ctrab where ctrab.cod-ctrab = fi-ctrab:screen-value in frame {&frame-name} NO-LOCK NO-ERROR.
                IF NOT AVAIL ctrab THEN do:
                    {utp/ut-liter.i Centro_de_Trabalho *}
                    run utp/ut-msgs.p (input "show":U,
                                       input 47,
                                       input RETURN-VALUE).
                    apply 'entry' to fi-ctrab.
                    return 'adm-error':U.
                end.
                ELSE DO:
                    /*Verifica se o centro de trabalho pertence ao grupo de mÿquina informado na pag. 1*/
                    FIND FIRST grup-maquina WHERE ROWID(grup-maquina) = gr-grup-maquina NO-LOCK NO-ERROR.
                    IF AVAIL grup-maquina THEN DO:
    
                        IF ctrab.gm-codigo <> grup-maquina.gm-codigo THEN DO:
                            run utp/ut-msgs.p (input "show":U,
                                               input 28533,
                                               input RETURN-VALUE).
                            apply 'entry' to fi-ctrab.
                            return 'adm-error':U.
                        END.                                                                             
                    END.
                  IF l-mudancas-sfc THEN DO:

                       find first area-produc-ctrab where
                                  area-produc-ctrab.cod-ctrab       = ctrab.cod-ctrab AND
                                  area-produc-ctrab.dat-inic-valid <= today  and
                                  area-produc-ctrab.dat-fim-valid   > today NO-LOCK NO-ERROR.
                       if not avail area-produc-ctrab then do:
                           run utp/ut-msgs.p (input "show":U,         
                                              input 17562,            
                                              input "":U). 
                           apply 'entry' to fi-ctrab.
                           return 'adm-error':U.
                       end.
                       ELSE DO:
                           find first area-produc 
                                where area-produc.cod-area-produc = area-produc-ctrab.cod-area-produc no-lock no-error. 
                           find first ord-prod where ord-prod.nr-ord-produ = oper-ord.nr-ord-produ no-lock no-error.     
                           if AVAIL ord-prod AND
                               area-produc.cod-estabel <> ord-prod.cod-estabel then do:
                               run utp/ut-msgs.p (input "show":U,  
                                                  input 32495,     
                                                  input ord-prod.cod-estabel).     
                               apply 'entry' to fi-ctrab.          
                               return 'adm-error':U.                       
                           end.
                       END.

                       if can-find(first ctrab-operac-aloc no-lock
                                   where ctrab-operac-aloc.num-id-operacao = oper-ord.num-id-operacao
                                     and ctrab-operac-aloc.op-altern       = oper-ord.op-altern)
                           and
                          not can-find(first ctrab-operac-aloc no-lock
                                       where ctrab-operac-aloc.cod-ctrab       = ctrab.cod-ctrab
                                         and ctrab-operac-aloc.num-id-operacao = oper-ord.num-id-operacao
                                         and ctrab-operac-aloc.op-altern       = oper-ord.op-altern) then do:
                             /*Centro de Trabalho n’o ² valido para a Opera»’o.*/            
                             run utp/ut-msgs.p (input "show":U,     
                                                input 32544,        
                                                input ctrab.cod-ctrab).
                             apply 'entry' to fi-ctrab.             
                             return 'adm-error':U.
                       end.
                  end.
              END.
          end.
  &endif
  

    IF oper-ord.cod-grp-setup:SENSITIVE in frame {&frame-name} = YES AND 
       oper-ord.cod-grp-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO: 


        IF NOT CAN-FIND(FIRST reduc-prepar-aloc 
                        WHERE reduc-prepar-aloc.cod-reduc-prepar = oper-ord.cod-grp-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:

            {utp/ut-liter.i Redutor * }

            run utp/ut-msgs.p (input "show":U,     
                               input 56,        
                               input RETURN-VALUE).
            apply 'entry' to  oper-ord.cod-grp-setup.             
            return 'adm-error':U.

        END.


        RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                      INPUT "gm-codigo").
        ASSIGN c-gm-codigo = RETURN-VALUE.


        IF NOT CAN-FIND(FIRST matriz-reduc-prepar-aloc NO-LOCK
                        WHERE matriz-reduc-prepar-aloc.gm-codigo = c-gm-codigo 
                          AND (matriz-reduc-prepar-aloc.cod-reduc-dest = oper-ord.cod-grp-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} OR
                               matriz-reduc-prepar-aloc.cod-reduc-orig = oper-ord.cod-grp-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:

            {utp/ut-liter.i Grupo_de_Maquina: * }
            ASSIGN c-aux = RETURN-VALUE +  c-gm-codigo + "  ".
            {utp/ut-liter.i Redutor: * }
            ASSIGN c-aux = c-aux + RETURN-VALUE + oper-ord.cod-grp-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
            {utp/ut-table.i mgind matriz-reduc-prepar-aloc 1}

            run utp/ut-msgs.p (input "show":U,     
                               input 56,        
                               input RETURN-VALUE + "~~" + c-aux).

            apply 'entry' to  oper-ord.cod-grp-setup.             
            return 'adm-error':U.

        END.

        /*Entrar somente quando for altera‡Æo, pois quando for inclusÆo nÆo existir  o SPLIT neste momento*/

        IF AVAILABLE oper-ord THEN DO:

            for each split-operac NO-LOCK
               where split-operac.nr-ord-produ   = oper-ord.nr-ord-produ   
                 and split-operac.num-operac-sfc = oper-ord.num-operac-sfc:
    
                IF NOT CAN-FIND(FIRST matriz-reduc-prepar-aloc NO-LOCK
                                WHERE matriz-reduc-prepar-aloc.gm-codigo = split-operac.gm-codigo 
                                  AND (matriz-reduc-prepar-aloc.cod-reduc-dest = oper-ord.cod-grp-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} OR
                                       matriz-reduc-prepar-aloc.cod-reduc-orig = oper-ord.cod-grp-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:
    
                    {utp/ut-liter.i Split: * }
                    ASSIGN c-aux = RETURN-VALUE + string(split-operac.op-codigo) + "/" + string(split-operac.num-split-operac) + "  ".
                    {utp/ut-liter.i Grupo_de_Maquina: * }
                    ASSIGN c-aux = c-aux + RETURN-VALUE +  split-operac.gm-codigo + "  ".
                    {utp/ut-liter.i Redutor: * }
                    ASSIGN c-aux = c-aux + RETURN-VALUE + oper-ord.cod-grp-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
                    {utp/ut-table.i mgind matriz-reduc-prepar-aloc 1}
                  
                    run utp/ut-msgs.p (input "show":U,     
                                       input 56,        
                                       input RETURN-VALUE + "~~" + c-aux).
                  
                    apply 'entry' to  oper-ord.cod-grp-setup.             
                    return 'adm-error':U.
                  
                END.
            END.
        END.

    END.

    &IF DEFINED (bf_man_sfc_ref_oper) &THEN
    DO WITH FRAME {&frame-name}:
        IF AVAIL ord-prod THEN DO:
            find first item-uni-estab 
                where item-uni-estab.cod-estabel = ord-prod.cod-estabel
                and   item-uni-estab.it-codigo   = ord-prod.it-codigo
                no-lock no-error.

            IF  AVAIL item-uni-estab
            /* os:9927 tarefa:253.745 */
            AND item-uni-estab.log-control-estoq-refugo  AND ( ord-prod.rep-prod = 2 OR ord-prod.rep-prod = 3 )THEN DO:
                IF  oper-ord.cod-item-refugo:SCREEN-VALUE = " ":U THEN DO:
                    {utp/ut-liter.i Item_refugo_n’o_pode_ser_o_item_branco *}
                    run utp/ut-msgs.p (input "show",
                                       input 29469 ,
                                       input  Return-value ).
                    apply "entry" to oper-ord.cod-item-refugo in frame {&frame-name}.
                    return "adm-error".
                END.
         
                IF  oper-ord.cod-item-refugo:SCREEN-VALUE = ord-prod.it-codigo THEN DO:
                    {utp/ut-liter.i Item_refugo_n’o_pode_ser_o_item_da_ordem *}
                    run utp/ut-msgs.p (input "show",
                                       input 17006 ,
                                       input  Return-value ).
                    apply "entry" to oper-ord.cod-item-refugo in frame {&frame-name}.
                    return "adm-error".
                END.
         
                FOR FIRST b-ITEM FIELDS(it-codigo tipo-contr tipo-con-est)
                    WHERE b-ITEM.it-codigo = oper-ord.cod-item-refugo:SCREEN-VALUE NO-LOCK: END.
                IF  NOT AVAIL b-ITEM THEN DO:
                    {utp/ut-liter.i Item_n’o_cadastrado *}
                    run utp/ut-msgs.p (input "show",
                                       input 17006 ,
                                       input  Return-value ).
                    apply "entry" to oper-ord.cod-item-refugo in frame {&frame-name}.
                    return "adm-error".
                END.
         
                IF  b-ITEM.tipo-contr <> 2 THEN DO:
                    {utp/ut-liter.i Item_deve_ser_de_controle_total *}
                    run utp/ut-msgs.p (input "show",
                                       input 29462 ,
                                       input  Return-value ).
                    apply "entry" to oper-ord.cod-item-refugo in frame {&frame-name}.
                    return "adm-error".
                END.
         
                IF  b-ITEM.tipo-con-est <> 1 THEN DO:
                    {utp/ut-liter.i Item_deve_ter_tipo_de_controle_de_estoque_Serial *}
                    run utp/ut-msgs.p (input "show",
                                       input 29463 ,
                                       input  Return-value ).
                    apply "entry" to oper-ord.cod-item-refugo in frame {&frame-name}.
                    return "adm-error".
                END.
         
                IF  DEC(oper-ord.val-relac-refugo-item:SCREEN-VALUE) <= 0
                OR  DEC(oper-ord.val-relac-refugo-item:SCREEN-VALUE)  = ? THEN DO:
                    {utp/ut-liter.i Valor_invÿlido_para_a_rela»’o_refugo_item *}
                    run utp/ut-msgs.p (input "show",
                                       input 17006 ,
                                       input  Return-value ).
                    apply "entry" to oper-ord.val-relac-refugo-item in frame {&frame-name}.
                    return "adm-error".
                END.
            END.
        END.
    END.
    &ENDIF

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
  {src/adm/template/snd-list.i "oper-ord"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaHandlePag1 V-table-Win 
PROCEDURE setaHandlePag1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-handle AS HANDLE NO-UNDO.
ASSIGN h-pag1 = p-handle.

RETURN "OK":U.
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

