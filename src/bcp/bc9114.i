/***********************************************************************************
** Include...: bc9114.i
** Objetivo..: Fazer o update dos campos da interface caracter do Data Collection
** Autor.....: Carlos Alberto Soares Pereira - Fev/2001
** Parametros: 1 - Numero da frame 
***********************************************************************************/
    
    _Frame{&FrameNum}:
    Repeat While Not vLogSai
            On Error  Undo _Frame{&FrameNum}, Retry _Frame{&FrameNum}
            On EndKey Undo _Frame{&FrameNum}, Leave _Frame{&FrameNum}:

            &IF {&Frame{&FrameNum}Repeat} = Yes &THEN
            Assign vLogFinaliza  = No
                   vNumFrame     = 0.


            Do While Not vLogFinaliza On Error  Undo _Frame{&FrameNum}, Retry _Frame{&FrameNum}
                                      On EndKey Undo _Frame{&FrameNum}, Leave _Frame{&FrameNum}:
                
            &ENDIF
            /*&IF {&Frame{&FrameNum}Repeat} */

                Assign vNumFrame = vNumFrame + 1.
        
                    
                View frame {&Frame{&FrameNum}Name}.
                {&TriggerBeforeFrame{&FrameNum}}
                If vLogUpdateFrame = Yes Then Do:
                    Update {&Update{&FrameNum}Fields} With Frame {&Frame{&FrameNum}Name} No-Error.
                End. /*If vLogUpdateFrame = Yes Then Do:*/
                &IF Defined(TriggerAfterFrame{&FrameNum}) &THEN
                    {&TriggerAfterFrame{&FrameNum}}
                    If   vLogErro = Yes Then Undo _Frame{&FrameNum}, Retry _Frame{&FrameNum}.
                &ENDIF
                /* &IF Defined(TriggerAfterFrame{&FrameNum}) */
    
                    Hide Frame {&Frame{&FrameNum}Name}.
        
            &IF {&Frame{&FrameNum}Repeat} = Yes &THEN
            
            End. /* Do While Not */

            Assign vLogFinaliza = No.

            &ENDIF
            /* &IF {&Frame{&FrameNum}Repeat} */

/* Deve ser colocado um End no final da interacao deste Repeat pois os mesmo encadeia uma unica transacao */
/* Para isto utilizar o seguinte codigo:                                                                  */
/* &If Defined(&Frame99Name) &Then                                                                        */
/*     End. /* Repeat {&Frame99Name} */                                                                   */
/* &EndIf                                                                                                 */
