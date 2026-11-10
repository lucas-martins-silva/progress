/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9112 MBC}
&ENDIF


{include/i-prgvrs.i BC9112 2.00.00.002 } /*** "010002" ***/
/********************************************************************************************
**   Programa..: bc9112.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.001 - mar/2003 - Karen de Freitas Machado                         **
**                                                                                         **
**   Objetivo..: Template DB Interface Menu para transacoes                                **
**                                                                                         **
**   Includes..: bc9105.i, bc9102.i                                                        **
**                                                                                         **
********************************************************************************************/
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
***************************************************************************************************/

Define New Global Shared Var lMenu          As Logical                               No-undo.
/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9112
/************************************************************/

/* Definicao Temp-Table tt-erro ---                         */
{bcp/bc9102.i}
/************************************************************/

/* Definicao de variaveis do menu ---                       */
{bcp/bc9112.i0} /* Login */
Define Variable c-opcao  As Character Format 'x(01)'              No-Undo.
Define Variable vDesErro As Character View-as Editor Size 5 By 2  No-Undo.
Define Variable vLogErro As Logical Init No                       No-Undo.
Define Variable vNumErro As Integer Format '>>>>>>9'              No-Undo.
Define Variable wgWindow As Handle                                No-Undo.
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
Define Frame Frame01
    'Menu'                 At Row 01 Col 01
    '1-Transf. Materiais'  At Row 02 Col 01
    '2-Transf. Mat. - V2'  At Row 03 Col 01
    '3-Contagem Ciclica'   At Row 04 Col 01
    '4-Requis. Materiais'  At Row 05 Col 01
    '5-Reporte        >|'  At Row 06 Col 01
    '6-Aviso Embarque'     At Row 07 Col 01
    &if '{&mgscm_version}' >= '2.04' &then
        '7-WMS            >|'  At Row 08 Col 01
    &ENDIF
    'F-Fim'                At Row 09 Col 01
    'Opcao[  ]'            At Row 09 Col 12
    c-opcao                At Row 09 Col 18 No-Label
        With 1 down font 3 Size 20 By 9 No-box.
/************************************************************/

/* Definicao da Frame02 ---                                 */
Define Frame Frame02
    'Menu - Reportes  [2]'  At Row 01 Col 01
    '1-Ordem/Oper/PtoCont'  At Row 02 Col 01
    '2-Repetitivo'          At Row 03 Col 01
    'V-Voltar'              At Row 07 Col 01
    'Opcao[  ]'             At Row 07 Col 12
    c-opcao                 At Row 07 Col 18 No-Label
        With 1 down font 3 Size 20 By 8 No-box.

/* Definicao da Frame03 ---                                 */
Define Frame Frame03
    'Menu - WMS  [2]'       At Row 01 Col 01
    '1-Entrada        >|'   At Row 02 Col 01
    '2-Sa¡da          >|'   At Row 03 Col 01
    '3-Outras         >|'   At Row 04 Col 01
    'V-Voltar'              At Row 07 Col 01
    'Opcao[  ]'             At Row 07 Col 12
    c-opcao                 At Row 07 Col 18 No-Label
        With 1 down font 3 Size 20 By 8 No-box.

/* Definicao da Frame04 ---                                 */
Define Frame Frame04
    'Menu-Entrada WMS[3]'   At Row 01 Col 01
    '1-Montagem Carga   '   At Row 02 Col 01
    '2-Conferˆncia      '   At Row 03 Col 01
    '3-Armazenamento    '   At Row 04 Col 01
    'V-Voltar'              At Row 07 Col 01
    'Opcao[  ]'             At Row 07 Col 12
    c-opcao                 At Row 07 Col 18 No-Label
        With 1 down font 3 Size 20 By 8 No-box.

/* Definicao da Frame05 ---                                 */
Define Frame Frame05
    'Menu-Sa¡da WMS[3]  '   At Row 01 Col 01
    '1-Picking          '   At Row 02 Col 01
    '2-Packing          '   At Row 03 Col 01
    '3-Ressuprimento    '   At Row 04 Col 01
    '4-Devolu‡Æo Picking'   At Row 05 Col 01
    '5-Packing List     '   At Row 06 Col 01
    'V-Voltar'              At Row 07 Col 01
    'Opcao[  ]'             At Row 07 Col 12
    c-opcao                 At Row 07 Col 18 No-Label
        With 1 down font 3 Size 20 By 8 No-box.

