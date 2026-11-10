EMPTY TEMP-TABLE RowErrors               NO-ERROR.
EMPTY TEMP-TABLE ttReturnInvoiceDocument NO-ERROR.


DEFINE VARIABLE r-nota-fiscal AS ROWID      NO-UNDO.

RUN pi-criaTtReturnInvoiceDocument.

IF  RETURN-VALUE <> "OK":U THEN
    RETURN "OK":U. /*voltar, e nÆo continuar, e devolver OK ao EAI*/

ASSIGN r-nota-fiscal = ROWID(nota-fiscal).

IF  AVAIL ttReturnInvoiceDocument THEN
    CASE ttReturnInvoiceDocument.cStat:
    
        WHEN "101":U OR       /*101 - Cancelamento de NF-e homologado  */
        WHEN "151":U OR       /*151 - Cancelamento de NF-e homologado fora de prazo*/                                  
        WHEN "155":U OR       /*155 - Cancelamento homologado fora de prazo (para Evento de Cancelamento [NT2011.006]*/
        WHEN "102":U THEN DO: /*102 - Inutiliza‡Æo de n£mero homologado*/
    
            RUN ftp/ft0911.p (INPUT ROWID(nota-fiscal),
                              INPUT ttReturnInvoiceDocument.cStat,
                              INPUT ttReturnInvoiceDocument.nProt).
        END.
    
        OTHERWISE DO: /*Uso Autorizado, Rejei‡Æo, Uso Denegado, etc.*/

            {adapters/xml/ep2/axrep001upsert.i}

        END.
    
    END CASE.



/*Verificar se est  como Uso Autorizado[3] ou Documento Cancelado[6], para solicitar o xml ao TSS*/
FIND FIRST nota-fiscal
     WHERE ROWID(nota-fiscal) = r-nota-fiscal NO-LOCK NO-ERROR.

IF &if "{&bf_dis_versao_ems}":U >= "2.07":U &then
    (nota-fiscal.idi-sit-nf-eletro   = 3 OR nota-fiscal.idi-sit-nf-eletro   = 4 OR nota-fiscal.idi-sit-nf-eletro   = 6 OR nota-fiscal.idi-sit-nf-eletro   = 7)
   &else
    CAN-FIND (FIRST sit-nf-eletro NO-LOCK
              WHERE sit-nf-eletro.cod-estabel  = nota-fiscal.cod-estabel
                AND sit-nf-eletro.cod-serie    = nota-fiscal.serie
                AND sit-nf-eletro.cod-nota-fis = nota-fiscal.nr-nota-fis
                AND (sit-nf-eletro.idi-sit-nf-eletro = 3
                OR   sit-nf-eletro.idi-sit-nf-eletro = 6))
   &endif
THEN DO:
    RUN pi-EnviaNotaTSS.
END.
