/**************************************************************************************************
** Programa: bc9100.i                                                                            **
** Objetivo: Template padrao DC para interfaces caracter                                         **
**    Autor: Carlos Alberto Soares Pereira                                                       **
**     Data: 25/05/00                                                                            **
**************************************************************************************************/
/* Variable Definitions ---                                                            */

Define New Global Shared Var lMenu          As Logical                               No-undo.
Define Variable vDesErro                    As Character View-as Editor Size 5 By 2  No-undo.
Define Variable vTransDetail                As Character                             No-undo.
Define Variable vFrameList                  As Character                             No-undo.
Define Variable vTransaction                As Character                             No-undo.

Define Variable vConteudoRaw                As Raw                                   No-undo.

Define Variable wgWindow                    As Handle                                No-undo.
Define Variable wgapi010                    As Handle                                No-undo.

Define Variable vNumErro                    As Integer Format '>>>>>>9'              No-undo.
Define Variable vNumFrame                   As Integer Format '>>>>>>9'              No-undo.

Define Variable vLogFinaliza                As Logical Init No                       No-undo.
Define Variable vLogUpdateFrame             As Logical Init Yes                      No-undo.
Define Variable vLogCancela                 As Logical Init No                       No-undo.
Define Variable vLogSai                     As Logical Init No                       No-undo.
Define Variable vLogErro                    As Logical Init No                       No-undo.
Define Variable vLogEtiqueta                As Logical Init No                       No-undo.
/* dako */
DEF VAR h_bcapi001  AS HANDLE NO-UNDO.
/* dako */
/* tt-erro Definitions ---                                                             */
{bcp/bc9102.i}
Define temp-table tt-erro-tipo-trans NO-UNDO like tt-erro{&Ext}.

/* tt-trans Definitions ---                                                            */
{bcp/bcapi001.i}

/* tt-bc-tipo-trans Definitions ---                                                    */
{bcp/bcapi010.i}

/* Definitions Frames ---                                                              */
{bcp/bc9103.i} 

Find First bc-prog-trans no-lock 
     where bc-prog-trans.cod_prog_dtsul = '{&ProgramName}' No-error.

If  Not AvailAble bc-prog-trans Then Do:
    Hide All.
    /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
    DEFINE VARIABLE c-lbl-liter-programa-programname AS CHARACTER FORMAT "X(27)" NO-UNDO.
    {utp/ut-liter.i "Programa_({&ProgramName})" *}
    ASSIGN c-lbl-liter-programa-programname = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-nao-possue-relacio AS CHARACTER FORMAT "X(20)" NO-UNDO.
    {utp/ut-liter.i "n∆o_possue_Relacio" *}
    ASSIGN c-lbl-liter-nao-possue-relacio = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-namento-programa-x AS CHARACTER FORMAT "X(20)" NO-UNDO.
    {utp/ut-liter.i "namento_Programa_X" *}
    ASSIGN c-lbl-liter-namento-programa-x = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-transacao-bc0111 AS CHARACTER FORMAT "X(20)" NO-UNDO.
    {utp/ut-liter.i "Transaá∆o_(bc0111)" *}
    ASSIGN c-lbl-liter-transacao-bc0111 = TRIM(RETURN-VALUE).
    Display c-lbl-liter-programa-programname  At Row 01 Col 01 NO-LABEL
            c-lbl-liter-nao-possue-relacio    At Row 02 Col 01 NO-LABEL
            c-lbl-liter-namento-programa-x    At Row 03 Col 01 NO-LABEL
            c-lbl-liter-transacao-bc0111      At Row 04 Col 01 NO-LABEL
            With Font 3 Size {&FrameSize} No-box.
    Pause 1 No-message.
    Return Error.
End.

/* dako */
     
&IF Defined(UsingBcTransfilho)
&THEN

     &IF '{&UsingBcTransfilho}' = 'YES'
     &THEN
     
     RUN bcp/bcapi001.p     PERSISTENT SET h_bcapi001 (INPUT-OUTPUT TABLE TT-TRANS, input-output table tt-erro{&Ext}).
     
     &ENDIF
     
&ENDIF
     
/* dako */

Assign vTransaction = bc-prog-trans.cd-trans.

Assign Session:data-entry-return = Yes.

If  lMenu = No Then Do:
    If Session:window-system <> 'TTY' Then Do:
          Create Window wgWindow Assign
                Status-area  = No
                Message-area = No
                Width        = Frame Frame01:Width
                Height       = Frame Frame01:Height
                Title        = vTransaction.
          Assign Current-window = wgWindow.
    End.
End.

If Session:window-system <> 'TTY' Then
    Assign Current-window:Title = vTransaction.

/* Triggers Open Program inicio ---            */
{&TriggersOpenProgram}
/* Triggers Open Program inicio fim ---        */

/* Triggers do usuario inicio ---              */
{&UserTriggers}
/* Triggers do usuario fim ---                 */

ON 'F2':U Anywhere 
DO:
    Assign vLogFinaliza = Yes.
END.

ON 'F4' Anywhere 
DO:
    If  vNumFrame = 0 Then Do:
        Assign vLogCancela  = Yes
               vLogFinaliza = Yes
               vLogSai      = Yes.
    End.
    Assign vNumFrame    = vNumFrame - 1.
END.

Create {&TempTable}.

/* Update dos campos da Interface */
{bcp/bc9104.i}

Delete {&TempTable}.

Assign Session:data-entry-return = No.

/* Triggers Close Program inicio ---            */
{&TriggersCloseProgram}
/* Triggers Close Program inicio fim ---        */

If  lMenu = No Then Do:
    If Valid-handle(wgWindow) Then Do:
        Assign wgWindow:visible = NO .
        Delete Object wgWindow.
    End.
