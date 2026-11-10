&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AO0302B 2.00.00.004 } /*** 010004 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0302b MAO}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AO0302B
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              fi-docto-fim fi-docto-ini fi-empresa-fim fi-empresa-ini ~
                              fi-equipto-fim fi-equipto-ini fi-data-fim fi-data-ini ~
                              fi-amostra-fim fi-amostra-ini fi-modelo-fim fi-modelo-ini fi-compto-fim ~
                              fi-compto-ini fi-tp-mater-fim fi-tp-mater-ini fi-lubrific-fim fi-lubrific-ini ~
                              fi-tag-ini fi-tag-fim fi-cc-ini fi-cc-fim

{aop/ao0302.i} /** Defini‡Æo da ttSelecao **/

/* Parameters Definitions ---                                           */
define input-output parameter table for ttSelecao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 ~
IMAGE-15 IMAGE-16 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-24 IMAGE-29 IMAGE-30 ~
IMAGE-43 IMAGE-44 IMAGE-45 IMAGE-46 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 ~
rtToolBar IMAGE-50 IMAGE-51 fi-data-ini fi-data-fim fi-amostra-ini ~
fi-amostra-fim fi-docto-ini fi-docto-fim fi-empresa-ini fi-empresa-fim ~
fi-equipto-ini fi-equipto-fim fi-modelo-ini fi-modelo-fim fi-compto-ini ~
fi-compto-fim fi-tp-mater-ini fi-tp-mater-fim fi-lubrific-ini ~
fi-lubrific-fim fi-tag-ini fi-tag-fim fi-cc-ini fi-cc-fim fi-unid-negoc-ini ~
fi-unid-negoc-fim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-data-ini fi-data-fim fi-amostra-ini ~
fi-amostra-fim fi-docto-ini fi-docto-fim fi-empresa-ini fi-empresa-fim ~
fi-equipto-ini fi-equipto-fim fi-modelo-ini fi-modelo-fim fi-compto-ini ~
fi-compto-fim fi-tp-mater-ini fi-tp-mater-fim fi-lubrific-ini ~
fi-lubrific-fim fi-tag-ini fi-tag-fim fi-cc-ini fi-cc-fim fi-unid-negoc-ini ~
fi-unid-negoc-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-amostra-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-amostra-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "N£mero Amostra" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-fim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-ini AS CHARACTER FORMAT "X(20)":U 
     LABEL "CCusto Eqpto" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-compto-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-compto-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Compartimento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-ini AS DATE FORMAT "99/99/9999" INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data":R12 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-docto-fim AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-docto-ini AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Documento":R9 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empresa-fim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empresa-ini LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-equipto-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-equipto-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lubrific-fim AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lubrific-ini AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Lubrifica‡Æo":R15 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-modelo-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-modelo-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Modelo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tag-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tag-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Tag" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tp-mater-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tp-mater-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Tipo Material":R18 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-45
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-46
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-50
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-51
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 65 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-data-ini AT ROW 1.17 COL 13 COLON-ALIGNED HELP
          "Data"
     fi-data-fim AT ROW 1.17 COL 43.72 COLON-ALIGNED NO-LABEL
     fi-amostra-ini AT ROW 2.13 COL 13 COLON-ALIGNED
     fi-amostra-fim AT ROW 2.17 COL 43.72 COLON-ALIGNED NO-LABEL
     fi-docto-ini AT ROW 3.13 COL 13 COLON-ALIGNED HELP
          "C¢digo da Oficina"
     fi-docto-fim AT ROW 3.17 COL 43.72 COLON-ALIGNED HELP
          "C¢digo da Oficina" NO-LABEL
     fi-empresa-ini AT ROW 4.13 COL 13 COLON-ALIGNED HELP
          ""
     fi-empresa-fim AT ROW 4.17 COL 43.72 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-equipto-ini AT ROW 5.13 COL 13 COLON-ALIGNED
     fi-equipto-fim AT ROW 5.17 COL 43.72 COLON-ALIGNED NO-LABEL
     fi-modelo-ini AT ROW 6.13 COL 13 COLON-ALIGNED
     fi-modelo-fim AT ROW 6.17 COL 43.72 COLON-ALIGNED NO-LABEL
     fi-compto-ini AT ROW 7.13 COL 13 COLON-ALIGNED
     fi-compto-fim AT ROW 7.17 COL 43.72 COLON-ALIGNED NO-LABEL
     fi-tp-mater-ini AT ROW 8.13 COL 13 COLON-ALIGNED HELP
          "C¢digo do estabelecimento."
     fi-tp-mater-fim AT ROW 8.17 COL 43.72 COLON-ALIGNED HELP
          "C¢digo do estabelecimento." NO-LABEL
     fi-lubrific-ini AT ROW 9.17 COL 13 COLON-ALIGNED
     fi-lubrific-fim AT ROW 9.17 COL 43.72 COLON-ALIGNED HELP
          "C¢digo do Setor da Oficina" NO-LABEL
     fi-tag-ini AT ROW 10.17 COL 13 COLON-ALIGNED
     fi-tag-fim AT ROW 10.17 COL 43.72 COLON-ALIGNED NO-LABEL
     fi-cc-ini AT ROW 11.17 COL 13 COLON-ALIGNED
     fi-cc-fim AT ROW 11.17 COL 43.72 COLON-ALIGNED NO-LABEL
     fi-unid-negoc-ini AT ROW 12.17 COL 13 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio"
     fi-unid-negoc-fim AT ROW 12.17 COL 43.72 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio" NO-LABEL
     btOK AT ROW 13.46 COL 2
     btCancel AT ROW 13.46 COL 13
     btHelp2 AT ROW 13.46 COL 55
     IMAGE-10 AT ROW 7.17 COL 41.86
     IMAGE-11 AT ROW 8.17 COL 41.86
     IMAGE-12 AT ROW 8.13 COL 35.86
     IMAGE-13 AT ROW 3.17 COL 41.86
     IMAGE-14 AT ROW 3.13 COL 35.86
     IMAGE-15 AT ROW 9.17 COL 35.86
     IMAGE-16 AT ROW 9.17 COL 41.86
     IMAGE-21 AT ROW 2.17 COL 41.86
     IMAGE-22 AT ROW 2.13 COL 35.86
     IMAGE-23 AT ROW 1.17 COL 41.86
     IMAGE-24 AT ROW 1.17 COL 35.86
     IMAGE-29 AT ROW 4.17 COL 41.86
     IMAGE-30 AT ROW 4.13 COL 35.86
     IMAGE-43 AT ROW 10.17 COL 41.86
     IMAGE-44 AT ROW 11.17 COL 35.86
     IMAGE-45 AT ROW 11.17 COL 41.86
     IMAGE-46 AT ROW 10.17 COL 35.86
     IMAGE-5 AT ROW 5.13 COL 35.86
     IMAGE-6 AT ROW 5.17 COL 41.86
     IMAGE-7 AT ROW 6.17 COL 35.86
     IMAGE-8 AT ROW 6.17 COL 41.86
     IMAGE-9 AT ROW 7.13 COL 35.86
     rtToolBar AT ROW 13.25 COL 1
     IMAGE-50 AT ROW 12.17 COL 35.86
     IMAGE-51 AT ROW 12.17 COL 41.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65 BY 13.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 13.71
         WIDTH              = 65
         MAX-HEIGHT         = 14.29
         MAX-WIDTH          = 65
         VIRTUAL-HEIGHT     = 14.29
         VIRTUAL-WIDTH      = 65
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-empresa-fim IN FRAME fpage0
   LIKE = ems2cad.empresa.ep-codigo                                     */
