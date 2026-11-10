&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0804F 2.00.00.020 } /*** "010020" 22/07/2024 10:40:31  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0804f MAB}
&ENDIF


/*****************************************************************************
**
**       Programa: AB0804F
**
**       Objetivo: Procedures utilizadas por Frotas no Recebimento
**
*****************************************************************************/
/*******************************************************
** Definiá∆o de ParÉmetros 
*******************************************************/
define input parameter p-handle-pai    as handle  no-undo.
define input parameter p-handle-folder as handle  no-undo.
define input parameter p-cod-emitente  as integer no-undo.

/*******************************************************
** Definiá∆o Vari†veis de Tela 
*******************************************************/
DEFINE VARIABLE dat-movto AS date FORMAT "99/99/9999":U 
 initial today
 VIEW-AS FILL-IN 
 SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE c-hr-inicial AS character FORMAT "99:99":U 
 initial "0000"
 VIEW-AS FILL-IN 
 SIZE 6 BY .88 NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE VARIABLE i-ep-codigo LIKE empresa.ep-codigo format "x(03)":U 
&ELSE
DEFINE VARIABLE i-ep-codigo AS integer FORMAT ">>9":U 
&ENDIF
 VIEW-AS FILL-IN 
 SIZE 5 BY .88 NO-UNDO.
DEFINE VARIABLE c-cod-eqpto AS character FORMAT "x(16)":U 
 VIEW-AS FILL-IN 
 SIZE 16 BY .88 NO-UNDO.
DEFINE VARIABLE c-desc-eqpto AS character FORMAT "x(40)":U 
 VIEW-AS FILL-IN 
 SIZE 42 BY .88 NO-UNDO.
DEFINE VARIABLE de-contador AS decimal FORMAT ">,>>>,>>9.9":U 
 VIEW-AS FILL-IN 
 SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE c-un AS character FORMAT "x(2)":U 
 VIEW-AS FILL-IN 
 SIZE 4 BY .88 NO-UNDO.
DEFINE VARIABLE de-contador-sec AS decimal FORMAT ">,>>>,>>9.9":U 
 VIEW-AS FILL-IN 
 SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE c-un-sec AS character FORMAT "x(2)":U 
 VIEW-AS FILL-IN 
 SIZE 4 BY .88 NO-UNDO.
DEFINE VARIABLE c-posto AS character FORMAT "x(8)":U 
 VIEW-AS FILL-IN 
 SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE c-desc-posto AS character FORMAT "x(40)":U 
 VIEW-AS FILL-IN 
 SIZE 35 BY .88 NO-UNDO.
DEFINE VARIABLE c-ct-codigo AS character FORMAT "x(20)":U 
 VIEW-AS FILL-IN 
 SIZE 20 BY .88 NO-UNDO.
DEFINE VARIABLE c-cc-codigo AS character FORMAT "x(20)":U 
 VIEW-AS FILL-IN 
 SIZE 20 BY .88 NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE VARIABLE i-empresa-matr LIKE empresa.ep-codigo format "x(03)":U 
&ELSE
DEFINE VARIABLE i-empresa-matr AS INTEGER FORMAT ">>9":U 
&ENDIF
 VIEW-AS FILL-IN 
 SIZE 5 BY .88 NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE VARIABLE c-estabel-matr AS character format "x(05)":U 
&ELSE
DEFINE VARIABLE c-estabel-matr AS character FORMAT "x(03)":U 
&ENDIF
 VIEW-AS FILL-IN 
 SIZE 5 BY .88 NO-UNDO.
DEFINE VARIABLE c-cod-matr AS character FORMAT "x(10)":U 
 VIEW-AS FILL-IN 
 SIZE 12 BY .88 NO-UNDO.
DEFINE VARIABLE c-nome-motorista AS character FORMAT "x(40)":U 
 VIEW-AS FILL-IN 
 SIZE 40.5 BY .88 NO-UNDO.
DEFINE VARIABLE c-cod-evento AS character FORMAT "x(8)":U 
 VIEW-AS FILL-IN 
 SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE c-desc-evento AS character FORMAT "x(40)":U 
 VIEW-AS FILL-IN 
 SIZE 35 BY .88 NO-UNDO.
DEFINE VARIABLE c-cod-compart AS character FORMAT "x(8)":U 
 VIEW-AS FILL-IN 
 SIZE 10 BY .88 NO-UNDO.
DEFINE VARIABLE c-desc-compart AS character FORMAT "x(40)":U 
 VIEW-AS FILL-IN 
 SIZE 35 BY .88 NO-UNDO.
DEFINE VARIABLE c-cod-rota AS character FORMAT "x(12)":U 
 VIEW-AS FILL-IN 
 SIZE 12 BY .88 NO-UNDO.
DEFINE VARIABLE c-cod-ativid AS character FORMAT "x(8)":U 
 VIEW-AS FILL-IN 
 SIZE 10 BY .88 NO-UNDO.
DEFINE RECTANGLE rec-frotas
 EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
 SIZE 84.14 BY 9.5.
DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET horizontal
     RADIO-BUTTONS 
     "A&bastecimento", 1,
     "&Lubrificaá∆o", 2,
     "&Outros", 3
     SIZE 40 BY .58 NO-UNDO.
DEFINE RECTANGLE rec-tipo
 EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
 SIZE 42 BY 1.20.
DEFINE VARIABLE c-desc-tipo AS character FORMAT "x(8)":U 
 VIEW-AS text
 SIZE 5 BY .58 NO-UNDO.