End.

/* dako */

IF  VALID-HANDLE(h_bcapi001)  = YES
AND h_bcapi001:TYPE           = "PROCEDURE":U  
AND h_bcapi001:FILE-NAME      = "bcp/bcapi001.p":U 
THEN DO:
    DELETE OBJECT h_bcapi001.
END.
/* dako */

&IF Defined(ActiveObject1) &THEN
    If Valid-handle({&ActiveObject1}) Then Run destroy In {&ActiveObject1} no-error.
    If Valid-handle({&ActiveObject1}) Then Delete Object {&ActiveObject1}.
&ENDIF
&IF Defined(ActiveObject2) &THEN
    If Valid-handle({&ActiveObject2}) Then Run destroy In {&ActiveObject2} no-error.
    If Valid-handle({&ActiveObject2}) Then Delete Object {&ActiveObject2}.
&ENDIF
&IF Defined(ActiveObject3) &THEN
    If Valid-handle({&ActiveObject3}) Then Run destroy In {&ActiveObject3} no-error.
    If Valid-handle({&ActiveObject3}) Then Delete Object {&ActiveObject3}.
&ENDIF
&IF Defined(ActiveObject4) &THEN
    If Valid-handle({&ActiveObject4}) Then Run destroy In {&ActiveObject4} no-error.
    If Valid-handle({&ActiveObject4}) Then Delete Object {&ActiveObject4}.
&ENDIF
&IF Defined(ActiveObject5) &THEN
    If Valid-handle({&ActiveObject5}) Then Run destroy In {&ActiveObject5} no-error.
    If Valid-handle({&ActiveObject5}) Then Delete Object {&ActiveObject5}.
&ENDIF
&IF Defined(ActiveObject6) &THEN
    If Valid-handle({&ActiveObject6}) Then Run destroy In {&ActiveObject6} no-error.
    If Valid-handle({&ActiveObject6}) Then Delete Object {&ActiveObject6}.
&ENDIF
&IF Defined(ActiveObject7) &THEN
    If Valid-handle({&ActiveObject7}) Then Run destroy In {&ActiveObject7} no-error.
    If Valid-handle({&ActiveObject7}) Then Delete Object {&ActiveObject7}.
&ENDIF
&IF Defined(ActiveObject8) &THEN
    If Valid-handle({&ActiveObject8}) Then Run destroy In {&ActiveObject8} no-error.
    If Valid-handle({&ActiveObject8}) Then Delete Object {&ActiveObject8}.
&ENDIF
&IF Defined(ActiveObject9) &THEN
    If Valid-handle({&ActiveObject9}) Then Run destroy In {&ActiveObject9} no-error.
    If Valid-handle({&ActiveObject9}) Then Delete Object {&ActiveObject9}.
&ENDIF
&IF Defined(ActiveObject10) &THEN
    If Valid-handle({&ActiveObject10}) Then Run destroy In {&ActiveObject10} no-error.
    If Valid-handle({&ActiveObject10}) Then Delete Object {&ActiveObject10}.
&ENDIF
&IF Defined(ActiveObject11) &THEN
    If Valid-handle({&ActiveObject11}) Then Run destroy In {&ActiveObject11} no-error.
    If Valid-handle({&ActiveObject11}) Then Delete Object {&ActiveObject11}.
&ENDIF
&IF Defined(ActiveObject12) &THEN
    If Valid-handle({&ActiveObject12}) Then Run destroy In {&ActiveObject12} no-error.
    If Valid-handle({&ActiveObject12}) Then Delete Object {&ActiveObject12}.
&ENDIF
&IF Defined(ActiveObject13) &THEN
    If Valid-handle({&ActiveObject13}) Then Run destroy In {&ActiveObject13} no-error.
    If Valid-handle({&ActiveObject13}) Then Delete Object {&ActiveObject13}.
&ENDIF
&IF Defined(ActiveObject14) &THEN
    If Valid-handle({&ActiveObject14}) Then Run destroy In {&ActiveObject14} no-error.
    If Valid-handle({&ActiveObject14}) Then Delete Object {&ActiveObject14}.
&ENDIF
&IF Defined(ActiveObject15) &THEN
    If Valid-handle({&ActiveObject15}) Then Run destroy In {&ActiveObject15} no-error.
    If Valid-handle({&ActiveObject15}) Then Delete Object {&ActiveObject15}.
&ENDIF
&IF Defined(ActiveObject16) &THEN
    If Valid-handle({&ActiveObject16}) Then Run destroy In {&ActiveObject16} no-error.
    If Valid-handle({&ActiveObject16}) Then Delete Object {&ActiveObject16}.
&ENDIF
&IF Defined(ActiveObject17) &THEN
    If Valid-handle({&ActiveObject17}) Then Run destroy In {&ActiveObject17} no-error.
    If Valid-handle({&ActiveObject17}) Then Delete Object {&ActiveObject17}.
&ENDIF
&IF Defined(ActiveObject18) &THEN
    If Valid-handle({&ActiveObject18}) Then Run destroy In {&ActiveObject18} no-error.
    If Valid-handle({&ActiveObject18}) Then Delete Object {&ActiveObject18}.
&ENDIF
&IF Defined(ActiveObject19) &THEN
    If Valid-handle({&ActiveObject19}) Then Run destroy In {&ActiveObject19} no-error.
    If Valid-handle({&ActiveObject19}) Then Delete Object {&ActiveObject19}.
&ENDIF
&IF Defined(ActiveObject20) &THEN
    If Valid-handle({&ActiveObject20}) Then Run destroy In {&ActiveObject20} no-error.
    If Valid-handle({&ActiveObject20}) Then Delete Object {&ActiveObject20}.
&ENDIF

Return.