/* Definicao da Frame06 ---                                 */
Define Frame Frame06
    'Menu-Outras WMS[3] '   At Row 01 Col 01
    '1-Transferˆncia    '   At Row 02 Col 01
    '2-Consulta Endere‡o'   At Row 03 Col 01
    '3-Invent rio       '   At Row 04 Col 01
    '4-Consulta Local   '   AT ROW 05 COL 01
    '5-Etiqueta Avulsa  '   AT ROW 06 COL 01
    'V-Voltar'              At Row 07 Col 01
    'Opcao[  ]'             At Row 07 Col 12
    c-opcao                 At Row 07 Col 18 No-Label
        With 1 down font 3 Size 20 By 8 No-box.

/************************************************************/

/* Definicao da _Error ---                                  */
Define Frame _Error
    'Erro:'         At Row 1 Col 1 
    vNumErro        At Row 1 Col 6 No-label
    vDesErro        At Row 2 Col 1 No-label
        With 1 down font 3 Size 20 By 8 No-box.

Assign vDesErro:Width  = Frame _Error:Width
       vDesErro:Height = Frame _Error:Height - 1.
/************************************************************/

/*****************************************   Frames Fim ******************************************/

/***********************************   Codigo Principal   ****************************************/
Assign Session:data-entry-return = Yes.
If Session:window-system <> 'TTY' Then Do:
    Create Window wgWindow Assign
          Status-area  = No
          Message-area = No
          Width        = Frame Frame01:Width
          Height       = Frame Frame01:Height
          Title        = 'Menu'.
    Assign Current-window = wgWindow.
End.

Assign lMenu = Yes.

Repeat  On Error Undo, Retry
        On EndKey Undo, Leave:
    {bcp/bc9112.i}  /* Login do Produto */      
    Assign c-opcao = ''.

    If Session:window-system <> 'TTY' Then
        Assign wgWindow:Title = "Menu".

    View frame Frame01.
    Update c-opcao With Frame Frame01.

    Run ExecutaOpcaoFrame01.

    If c-opcao = 'F' Then Leave.
End.

Assign Session:data-entry-return = No.

If Valid-handle(wgWindow) Then Do:
    Assign wgWindow:visible = No.
    Delete  Object wgWindow.
End.

Return.
/**************************************************************************************************/

/*********************************** Procedures Internas ******************************************/
Procedure ExecutaOpcaoFrame01:
    Assign vLogErro = No.
    Hide Frame Frame01.

    Case c-opcao:
        When '1' Then       /* Transferencia de Materiais   */
            Run 'bcp/bc9001.p':U.
        When '2' Then       /* Transf. Materiais - V2       */
            Run 'bcp/bc9005.p':U.
        When '3' Then       /* Contagem Ciclica             */
            Run 'bcp/bc9002.p':U.
        When '4' Then       /* Requisi‡Æo de Materiais      */
            Run 'bcp/bc9004.p':U.
        When '5' Then Do:   /* Reportes                     */
            Repeat  On Error Undo, Retry
                    On EndKey Undo, Leave:
                Assign c-opcao = ''.

                If Session:window-system <> 'TTY' Then
                    Assign wgWindow:Title = "Menu".

                View frame Frame02.
                Update c-opcao With Frame Frame02.

                Run ExecutaOpcaoFrame02.

                If c-opcao = 'V' Then Leave.
            End.

            Assign c-opcao = ''.
        End.
        When '6' Then       /* Aviso de Embarque            */
            Run 'bcp/bc9008.p':U.
        &if '{&mgscm_version}' >= '2.04' &then
            When '7' Then Do:   /* WMS                          */
                Repeat  On Error Undo, Retry
                        On EndKey Undo, Leave:
                    Assign c-opcao = ''.

                    If Session:window-system <> 'TTY' Then
                       Assign wgWindow:Title = "Menu".

                    View frame Frame03.
                    Update c-opcao With Frame Frame03.

                    Run ExecutaOpcaoFrame03.

                    If c-opcao = 'V' Then Leave.
                End.

                Assign c-opcao = ''.
            End.
        &endif
        When 'F' Then do:
            Hide All.
            /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
            DEFINE VARIABLE c-lbl-liter-data-collection AS CHARACTER FORMAT "X(17)" NO-UNDO.
            {utp/ut-liter.i "Data_Collection" *}
            ASSIGN c-lbl-liter-data-collection = TRIM(RETURN-VALUE).
            Display 'Datasul S.A.'    At Row 01 Col 01
                    c-lbl-liter-data-collection At Row 02 Col 01 NO-LABEL With Font 3 Size 20 By 8 No-box.
            Pause 1 No-message.
        End.
        Otherwise do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "0" "Opcao invalida"}
        End.
    End Case.

    If  Frame Frame01:Visible = Yes Then
        Hide Frame Frame01.

    If  Frame Frame02:Visible = Yes Then
        Hide Frame Frame02.

    Assign lMenu = No.

