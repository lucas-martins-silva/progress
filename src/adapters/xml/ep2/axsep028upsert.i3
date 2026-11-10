PROCEDURE pi-localiza-tabelas:

    ASSIGN cCodEstabel = nota-fiscal.cod-estabel.
    
    RUN pi-localiza-tabelas-ttEmitNFCom.    
    
    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
    END.

    ASSIGN i-natureza = emitente.natureza.
    
    ASSIGN l-prod-rural = NO.
    
    IF i-natureza = 1 AND
      (emitente.atividade = "Rural" OR 
       emitente.atividade = "Fisica" OR 
       emitente.atividade = "Física") THEN
      ASSIGN l-prod-rural = YES.
    
    FOR FIRST contrato-nfcom NO-LOCK    
        WHERE contrato-nfcom.cod-emitente = nota-fiscal.cod-emitente
          AND contrato-nfcom.nr-contrato  = substring(nota-fiscal.char-2,263,20)
          AND contrato-nfcom.tp-servico   = int(substring(nota-fiscal.char-2,284,1)):
    END.
       
    FOR FIRST bf-natur-oper-nf NO-LOCK
        WHERE bf-natur-oper-nf.nat-operacao = nota-fiscal.nat-operacao:
    END.
    
    FOR FIRST bf-pais NO-LOCK
        WHERE bf-pais.nome-pais = emitente.pais:
    END.

END PROCEDURE.