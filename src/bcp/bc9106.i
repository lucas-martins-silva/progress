/***************************************************************************************
** Copyright DATASUL S.A. (1999)                                                      **
** Todos os Direitos Reservados.                                                      ** 
**                                                                                    **
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao                   **
** parcial ou total por qualquer meio, so podera ser feita mediante                   **
** autorizacao expressa.                                                              ** 
****************************************************************************************/
/***************************************************************************************
** Program   : bc9106.i                                                               **
** Purpose   : Faz a manutencao nas temp-tables das transacoes do coleta de           **
**             dados.                                                                 **
** Parameters: Variavel global vAcessType determina o tipo de acesso ao               **
**             programa.                                                              **
**             1 - Alteracao                                                          **
**             2 - Consulta                                                           **
** Notes     : None.                                                                  **
** Author    : Carlos Alberto Soares Pereira - 20/12/1999                             **
****************************************************************************************/

/* {&Table} Definitions ---                                                            */
{{&NameOfTTInclude}}

/* tt-erro Definitions ---                                                             */
{cdp/cd0666.i}

/* tt-trans Definitions ---                                                            */
{bcp/bcapi001.i}

/* tt-etiquera Definitions ---                                                         */
{bcp/bcapi002.i}

/* tt-prog-bc Definitions ---                                                          */
{bcp/bcapi004.i}

/* Definitions Procedures Proxy ---                                                    */
{bcp/bcproxy.i2}


/*************************************************/

/* Input-Output Parameters ---                                                         */
DEFINE INPUT PARAM h-handleParam AS HANDLE   NO-UNDO.
DEFINE INPUT PARAM h-handleSon   AS HANDLE   NO-UNDO.
DEFINE INPUT PARAM pNumTransacao AS INTEGER  NO-UNDO.
DEFINE INPUT PARAM pDesDetalhe   AS CHAR     NO-UNDO.
DEFINE INPUT PARAM pRawContent   AS RAW      NO-UNDO.
DEFINE INPUT PARAM pLogApaga     AS LOGICAL  NO-UNDO.

/* Global Variable Definitions ---                                                     */
DEFINE NEW GLOBAL SHARED VAR vAcessType AS INTEGER NO-UNDO.

/* Local Variable Definitions ---                                                      */
DEFINE VARIABLE wgWindow        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wgFocus         AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE vCodTransaction AS CHARACTER     NO-UNDO.

/* Rectangle Definitions ---                                                           */
DEFINE RECTANGLE rtButton SIZE 1 BY 1.3  EDGE-PIXELS 2 GRAPHIC-EDGE BGCOLOR 7 TOOLTIP 'Modura dos Botoes. Obj:rtButton'.
DEFINE RECTANGLE rtMoldur SIZE 1 BY .1   EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL   TOOLTIP 'Modura dos Campos. Obj:rtMoldur'.

/* Buttons Definitions ---                                                             */
DEFINE BUTTON btOk       LABEL '&Ok'         SIZE 10 by 0.9 TOOLTIP 'Confirma e Sai do Programa. Obj:btOk'.
DEFINE BUTTON btCancela  LABEL '&Cancela'    SIZE 10 by 0.9 TOOLTIP 'Confirma e Sai do Programa. Obj:btCancela'.

IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
   RUN piBloqWindow IN h-handleParam.  

/* Windows Definitions ---                                                             */
CREATE WINDOW wgWindow ASSIGN
    HIDDEN             = YES
    TITLE              = 'Transacao ' + '{&ProgramTitle}'
    HEIGHT             = 1
    WIDTH              = 1
    MAX-HEIGHT         = 1
    MAX-WIDTH          = 1
    VIRTUAL-HEIGHT     = 1
    VIRTUAL-WIDTH      = 1
    RESIZE             = NO
    SCROLL-BARS        = NO
    STATUS-AREA        = NO
    BGCOLOR            = ?
    FGCOLOR            = ?
    THREE-D            = YES
    MESSAGE-AREA       = NO
    SENSITIVE          = YES.

/* Frames Definitions ---                                                               */
DEFINE FRAME fFields 
            {&FrameFields}
        WITH {&FrameNumOfColumns} COLUMNS 1 DOWN THREE-D FONT 2 NO-BOX.

