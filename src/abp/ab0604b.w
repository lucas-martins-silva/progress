&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i AB0604B 2.00.00.003 } /*** 010003 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0604b MAB}
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
&GLOBAL-DEFINE Program        AB0604B
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 slDisp slSelect

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def temp-table ttVisao no-undo
    field dimensao  as char
    field sequencia as integer
    index codigo is primary unique sequencia.

define temp-table tt-lista no-undo
    field c-value as char
    field c-label as char
    field i-seq   as int.

def input-output param table for ttVisao.

def var cDimensoes2 as char  no-undo.
def var lResult     as log  no-undo.
def var iPos        as int  no-undo.
def var cTemp       as char no-undo.
def var cLista      as char no-undo.
def var iCont       as int  no-undo.
def var iCont2      as int  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 rtToolBar slDisp btAddAllTarget ~
slSelect btUp btAddTarget btDelTarget btDown btDelAllTarget btOK btCancel ~
btHelp2 
&Scoped-Define DISPLAYED-OBJECTS slDisp slSelect 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btAddAllTarget 
     IMAGE-UP FILE "image\add-all":U
     IMAGE-INSENSITIVE FILE "image\ii-add-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui Todos".

DEFINE BUTTON btAddTarget 
     IMAGE-UP FILE "image/next-au":U
     IMAGE-INSENSITIVE FILE "image/next-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Inclui".

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDelAllTarget 
     IMAGE-UP FILE "image\del-all":U
     IMAGE-INSENSITIVE FILE "image\ii-del-all":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira Todos".

DEFINE BUTTON btDelTarget 
     IMAGE-UP FILE "image/prev-au":U
     IMAGE-INSENSITIVE FILE "image/prev-ai":U
     LABEL "" 
     SIZE 7 BY 1 TOOLTIP "Retira".

DEFINE BUTTON btDown 
     IMAGE-UP FILE "image\im-down2":U
     IMAGE-INSENSITIVE FILE "image\ii-down2":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Inclui Todos".

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btUp 
     IMAGE-UP FILE "image\im-up2":U
     IMAGE-INSENSITIVE FILE "image\ii-up2":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Inclui Todos".

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64.29 BY 5.88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 65.57 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE slDisp AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 24.14 BY 4.92 NO-UNDO.

DEFINE VARIABLE slSelect AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 24.14 BY 4.92 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     slDisp AT ROW 1.83 COL 2.86 NO-LABEL
     btAddAllTarget AT ROW 1.88 COL 27.72
     slSelect AT ROW 1.88 COL 35.29 NO-LABEL
     btUp AT ROW 2.5 COL 60.57
     btAddTarget AT ROW 3.13 COL 27.72
     btDelTarget AT ROW 4.38 COL 27.72
     btDown AT ROW 4.5 COL 60.57
     btDelAllTarget AT ROW 5.63 COL 27.72
     btOK AT ROW 7.71 COL 2
     btCancel AT ROW 7.71 COL 13
     btHelp2 AT ROW 7.71 COL 50
     "Dimensäes Dispon¡veis:" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 1.08 COL 6.14
     "Dimensäes Selecionadas:" VIEW-AS TEXT
          SIZE 18.14 BY .54 AT ROW 1.13 COL 37.57
     RECT-2 AT ROW 1.33 COL 1.72
     rtToolBar AT ROW 7.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.86 BY 8.08
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
         HEIGHT             = 8.13
         WIDTH              = 65.43
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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


&Scoped-define SELF-NAME btAddAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddAllTarget wWindow
ON CHOOSE OF btAddAllTarget IN FRAME fpage0
DO:
  &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
  do while slDisp:LIST-ITEM-PAIRS <> ?:
  &else
  do while slDisp:LIST-ITEMS <> ?:
  &endif
    apply 'choose' to btAddtarget.
  end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddTarget wWindow
ON CHOOSE OF btAddTarget IN FRAME fpage0
DO:  
   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then                                            
        if slSelect:LIST-ITEM-PAIRS = ? then
           assign lResult = slSelect:add-last (input frame fPage0 slDisp,
                                               input frame fPage0 slDisp)
                            slSelect:screen-value = input frame fPage0 slDisp.
       else 
           assign lResult = slSelect:add-last (input frame fPage0 slDisp,
                                               input frame fPage0 slDisp)
                            slSelect:screen-value = input frame fPage0 slDisp.
       if lResult then do:
          slDisp:delete (input frame fPage0 slDisp).      
          if slDisp:LIST-ITEM-PAIRS <> ? then
             assign slDisp:screen-value = entry (1, slDisp:LIST-ITEM-PAIRS).
       end.
       assign btAddTarget:sensitive    = (slDisp:LIST-ITEM-PAIRS   <> ?)
              btAddAllTarget:sensitive = (slDisp:LIST-ITEM-PAIRS   <> ?)
              btDelTarget:sensitive    = (slSelect:LIST-ITEM-PAIRS <> ?)
              btDelAllTarget:sensitive = (slSelect:LIST-ITEM-PAIRS <> ?)
              btUp:sensitive           = (slSelect:LIST-ITEM-PAIRS <> ?)
              btDown:sensitive         = (slSelect:LIST-ITEM-PAIRS <> ?).
    &else
    
       /*Normal sem tradu‡Æo*/
       if slSelect:list-items = ? then
          assign lResult = slSelect:add-last (input frame fPage0 slDisp)
                           slSelect:screen-value = input frame fPage0 slDisp.
       else 
           /*assign lResult = slSelect:insert (input frame fPage0 slDisp , 
                                             input frame fPage0 slSelect).*/
           assign lResult = slSelect:add-last (input frame fPage0 slDisp)
                            slSelect:screen-value = input frame fPage0 slDisp.
    
       if lResult then do:
          slDisp:delete (input frame fPage0 slDisp).      
          if slDisp:list-items <> ? then
             assign slDisp:screen-value = entry (1, slDisp:list-items).
       end.

       assign btAddTarget:sensitive    = (slDisp:list-items   <> ?)
              btAddAllTarget:sensitive = (slDisp:list-items   <> ?)
              btDelTarget:sensitive    = (slSelect:list-items <> ?)
              btDelAllTarget:sensitive = (slSelect:list-items <> ?)
              btUp:sensitive           = (slSelect:list-items <> ?)
              btDown:sensitive         = (slSelect:list-items <> ?).
    &endif
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


