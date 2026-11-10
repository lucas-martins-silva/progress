&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
          movfro           PROGRESS
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
{include/i-prgvrs.i AB0302D 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0302d MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0302D
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              fiDoctoIni fiDoctoFim ~
                              fiEpIni fiEpFim ~
                              fiEqptoIni fiEqptoFim ~
                              fiDataIni fiDataFim

define variable hAcomp as handle     no-undo.
{frbo/bofr055.i tt-abastec}
/* Parameters Definitions ---                                           */
define input parameter p-num-docto like mab-abastec-lubrific.num-docto no-undo.

DEFINE VARIABLE c-msg AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dir_name AS CHARACTER.
DEFINE VARIABLE cLocalXmlGerado AS CHARACTER FORMAT "x(200)" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 ~
IMAGE-6 RECT-21 rtToolBar IMAGE-15 IMAGE-16 fiDataIni fiDataFim fiDoctoIni ~
fiDoctoFim fiEpini fiEpFim fiEqptoIni fiEqptoFim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fiDataIni fiDataFim fiDoctoIni fiDoctoFim ~
fiEpini fiEpFim fiEqptoIni fiEqptoFim 

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

DEFINE VARIABLE fiDataFim AS DATE FORMAT "99/99/9999" INITIAL 10/04/07 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiDataIni AS DATE FORMAT "99/99/9999" INITIAL 10/04/07 
     LABEL "Data Movimento":R17 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiDoctoFim LIKE mab-abastec-lubrific.num-docto
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fiDoctoIni LIKE mab-abastec-lubrific.num-docto
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fiEpFim LIKE mab-eqpto.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEpini LIKE mab-eqpto.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEqptoFim LIKE mab-eqpto.cod-eqpto
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEqptoIni LIKE mab-eqpto.cod-eqpto
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 4.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 63 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiDataIni AT ROW 1.5 COL 19 COLON-ALIGNED HELP
          "Data do movimento"
     fiDataFim AT ROW 1.5 COL 37.14 COLON-ALIGNED HELP
          "Data do movimento" NO-LABEL
     fiDoctoIni AT ROW 2.5 COL 20 COLON-ALIGNED HELP
          ""
     fiDoctoFim AT ROW 2.5 COL 37.14 COLON-ALIGNED HELP
          "" NO-LABEL
     fiEpini AT ROW 3.5 COL 19 HELP
          ""
          FONT 1
     fiEpFim AT ROW 3.5 COL 39.14 HELP
          "" NO-LABEL
          FONT 1
     fiEqptoIni AT ROW 4.5 COL 3 HELP
          ""
          FONT 1
     fiEqptoFim AT ROW 4.5 COL 39.14 HELP
          "" NO-LABEL
          FONT 1
     btOK AT ROW 5.96 COL 2
     btCancel AT ROW 5.96 COL 13
     btHelp2 AT ROW 5.96 COL 52.86
     IMAGE-1 AT ROW 3.5 COL 31.43
     IMAGE-2 AT ROW 3.5 COL 36
     IMAGE-3 AT ROW 4.5 COL 31.43
     IMAGE-4 AT ROW 4.5 COL 36
     IMAGE-5 AT ROW 2.5 COL 31.43
     IMAGE-6 AT ROW 2.5 COL 36
     RECT-21 AT ROW 1 COL 1
     rtToolBar AT ROW 5.75 COL 1
     IMAGE-15 AT ROW 1.5 COL 31.43
     IMAGE-16 AT ROW 1.5 COL 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 63 BY 6.21
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
         TITLE              = "Exportaá∆o Abastecimento"
         HEIGHT             = 6.25
         WIDTH              = 62.86
         MAX-HEIGHT         = 27.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.21
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
/* SETTINGS FOR FILL-IN fiDoctoFim IN FRAME fpage0
   LIKE = movfro.mab-abastec-lubrific.num-docto EXP-SIZE                */
/* SETTINGS FOR FILL-IN fiDoctoIni IN FRAME fpage0
   LIKE = movfro.mab-abastec-lubrific.num-docto EXP-SIZE                */
/* SETTINGS FOR FILL-IN fiEpFim IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-eqpto.ep-codigo EXP-SIZE                    */
/* SETTINGS FOR FILL-IN fiEpini IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-eqpto.ep-codigo EXP-SIZE                    */
/* SETTINGS FOR FILL-IN fiEqptoFim IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-eqpto.cod-eqpto EXP-SIZE                    */
/* SETTINGS FOR FILL-IN fiEqptoIni IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-eqpto.cod-eqpto EXP-SIZE                    */
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
ON END-ERROR OF wWindow /* Exportaá∆o Abastecimento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Exportaá∆o Abastecimento */
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
do:
    blk1:
    do on stop undo, return "NOK":U:

        /** Verifica parametro de integracao do AB0116 **/
        {utp/ut-liter.i Sim}
        for first mab-param-integr
            where mab-param-integr.cdn-param = 10
              and trim(entry(3,mab-param-integr.des-valor)) = trim(return-value) no-lock:
        end.
        if not avail mab-param-integr then return.

        /** Busca catalogo de Documentos **/
        for first catal_docto_anexo
            where catal_docto_anexo.cod_catal_docto_anexo = trim(entry(5,mab-param-integr.des-valor)) no-lock:
        end.
        ASSIGN dir_name = catal_docto_anexo.cod_path_catal + "~\EXP".
        if not avail catal_docto_anexo then return.
        FILE-INFO:FILE-NAME = dir_name.
        IF FILE-INFO:full-pathname = ? THEN DO: 
            {utp/ut-liter.i "Diretorio_n∆o_encontrado_verifique_o_catalogo"}
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-diretorio-nao-encontrado-verif AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-liter-diretorio-nao-encontrado-verif = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-verifique-se-o-diretorio-de-ex AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Verifique_se_o_diret¢rio_de_exportaá∆o_foi_criado_ou_alterado" *}
            ASSIGN c-lbl-liter-verifique-se-o-diretorio-de-ex = TRIM(RETURN-VALUE).
            run utp/ut-msgs.p (input "show",
                               input 17006,
                               input c-lbl-liter-diretorio-nao-encontrado-verif + "~~" 
                               + c-lbl-liter-verifique-se-o-diretorio-de-ex).
            RETURN "NOK":U.
        END.
       {utp/ut-liter.i Algum(s)_arquivo(s)_pode(m)_n∆o_ser_gerado(s)}
       run utp/ut-msgs.p (input "show",
                           input 27979,
                           input RETURN-VALUE ).

        /** Acompanhamento **/
        run utp/ut-acomp.p persistent set hAcomp.
        {utp/ut-liter.i "Integra Rastreamento (XML)"}
        run pi-inicializar in hAcomp (trim(return-value)).
        assign c-msg = "":U.

        for each mab-abastec-lubrific
            where mab-abastec-lubrific.num-docto >= int(fiDoctoIni:screen-value in frame fPage0)
            and   mab-abastec-lubrific.num-docto <= int(fiDoctoFim:screen-value in frame fPage0)
            and   mab-abastec-lubrific.ep-codigo >= &IF "{&mguni_version}" >= "2.071" &THEN fiEpIni:screen-value in frame fPage0 &else int(fiEpIni:screen-value in frame fPage0) &ENDIF
            and   mab-abastec-lubrific.ep-codigo <= &IF "{&mguni_version}" >= "2.071" &THEN fiEpFim:screen-value in frame fPage0 &else int(fiEpFim:screen-value in frame fPage0) &ENDIF
            and   mab-abastec-lubrific.cod-eqpto >= fiEqptoIni:screen-value in frame fPage0  
            and   mab-abastec-lubrific.cod-eqpto <= fiEqptoFim:screen-value in frame fPage0  
            and   mab-abastec-lubrific.dat-movto >= date(fiDataIni:screen-value in frame fPage0)
            and   mab-abastec-lubrific.dat-movto <= date(fiDataFim:screen-value in frame fPage0) no-lock:
            
            /** Valida se ficha est† consistida **/
            if not mab-abastec-lubrific.log-consist then do:
                assign c-msg = c-msg + string(mab-abastec-lubrific.num-docto) + ", ".
                next.
            end.

            /**Valida se o equipto est† integredo**/
            for first mab-eqpto                     
                where mab-eqpto.ep-codigo = mab-abastec-lubrific.ep-codigo
                and   mab-eqpto.cod-eqpto = mab-abastec-lubrific.cod-eqpto
                and   mab-eqpto.log-livre-1 = YES no-lock:                
            end.                                                          
            if NOT avail mab-eqpto then DO:
                assign c-msg = c-msg + STRING (mab-abastec-lubrific.num-docto) + ", ".
                NEXT.
            END.

            /** Valida se Ç uma filha de abastecimento **/
            FOR first mab-item-abastec
                where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto
                 AND  mab-item-abastec.ep-codigo = mab-abastec-lubrific.ep-codigo NO-LOCK :
            END.
            if NOT avail mab-item-abastec then DO: 
                assign c-msg = c-msg + STRING (mab-abastec-lubrific.num-docto) + ", ".
                NEXT.
            END.

            create tt-abastec.
            buffer-copy mab-abastec-lubrific to tt-abastec.

            /** Acompanhamento **/
            {utp/ut-liter.i "Documento"}
            run pi-Acompanhar in hAcomp (return-value + ": " + string(mab-abastec-lubrific.num-docto)).

            /** Chamada do adpter de geraá∆o do arquivo XML **/
            run adapters/xml/mn2/axsmf014.p (input table tt-abastec,
                                             input "ADD":U,
                                             OUTPUT cLocalXmlGerado).

            if return-value = "NOK":U THEN DO: 
                assign c-msg = c-msg + string(mab-abastec-lubrific.num-docto) + ", ".
                next.
            END.
        end.
            if c-msg <> "":U then do:
                {utp/ut-liter.i Arquivo(s)_n∆o_gerado(s)}
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-documentos-nr AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Documento(s)_nr" *}
                        ASSIGN c-lbl-liter-documentos-nr = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-nao-foi-gerado-porque-a-ficha AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "n∆o_foi_gerado_porque_a_ficha_n∆o_est†_consistida_ou_o_equipamento_n∆o_est†_integrado_com_o_rastreamento_ou_n∆o_possui_apontamento_de_abastecimento" *}
                        ASSIGN c-lbl-liter-nao-foi-gerado-porque-a-ficha = TRIM(RETURN-VALUE).
                        run utp/ut-msgs.p (input "show", 
                                           input 27979,  
                                           input c-lbl-liter + "~~" + c-lbl-liter-documentos-nr + ".: " + c-msg + c-lbl-liter-nao-foi-gerado-porque-a-ficha).
            END.
            ELSE do:
                {utp/ut-liter.i Arquivo(s)_gerado(s)_com_sucesso}
                                   run utp/ut-msgs.p (input "show",
                                                      input 17006,
                                                      input return-value).
            END.

        run pi-Finalizar in hAcomp.
        apply "CLOSE":U to this-procedure.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s inicializaá∆o da tela