/*********************************************************
** Definiá∆o de Frames 
*********************************************************/
define frame fPageFrotas
    rec-tipo         AT ROW 1.5  COL 15   colon-aligned 
    rs-tipo          AT ROW 1.9  COL 16   colon-aligned no-label
    c-desc-tipo      AT ROW 1.35 COL 16   colon-aligned no-label
    dat-movto     AT ROW 2.75 COL 15   colon-aligned
    c-hr-inicial     AT ROW 2.75 COL 25.5 colon-aligned no-label
    i-ep-codigo      AT ROW 3.75 COL 15   colon-aligned
    c-cod-eqpto      AT ROW 3.75 COL 20.5 colon-aligned no-label
    c-desc-eqpto     AT ROW 3.75 COL 37   colon-aligned no-label
    de-contador      AT ROW 4.75 COL 15   colon-aligned
    c-un             AT ROW 4.75 COL 25.5 colon-aligned no-label
    de-contador-sec  AT ROW 4.75 COL 60.5 colon-aligned
    c-un-sec         AT ROW 4.75 COL 71   colon-aligned no-label
    c-ct-codigo      AT ROW 5.75 COL 40.5 colon-aligned
    c-cc-codigo      AT ROW 5.75 COL 60   colon-aligned no-label
    c-posto          AT ROW 6.75 COL 15   colon-aligned
    c-desc-posto     AT ROW 6.75 COL 25.5 colon-aligned no-label
    c-cod-ativid     AT ROW 6.75 COL 69   colon-aligned
    i-empresa-matr   AT ROW 7.75 COL 15   colon-aligned 
    c-estabel-matr   AT ROW 7.75 COL 20.5    COLON-ALIGNED NO-LABEL
    c-cod-matr       AT ROW 7.75 COL 26   COLON-ALIGNED NO-LABEL
    c-nome-motorista AT ROW 7.75 COL 38.5 colon-aligned no-label
    c-cod-rota       AT ROW 8.75 COL 67   colon-aligned
    c-cod-evento     AT ROW 8.75 COL 15   colon-aligned
    c-desc-evento    AT ROW 8.75 COL 25.5 colon-aligned no-label
    c-cod-compart    AT ROW 9.75 COL 15   colon-aligned
    c-desc-compart   AT ROW 9.75 COL 25.5 colon-aligned no-label
    rec-frotas       AT ROW 1.25 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
     SIDE-LABELS NO-UNDERLINE THREE-D 
     AT COL 3.57 ROW 2.38
     SIZE 84.43 BY 10.45
     FONT 1.

/***********************************************************
** Definiá∆o prÇ-processadores
***********************************************************/
&GLOBAL-DEFINE pageFrotas dat-movto c-hr-inicial i-ep-codigo c-cod-eqpto ~
                          de-contador de-contador-sec c-posto c-ct-codigo c-cc-codigo i-empresa-matr c-estabel-matr~
                          c-cod-matr c-cod-evento rs-tipo c-cod-compart ~
                          c-cod-rota c-cod-ativid

/*************************************************************
** Definiá∆o vari†veis validaá‰es em tela
*************************************************************/
DEFINE VARIABLE cCodModelo     AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cHora          AS CHARACTER format "99:99" NO-UNDO.


/************************************************************
** Definiá∆o dos handles 
************************************************************/
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPosto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMoto      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvento    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOComp      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOFicha     AS HANDLE NO-UNDO.

/***********************************************************
** Definiá∆o vari†veis utilizadas internamente 
***********************************************************/
DEFINE VARIABLE hProgramZoom                     AS HANDLE NO-UNDO.
DEFINE VARIABLE hShowMsg                         AS HANDLE NO-UNDO.
DEFINE VARIABLE hWindowParent                    AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.

DEFINE VARIABLE lLogContSec                      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cUnModelSec                      AS CHARACTER NO-UNDO.
/***********************************************************
** Definiá∆o vari†veis globais
***********************************************************/
define new global shared variable iEmpresa like mab-comptmento-eqpto.ep-codigo no-undo.
define new global shared variable cEqpto   like mab-comptmento-eqpto.cod-eqpto no-undo.

/***********************************************************
** Definiá∆o vari†veis globais da sess∆o
***********************************************************/
{utp/ut-glob.i}

/*elementos para chamada da upc Colombo*/
def var c-nom-prog-upc-mg97  as char init "" no-undo.
find prog_dtsul where prog_dtsul.cod_prog_dtsul = "ab0804f" no-lock no-error.
if  avail prog_dtsul THEN
    assign c-nom-prog-upc-mg97  = prog_dtsul.nom_prog_upc.

/*variaveis globais para funcionamento da upc Colombo*/
&IF "{&mguni_version}" >= "2.071" &THEN
DEF NEW GLOBAL SHARED VARIABLE i-glob-ep-codigo LIKE empresa.ep-codigo NO-UNDO.
&ELSE
DEF NEW GLOBAL SHARED VARIABLE i-glob-ep-codigo AS INT NO-UNDO.
&ENDIF
DEF NEW GLOBAL SHARED VARIABLE c-glob-cod-eqpto AS CHAR FORMAT "X(16)" NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE c-glob-cod-posto AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE c-glob-conta-contabil AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE c-glob-sub-conta AS CHAR NO-UNDO.

{cdp/cdunif001.i} /*vari†veis unificaá∆o de conceito*/
/*unificaá∆o de conceito - centro de custo e conta contabil*/
DEFINE VARIABLE cEmpresaEstab AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dDtMovimento  AS DATE        NO-UNDO.

DEF TEMP-TABLE RowErrors NO-UNDO 
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPosto Include 
FUNCTION fnPosto RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 9.5
         WIDTH              = 34.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
i-ep-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPageFrotas.
c-cod-eqpto:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPageFrotas.
c-posto:LOAD-MOUSE-POINTER("image/lupa.cur":U)       IN FRAME fPageFrotas.
c-ct-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPageFrotas.
c-cc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)   IN FRAME fPageFrotas.
c-cod-matr:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPageFrotas.
c-cod-evento:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPageFrotas.
c-cod-compart:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPageFrotas.
c-cod-rota:LOAD-MOUSE-POINTER("image/lupa.cur":U)    IN FRAME fPageFrotas.
c-cod-ativid:LOAD-MOUSE-POINTER("image/lupa.cur":U)  IN FRAME fPageFrotas.
i-empresa-matr:LOAD-MOUSE-POINT("image/lupa.cur":U)  IN FRAME fPageFrotas.
c-estabel-matr:LOAD-MOUSE-POINT("image/lupa.cur":U)  IN FRAME fPageFrotas.

{abp/ab9000.i} /** Formato de Contas e Hora **/

assign v_cod_finalid = {adinc/i05ad049.i 4 1 }                       /* 1 - Consumo        */
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}  /* 3 - Ordem Serviáo  */
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}. /* 5 - M∆o de Obra    */

assign frame fPageFrotas:box = no.