&Scoped-define SELF-NAME btDelAllTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelAllTarget wWindow
ON CHOOSE OF btDelAllTarget IN FRAME fpage0
DO:
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    do while slSelect:LIST-ITEM-PAIRS <> ?:
    &else
    do while slSelect:list-items <> ?:
    &endif
    apply 'choose' to btDeltarget.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelTarget wWindow
ON CHOOSE OF btDelTarget IN FRAME fpage0
DO:
  
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then  
      if slDisp:LIST-ITEM-PAIRS = ? then
           assign lResult = slDisp:add-last (input frame fPage0 slSelect,
                                             input frame fPage0 slSelect)
                            slDisp:screen-value = input frame fPage0 slSelect.
       else 
           assign lResult = slDisp:add-last (input frame fPage0 slSelect,
                                             input frame fPage0 slSelect)
                            slDisp:screen-value = input frame fPage0 slSelect.
      
      if lResult then do:
         slSelect:delete (input frame fPage0 slSelect).      
         if slSelect:LIST-ITEM-PAIRS <> ? then
            assign slSelect:screen-value = entry (1, slSelect:LIST-ITEM-PAIRS).
      end.
      
      assign btAddTarget:sensitive    = (slDisp:LIST-ITEM-PAIRS   <> ?)
             btAddAllTarget:sensitive = (slDisp:LIST-ITEM-PAIRS   <> ?)
             btDelTarget:sensitive    = (slSelect:LIST-ITEM-PAIRS <> ?)
             btDelAllTarget:sensitive = (slSelect:LIST-ITEM-PAIRS <> ?)
             btUp:sensitive           = (slSelect:LIST-ITEM-PAIRS <> ?)
             btDown:sensitive         = (slSelect:LIST-ITEM-PAIRS <> ?).  
  &else
      /*Normal sem tradu‡Æo*/
      if slDisp:list-items = ? THEN
          assign lResult = slDisp:add-last (input frame fPage0 slSelect)
                           slDisp:screen-value = input frame fPage0 slSelect.
      else 
          assign lResult = slDisp:insert (input frame fPage0 slSelect, 
                                          input frame fPage0 slDisp).
      if lResult then do:
         slSelect:delete (input frame fPage0 slSelect).      
         if slSelect:list-items <> ? then
            assign slSelect:screen-value = entry (1, slSelect:list-items).
      end.
      
      assign btAddTarget:sensitive    = (slDisp:list-items   <> ?)
             btAddAllTarget:sensitive = (slDisp:list-items   <> ?)
             btDelTarget:sensitive    = (slSelect:list-items <> ?)
             btDelAllTarget:sensitive = (slSelect:list-items <> ?)
             btUp:sensitive           = (slSelect:list-items <> ?)
             btDown:sensitive         = (slSelect:list-items <> ?).
  &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDown wWindow