------------------------------------------------------------------------------*/
    {utp/ut-liter.i "Data_Movimento"}
    ASSIGN fiDataIni:LABEL IN FRAME fPage0 = trim(return-value).
    {utp/ut-liter.i "Documento"}
    ASSIGN fiDoctoIni:LABEL IN FRAME fPage0 = trim(return-value).
    {utp/ut-liter.i "Empresa"}
    ASSIGN fiEpIni:LABEL IN FRAME fPage0 = trim(return-value).
    {utp/ut-liter.i "Equipamento"}
    ASSIGN fiEqptoIni:LABEL IN FRAME fPage0 = trim(return-value).
    
    assign fiDoctoIni:screen-value in frame fPage0 = string(p-num-docto)
           fiDoctoFim:screen-value in frame fPage0 = string(p-num-docto)
           fiEpIni:screen-value    in frame fPage0 = "0":U
           fiEpFim:screen-value    in frame fPage0 = "999":U
           fiEqptoIni:screen-value in frame fPage0 = "":U
           fiEqptoFim:screen-value in frame fPage0 = "ZZZZZZZZZZZZZZZZ":U
           fiDataIni:screen-value in frame fPage0 = &IF "{&ems_dbtype}":U = "MSS":U &THEN "01/01/1800":U &ELSE "01/01/0001":U &ENDIF 
           fiDataFim:screen-value in frame fPage0 = "31/12/9999":U.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

