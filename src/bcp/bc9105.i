  /*  Data     - Autor - OBS
      22/06/05 - dumke - Incluido o do no pause no-message, pois quando estava com a menssagem de erro
      na tela, se o usuario desse um "esc" pelo coletor, o mesmo continuava o processo.
      22/06/05 - dumke - incluido o preprocessador de tempo, pois se o mesmo tiver disponivel nao
      precisa precionar enter para sair da mensagem.
  */           
            &IF Defined(ProcedureClearFrame) 
            &THEN
                 &IF '{&ProcedureClearFrame}' <> ""
                 &then 
                      RUN {&ProcedureClearFrame}.
                 &ENDIF
            &ENDIF
            PAUSE 0.


            Hide All No-pause.
            &IF DEFINED(MessageBell) <> 0
               &THEN 
                  IF {&MessageBell}
                      THEN Bell.
            &ENDIF
            DO WHILE LASTKEY <> -1:   
               View Frame _Error.
               Assign vNumErro:screen-value In Frame _Error = "{1}" {3}.
               &IF "{2}" = "return-value" &THEN
                    Assign vDesErro:screen-value In Frame _Error = {2} {4}. /* Alterado de "{2}" para {2} devido tÇcnica de traduá∆o */
               &else
                    Assign vDesErro:screen-value In Frame _Error = "{2}" {4}. 
               &ENDIF
               
               &IF DEFINED(ErrorDisplaySeconds) = 0 
               &THEN
                   READKEY.
                   IF LASTKEY <> 27 THEN   /* s¢ n∆o sai da mensagem com ESC */
                   LEAVE.
               &ELSE
                   READKEY PAUSE {&ErrorDisplaySeconds}. 
                   IF LASTKEY <> 27 THEN   /* s¢ n∆o sai da mensagem com ESC */
                   LEAVE.
               &ENDIF                              
            end.
            Hide Frame _Error.

            &IF Defined(ProcedureClearFrame) 
            &THEN
                 &IF '{&ProcedureClearFrame}' <> ""
                 &then 
                      RUN {&ProcedureClearFrame}.
                 &ENDIF
            &ENDIF
            Hide All No-pause.
            PAUSE 0.
