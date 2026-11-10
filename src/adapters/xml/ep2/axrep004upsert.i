
EMPTY TEMP-TABLE RowErrors NO-ERROR.

IF (ttConsultationDocument.cStat <> "100" OR     /*100 Uso Autorizado*/               
    ttConsultationDocument.cStat <> "150") AND   /*150 Uso Autorizado fora de prazo*/ 
   (ttConsultationDocument.cStat <> "101" OR     /*101 Cancelamento de NF-e homologado*/
    ttConsultationDocument.cStat <> "151" OR     /*151 Cancelamento de NF-e homologado fora de prazo*/
    ttConsultationDocument.cStat <> "155") AND   /*155 Cancelamento homologado fora de prazo (para Evento de Cancelamento [NT2011.006]*/
   ttConsultationDocument.cStat <> "110" THEN DO:

  
   FOR EACH estabelec FIELDS(cgc cod-estabel) NO-LOCK
       WHERE estabelec.cgc = substr(ttConsultationDocument.id,7,14),
       FIRST nota-fiscal FIELDS(cod-estabel serie nr-nota-fis) NO-LOCK             
       WHERE nota-fiscal.cod-estabel = estabelec.cod-estabel                   AND
             nota-fiscal.serie       = substr(ttConsultationDocument.id,23,3)  AND
             nota-fiscal.nr-nota-fis = substr(ttConsultationDocument.id,26,9): 
    
        CREATE ret-nf-eletro.
        ASSIGN ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel 
               ret-nf-eletro.cod-serie   = nota-fiscal.serie 
               ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis 
               ret-nf-eletro.cod-msg     = ttConsultationDocument.xMotivo
               ret-nf-eletro.dat-ret     = TODAY
               ret-nf-eletro.hra-ret     = REPLACE(STRING(TIME, "HH:MM:SS"),":","")
               ret-nf-eletro.log-ativo   = YES.
    END.
END.

