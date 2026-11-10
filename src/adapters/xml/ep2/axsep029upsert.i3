PROCEDURE pi-localiza-tabelas:

    ASSIGN cCodEstabel = dce-documento.cod-estabel.
    
    RUN pi-localiza-tabelas-ttEmitDCe.    

END PROCEDURE.

PROCEDURE pi-localiza-tabelas-ttEmitDCe: 

    IF  NOT VALID-HANDLE(h-cdapi704) THEN
        RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.

    IF  NOT AVAIL estabelec
    OR (AVAIL estabelec 
        AND estabelec.cod-estabel <> cCodEstabel) THEN
        FOR FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = cCodEstabel:
        END.

    IF  NOT AVAIL bf-unid-feder-est THEN
        FOR FIRST bf-unid-feder-est NO-LOCK
            WHERE bf-unid-feder-est.pais   = estabelec.pais
              AND bf-unid-feder-est.estado = estabelec.estado:
        END.

END PROCEDURE.