/** Equipamento **/
ON LEAVE OF c-cod-eqpto IN FRAME fPageFrotas DO:
    run buscaModelo in this-procedure.
    {method/referencefields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="c-desc-eqpto"
        &Frame1="fPageFrotas"
        &FieldName2="un"
        &FieldScreen2="c-un"
        &Frame2="fPageFrotas"}
    /*chamada upc Colombo*/
    APPLY "leave":U TO c-posto IN FRAME fPageFrotas.
    RUN piValidaContadorSec IN THIS-PROCEDURE.
END.
ON LEAVE OF i-ep-codigo IN FRAME fPageFrotas DO:
    /*chamada upc Colombo*/
    APPLY "leave":U TO c-posto IN FRAME fPageFrotas.
END.
ON MOUSE-SELECT-DBLCLICK OF c-cod-eqpto IN FRAME fPageFrotas
OR "F5":U OF c-cod-eqpto IN FRAME fPageFrotas DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr007.w"
           &FieldZoom1="ep-codigo"
           &FieldScreen1="i-ep-codigo"
           &Frame1="fPageFrotas"
           &FieldZoom2="cod-eqpto"
           &FieldScreen2="c-cod-eqpto"
           &Frame2="fPageFrotas"
           &EnableImplant="YES"}
        wait-for "CLOSE":U of hProgramZoom.
        apply "LEAVE":U to self.  
END.
/** Empresa **/
ON MOUSE-SELECT-DBLCLICK OF i-ep-codigo IN FRAME fPageFrotas
OR "F5":U OF i-ep-codigo IN FRAME fPageFrotas DO:
    apply "F5":U to c-cod-eqpto in frame fPageFrotas.
END.
/** Empresa   **/
ON LEAVE OF i-empresa-matr IN FRAME fPageFrotas DO:
        {method/referencefields.i
            &HandleDBOLeave="hDBOMoto"
            &KeyValue1="i-empresa-matr:screen-value in frame fPageFrotas"
            &KeyValue2="c-estabel-matr:screen-value in frame fPageFrotas"
            &KeyValue3="c-cod-matr:screen-value in frame fPageFrotas"
            &FieldName1="nom-motoris"
            &FieldScreen1="c-nome-motorista"
            &Frame1="fPageFrotas"}   
            
/*             &FieldName1="ep-codigo"        */
/*             &FieldScreen1="i-empresa-matr" */
/*             &Frame1="fPageFrotas"          */
/*             &FieldName2="cod-estabel"      */
/*             &FieldScreen2="c-estabel-matr" */
/*             &Frame2="fPageFrotas"          */
/*             &FieldName3="motorista"        */
/*             &FieldScreen3="c-cod-matr"     */
/*             &Frame3="fPageFrotas"          */
END.
ON MOUSE-SELECT-DBLCLICK OF i-empresa-matr IN FRAME fPageFrotas
OR "F5":U OF i-empresa-matr IN FRAME fPageFrotas DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr017.w"
       &FieldZoom1="ep-codigo"
       &FieldScreen1="i-empresa-matr"
       &Frame1="fPageFrotas"
       &FieldZoom2="cod-estabel"
       &FieldScreen2="c-estabel-matr"
       &Frame2="fPageFrotas"
       &FieldZoom3="cod-matr"
       &FieldScreen3="c-cod-matr"
       &Frame3="fPageFrotas"
       &EnableImplant="YES"} 
END.
/** Estabelecimento **/
ON LEAVE OF c-estabel-matr IN FRAME fPageFrotas DO:
    {method/referencefields.i
        &HandleDBOLeave="hDBOMoto"
        &KeyValue1="i-empresa-matr:screen-value in frame fPageFrotas"
        &KeyValue2="c-estabel-matr:screen-value in frame fPageFrotas"
        &KeyValue3="c-cod-matr:screen-value in frame fPageFrotas"
        &FieldName1="nom-motoris"
        &FieldScreen1="c-nome-motorista"
        &Frame1="fPageFrotas"}   
/*         &FieldName1="ep-codigo"        */
/*         &FieldScreen1="i-empresa-matr" */
/*         &Frame1="fPageFrotas"          */
/*         &FieldName2="cod-estabel"      */
/*         &FieldScreen2="c-estabel-matr" */
/*         &Frame2="fPageFrotas"          */
/*         &FieldName3="motorista"        */
/*         &FieldScreen3="c-cod-matr"     */
/*         &Frame3="fPageFrotas"          */
END.
ON MOUSE-SELECT-DBLCLICK OF c-estabel-matr IN FRAME fPageFrotas
OR "F5":U OF c-estabel-matr IN FRAME fPageFrotas DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr017.w"
       &FieldZoom1="ep-codigo"
       &FieldScreen1="i-empresa-matr"
       &Frame1="fPageFrotas"
       &FieldZoom2="cod-estabel"
       &FieldScreen2="c-estabel-matr"
       &Frame2="fPageFrotas"
       &FieldZoom3="cod-matr"
       &FieldScreen3="c-cod-matr"
       &Frame3="fPageFrotas"
       &EnableImplant="YES"} 
END.

/** Motorista **/
ON LEAVE OF c-cod-matr IN FRAME fPageFrotas DO:
    {method/referencefields.i
        &HandleDBOLeave="hDBOMoto"
        &KeyValue1="i-empresa-matr:screen-value in frame fPageFrotas"
        &KeyValue2="c-estabel-matr:screen-value in frame fPageFrotas"
        &KeyValue3="c-cod-matr:screen-value in frame fPageFrotas"
        &FieldName1="nom-motoris"
        &FieldScreen1="c-nome-motorista"
        &Frame1="fPageFrotas"}   
/*         &FieldName1="ep-codigo"        */
/*         &FieldScreen1="i-empresa-matr" */
/*         &Frame1="fPageFrotas"          */
/*         &FieldName2="cod-estabel"      */
/*         &FieldScreen2="c-estabel-matr" */
/*         &Frame2="fPageFrotas"          */
/*         &FieldName3="motorista"        */
/*         &FieldScreen3="c-cod-matr"     */
/*         &Frame3="fPageFrotas"          */

END.
ON MOUSE-SELECT-DBLCLICK OF c-cod-matr IN FRAME fPageFrotas
OR "F5":U OF c-cod-matr IN FRAME fPageFrotas DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr017.w"
       &FieldZoom1="ep-codigo"
       &FieldScreen1="i-empresa-matr"
       &Frame1="fPageFrotas"
       &FieldZoom2="cod-estabel"
       &FieldScreen2="c-estabel-matr"
       &Frame2="fPageFrotas"
       &FieldZoom3="cod-matr"
       &FieldScreen3="c-cod-matr"
       &Frame3="fPageFrotas"
       &EnableImplant="YES"} 
