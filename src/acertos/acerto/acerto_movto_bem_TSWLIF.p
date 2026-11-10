output to value(session:temp-directory + "\del_mov.txt").
FOR EACH movto-bem
   WHERE bm-codigo  =  104002118
     AND bm-indice  = 000        
     AND mb-per-ano = "012014":
   EXPORT   movto-bem.
   DELETE   movto-bem.  
END.     

MESSAGE "TERMINO EXECU°€O"
SKIP "Encaminhar no chamado o arquivo del_mov.TXT"
SKIP "Gerado em " session:temp-directory
view-as alert-box. 
