&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-antecip-import NO-UNDO LIKE antecip-import
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0055N2 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0055N2 MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0055N2
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   de-vl-vincular btExit btHelp btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

{cxbo/bocx00451.i1}

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER phCaller  AS   HANDLE                                          NO-UNDO.
DEFINE INPUT PARAMETER pr-recid  LIKE tt_tit_ap_antecip_sdo_a_vincular.ttv_rec_tit_ap NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt_tit_ap_antecip_sdo_a_vincular.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-lb-valor-informado             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lb-sld-disponivel              AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-1 btExit btHelp ~
fi-cod-estab-ap fi-cdn-emitente-ap fi-nom-abrev-ap fi-cod-espec-docto-ap ~
fi-cod-refer-antecip-ap fi-cod-ser-docto-ap fi-cod-moed-ap fi-cod-tit-ap ~
fi-dat-transacao fi-cod-parc-ap de-val-sdo-tit-ap de-vl-vincular btOK ~
btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estab-ap fi-cdn-emitente-ap ~
fi-nom-abrev-ap fi-cod-espec-docto-ap fi-cod-refer-antecip-ap ~
fi-cod-ser-docto-ap fi-cod-moed-ap fi-cod-tit-ap fi-dat-transacao ~
fi-cod-parc-ap de-val-sdo-tit-ap de-vl-vincular 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE de-val-sdo-tit-ap LIKE tt-antecip-import.val-sdo-tit-ap
     LABEL "Valor Saldo T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-vincular AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor a Vincular" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cdn-emitente-ap LIKE tt-antecip-import.cdn-emitente-ap
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-espec-docto-ap LIKE tt-antecip-import.cod-espec-docto-ap
     LABEL "Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab-ap LIKE tt-antecip-import.cod-estab-ap
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-moed-ap LIKE tt-antecip-import.cod-moed-ap
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-parc-ap LIKE tt-antecip-import.cod-parc-ap
     LABEL "Parcela" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-refer-antecip-ap LIKE tt-antecip-import.cod-refer-antecip-ap
     LABEL "Referˆncia" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-ap LIKE tt-antecip-import.cod-ser-docto-ap
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-tit-ap LIKE tt-antecip-import.cod-tit-ap
     LABEL "T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dat-transacao LIKE tt-antecip-import.dat-transacao
     LABEL "Data Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nom-abrev-ap LIKE tt-antecip-import.nom-abrev-ap
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 6.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     fi-cod-estab-ap AT ROW 2.75 COL 15 COLON-ALIGNED HELP
          "Estabelecimento do Titulo do Contas a Pagar" WIDGET-ID 6
          LABEL "Estabelecimento"
     fi-cdn-emitente-ap AT ROW 3.75 COL 15 COLON-ALIGNED HELP
          "Emitente do T¡tulo do Contas a Pagar" WIDGET-ID 2
          LABEL "Fornecedor"
     fi-nom-abrev-ap AT ROW 3.75 COL 23 COLON-ALIGNED HELP
          "Nome Abreviado Emitente Contas a Pagar" NO-LABEL WIDGET-ID 20
     fi-cod-espec-docto-ap AT ROW 4.75 COL 15 COLON-ALIGNED HELP
          "Esp‚cie do T¡tulo do Contas a pagar" WIDGET-ID 4
          LABEL "Esp‚cie"
     fi-cod-refer-antecip-ap AT ROW 4.75 COL 60 COLON-ALIGNED HELP
          "" WIDGET-ID 12
          LABEL "Referˆncia"
     fi-cod-ser-docto-ap AT ROW 5.75 COL 15 COLON-ALIGNED HELP
          "" WIDGET-ID 14
          LABEL "S‚rie"
     fi-cod-moed-ap AT ROW 5.75 COL 60 COLON-ALIGNED HELP
          "" WIDGET-ID 8
          LABEL "Moeda"
     fi-cod-tit-ap AT ROW 6.75 COL 15 COLON-ALIGNED HELP
          "" WIDGET-ID 16
          LABEL "T¡tulo"
     fi-dat-transacao AT ROW 6.75 COL 60 COLON-ALIGNED HELP
          "" WIDGET-ID 18
          LABEL "Data Transa‡Æo"
     fi-cod-parc-ap AT ROW 7.75 COL 15 COLON-ALIGNED HELP
          "" WIDGET-ID 10
          LABEL "Parcela"
     de-val-sdo-tit-ap AT ROW 7.75 COL 60 COLON-ALIGNED HELP
          "" WIDGET-ID 22
          LABEL "Valor Saldo T¡tulo"
     de-vl-vincular AT ROW 9.17 COL 60 COLON-ALIGNED WIDGET-ID 24
     btOK AT ROW 10.58 COL 2
     btCancel AT ROW 10.58 COL 13
     btHelp2 AT ROW 10.58 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 10.38 COL 1
     RECT-1 AT ROW 2.5 COL 1 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.96
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-antecip-import T "?" NO-UNDO mgcad antecip-import
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 11
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
/* SETTINGS FOR FILL-IN de-val-sdo-tit-ap IN FRAME fpage0
   LIKE = Temp-Tables.tt-antecip-import.val-sdo-tit-ap EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN fi-cdn-emitente-ap IN FRAME fpage0
   LIKE = Temp-Tables.tt-antecip-import.cdn-emitente-ap EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN fi-cod-espec-docto-ap IN FRAME fpage0
   LIKE = Temp-Tables.tt-antecip-import.cod-espec-docto-ap EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN fi-cod-estab-ap IN FRAME fpage0
   LIKE = Temp-Tables.tt-antecip-import.cod-estab-ap EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN fi-cod-moed-ap IN FRAME fpage0
   LIKE = Temp-Tables.tt-antecip-import.cod-moed-ap EXP-LABEL EXP-SIZE  */