ON CHOOSE OF btDown IN FRAME fpage0
DO:
   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       DEFINE buffer bflista FOR tt-lista.
       ASSIGN slSelect.
       assign iPos = slSelect:lookup (input slSelect).
       if iPos < (num-entries (slSelect:LIST-ITEM-PAIRS) / 2) then do:
          FOR EACH tt-lista:
              DELETE tt-lista.
          END.
          do iCont = 1 to num-entries (slSelect:LIST-ITEM-PAIRS):
              ASSIGN icont = icont + 1.
              CREATE tt-lista.
              ASSIGN tt-lista.i-seq = icont / 2
                     tt-lista.c-value = entry(icont,slSelect:list-item-pairs) 
                     tt-lista.c-label = entry(icont,slSelect:list-item-pairs).
          END.
          for first tt-lista
              where tt-lista.i-seq = ipos exclusive-lock:
              for first BfLista
                  where BfLista.i-seq   = tt-lista.i-seq + 1 exclusive-lock:
                  assign BfLista.i-seq  = tt-lista.i-seq
                         tt-lista.i-seq = ipos + 1.
              end.
          end.
          assign slSelect:list-item-pairs = ?.
          for each tt-lista by tt-lista.i-seq:
                 slSelect:add-last (tt-lista.c-value, 
                                    tt-lista.c-label).
          end.
          assign icont  = (ipos * 2) + 2
                 slSelect:screen-value = entry (icont, slSelect:list-item-pairs).
       end. 
   &else 
       ASSIGN slSelect.
       assign iPos = slSelect:lookup (input slSelect).
       if iPos < num-entries (slSelect:list-items) then do:
          assign cLista = "".
          do iCont = 1 to num-entries (slSelect:list-items):
             case iCont:
                  when iPos then
                       assign cTemp  = entry (iPos, slSelect:list-items)
                              cLista = cLista + (if cLista = "" then "" else ",") +
                                        entry (iPos + 1, slSelect:list-items).
    
                  when iPos + 1 then
                       assign cLista = cLista + (if cLista = "" then "" else ",") +
                                        cTemp.
                  otherwise assign cLista = cLista + (if cLista = "" then "" else ",") +
                                             entry (iCont, slSelect:list-items).
             end case.
          end.
          assign slSelect:list-items   = cLista
                 slSelect:screen-value = entry (iPos + 1, slSelect:list-items).
       end.
   &endif
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
    &IF integer(entry(1,proversion,".")) >= 9 &THEN
        EMPTY TEMP-TABLE ttVisao.
    &ELSE
        for each ttVisao:
            delete ttVisao.
        end.
    &ENDIF
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then 
        do iCont = 1 to num-entries (slSelect:LIST-ITEM-PAIRS):
           create ttVisao.
           assign icont            = icont + 1
                  ttVisao.sequencia = iCont / 2
                  ttVisao.dimensao  = entry (iCont, slSelect:LIST-ITEM-PAIRS).
        end.
    &else
        do iCont = 1 to num-entries (slSelect:list-items):
           create ttVisao.
           assign ttVisao.sequencia = iCont
                  ttVisao.dimensao  = entry (iCont, slSelect:list-items).
        end.
    &endif
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUp wWindow
ON CHOOSE OF btUp IN FRAME fpage0
DO:
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then   
       DEFINE BUFFER bflista FOR tt-lista.
       ASSIGN slSelect.
       assign iPos = slSelect:lookup (input slSelect).
       if iPos > 1 then do:
          assign cLista = "".
          FOR EACH tt-lista:
              DELETE tt-lista.
          END.
          do iCont = 1 to num-entries (slSelect:LIST-ITEM-PAIRS):
             ASSIGN icont = icont + 1.
             CREATE tt-lista.
             ASSIGN tt-lista.i-seq   = icont / 2
                    tt-lista.c-value = entry(icont,slSelect:list-item-pairs)
                    tt-lista.c-label = entry(icont,slSelect:list-item-pairs).
          end.
          for first tt-lista
              where tt-lista.i-seq = ipos exclusive-lock:
              for first BfLista
                  where BfLista.i-seq   = tt-lista.i-seq - 1 exclusive-lock:
                  assign BfLista.i-seq  = tt-lista.i-seq
                         tt-lista.i-seq = ipos - 1.
              end.
          end.
          assign slSelect:list-item-pairs = ?.
          for each tt-lista by tt-lista.i-seq:
                slSelect:add-last (tt-lista.c-value, 
                                   tt-lista.c-label).
          end.

          assign icont  = (ipos * 2) - 2
                 slSelect:screen-value = entry (icont, slSelect:list-item-pairs).
       end. 
  &else      
       /*Nomal sem tradu‡Æo*/ 
       ASSIGN slSelect.
       assign iPos = slSelect:lookup (input slSelect).
       if iPos > 1 then do:
          assign cLista = "".
          do iCont = 1 to num-entries (slSelect:list-items):
             case iCont:
                  when iPos - 1 then
                       assign cTemp  = entry (iPos - 1, slSelect:list-items)
                              cLista = cLista + (if cLista = "" then "" else ",") +
                                        entry (iPos, slSelect:list-items).
                  when iPos then
                       assign cLista = cLista + (if cLista = "" then "" else ",") +
                                        cTemp.
                  otherwise assign cLista = cLista + (if cLista = "" then "" else ",") +
                                             entry (iCont, slSelect:list-items).
             end case.
          end.
          assign slSelect:list-items   = cLista
                 slSelect:screen-value = entry (iPos - 1, slSelect:list-items).
       end.
  &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slDisp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slDisp wWindow
