/*Api para eliminar a tabela fechto-qualid e alterar a situa‡Æo fechto-produt-period, quando eliminado o roteiro do m¢dulo de CQ*/
{cdp/cd0666.i}   /** Definicao da tt-erro **/

DEFINE BUFFER bf-analis-lab-period FOR analis-lab-period.

DEFINE VARIABLE i-nr-ficha LIKE  analis-lab-period.nr-ficha   NO-UNDO.
DEFINE VARIABLE i-num-msg  AS INTEGER                         NO-UNDO.
DEFINE VARIABLE c-msg-erro AS CHARACTER FORMAT "X(255)"       NO-UNDO.


PROCEDURE setNrFicha:
    DEFINE INPUT PARAM pNrFicha LIKE  analis-lab-period.nr-ficha NO-UNDO.

    ASSIGN i-nr-ficha =  pNrFicha.


END PROCEDURE.

PROCEDURE pi-elimina-analise-aqr:

    
      for first analis-lab-period 
          where analis-lab-period.nr-ficha = i-nr-ficha NO-LOCK:
          
          FOR FIRST ficha-cq NO-LOCK 
               WHERE ficha-cq.nr-ficha =  analis-lab-period.nr-ficha:
    
              FOR FIRST fechto-produt-period EXCLUSIVE-LOCK
                  WHERE fechto-produt-period.cod-period       = string(MONTH(analis-lab-period.dat-analis),'99') + string(YEAR(analis-lab-period.dat-analis),'9999')
                  AND   fechto-produt-period.cdn-produt-rural = analis-lab-period.cdn-produt-rural 
                  AND   fechto-produt-period.cod-propried     = analis-lab-period.cod-propried 
                  AND   fechto-produt-period.it-codigo        = ficha-cq.it-codigo 
                  AND   fechto-produt-period.cod-estabel      = ficha-cq.cod-estabel:
                
                  
                  IF fechto-produt-period.idi-situacao = 3  THEN DO: /*NF GERADA*/
                      /*CRIAR O ERRO REFERENTE INFORMANDO AO USUµRIO QUE EXISTEM NOTAS GERADAS PARA O PERÖODO*/
                      {utp\ut-liter.i Ser _necess rio_eliminar_as_notas_geradas_neste_per¡odo,_para_que_seja_poss¡vel_eliminar_os_exames}
                       ASSIGN c-msg-erro = RETURN-VALUE
                              i-num-msg  = 56557.
                             
                       RUN pi-tt-erro. 
                       RETURN "NOK":U.
                  END.
                  ELSE DO:
                      ASSIGN  fechto-produt-period.idi-situacao = 1. /*PENDENTE*/
                  END.
              END.
          END.
          
          IF RETURN-VALUE <> "NOK":U THEN DO:
          
             FOR EACH  it-exame FIELDS(cod-exame it-codigo) NO-LOCK
                 WHERE it-exame.it-codigo = ficha-cq.it-codigo:
    
    
                 FOR EACH  it-comp-exame FIELDS(cod-exame it-codigo cod-comp) NO-LOCK    
                     WHERE it-comp-exame.it-codigo = it-exame.it-codigo
                     AND   it-comp-exame.cod-exame = it-exame.cod-exame:
    
                     FOR EACH  res-fic-cq FIELDS(resultado it-codigo cod-exame cod-comp) NO-LOCK 
                         WHERE res-fic-cq.nr-ficha  = analis-lab-period.nr-ficha
                         AND   res-fic-cq.it-codigo = it-comp-exame.it-codigo
                         AND   res-fic-cq.cod-comp  = it-comp-exame.cod-comp:
        
                         FOR FIRST fechto-qualid EXCLUSIVE-LOCK
                               WHERE fechto-qualid.cod-period       = string(MONTH(analis-lab-period.dat-analis),'99') + string(YEAR(analis-lab-period.dat-analis),'9999')
                                 AND fechto-qualid.cdn-produt-rural = analis-lab-period.cdn-produt-rural
                                 AND fechto-qualid.cod-propried     = analis-lab-period.cod-propried
                                 AND fechto-qualid.it-codigo        = res-fic-cq.it-codigo    
                                 AND fechto-qualid.cod-exame        = res-fic-cq.cod-exame       
                                 AND fechto-qualid.cdn-comp         = res-fic-cq.cod-comp
                                 AND fechto-qualid.cod-estabel      = ficha-cq.cod-estabel:
              
                             DELETE fechto-qualid.
                         END.
                     END.
                 END.
             END.
             FOR FIRST bf-analis-lab-period EXCLUSIVE-LOCK
                 WHERE bf-analis-lab-period.nr-ficha = analis-lab-period.nr-ficha:
                 DELETE bf-analis-lab-period.
             END.
          END.
     end.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setTtErro:
    DEFINE INPUT PARAMETER TABLE FOR tt-erro.

END PROCEDURE.

PROCEDURE getTtErro:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

END PROCEDURE.


PROCEDURE pi-tt-erro :
    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

    
    ASSIGN i-seq = 0.
    FIND LAST tt-erro NO-ERROR.
    IF AVAIL tt-erro THEN
        ASSIGN i-seq = tt-erro.i-sequen + 1.
    ELSE 
        ASSIGN i-seq = 1.

    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = i-seq
           tt-erro.cd-erro  = i-num-msg 
           tt-erro.mensagem = c-msg-erro.

    RETURN "OK":U.
END PROCEDURE.

