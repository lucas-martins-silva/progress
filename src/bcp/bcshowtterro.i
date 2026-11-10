If can-find(first {1}) then do:
        Hide All no-pause.
        For Each {1}:
            Run 'bcp/bc9115.p':U (Input {1}.cd-erro,
                                  Input "ERRO: " + {1}.mensagem,
                                  &IF Defined(FrameSizeError)
                                  &THEN
                                  Input Int(Entry(3,'{&FrameSizeError}',' ')), /*Linhas*/
                                  Input Int(Entry(1,'{&FrameSizeError}',' ')), /*Colunas*/
                                  &ELSE
                                  Input Int(Entry(3,'{&FrameSize}',' ')), /*Linhas*/
                                  Input Int(Entry(1,'{&FrameSize}',' ')), /*Colunas*/
                                  &ENDIF
                                  &IF Defined(ErrorDisplaySeconds)
                                  &THEN
                                  Input Int({&ErrorDisplaySeconds}'), /*Segundos*/
                                  &ELSE
                                  Input 1, /*Segundos*/
                                  &ENDIF
                                  ).
	     If "{2}" = "Empty" then delete {1}.

    	 End.
        Hide All No-pause.
        Pause 0 No-message.
End.    