End Procedure.

Procedure ExecutaOpcaoFrame02:
    Assign vLogErro = No.

    Hide Frame Frame02.

    Case c-opcao:
        When '1' Then
            Run 'bcp/bc9003.p':U.
        When '2' Then
            Run 'bcp/bc9006.p':U.
        When 'V' Then .
        Otherwise do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "0" "Opcao invalida"}
        End.
    End Case.

    Hide All.
End Procedure.

Procedure ExecutaOpcaoFrame03:
    Assign vLogErro = No.

    Hide Frame Frame03.

    Case c-opcao:
        When '1' THEN DO:
            Repeat  On Error Undo, Retry
                    On EndKey Undo, Leave:
                Assign c-opcao = ''.
                If Session:window-system <> 'TTY' Then
                    Assign wgWindow:Title = "Menu".
                View frame Frame04.
                Update c-opcao With Frame Frame04.
                RUN ExecutaOpcaoFrame04.
                If c-opcao = 'V' Then Leave.
            End.
            Assign c-opcao = ''.
        End.
        When '2' THEN DO:
            Repeat  On Error Undo, Retry
                    On EndKey Undo, Leave:
                Assign c-opcao = ''.
                If Session:window-system <> 'TTY' Then
                    Assign wgWindow:Title = "Menu".
                View frame Frame05.
                Update c-opcao With Frame Frame05.
                Run ExecutaOpcaoFrame05.
                If c-opcao = 'V' Then Leave.
            End.
            Assign c-opcao = ''.
        End.
        When '3' THEN DO:
            Repeat  On Error Undo, Retry
                    On EndKey Undo, Leave:
                Assign c-opcao = ''.
                If Session:window-system <> 'TTY' Then
                    Assign wgWindow:Title = "Menu".
                View frame Frame06.
                Update c-opcao With Frame Frame06.
                Run ExecutaOpcaoFrame06.
                If c-opcao = 'V' Then Leave.
            End.
            Assign c-opcao = ''.
        End.
        When 'V' Then .
        Otherwise do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "0" "Op‡Æo Inv lida"}
        End.
    End Case.

    Hide All.
End Procedure.

Procedure ExecutaOpcaoFrame04:
    Assign vLogErro = No.
    Hide Frame Frame04.
    Case c-opcao:
        When '1' Then
            Run 'bcp/bc9015.p':U.
        When '2' Then
            Run 'bcp/bc9016.p':U.
        When '3' Then
            Run 'bcp/bc9017.p':U.
        When 'V' Then .
        Otherwise do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "0" "Op‡Æo Inv lida"}
        End.
    End Case.
    Hide All.
End Procedure.

Procedure ExecutaOpcaoFrame05:
    Assign vLogErro = No.
    Hide Frame Frame05.
    Case c-opcao:
        When '1' Then
            Run 'bcp/bc9018.p':U.
        When '2' Then
            Run 'bcp/bc9019.p':U.
        When '3' Then
            Run 'bcp/bc9020.p':U.
        When '4' Then
            Run 'bcp/bc9021.p':U.
        When '5' Then
            Run 'bcp/bc9022.p':U.
        When 'V' Then .
        Otherwise do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "0" "Op‡Æo Inv lida"}
        End.
    End Case.
    Hide All.
End Procedure.

Procedure ExecutaOpcaoFrame06:
    Assign vLogErro = No.
    Hide Frame Frame06.
    Case c-opcao:
        When '1' Then
            Run 'bcp/bc9025.p':U.
        When '2' Then
            Run 'bcp/bc9023.p':U.
        When '3' Then
            Run 'bcp/bc9024.p':U.
        WHEN '4' THEN
            Run 'bcp/bc9039.p':U.
        WHEN '5' THEN
            Run 'bcp/bc0801.w':U.
        When 'V' Then .
        Otherwise do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "0" "Op‡Æo Inv lida"}
        End.
    End Case.
    Hide All.
End Procedure.

FINALLY:   
   
   ASSIGN lMenu = NO.
    
   IF THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
 
   RETURN 'OK':U.
END FINALLY.