DEFINE FRAME fObjects 
             rtMoldur
             rtButton btOk AT ROW 01 COL 01 
             btCancela     AT ROW 01 COL 01
                WITH THREE-D FONT 1  NO-BOX.

//liga o facelift
&GLOBAL-DEFINE aplica_facelift YES
{include/i_fcldef.i}
{include/i_fclfrm.i fObjects}

IF vAcessType = 1 THEN DO:
   FIND FIRST bc-prog-trans NO-LOCK 
        WHERE bc-prog-trans.cod_prog_dtsul = '{&TransactionProgram}' NO-ERROR.
   IF NOT AVAIL bc-prog-trans THEN DO:
      RETURN ERROR.
   END.
   ASSIGN vCodTransaction = bc-prog-trans.cd-trans.
End.

/* Triggers Definitions Begin ---                                                       */
&IF '{&TriggerObject01}' <> '' &THEN
   ON {&TriggerEvent01} OF {&TriggerObject01} IN FRAME f{&TriggerFrame01} DO:
      {&TriggerCode01}
   END. 
&ENDIF
&IF '{&TriggerObject02}' <> '' &THEN
   ON {&TriggerEvent02} OF {&TriggerObject02} IN FRAME f{&TriggerFrame02} DO:
      {&TriggerCode02}
   END. 
&ENDIF
&IF '{&TriggerObject03}' <> '' &THEN
   ON {&TriggerEvent03} Of {&TriggerObject03} IN FRAME f{&TriggerFrame03} DO:
      {&TriggerCode03}
   END. 
&ENDIF
&IF '{&TriggerObject04}' <> '' &THEN
   ON {&TriggerEvent04} OF {&TriggerObject04} IN FRAME f{&TriggerFrame04} DO:
      {&TriggerCode04}
   END. 
&ENDIF
&IF '{&TriggerObject05}' <> '' &THEN
   ON {&TriggerEvent05} Of {&TriggerObject05} IN FRAME f{&TriggerFrame05} DO:
      {&TriggerCode05}
   END. 
&ENDIF
&IF '{&TriggerObject06}' <> '' &THEN
   ON {&TriggerEvent06} Of {&TriggerObject06} IN FRAME f{&TriggerFrame06} DO:
      {&TriggerCode06}
   END. 
&ENDIF
&IF '{&TriggerObject07}' <> '' &THEN
   ON {&TriggerEvent07} OF {&TriggerObject07} IN FRAME f{&TriggerFrame07} DO:
      {&TriggerCode07}
   END. 
&ENDIF
&IF '{&TriggerObject08}' <> '' &THEN
   ON {&TriggerEvent08} OF {&TriggerObject08} IN FRAME f{&TriggerFrame08} DO:
      {&TriggerCode08}
   END. 
&ENDIF
&IF '{&TriggerObject09}' <> '' &THEN
   ON {&TriggerEvent09} Of {&TriggerObject09} IN FRAME f{&TriggerFrame09} DO:
      {&TriggerCode09}
   END. 
&ENDIF
&IF '{&TriggerObject10}' <> '' &THEN
   ON {&TriggerEvent10} OF {&TriggerObject10} IN FRAME f{&TriggerFrame10} DO:
      {&TriggerCode10}
   END. 
&ENDIF
&IF '{&TriggerObject11}' <> '' &THEN
   ON {&TriggerEvent11} OF {&TriggerObject11} IN FRAME f{&TriggerFrame11} DO:
      {&TriggerCode11}
   END. 
&ENDIF
&IF '{&TriggerObject12}' <> '' &THEN
   ON {&TriggerEvent12} OF {&TriggerObject12} IN FRAME f{&TriggerFrame12} DO:
      {&TriggerCode12}
   END. 
&ENDIF
&IF '{&TriggerObject13}' <> '' &THEN
   ON {&TriggerEvent13} OF {&TriggerObject13} IN FRAME f{&TriggerFrame13} DO:
      {&TriggerCode13}
   END. 
&ENDIF
&IF '{&TriggerObject14}' <> '' &THEN
   ON {&TriggerEvent14} OF {&TriggerObject14} IN FRAME f{&TriggerFrame14} DO:
      {&TriggerCode14}
   END. 