ON MOUSE-SELECT-DBLCLICK OF slDisp IN FRAME fpage0
DO:
  
  apply 'choose' to btAddTarget.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME slSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL slSelect wWindow
ON MOUSE-SELECT-DBLCLICK OF slSelect IN FRAME fpage0
DO:
  
  apply 'choose' to btDelTarget.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


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

    {utp/ut-liter.i Empresa}
    ASSIGN cDimensoes2 = '01 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Tipo_Equipamento}
    ASSIGN cDimensoes2 = cDimensoes2 + ',02 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Estrutura_Mecƒnica}
    ASSIGN cDimensoes2 = cDimensoes2 + ',03 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Grupo}
    ASSIGN cDimensoes2 = cDimensoes2 + ',04 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Modelo}
    ASSIGN cDimensoes2 = cDimensoes2 + ',05 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Equipamento}
    ASSIGN cDimensoes2 = cDimensoes2 + ',06 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Ano_Fabrica‡Æo}
    ASSIGN cDimensoes2 = cDimensoes2 + ',07 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Estabelecimento}
    ASSIGN cDimensoes2 = cDimensoes2 + ',08 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Tag}
    ASSIGN cDimensoes2 = cDimensoes2 + ',09 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Situa‡Æo}
    ASSIGN cDimensoes2 = cDimensoes2 + ',10 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Propriet rio}
    ASSIGN cDimensoes2 = cDimensoes2 + ',11 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Marca}
    ASSIGN cDimensoes2 = cDimensoes2 + ',12 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Centro_Custo}
    ASSIGN cDimensoes2 = cDimensoes2 + ',13 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Data_Compra}
    ASSIGN cDimensoes2 = cDimensoes2 + ',14 ' +  trim(RETURN-VALUE).
    {utp/ut-liter.i Valor_Compra}
    ASSIGN cDimensoes2 = cDimensoes2 + ',15 ' +  trim(RETURN-VALUE).

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            {utp/ut-liter.i Unidade_Neg¢cio}
            ASSIGN cDimensoes2 = cDimensoes2 + ',16 ' +  trim(RETURN-VALUE).
            END.
    &ENDIF
    {utp/ut-liter.i Tipo_Material}
    ASSIGN cDimensoes2 = cDimensoes2 + ',17 ' +  trim(RETURN-VALUE).

DO WITH FRAME fPage0:
    for each ttVisao BY ttVisao.sequencia:
        slSelect:add-last (ttVisao.dimensao).        
    end.
    /*Normal*/
    do iCont = 1 to num-entries(cDimensoes2):
        if not can-find (ttVisao where
                         ttVisao.dimensao = entry(iCont,cDimensoes2)) then
           slDisp:add-last (entry(iCont,cDimensoes2)).
    end.    
    
    if slDisp:list-items <> ? then
       assign slDisp:screen-value = entry (1, slDisp:list-items).
   
    if slSelect:list-items <> ? then
       assign slSelect:screen-value = entry (1, slSelect:list-items).
       
    assign btAddTarget:sensitive    = (slDisp:list-items   <> ?)
           btAddAllTarget:sensitive = (slDisp:list-items   <> ?)
           btDelTarget:sensitive    = (slSelect:list-items <> ?)
           btDelAllTarget:sensitive = (slSelect:list-items <> ?)
           btUp:sensitive           = (slSelect:list-items <> ?)
           btDown:sensitive         = (slSelect:list-items <> ?).

END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