END.
/** Posto Combust°vel **/
ON LEAVE OF c-posto IN FRAME fPageFrotas DO:
    {method/referencefields.i
        &HandleDBOLeave="hDBOPosto"
        &KeyValue1="c-posto:screen-value in frame fPageFrotas"
        &FieldName1="des-posto"
        &FieldScreen1="c-desc-posto"
        &Frame1="fPageFrotas"}  
        

        if  (c-nom-prog-upc-mg97 <> "":U AND
            rs-tipo:SCREEN-VALUE IN FRAME fPageFrotas <> "3":U) THEN do:

            /*chama upc da Colombo*/
            ASSIGN &IF "{&mguni_version}" >= "2.071" &THEN
                       i-glob-ep-codigo   = i-ep-codigo:SCREEN-VALUE IN FRAME fPageFrotas
                   &ELSE
                       i-glob-ep-codigo   = INT(i-ep-codigo:SCREEN-VALUE IN FRAME fPageFrotas)
                   &ENDIF
                   c-glob-cod-eqpto   = c-cod-eqpto:SCREEN-VALUE IN FRAME fPageFrotas
                   c-glob-cod-posto   = c-posto:SCREEN-VALUE IN FRAME fPageFrotas
                   c-glob-conta-contabil = c-ct-codigo:SCREEN-VALUE IN FRAME fPageFrotas
                   c-glob-sub-conta      = c-cc-codigo:SCREEN-VALUE IN FRAME fPageFrotas.

            run value(c-nom-prog-upc-mg97) (input "leave-posto", 
                                            input "",
                                            input THIS-PROCEDURE,
                                            input FRAME fPageFrotas:HANDLE,
                                            input "",
                                            input ?).

            assign c-ct-codigo:SCREEN-VALUE IN FRAME fPageFrotas = c-glob-conta-contabil
                   c-cc-codigo:SCREEN-VALUE IN FRAME fPageFrotas = c-glob-sub-conta.
        end.
        

END.
ON MOUSE-SELECT-DBLCLICK OF c-posto IN FRAME fPageFrotas 
OR "F5":U OF c-posto IN FRAME fPageFrotas DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr021.w"
           &FieldZoom1="cod-posto"
           &FieldScreen1="c-posto"
           &Frame1="fPageFrotas"
           &FieldZoom2="des-posto"
           &FieldScreen2="c-desc-posto"
           &Frame2="fPageFrotas"
           &EnableImplant="YES"} 
END.
/** Conta **/
ON MOUSE-SELECT-DBLCLICK OF c-ct-codigo IN FRAME fPageFrotas 
OR "F5":U OF c-ct-codigo IN FRAME fPageFrotas DO:
    RUN pi-zoomConta IN THIS-PROCEDURE.