&ENDIF
&IF '{&TriggerObject15}' <> '' &THEN
   ON {&TriggerEvent15} OF {&TriggerObject15} IN FRAME f{&TriggerFrame15} DO:
      {&TriggerCode15}
   END. 
&ENDIF

/* Triggers Definitions End   ---                                                       */

/* Aplica formatos customizados aos campos da tela */
RUN CustomizeFormats.

/* Aplica propriedades customizadas aos campos da tela */
RUN CustomizeFieldProperties.

/* Ajusta os objetos na tela ---                                                        */
ASSIGN FRAME fFields:WIDTH   = FRAME fFields:WIDTH  + 2.0
       FRAME fObjects:WIDTH  = FRAME fFields:WIDTH  + 2.0
       FRAME fObjects:HEIGHT = FRAME fFields:HEIGHT + 2.0
       FRAME fObjects:ROW    = 1
       FRAME fObjects:COL    = 1.6
       FRAME fFields:FRAME   = FRAME fObjects:HANDLE
       FRAME fFields:ROW     = 1.3
       FRAME fFields:COL     = 2.0
       wgWindow:WIDTH        = FRAME fObjects:WIDTH  + 0.5
       wgWindow:HEIGHT       = FRAME fObjects:HEIGHT + 0.2
       wgWindow:MAX-WIDTH    = FRAME fObjects:WIDTH  + 0.5
       wgWindow:MAX-HEIGHT   = FRAME fObjects:HEIGHT + 0.2
       rtMoldur:ROW          = 1.15
       rtMoldur:COL          = 1.0
       rtMoldur:WIDTH        = FRAME fObjects:WIDTH  - 0.5
       rtMoldur:HEIGHT       = FRAME fObjects:HEIGHT - 1.65
       rtButton:ROW          = FRAME fObjects:HEIGHT - 0.35
       rtButton:COL          = 1.0
       rtButton:WIDTH        = FRAME fObjects:WIDTH  - 0.5
       btOk:ROW              = rtButton:ROW          + 0.25
       btOk:COL              = rtButton:COL          + 0.8
       btCancela:ROW         = rtButton:ROW          + 0.25
       btCancela:COL         = btOk:COL              + 10.5.



/* Nomeia Titulo do programa conforme tipo de acesso */
CASE vAcessType:
   WHEN 1 THEN ASSIGN wgWindow:TITLE = 'Modifica ' + wgWindow:TITLE. /* Alteracao   */
   WHEN 2 THEN ASSIGN wgWindow:TITLE = 'Consulta ' + wgWindow:TITLE. /* Consulta    */
   OTHERWISE   ASSIGN wgWindow:TITLE = 'Consulta ' + wgWindow:TITLE. /* Consulta    */
END CASE.

ASSIGN wgWindow:VISIBLE = YES.

VIEW FRAME fObjects IN WINDOW wgWindow.

/* Habilita frame de acordo com o tipo de acesso */

CASE vAcessType:
   WHEN 1 THEN DO:
      RUN EnableToUpdate. /* Alteracao   */
      RAW-TRANSFER pRawContent TO {&Table}.
      FIND FIRST {&Table} NO-ERROR.
      DISPLAY {&FrameFields} WITH FRAME fFields NO-ERROR.
      RUN DisplayCustomFields.
   END.
   WHEN 2 THEN DO:
      RUN EnableToView.   /* Consulta    */
      RAW-TRANSFER pRawContent TO {&Table}.
      FIND FIRST {&Table} NO-ERROR.
      DISPLAY {&FrameFields} WITH FRAME fFields NO-ERROR.
      RUN DisplayCustomFields.
   END.
   OTHERWISE RUN EnableToView.   /* Stand Alone */
END CASE.

ON END-ERROR ANYWHERE DO:
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR.
   RUN destroyhandle.
   APPLY "CLOSE" TO THIS-PROCEDURE.
END.

ON CLOSE OF THIS-PROCEDURE DO:
   ASSIGN wgWindow:VISIBLE = NO.
   DELETE WIDGET wgWindow.
END.


ON CHOOSE OF btCancela IN FRAME fObjects DO:
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR.
   RUN destroyhandle.
   APPLY "CLOSE" TO THIS-PROCEDURE.