/* SETTINGS FOR FILL-IN fi-empresa-ini IN FRAME fpage0
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    run piGrava in this-procedure.  
    apply "CLOSE":U to this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


ASSIGN fi-empresa-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF.
       fi-empresa-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

/*--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Empresa"}
assign fi-empresa-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Equipamento"}
assign fi-equipto-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i Data * }
assign fi-data-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Modelo"}
assign fi-modelo-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i "Documento"}
assign fi-docto-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i N£mero_Amostra * }
assign fi-amostra-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i Compartimento * }
assign fi-compto-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i Tipo_Material * }
assign fi-tp-mater-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i Lubrifica‡Æo  }
assign fi-lubrific-ini:label in frame fPage0 = trim(return-value).
{utp/ut-liter.i Unidade_Neg¢cio  }
assign fi-unid-negoc-ini:label in frame fPage0 = trim(return-value).

ASSIGN fi-unid-negoc-ini:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-ini:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-fim:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-fim:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-50:VISIBLE            IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-51:VISIBLE            IN FRAME fPage0 = l-usa-unid-negoc.

do with frame fPage0:
    find first ttSelecao no-lock no-error.
    if avail ttSelecao then do:
        assign fi-empresa-ini:screen-value   = string(ttSelecao.empresa-ini)
               fi-empresa-fim:screen-value   = string(ttSelecao.empresa-fim)
               fi-equipto-ini:screen-value   = ttSelecao.equipto-ini
               fi-equipto-fim:screen-value   = ttSelecao.equipto-fim
               fi-modelo-ini:screen-value    = ttSelecao.modelo-ini 
               fi-modelo-fim:screen-value    = ttSelecao.modelo-fim 
               fi-data-ini:screen-value      = string(ttSelecao.data-ini) 
               fi-data-fim:screen-value      = string(ttSelecao.data-fim) 
               fi-docto-ini:screen-value     = string(ttSelecao.docto-ini)  
               fi-docto-fim:screen-value     = string(ttSelecao.docto-fim)  
               fi-amostra-ini:screen-value   = string(ttSelecao.amostra-ini) 
               fi-amostra-fim:screen-value   = string(ttSelecao.amostra-fim) 
               fi-compto-ini:screen-value    = ttSelecao.compto-ini   
               fi-compto-fim:screen-value    = ttSelecao.compto-fim   
               fi-tp-mater-ini:screen-value  = ttSelecao.tp-mater-ini
               fi-tp-mater-fim:screen-value  = ttSelecao.tp-mater-fim
               fi-lubrific-ini:screen-value  = string(ttSelecao.lubrific-ini)  
               fi-lubrific-fim:screen-value  = string(ttSelecao.lubrific-fim)
               fi-tag-ini:screen-value       = ttSelecao.tag-ini
               fi-tag-fim:screen-value       = ttSelecao.tag-fim
               fi-cc-ini:screen-value        = ttSelecao.cc-ini
               fi-cc-fim:screen-value        = ttSelecao.cc-fim.

        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                ASSIGN fi-unid-negoc-ini:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.unid-negoc-ini
                       fi-unid-negoc-fim:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.unid-negoc-fim.
            END.
        &ENDIF
    end.
end.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGrava wWindow 
PROCEDURE piGrava :
/*------------------------------------------------------------------------------
  Purpose:     piGrava
  Parameters:  <none>
  Notes:       Grava os dados de tela na temp-table 
------------------------------------------------------------------------------*/
find first ttSelecao exclusive-lock no-error.
if avail ttSelecao then do:
    assign &IF "{&mguni_version}" >= "2.071" &THEN
           ttSelecao.empresa-ini   =  fi-empresa-ini:screen-value in frame fPage0
           ttSelecao.empresa-fim   =  fi-empresa-fim:screen-value in frame fPage0
           &ELSE
           ttSelecao.empresa-ini   =  int(fi-empresa-ini:screen-value in frame fPage0)    
           ttSelecao.empresa-fim   =  int(fi-empresa-fim:screen-value in frame fPage0)    
           &ENDIF
           ttSelecao.equipto-ini   =  fi-equipto-ini:screen-value in frame fPage0    
           ttSelecao.equipto-fim   =  fi-equipto-fim:screen-value in frame fPage0    
           ttSelecao.modelo-ini    =  fi-modelo-ini:screen-value in frame fPage0      
           ttSelecao.modelo-fim    =  fi-modelo-fim:screen-value in frame fPage0      
           ttSelecao.data-ini      =  date(fi-data-ini:screen-value in frame fPage0)
           ttSelecao.data-fim      =  date(fi-data-fim:screen-value in frame fPage0)
           ttSelecao.docto-ini     =  int(fi-docto-ini:screen-value in frame fPage0)      
           ttSelecao.docto-fim     =  int(fi-docto-fim:screen-value in frame fPage0)      
           ttSelecao.amostra-ini   =  fi-amostra-ini:screen-value in frame fPage0        
           ttSelecao.amostra-fim   =  fi-amostra-fim:screen-value in frame fPage0        
           ttSelecao.compto-ini    =  fi-compto-ini:screen-value in frame fPage0     
           ttSelecao.compto-fim    =  fi-compto-fim:screen-value in frame fPage0     
           ttSelecao.tp-mater-ini  =  fi-tp-mater-ini:screen-value in frame fPage0     
           ttSelecao.tp-mater-fim  =  fi-tp-mater-fim:screen-value in frame fPage0     
           ttSelecao.lubrific-ini  =  int(fi-lubrific-ini:screen-value in frame fPage0)        
           ttSelecao.lubrific-fim  =  int(fi-lubrific-fim:screen-value in frame fPage0)
           ttSelecao.tag-ini       =  fi-tag-ini:screen-value in frame fPage0     
           ttSelecao.tag-fim       =  fi-tag-fim:screen-value in frame fPage0
           ttSelecao.cc-ini        =  fi-cc-ini:screen-value in frame fPage0
           ttSelecao.cc-fim        =  fi-cc-fim:screen-value in frame fPage0.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN ttSelecao.unid-negoc-ini = fi-unid-negoc-ini:screen-value in frame fPage0
                   ttSelecao.unid-negoc-fim = fi-unid-negoc-fim:screen-value in frame fPage0.
        END.
    &ENDIF
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