END.
ON LEAVE OF c-ct-codigo IN FRAME fPageFrotas /* Cta Cont†bil */
DO:
    ASSIGN  cEmpresaEstab = INPUT FRAME fPageFrotas i-ep-codigo
            dDtMovimento  = INPUT FRAME fPageFrotas dat-movto.

    IF dDtMovimento = ? THEN ASSIGN dDtMovimento = TODAY.
                                                
    {cdp/cdunif001a.i  c-ct-codigo c-cc-codigo fPageFrotas dDtMovimento cEmpresaEstab """" }

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    DEFINE VARIABLE c-conta-contabil AS CHARACTER  NO-UNDO.
    assign c-conta-contabil = input frame fPageFrotas c-ct-codigo + 
                              input frame fPageFrotas c-cc-codigo.
    /** Passa conta do equipamento para Conta Cont†bil do Item **/
    run pi-leave-conta-frotas in p-handle-pai (INPUT input frame fPageFrotas c-ct-codigo,
                                               INPUT input frame fPageFrotas c-cc-codigo) no-error.

END.
ON ENTRY OF c-ct-codigo IN FRAME fPageFrotas /* cc-codigo */
DO:
  ASSIGN c-ct-codigo:FORMAT IN FRAME fPageFrotas = "x(20)".
END.
/** Sub Conta **/
ON MOUSE-SELECT-DBLCLICK OF c-cc-codigo IN FRAME fPageFrotas
OR "F5":U OF c-cc-codigo IN FRAME fPageFrotas DO:
    RUN pi-zoomCentroCusto IN THIS-PROCEDURE.
END.
ON leave OF c-cc-codigo IN FRAME fPageFrotas DO:
    DEFINE VARIABLE c-conta-contabil AS CHARACTER  NO-UNDO.

    IF c-cc-codigo:SCREEN-VALUE <> "" THEN
        ASSIGN c-cc-codigo:FORMAT IN FRAME fPageFrotas = p_cod_format_ccusto.

    assign c-conta-contabil = input frame fPageFrotas c-ct-codigo + 
                              input frame fPageFrotas c-cc-codigo.
    /** Passa conta do equipamento para Conta Cont†bil do Item **/
    run pi-leave-conta-frotas in p-handle-pai (INPUT input frame fPageFrotas c-ct-codigo,
                                               INPUT input frame fPageFrotas c-cc-codigo) no-error.
END.
ON ENTRY OF c-cc-codigo IN FRAME fPageFrotas /* cc-codigo */
DO:
  ASSIGN c-cc-codigo:FORMAT IN FRAME fPageFrotas = "x(20)".
END.
/** Evento **/
ON LEAVE OF c-cod-evento IN FRAME fPageFrotas DO:
    {method/referencefields.i
        &HandleDBOLeave="hDBOEvento"
        &KeyValue1="c-cod-evento:screen-value in frame fPageFrotas"
        &FieldName1="des-evento"
        &FieldScreen1="c-desc-evento"
        &Frame1="fPageFrotas"}   
END.
ON MOUSE-SELECT-DBLCLICK OF c-cod-evento IN FRAME fPageFrotas 
OR "F5":U OF c-cod-evento IN FRAME fPageFrotas DO:
  /** Verifica como deve trazer o zoom de eventos **/
  case input frame fPageFrotas rs-tipo:
      /** Lubrificaá∆o (‡leo / Filtro) **/
      when 2 then do:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="c-cod-evento"
           &Frame1="fPageFrotas"
           &FieldZoom2="des-evento"
           &FieldScreen2="c-desc-evento"
           &Frame2="fPageFrotas"
           &RunMethod="run setaFiltro in hProgramZoom (yes, yes, no, no , no, no)."
           &EnableImplant="YES"}         
      end.                               
      /** Diversos (Custos) **/          
      otherwise do:                      
        {method/zoomfields.i             
           &ProgramZoom="frzoom/z01fr010.w" 
           &FieldZoom1="cod-evento"      
           &FieldScreen1="c-cod-evento"  
           &Frame1="fPageFrotas"         
           &FieldZoom2="des-evento"      
           &FieldScreen2="c-desc-evento" 
           &Frame2="fPageFrotas"         
           &RunMethod="run setaFiltro in hProgramZoom (no, no, no, no , yes, no)."
           &EnableImplant="YES"}         
      end.         
  end case.        
END.               
/** Compartimento **/                    
ON LEAVE OF c-cod-compart IN FRAME fPageFrotas DO:
    {method/referencefields.i
        &HandleDBOLeave="hDBOComp"
        &KeyValue1="c-cod-compart:screen-value in frame fPageFrotas"
        &FieldName1="des-comptmento"
        &FieldScreen1="c-desc-compart"
        &Frame1="fPageFrotas"}  
END.
ON MOUSE-SELECT-DBLCLICK OF c-cod-compart IN FRAME fPageFrotas 
OR "F5":U OF c-cod-compart IN FRAME fPageFrotas DO:
    assign iEmpresa = input frame fPageFrotas i-ep-codigo
           cEqpto   = input frame fPageFrotas c-cod-eqpto.

        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr004.w"
           &FieldZoom1="cod-comptmento"
           &FieldScreen1="c-cod-compart"
           &Frame1="fPageFrotas"
           &FieldZoom2="des-comptmento"
           &FieldScreen2="c-desc-compart"
           &Frame2="fPageFrotas"}  
END.
/** Hora Inicial **/
ON LEAVE OF c-hr-inicial IN FRAME fPageFrotas DO:
    /** Consiste o hor†rio **/
    assign cHora = c-hr-inicial:screen-value in frame fPageFrotas.
    run piFormataHorarioMin (input-output cHora).
    if return-value = "NOK":U then do:
        apply "ENTRY":U to c-hr-inicial in frame fPageFrotas.
        return no-apply.
    end.
    assign c-hr-inicial:screen-value in frame fPageFrotas = cHora.  
END.
/** Radio-Set **/
ON VALUE-CHANGED OF rs-tipo IN FRAME fPageFrotas DO:
  /** Habilita/Desabilita campos conforme escolha **/
  case input frame fPageFrotas rs-tipo:
      /** Abastecimento **/
      when 1 then do:
          assign c-cod-evento:sensitive in frame fPageFrotas  = no
                 c-cod-compart:sensitive in frame fPageFrotas = no
                 de-contador:sensitive in frame fPageFrotas   = yes
                 de-contador-sec:sensitive in frame fPageFrotas = yes
                 c-posto:sensitive in frame fPageFrotas       = yes
                 c-cod-matr:sensitive in frame fPageFrotas    = yes
                 c-cod-rota:sensitive in frame fPageFrotas    = yes
                 c-cod-ativid:sensitive in frame fPageFrotas  = yes
                 c-cod-evento                                 = "":U
                 c-cod-compart                                = "":U.
          if c-posto:screen-value = "":U then do:
              assign c-posto = fnPosto().
              display c-posto with frame fPageFrotas.
              apply "LEAVE":U to c-posto       in frame fPageFrotas.
          end.
          display c-cod-evento c-cod-compart
              with frame fPageFrotas.
          apply "LEAVE":U to c-cod-evento  in frame fPageFrotas.
          apply "LEAVE":U to c-cod-compart in frame fPageFrotas.
          /** Verifica se Atividade, Motorista e Trajeto s∆o Modificados em tela **/
          run piParametros in this-procedure.
      end.
      /** Lubrificaá∆o **/
      when 2 then do:
          assign c-cod-evento:sensitive in frame fPageFrotas  = yes
                 c-cod-compart:sensitive in frame fPageFrotas = yes
                 de-contador:sensitive in frame fPageFrotas   = yes
                 de-contador-sec:sensitive in frame fPageFrotas = yes
                 c-cod-rota:sensitive in frame fPageFrotas    = yes
                 c-cod-ativid:sensitive in frame fPageFrotas  = yes
                 c-posto:sensitive in frame fPageFrotas       = yes
                 c-cod-matr:sensitive in frame fPageFrotas    = yes.
          if c-posto:screen-value = "":U then do:
              assign c-posto = fnPosto().
              display c-posto with frame fPageFrotas.
              apply "LEAVE":U to c-posto       in frame fPageFrotas.
          end.
          /** Verifica se Atividade, Motorista e Trajeto s∆o Modificados em tela **/
          run piParametros in this-procedure.
      end.
      /** Outros **/
      when 3 then do:
          assign c-cod-evento:sensitive in frame fPageFrotas  = yes
                 c-cod-compart:sensitive in frame fPageFrotas = no
                 de-contador:sensitive in frame fPageFrotas   = no
                 de-contador-sec:sensitive in frame fPageFrotas = no
                 c-posto:sensitive in frame fPageFrotas       = no
                 c-cod-matr:sensitive in frame fPageFrotas    = no
                 c-cod-rota:sensitive in frame fPageFrotas    = no
                 c-cod-ativid:sensitive in frame fPageFrotas  = no
                 c-cod-compart                                = "":U
                 de-contador                                  = 0
                 de-contador-sec                              = 0
                 c-posto                                      = "":U
                 c-cod-matr                                   = "":U
                 c-cod-rota                                   = "":U
                 c-cod-ativid                                 = "":U.
          display c-cod-compart de-contador de-contador-sec
                  c-posto c-cod-matr c-cod-rota
                  c-cod-ativid
              with frame fPageFrotas.
          apply "LEAVE":U to c-cod-compart in frame fPageFrotas.
          apply "LEAVE":U to c-posto       in frame fPageFrotas.
          apply "LEAVE":U to c-cod-matr    in frame fPageFrotas.
      end.
  end case.
END.

ON MOUSE-SELECT-DBLCLICK OF c-cod-rota IN FRAME fPageFrotas 
OR "F5":U OF c-cod-rota IN FRAME fPageFrotas DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr028.w"
           &FieldZoom1="cod-rota"
           &FieldScreen1="c-cod-rota"
           &Frame1="fPageFrotas"
           &EnableImplant="YES"}
END.
ON MOUSE-SELECT-DBLCLICK OF c-cod-ativid IN FRAME fPageFrotas 
OR "F5":U OF c-cod-ativid IN FRAME fPageFrotas DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr001.w"
           &FieldZoom1="cod-ativid"
           &FieldScreen1="c-cod-ativid"
           &Frame1="fPageFrotas"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo Include 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/
define variable c-conta      as character no-undo.
define variable c-sub        as character no-undo.
define variable c-ativid     as character no-undo.
define variable c-unid       as character no-undo.
DEFINE VARIABLE c-conta-lub  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ccusto-lub AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-hist-estab AS CHARACTER NO-UNDO.

{method/referencefields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="input frame fPageFrotas i-ep-codigo"
    &KeyValue2="input frame fPageFrotas c-cod-eqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}
    
/** Busca Atividade e Conta Cont†bil do Hist¢rico Atividade Equipamento **/    
run buscaAtividade in hDBOFicha (input  input frame fPageFrotas i-ep-codigo,
                                 input  input frame fPageFrotas c-cod-eqpto,
                                 input  input frame fPageFrotas dat-movto,
                                 output c-cod-ativid,
                                 output c-ct-codigo,
                                 output c-cc-codigo,
                                 output c-unid,
                                 OUTPUT c-conta-lub,
                                 OUTPUT c-ccusto-lub,
                                 OUTPUT c-hist-estab).

FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
    IF mab-param.des-valor = "1":U THEN DO:
        IF INPUT FRAME fPageFrotas rs-tipo = "2" THEN DO:
            ASSIGN c-ct-codigo = c-conta-lub
                   c-cc-codigo = c-ccusto-lub.
        END.
    END.
END.


display c-ct-codigo c-cc-codigo c-cod-ativid
    with frame fPageFrotas.

apply "LEAVE":U to c-ct-codigo in frame fPageFrotas.
    
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-frota-cria-folder Include 
PROCEDURE pi-frota-cria-folder :
/*------------------------------------------------------------------------------
  Purpose:     pi-frota-cria-folder
  Parameters:  <none>
  Notes:       Cria a Frame de Frotas
------------------------------------------------------------------------------*/
define input parameter p-handle-fPage0 as handle no-undo.

define variable c-form-conta as character no-undo.
define variable c-form-sub   as character no-undo.


/** Cria folder **/
{utp/ut-liter.i "Frota / MI"}
run insertFolder in p-handle-folder (input ?,
                                     input p-handle-fPage0,
                                     input frame fPageFrotas:handle,
                                     input return-value).
/** Busca os formatos da conta e sub-conta **/
EMPTY TEMP-TABLE tt_log_erro.


IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.  
IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

ASSIGN  cEmpresaEstab = INPUT FRAME fPageFrotas i-ep-codigo
        dDtMovimento  = INPUT FRAME fPageFrotas dat-movto.

IF dDtMovimento = ? THEN ASSIGN dDtMovimento = TODAY.


RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT cEmpresaEstab,  /* EMPRESA EMS2 */
                                               INPUT "",          /* PLANO CCUSTO */
                                               INPUT dDtMovimento,               /* DATA DE TRANSACAO */
                                               OUTPUT p_cod_format_ccusto,      /* FORMATO CCUSTO */
                                               OUTPUT TABLE tt_log_erro). /* ERROS */


RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT cEmpresaEstab,
                                                   INPUT "",
                                                   INPUT dDtMovimento,
                                                   OUTPUT p_cod_format_cta_ctbl,
                                                   OUTPUT TABLE tt_log_erro).


IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.
IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.

{cdp/cdunif001b.i}

/** Labels em tela **/
{utp/ut-liter.i "Tipo"}
assign c-desc-tipo:screen-value in frame fPageFrotas = trim(return-value).
{utp/ut-liter.i "Data"}
assign dat-movto:label in frame fPageFrotas = trim(return-value)
       c-hr-inicial = replace(string(time,"hh:mm":U),":":U,"":U).
{utp/ut-liter.i "Equipamento"}
assign i-ep-codigo:label in frame fPageFrotas = trim(return-value).
{utp/ut-liter.i "Contador"}
assign de-contador:label in frame fPageFrotas = trim(return-value).
{utp/ut-liter.i Contador_Secund†rio *}
assign de-contador-sec:label in frame fPageFrotas = trim(return-value).
{utp/ut-liter.i "Posto"}
assign c-posto:label in frame fPageFrotas = trim(return-value).
{utp/ut-liter.i "Conta Equipamento"}
assign c-ct-codigo:label  in frame fPageFrotas = trim(return-value)
       c-ct-codigo:format in frame fPageFrotas = IF c-ct-codigo:SCREEN-VALUE <> "" THEN p_cod_format_cta_ctbl ELSE "X(20)"
       c-cc-codigo:format in frame fPageFrotas = IF c-cc-codigo:SCREEN-VALUE <> "" THEN p_cod_format_ccusto ELSE "X(20)"  .
{utp/ut-liter.i "Motorista"}
assign i-empresa-matr:label in frame fPageFrotas = trim(return-value).
{utp/ut-liter.i "Evento Frota"}
assign c-cod-evento:label in frame fPageFrotas = trim(return-value).
{utp/ut-liter.i "Compartimento"}
assign c-cod-compart:label in frame fPageFrotas = trim(return-value).
{utp/ut-liter.i "Trajeto"}
assign c-cod-rota:label in frame fPageFrotas = trim(return-value).
{utp/ut-liter.i "Atividade"}
assign c-cod-ativid:label in frame fPageFrotas = trim(return-value).

/** Inicializa Handles necess†rios **/
run pi-frota-inicializa-handle in this-procedure.

/** Folder Inicial **/
run pi-frota-seta-folder in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-frota-destroy-handle Include 
PROCEDURE pi-frota-destroy-handle :
/*------------------------------------------------------------------------------
  Purpose:     pi-frota-destroy-handle
  Parameters:  <none>
  Notes:       Elimina handles da mem¢ria
------------------------------------------------------------------------------*/
/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run Destroy in hDBOEqpto.
/** Modelo **/
if valid-handle(hDBOModelo) then
    run Destroy in hDBOModelo.
/** Posto **/
if valid-handle(hDBOPosto) then
    run Destroy in hDBOPosto.
/** Motorista **/
if valid-handle(hDBOMoto) then
    run Destroy in hDBOMoto.
/** Evento **/
if valid-handle(hDBOEvento) then
    run Destroy in hDBOEvento.
/** Compartimento **/
if valid-handle(hDBOComp) then
    run Destroy in hDBOComp.
/** Ficha **/
if valid-handle(hDBOFicha) then
    run Destroy in hDBOFicha.

{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-frota-inicializa-handle Include 
PROCEDURE pi-frota-inicializa-handle :
/*------------------------------------------------------------------------------
  Purpose:     pi-frota-inicializa-handle
  Parameters:  <none>
  Notes:       Inicializa os handles utilizados pelo folder frotas
------------------------------------------------------------------------------*/
    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Posto  ---*/
    IF NOT VALID-HANDLE(hDBOPosto) OR
       hDBOPosto:TYPE <> "PROCEDURE":U OR
       hDBOPosto:FILE-NAME <> "frbo/bofr021.p":U THEN DO:
        run frbo/bofr021.p persistent set  hDBOPosto.
    END.
    
    RUN openQueryStatic IN hDBOPosto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Motorista  ---*/
    IF NOT VALID-HANDLE(hDBOMoto) OR
       hDBOMoto:TYPE <> "PROCEDURE":U OR
       hDBOMoto:FILE-NAME <> "frbo/bofr017.p":U THEN DO:
        run frbo/bofr017.p persistent set  hDBOMoto.
    END.
    
    RUN openQueryStatic IN hDBOMoto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Evento ---*/
    IF NOT VALID-HANDLE(hDBOEvento) OR
       hDBOEvento:TYPE <> "PROCEDURE":U OR
       hDBOEvento:FILE-NAME <> "frbo/bofr010.p":U THEN DO:
        run frbo/bofr010.p persistent set  hDBOEvento.
    END.
    
    RUN openQueryStatic IN hDBOEvento (INPUT "Main":U) NO-ERROR.

    /*--- DBO Compartimento ---*/
    IF NOT VALID-HANDLE(hDBOComp) OR
       hDBOComp:TYPE <> "PROCEDURE":U OR
       hDBOComp:FILE-NAME <> "frbo/bofr003.p":U THEN DO:
        run frbo/bofr003.p persistent set  hDBOComp.
    END.
    
    RUN openQueryStatic IN hDBOComp (INPUT "Main":U) NO-ERROR.

    /*:T--- BO de Ficha Abatestecimento / Lubificaá∆o ---*/
    IF NOT VALID-HANDLE(hDBOFicha) OR
       hDBOFicha:TYPE <> "PROCEDURE":U OR
       hDBOFicha:FILE-NAME <> "frbo/bofr055.p":U THEN DO:
        run frbo/bofr055.p persistent set hDBOFicha.
    END.
    
    RUN openQueryStatic IN hDBOFicha (INPUT "Main":U) NO-ERROR.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-frota-seta-folder Include 
PROCEDURE pi-frota-seta-folder :
/*------------------------------------------------------------------------------
  Purpose:     pi-frota-seta-folder
  Parameters:  <none>
  Notes:       Seta a p†gina correta e mostra dados iniciais
------------------------------------------------------------------------------*/
/** Habilita e mostra campos em tela **/
assign rs-tipo      = 1
       c-hr-inicial = replace(string(time,"hh:mm":U),":":U,"":U)
       c-posto      = fnPosto().

enable {&pageFrotas} with frame fPageFrotas.
display {&pageFrotas} with frame fPageFrotas.

assign c-desc-eqpto:screen-value     in frame fPageFrotas = "":U
       c-nome-motorista:screen-value in frame fPageFrotas = "":U
       c-desc-evento:screen-value    in frame fPageFrotas = "":U
       c-desc-compart:screen-value   in frame fPageFrotas = "":U.

apply "LEAVE":U         to c-posto in frame fPageFrotas.
apply "VALUE-CHANGED":U to rs-tipo in frame fPageFrotas.

/** Coloca programa na primeira p†gina **/
run setFolder in p-handle-folder (input 1).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-frota-seta-valores Include 
PROCEDURE pi-frota-seta-valores :
/*------------------------------------------------------------------------------
  Purpose:     pi-frota-seta-valores
  Parameters:  entrada  = C¢digo do Item
               entrada  
  Notes:       Abastecimento x Recebimento
------------------------------------------------------------------------------*/
define input parameter p-it-codigo    as character no-undo.

define buffer bf-item-frota for item.

/** Item deve ser dÇbito direto e equipamento deve estar informado **/
if can-find(first bf-item-frota 
            where bf-item-frota.it-codigo  = p-it-codigo
            and   bf-item-frota.tipo-contr = 4 no-lock) 
    &IF "{&mguni_version}" >= "2.071" &THEN
    and input frame fPageFrotas i-ep-codigo  > "" 
    &ELSE
    and input frame fPageFrotas i-ep-codigo  > 0 
    &ENDIF
    and input frame fPageFrotas c-cod-eqpto <> "":U then do:
    /** Valida se o item dÇbito direto est† relacionado com 
        Tipo de material do Abastecimento / Lubrificaá∆o **/
    run abp/ab0804d.p (input input frame fPageFrotas dat-movto,
                       input input frame fPageFrotas c-hr-inicial,
                       input input frame fPageFrotas i-ep-codigo,
                       input input frame fPageFrotas c-cod-eqpto,
                       input input frame fPageFrotas de-contador,
                       input input frame fPageFrotas de-contador-sec,
                       input input frame fPageFrotas c-posto,
                       INPUT INPUT FRAME fPageFrotas i-empresa-matr,
                       INPUT INPUT FRAME fPageFrotas c-estabel-matr,
                       input input frame fPageFrotas c-cod-matr,
                       input input frame fPageFrotas c-cod-evento,
                       input input frame fPageFrotas c-cod-compart,
                       input input frame fPageFrotas c-cod-rota,
                       input input frame fPageFrotas c-cod-ativid,
                       input input frame fPageFrotas rs-tipo).
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-frota-zera-valores Include 
PROCEDURE pi-frota-zera-valores :
/*------------------------------------------------------------------------------
  Purpose:     pi-frota-zera-valores
  Parameters:  <none>
  Notes:       Zera os vaalores das vari†veis globais
------------------------------------------------------------------------------*/
/** Folder Inicial **/
run pi-frota-seta-folder in this-procedure.

/** Limpa os dados das vari†veis globais **/
run abp/ab0804d.p (input today,
                   input "0000":U,
                   input 0,
                   input "":U,
                   input 0,
                   input 0,
                   input "":U,
                   INPUT 0,
                   INPUT "":U,
                   input "":U,
                   input "":U,
                   input "":U,
                   input "":U,
                   input "":U,
                   input 0).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoomCentroCusto Include 
PROCEDURE pi-zoomCentroCusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN  cEmpresaEstab = INPUT FRAME fPageFrotas i-ep-codigo
            dDtMovimento  = INPUT FRAME fPageFrotas dat-movto.

    IF dDtMovimento = ? THEN ASSIGN dDtMovimento = TODAY.

    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT cEmpresaEstab,         /*Empresa*/
                                                   INPUT "",                    /*Estabelecimento */
                                                   INPUT YES,                   /*Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                    /*Unidade de Neg¢cio*/
                                                   INPUT "",                    /*Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,        /*C¢digo da Conta*/
                                                   INPUT "",                    /*C¢digo do Plano de Centro de Custo*/
                                                   INPUT dDtMovimento,          /*Data da Transaá∆o*/
                                                   OUTPUT v_cod_ccusto,         /*C¢digo CCusto*/
                                                   OUTPUT v_des_ccusto,         /*Descriá∆o CCusto*/
                                                   OUTPUT TABLE tt_log_erro ).  /*Erros*/

    ASSIGN c-cc-codigo:SCREEN-VALUE IN FRAME fPageFrotas = v_cod_ccusto.

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoomConta Include 
PROCEDURE pi-zoomConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h_api_cta_ctbl) OR
        h_api_cta_ctbl:TYPE      <> "PROCEDURE":U OR
        h_api_cta_ctbl:FILE-NAME <> "prgint/utb/utb743za.py":U THEN DO:
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.    
    END.
    
    ASSIGN  cEmpresaEstab = INPUT FRAME fPageFrotas i-ep-codigo
            dDtMovimento  = INPUT FRAME fPageFrotas dat-movto.

    IF dDtMovimento = ? THEN ASSIGN dDtMovimento = TODAY.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  cEmpresaEstab,       /* EMPRESA PADR«O DO USUµRIO*/
                                                   INPUT  "CEP",               /* MODULO */                                                  
                                                   INPUT  "",                  /* PLANO DE CONTAS */
                                                   INPUT  v_cod_finalid,       /* FINALIDADES */
                                                   INPUT  dDtMovimento,        /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,      /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    IF v_cod_cta_ctbl <> "" THEN
		ASSIGN c-ct-codigo:SCREEN-VALUE IN FRAME fPageFrotas = v_cod_cta_ctbl.
    
    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piParametros Include 
PROCEDURE piParametros :
/*------------------------------------------------------------------------------
  Purpose:     piParametros
  Parameters:  <none>
  Notes:       Busca ParÉmetros e habilita/desabilita campos em tela
------------------------------------------------------------------------------*/
for each  mab-param fields(des-valor cdn-param)
    where mab-param.cdn-param >= 7 
    and   mab-param.cdn-param <= 9 no-lock:
    case mab-param.cdn-param:
        /** Motorista **/
        when 7 then
            assign i-empresa-matr:sensitive in frame fPageFrotas = if mab-param.des-valor = "1":U then yes
                                                               else no
                   c-estabel-matr:sensitive in frame fPageFrotas = if mab-param.des-valor = "1":U then yes
                                                               else no
                   c-cod-matr:sensitive in frame fPageFrotas = if mab-param.des-valor = "1":U then yes
                                                               else no.
        /** Atividade **/
        when 8 then
            assign c-cod-ativid:sensitive in frame fPageFrotas = if mab-param.des-valor = "1":U
                                                                 then no
                                                                 else yes.
        /** Trajeto **/
        when 9 then
            assign c-cod-rota:sensitive in frame fPageFrotas = if mab-param.des-valor = "1":U
                                                               then yes
                                                               else no.
    end case.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaContadorSec Include 
PROCEDURE piValidaContadorSec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN lLogContSec = NO.
    IF  cCodModelo <> "" THEN DO:
        RUN gotokey IN hDBOEqpto (INPUT FRAME fPageFrotas i-ep-codigo,
                                  INPUT FRAME fPageFrotas c-cod-eqpto).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN getLogField   IN hDBOEqpto (INPUT "log-cont-sec":U,
                                            OUTPUT lLogContSec).
        END.
        IF  lLogContSec THEN DO:
            RUN gotokey IN hDBOModelo (INPUT cCodModelo).
            IF  RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField  IN hDBOModelo (INPUT "cod-livre-1":U,
                                                 OUTPUT cUnModelSec).
                ASSIGN cUnModelSec = SUBSTRING(cUnModelSec, 1, 2).
            END.
        END.
    END.
    
    IF  lLogContSec THEN
        ASSIGN de-contador-sec:SENSITIVE IN FRAME fPageFrotas = YES
               c-un-sec:SCREEN-VALUE     IN FRAME fPageFrotas = cUnModelSec.
    ELSE
        ASSIGN de-contador-sec:SCREEN-VALUE IN FRAME fPageFrotas = "0,0"
               c-un-sec:SCREEN-VALUE        IN FRAME fPageFrotas = ""
               de-contador-sec:SENSITIVE    IN FRAME fPageFrotas = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPosto Include 
FUNCTION fnPosto RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  fnPosto
    Notes:  Busca o c¢digo do posto do emitente da NF
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRetorno AS CHARACTER  NO-UNDO.

if can-find(first mab-posto
            where mab-posto.cod-emitente = p-cod-emitente no-lock) then do:
    for first mab-posto fields(cod-posto)
        where mab-posto.cod-emitente = p-cod-emitente no-lock:
        assign cRetorno = mab-posto.cod-posto.
    end.
end.
else do:
    assign cRetorno = "":U.
end.


  RETURN cRetorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