END.


ON WINDOW-CLOSE OF wgWindow DO:
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR.
    RUN destroyhandle.
   APPLY "CLOSE" TO THIS-PROCEDURE.
END.


ON CHOOSE OF btOK IN FRAME fObjects DO:
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR. 
   /* Verifica como proceder na saida do programa */
   CASE vAcessType:
      WHEN 1 THEN DO:
         RUN LocalAssignFields.
         ASSIGN pDesDetalhe = {&TransDetail}.
         APPLY "CLOSE" TO THIS-PROCEDURE.
      END.
      WHEN 2 THEN DO:
         APPLY "CLOSE" TO THIS-PROCEDURE.
      END.
      OTHERWISE DO:
         APPLY "CLOSE" TO THIS-PROCEDURE.
      END.
   END CASE.
   RAW-TRANSFER {&Table} TO pRawContent NO-ERROR.
   ASSIGN pLogApaga   = YES
          pDesDetalhe = {&TransDetail}.

   IF VALID-HANDLE(h-handleSon) AND STRING(h-handleSon) <> "0" THEN
      RUN pi-atualiza-dados IN h-handleSon (INPUT pNumTransacao,
                                            INPUT pDesDetalhe,
                                            INPUT pRawContent,
                                            INPUT pLogApaga) NO-ERROR.
   RUN destroyhandle.
END.


ASSIGN wgFocus = FRAME fFields:FIRST-CHILD.

IF wgWindow:MOVE-TO-TOP() THEN.

WAIT-FOR CLOSE OF THIS-PROCEDURE FOCUS wgFocus.


RETURN.

PROCEDURE DisplayCustomFields:
/*********************************************************************************************
** Purpose   : Faz Display de campos customizados pelo programador                          **
** Parameters: None                                                                         **
** Notes     : None.                                                                        **
**********************************************************************************************/

ASSIGN &IF '{&CustomDisplayField01}' <> '' &THEN
            {&CustomDisplayField01}:SCREEN-VALUE IN FRAME fFields = {&CustomValueField01}
       &ENDIF
       &IF '{&CustomDisplayField02}' <> '' &THEN
            {&CustomDisplayField02}:SCREEN-VALUE IN FRAME fFields = {&CustomValueField02}
       &ENDIF
       &IF '{&CustomDisplayField03}' <> '' &THEN
            {&CustomDisplayField03}:SCREEN-VALUE IN FRAME fFields = {&CustomValueField03}
       &ENDIF
       &IF '{&CustomDisplayField04}' <> '' &THEN
            {&CustomDisplayField04}:SCREEN-VALUE IN FRAME fFields = {&CustomValueField04}
       &ENDIF
       &IF '{&CustomDisplayField05}' <> '' &THEN
            {&CustomDisplayField05}:SCREEN-VALUE IN FRAME fFields = {&CustomValueField05}
       &ENDIF
       &IF '{&CustomDisplayField06}' <> '' &THEN
            {&CustomDisplayField06}:SCREEN-VALUE IN FRAME fFields = {&CustomValueField06}
       &ENDIF
       &IF '{&CustomDisplayField07}' <> '' &THEN
            {&CustomDisplayField07}:SCREEN-VALUE IN FRAME fFields = {&CustomValueField07}
       &ENDIF
       &IF '{&CustomDisplayField08}' <> '' &THEN
            {&CustomDisplayField08}:SCREEN-VALUE IN FRAME fFields = {&CustomValueField08}
       &ENDIF
       &IF '{&CustomDisplayField09}' <> '' &THEN
            {&CustomDisplayField09}:SCREEN-VALUE IN FRAME fFields = {&CustomValueField09}
       &ENDIF
       &IF '{&CustomDisplayField10}' <> '' &THEN
            {&CustomDisplayField10}:SCREEN-VALUE IN FRAME fFields = {&CustomValueField10}
       &ENDIF.
       
END PROCEDURE.

PROCEDURE LocalAssignFields:
/*********************************************************************************************
** Purpose   : Gravar os campos da tela.                                                    **
** Parameters: None                                                                         **
** Notes     : None.                                                                        **
**********************************************************************************************/
   DO WITH FRAME fFields:
      ASSIGN {&FrameFields}.
   END.