/* SETTINGS FOR FILL-IN fi-cod-parc-ap IN FRAME fpage0
   LIKE = Temp-Tables.tt-antecip-import.cod-parc-ap EXP-LABEL EXP-SIZE  */
/* SETTINGS FOR FILL-IN fi-cod-refer-antecip-ap IN FRAME fpage0
   LIKE = Temp-Tables.tt-antecip-import.cod-refer-antecip-ap EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN fi-cod-ser-docto-ap IN FRAME fpage0
   LIKE = Temp-Tables.tt-antecip-import.cod-ser-docto-ap EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN fi-cod-tit-ap IN FRAME fpage0
   LIKE = Temp-Tables.tt-antecip-import.cod-tit-ap EXP-LABEL EXP-SIZE   */
/* SETTINGS FOR FILL-IN fi-dat-transacao IN FRAME fpage0
   LIKE = Temp-Tables.tt-antecip-import.dat-transacao EXP-LABEL EXP-SIZE */
/* SETTINGS FOR FILL-IN fi-nom-abrev-ap IN FRAME fpage0
   LIKE = Temp-Tables.tt-antecip-import.nom-abrev-ap EXP-SIZE           */
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


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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
    ASSIGN INPUT FRAME fPage0 de-vl-vincular.

    IF de-vl-vincular <= 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 1470,
                           INPUT "").
        APPLY "entry":U TO de-vl-vincular IN FRAME fPage0.
        RETURN NO-APPLY.
    END.
    
    IF de-vl-vincular > tt_tit_ap_antecip_sdo_a_vincular.tta_val_sdo_vincular THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 55720,
                           INPUT c-lb-valor-informado + "~~" + 
                                 c-lb-sld-disponivel  + "~~" + 
                                 STRING(de-vl-vincular, "->>>,>>>,>>9.99":U) + "~~" +
                                 STRING(tt_tit_ap_antecip_sdo_a_vincular.tta_val_sdo_vincular,"->>>,>>>,>>9.99":U)).
        APPLY "entry":U TO de-vl-vincular IN FRAME fPage0.
        RETURN NO-APPLY.    
    END.

    RUN piVinculaAntecipacao IN phCaller (INPUT tt_tit_ap_antecip_sdo_a_vincular.ttv_rec_tit_ap,
                                          INPUT de-vl-vincular).

    RUN getRowErrors IN phCaller (OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorSubType = "ERROR":U ) then do:
        /** Instancia aplicativo **/
        {method/showmessage.i1}
        /** Mostra caixa com erros **/
        {method/showmessage.i2 &Modal="YES"}
        /** Limpa temp-tables de erros **/
        empty temp-table RowErrors.

        APPLY "ENTRY":U TO de-vl-vincular IN FRAME fpage0.
    END.
    ELSE DO:
        RUN openQueriesSon       IN phCaller.
        APPLY "CLOSE":U TO THIS-PROCEDURE.  
    END.

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa‡Æo dos campos em tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {utp/ut-liter.i Valor_Informado *}
    ASSIGN c-lb-valor-informado = TRIM(RETURN-VALUE).
    {utp/ut-liter.i o_Saldo_a_Vincular_ao_Embarque * }
    ASSIGN c-lb-sld-disponivel  = TRIM(RETURN-VALUE).

    FOR FIRST tt_tit_ap_antecip_sdo_a_vincular FIELDS(tta_cod_estab tta_cdn_fornecedor tta_nom_abrev_fornec tta_cod_espec_docto tta_cod_ser_docto tta_cod_tit_ap 
                                                      tta_cod_parcela tta_cod_refer tta_cod_indic_econ tta_dat_transacao tta_val_sdo_tit_ap tta_val_sdo_vincular )
        WHERE tt_tit_ap_antecip_sdo_a_vincular.ttv_rec_tit_ap = pr-recid NO-LOCK:

        ASSIGN fi-cod-estab-ap:SCREEN-VALUE         IN FRAME fPage0 = tt_tit_ap_antecip_sdo_a_vincular.tta_cod_estab       
               fi-cdn-emitente-ap:SCREEN-VALUE      IN FRAME fPage0 = STRING(tt_tit_ap_antecip_sdo_a_vincular.tta_cdn_fornecedor)
               fi-nom-abrev-ap:SCREEN-VALUE         IN FRAME fPage0 = tt_tit_ap_antecip_sdo_a_vincular.tta_nom_abrev_fornec
               fi-cod-espec-docto-ap:SCREEN-VALUE   IN FRAME fPage0 = tt_tit_ap_antecip_sdo_a_vincular.tta_cod_espec_docto 
               fi-cod-ser-docto-ap:SCREEN-VALUE     IN FRAME fPage0 = tt_tit_ap_antecip_sdo_a_vincular.tta_cod_ser_docto   
               fi-cod-tit-ap:SCREEN-VALUE           IN FRAME fPage0 = tt_tit_ap_antecip_sdo_a_vincular.tta_cod_tit_ap      
               fi-cod-parc-ap:SCREEN-VALUE          IN FRAME fPage0 = tt_tit_ap_antecip_sdo_a_vincular.tta_cod_parcela     
               fi-cod-refer-antecip-ap:SCREEN-VALUE IN FRAME fPage0 = tt_tit_ap_antecip_sdo_a_vincular.tta_cod_refer       
               fi-cod-moed-ap:SCREEN-VALUE          IN FRAME fPage0 = tt_tit_ap_antecip_sdo_a_vincular.tta_cod_indic_econ  
               fi-dat-transacao:SCREEN-VALUE        IN FRAME fPage0 = STRING(tt_tit_ap_antecip_sdo_a_vincular.tta_dat_transacao)
               de-val-sdo-tit-ap:SCREEN-VALUE       IN FRAME fPage0 = STRING(tt_tit_ap_antecip_sdo_a_vincular.tta_val_sdo_tit_ap).
               de-vl-vincular:SCREEN-VALUE          IN FRAME fPage0 = STRING(tt_tit_ap_antecip_sdo_a_vincular.tta_val_sdo_vincular).

    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose: Elimina‡Æo de handles utilizados pelo programa 
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
    {method/showmessage.i3}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