END PROCEDURE.

PROCEDURE EnableToUpdate:
/*********************************************************************************************
** Purpose   : Habilitar a frame para alteracao.                                            **
** Parameters: None                                                                         **
** Notes     : None.                                                                        **
**********************************************************************************************/
   ENABLE ALL WITH FRAME fFields.
   ENABLE btOK btCancela rtButton WITH FRAME fObjects.
END PROCEDURE.

PROCEDURE EnableToView:
/*********************************************************************************************
** Purpose   : Habilitar a frame somente para leitura.                                      **
** Parameters: None                                                                         **
** Notes     : None.                                                                        **
**********************************************************************************************/
   ENABLE btCancela rtButton WITH FRAME fObjects.
END PROCEDURE.

PROCEDURE CustomizeFormats:
/*********************************************************************************************
** Purpose   : Alterar o formado de campos da tela para um formato predefinido pelo         **
**             programador.                                                                 **
** Parameters: None                                                                         **
** Notes     : Definir pre-processor para cada campo.                                       **
**********************************************************************************************/
   ASSIGN &IF '{&CustomFormatField01}' <> '' &THEN
               {&CustomFormatField01}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField01}:FORMAT      IN FRAME fFields = {&FieldFormat01}
          &ENDIF
          &IF '{&CustomFormatField02}' <> '' &THEN
               {&CustomFormatField02}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField02}:FORMAT      IN FRAME fFields = {&FieldFormat02}
          &ENDIF
          &IF '{&CustomFormatField03}' <> '' &THEN
               {&CustomFormatField03}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField03}:FORMAT      IN FRAME fFields = {&FieldFormat03}
          &ENDIF
          &IF '{&CustomFormatField04}' <> '' &THEN
               {&CustomFormatField04}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField04}:FORMAT      IN FRAME fFields = {&FieldFormat04}
          &ENDIF
          &IF '{&CustomFormatField04}' <> '' &THEN
               {&CustomFormatField04}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField04}:FORMAT      IN FRAME fFields = {&FieldFormat04}
          &ENDIF
          &IF '{&CustomFormatField05}' <> '' &THEN
               {&CustomFormatField05}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField05}:FORMAT      IN FRAME fFields = {&FieldFormat05}
          &ENDIF
          &IF '{&CustomFormatField06}' <> '' &THEN
               {&CustomFormatField06}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField06}:FORMAT      IN FRAME fFields = {&FieldFormat06}
          &ENDIF
          &IF '{&CustomFormatField07}' <> '' &THEN
               {&CustomFormatField07}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField07}:FORMAT      IN FRAME fFields = {&FieldFormat07}
          &ENDIF
          &IF '{&CustomFormatField08}' <> '' &THEN
               {&CustomFormatField08}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField08}:FORMAT      IN FRAME fFields = {&FieldFormat08}
          &ENDIF
          &IF '{&CustomFormatField09}' <> '' &THEN
               {&CustomFormatField09}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField09}:FORMAT      IN FRAME fFields = {&FieldFormat09}
          &ENDIF
          &IF '{&CustomFormatField10}' <> '' &THEN
               {&CustomFormatField10}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField10}:FORMAT      IN FRAME fFields = {&FieldFormat10}
          &ENDIF
          &IF '{&CustomFormatField11}' <> '' &THEN
               {&CustomFormatField11}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField11}:FORMAT      IN FRAME fFields = {&FieldFormat11}
          &ENDIF
          &IF '{&CustomFormatField12}' <> '' &THEN
               {&CustomFormatField12}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField12}:FORMAT      IN FRAME fFields = {&FieldFormat12}
          &ENDIF
          &IF '{&CustomFormatField13}' <> '' &THEN
               {&CustomFormatField13}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField13}:FORMAT      IN FRAME fFields = {&FieldFormat13}
          &ENDIF
          &IF '{&CustomFormatField14}' <> '' &THEN
               {&CustomFormatField14}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField14}:FORMAT      IN FRAME fFields = {&FieldFormat14}
          &ENDIF
          &IF '{&CustomFormatField15}' <> '' &THEN
               {&CustomFormatField15}:AUTO-RESIZE IN FRAME fFields = YES
               {&CustomFormatField15}:FORMAT      IN FRAME fFields = {&FieldFormat15}
          &ENDIF.
          
END PROCEDURE.

PROCEDURE CustomizeFieldProperties:
/*********************************************************************************************
** Purpose   : Alterar as propriedades dos campos da tela conforme desejado pelos           **
**             programador.                                                                 **
** Parameters: None                                                                         **
** Notes     : Esta procedure foi implementada no final do desenvolvimento, entao para que  **
**             que nao houvesse retrabalho foram mantidas as procedures CustomizeFormats e  **
**             DisplayCustomFields que tem suas funcoes atendida por esta.                  **
**********************************************************************************************/

ASSIGN &IF '{&CustomFieldProperty01}' <> '' &THEN
            {&CustomFieldProperty01}:{&FieldProperty01} IN FRAME fFields = {&PropertyValue01} .
       &ENDIF
       &IF '{&CustomFieldProperty02}' <> '' &THEN
            {&CustomFieldProperty02}:{&FieldProperty02} IN FRAME fFields = {&PropertyValue02} .
       &ENDIF
       &IF '{&CustomFieldProperty03}' <> '' &THEN
            {&CustomFieldProperty03}:{&FieldProperty03} IN FRAME fFields = {&PropertyValue03} .
       &ENDIF
       &IF '{&CustomFieldProperty04}' <> '' &THEN
            {&CustomFieldProperty04}:{&FieldProperty04} IN FRAME fFields = {&PropertyValue04} .
       &ENDIF
       &IF '{&CustomFieldProperty05}' <> '' &THEN
            {&CustomFieldProperty05}:{&FieldProperty05} IN FRAME fFields = {&PropertyValue05} .
       &ENDIF
       &IF '{&CustomFieldProperty06}' <> '' &THEN
            {&CustomFieldProperty06}:{&FieldProperty06} IN FRAME fFields = {&PropertyValue06} .
       &ENDIF
       &IF '{&CustomFieldProperty07}' <> '' &THEN
            {&CustomFieldProperty07}:{&FieldProperty07} IN FRAME fFields = {&PropertyValue07} .
       &ENDIF
       &IF '{&CustomFieldProperty08}' <> '' &THEN
            {&CustomFieldProperty08}:{&FieldProperty08} IN FRAME fFields = {&PropertyValue08} .
       &ENDIF
       &IF '{&CustomFieldProperty09}' <> '' &THEN
            {&CustomFieldProperty09}:{&FieldProperty09} IN FRAME fFields = {&PropertyValue09} .
       &ENDIF
       &IF '{&CustomFieldProperty10}' <> '' &THEN
            {&CustomFieldProperty10}:{&FieldProperty10} IN FRAME fFields = {&PropertyValue10} .
       &ENDIF
       &IF '{&CustomFieldProperty11}' <> '' &THEN
            {&CustomFieldProperty11}:{&FieldProperty11} IN FRAME fFields = {&PropertyValue11} .
       &ENDIF
       &IF '{&CustomFieldProperty12}' <> '' &THEN
            {&CustomFieldProperty12}:{&FieldProperty12} IN FRAME fFields = {&PropertyValue12} .
       &ENDIF
       &IF '{&CustomFieldProperty13}' <> '' &THEN
            {&CustomFieldProperty13}:{&FieldProperty13} IN FRAME fFields = {&PropertyValue13} .
       &ENDIF
       &IF '{&CustomFieldProperty14}' <> '' &THEN
            {&CustomFieldProperty14}:{&FieldProperty14} IN FRAME fFields = {&PropertyValue14} .
       &ENDIF
       &IF '{&CustomFieldProperty15}' <> '' &THEN
            {&CustomFieldProperty15}:{&FieldProperty15} IN FRAME fFields = {&PropertyValue15} .
       &ENDIF.
       
END PROCEDURE.

PROCEDURE destroyhandle :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
   IF VALID-HANDLE(h-handleSon) AND STRING(h-handleSon) <> "0" THEN
      RUN eliminahandle IN h-handleSon NO-ERROR.

END PROCEDURE.

