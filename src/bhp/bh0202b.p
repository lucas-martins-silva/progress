/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0202B 2.00.00.008 } /*** "010008" 14/07/2026 15:13:27  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i Bh0202b MBH}
&ENDIF

/*******************************************************************************
**
**  Programa: BH0202B.P - Faz a transferˆncia do registro do arquivo de 
**                        hist¢ricos para o arquivo de movimento.
**                        PEDIDOS, FATURAMENTO, OBRIGACOES FISCAIS
**
*******************************************************************************/

DISABLE TRIGGERS FOR LOAD OF hisdis.nota-fiscal.
DISABLE TRIGGERS FOR LOAD OF hisdis.it-nota-fisc.  
DISABLE TRIGGERS FOR LOAD OF hisdis.it-nota-imp.   
DISABLE TRIGGERS FOR LOAD OF hisdis.nota-trans.    
DISABLE TRIGGERS FOR LOAD OF hisdis.fat-ser-lote.  
DISABLE TRIGGERS FOR LOAD OF hisdis.nar-it-nota.   
DISABLE TRIGGERS FOR LOAD OF hisdis.fat-repre.     
DISABLE TRIGGERS FOR LOAD OF hisdis.fat-duplic.    
DISABLE TRIGGERS FOR LOAD OF hisdis.nota-embal.    
DISABLE TRIGGERS FOR LOAD OF hisdis.item-embal.    
DISABLE TRIGGERS FOR LOAD OF hisdis.devol-cli.     
DISABLE TRIGGERS FOR LOAD OF hisdis.ped-venda.     
DISABLE TRIGGERS FOR LOAD OF hisdis.ped-item.      
DISABLE TRIGGERS FOR LOAD OF hisdis.ped-ent.       
DISABLE TRIGGERS FOR LOAD OF hisdis.ped-repre.       
DISABLE TRIGGERS FOR LOAD OF hisdis.cond-ped.      
DISABLE TRIGGERS FOR LOAD OF hisdis.fat-estat.     
DISABLE TRIGGERS FOR LOAD OF hisdis.doc-fiscal.    
DISABLE TRIGGERS FOR LOAD OF hisdis.it-doc-fisc.   
DISABLE TRIGGERS FOR LOAD OF hisdis.apur-imposto.  
DISABLE TRIGGERS FOR LOAD OF hisdis.imp-valor.     
DISABLE TRIGGERS FOR LOAD OF hisdis.imposto-guia.  
DISABLE TRIGGERS FOR LOAD OF hisdis.ext-doc-fiscal.
DISABLE TRIGGERS FOR LOAD OF hisadm.nota-fisc-social.
DISABLE TRIGGERS FOR LOAD OF hisadm.item-nota-social.

/* ============================ Input Parameters ============================ */
define input parameter c-nome-arq as char  no-undo.
define input parameter rw-arqmov  as rowid no-undo.


/* =============================== Main Block =============================== */
case c-nome-arq:
     when "nota-fiscal"      OR
     when "it-nota-fisc"     OR
     when "it-nota-imp"      OR 
     when "nota-trans"       OR 
     WHEN "fat-ser-lote"     OR
     when "nar-it-nota"      OR
     when "fat-repre"        OR
     when "fat-duplic"       OR 
     when "nota-embal"       OR
     when "item-embal"       OR 
     when "devol-cli"        OR 
     when "nota-fisc-social" OR 
     when "item-nota-social" THEN DO: 
         RUN pi-movdis1 (INPUT c-nome-arq).
         IF  RETURN-VALUE = "NOK":U THEN
             RETURN "NOK":U.
     END.                   
     when "ped-venda"          OR
     when "ped-item"           OR
     when "ped-ent"            OR 
     when "his-ped-ent"        OR 
     when "ped-repre"          OR
     when "cond-ped"           OR 
     when "fat-estat"          OR 
     when "doc-fiscal"         OR 
     when "it-doc-fisc"        OR 
     when "apur-imposto"       OR 
     when "imp-valor"          OR
     when "imposto-guia" then do:
         RUN pi-movdis2 (INPUT c-nome-arq).
         IF  RETURN-VALUE = "NOK":U THEN
             RETURN "NOK":U.
     end.
end case.

PROCEDURE pi-movdis1:
    DEF INPUT PARAM p-nome-arq AS CHAR NO-UNDO.

    case p-nome-arq:
         when "nota-fiscal" then do:
             find hisdis.nota-fiscal where rowid(hisdis.nota-fiscal) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.nota-fiscal NO-LOCK
                          WHERE movdis.nota-fiscal.cod-estabel = hisdis.nota-fiscal.cod-estabel
                          AND   movdis.nota-fiscal.serie       = hisdis.nota-fiscal.serie
                          AND   movdis.nota-fiscal.nr-nota-fis = hisdis.nota-fiscal.nr-nota-fis) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=nota-fiscal}
         end.
         when "it-nota-fisc" then do:
             find hisdis.it-nota-fisc where rowid(hisdis.it-nota-fisc) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.it-nota-fisc OF hisdis.it-nota-fisc NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=it-nota-fisc}	
         end.
         when "it-nota-imp" then do:
             find hisdis.it-nota-imp where rowid(hisdis.it-nota-imp) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.it-nota-imp OF hisdis.it-nota-imp NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=it-nota-imp}	
         end.
         when "nota-trans" then do:
             find hisdis.nota-trans where rowid(hisdis.nota-trans) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.nota-trans OF hisdis.nota-trans NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=nota-trans}
         end.
         when "fat-ser-lote" then do:
             find hisdis.fat-ser-lote where rowid(hisdis.fat-ser-lote) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.fat-ser-lote OF hisdis.fat-ser-lote NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=fat-ser-lote}
         end.
         when "nar-it-nota" then do:
             find hisdis.nar-it-nota where rowid(hisdis.nar-it-nota) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.nar-it-nota OF hisdis.nar-it-nota NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=nar-it-nota}
         end.
         when "fat-repre" then do:
             find hisdis.fat-repre where rowid(hisdis.fat-repre) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.fat-repre OF hisdis.fat-repre NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=fat-repre}
         end.
         when "fat-duplic" then do:
             find hisdis.fat-duplic where rowid(hisdis.fat-duplic) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.fat-duplic OF hisdis.fat-duplic NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=fat-duplic}
         end.
         when "nota-embal" then do:
             find hisdis.nota-embal where rowid(hisdis.nota-embal) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.nota-embal NO-LOCK
                          WHERE movdis.nota-embal.cod-estabel = hisdis.nota-embal.cod-estabel
                          AND   movdis.nota-embal.serie       = hisdis.nota-embal.serie      
                          AND   movdis.nota-embal.nr-nota-fis = hisdis.nota-embal.nr-nota-fis
                          AND   movdis.nota-embal.sigla-emb   = hisdis.nota-embal.sigla-emb) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=nota-embal}
         end.
         when "item-embal" then do:
             find hisdis.item-embal where rowid(hisdis.item-embal) = rw-arqmov no-lock no-error.
             {bhp/bh9801.i &area=dis &arqmov=item-embal}
         end.
         when "devol-cli" then do:
             find hisdis.devol-cli where rowid(hisdis.devol-cli) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.devol-cli 
                          WHERE movdis.devol-cli.serie-docto    = hisdis.devol-cli.serie-docto
                          AND   movdis.devol-cli.nro-docto      = hisdis.devol-cli.nro-docto
                          AND   movdis.devol-cli.cod-emitente   = hisdis.devol-cli.cod-emitente
                          AND   movdis.devol-cli.nat-operacao   = hisdis.devol-cli.nat-operacao
                          AND   movdis.devol-cli.sequencia      = hisdis.devol-cli.sequencia
                          AND   movdis.devol-cli.cod-estabel    = hisdis.devol-cli.cod-estabel
                          AND   movdis.devol-cli.serie          = hisdis.devol-cli.serie
                          AND   movdis.devol-cli.nr-nota-fis    = hisdis.devol-cli.nr-nota-fis
                          AND   movdis.devol-cli.nr-sequencia   = hisdis.devol-cli.nr-sequencia
                          AND   movdis.devol-cli.it-codigo      = hisdis.devol-cli.it-codigo NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=devol-cli}
         end.
         when "nota-fisc-social" then do:
             find hisadm.nota-fisc-social where rowid(hisadm.nota-fisc-social) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movadm.nota-fisc-social NO-LOCK
                          WHERE movadm.nota-fisc-social.cod-estabel  = hisadm.nota-fisc-social.cod-estabel
                          AND   movadm.nota-fisc-social.cod-serie    = hisadm.nota-fisc-social.cod-serie
                          AND   movadm.nota-fisc-social.cod-nota-fis = hisadm.nota-fisc-social.cod-nota-fis) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=adm &arqmov=nota-fisc-social}
         end.
         when "item-nota-social" then do:
             find hisadm.item-nota-social where rowid(hisadm.item-nota-social) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movadm.item-nota-social OF hisadm.item-nota-social NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=adm &arqmov=item-nota-social}	
         end.

    END CASE.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-movdis2:
    DEF INPUT PARAM p-nome-arq AS CHAR NO-UNDO.

    case p-nome-arq:
         when "ped-venda" then do:
             find hisdis.ped-venda where rowid(hisdis.ped-venda) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.ped-venda 
                          WHERE movdis.ped-venda.nr-pedido = hisdis.ped-venda.nr-pedido NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=ped-venda}
         end.
         when "ped-item" then do:
             find hisdis.ped-item where rowid(hisdis.ped-item) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.ped-item OF hisdis.ped-item NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=ped-item}
         end.
         when "ped-ent" then do:
             find hisdis.ped-ent where rowid(hisdis.ped-ent) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.ped-ent 
                          WHERE movdis.ped-ent.nome-abrev   = hisdis.ped-ent.nome-abrev
                          AND   movdis.ped-ent.nr-pedcli    = hisdis.ped-ent.nr-pedcli
                          AND   movdis.ped-ent.nr-sequencia = hisdis.ped-ent.nr-sequencia
                          AND   movdis.ped-ent.it-codigo    = hisdis.ped-ent.it-codigo
                          AND   movdis.ped-ent.cod-refer    = hisdis.ped-ent.cod-refer
                          AND   movdis.ped-ent.nr-entrega   = hisdis.ped-ent.nr-entrega NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=ped-ent}
         end.
         when "his-ped-ent" then do:
             find hisdis.his-ped-ent where rowid(hisdis.his-ped-ent) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.his-ped-ent NO-LOCK
                          where movdis.his-ped-ent.nome-abrev   = hisdis.his-ped-ent.nome-abrev
                          AND   movdis.his-ped-ent.nr-pedcli    = hisdis.his-ped-ent.nr-pedcli
                          AND   movdis.his-ped-ent.nr-sequencia = hisdis.his-ped-ent.nr-sequencia
                          AND   movdis.his-ped-ent.it-codigo    = hisdis.his-ped-ent.it-codigo
                          AND   movdis.his-ped-ent.cod-refer    = hisdis.his-ped-ent.cod-refer
                          AND   movdis.his-ped-ent.nr-entrega   = hisdis.his-ped-ent.nr-entrega) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=his-ped-ent}
         end.
         when "ped-repre" then do:
             find hisdis.ped-repre where rowid(hisdis.ped-repre) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.ped-repre 
                          WHERE movdis.ped-repre.nr-pedido         =  hisdis.ped-repre.nr-pedido
                          AND   movdis.ped-repre.nome-ab-rep       =  hisdis.ped-repre.nome-ab-rep
                          &IF "{&bf_dis_Versao_ems}" >= "2.04" &THEN
                          AND   movdis.ped-repre.cod-classificador =  hisdis.ped-repre.cod-classificador
                          &ENDIF  NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=ped-repre}
         end.
         when "cond-ped" then do:
             find hisdis.cond-ped where rowid(hisdis.cond-ped) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.cond-ped OF hisdis.cond-ped NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=cond-ped}
         end.
         when "fat-estat" then do:
             find hisdis.fat-estat where rowid(hisdis.fat-estat) = rw-arqmov no-lock no-error.
             {bhp/bh9801.i &area=dis &arqmov=fat-estat}	
         end.
         when "doc-fiscal" then do:
             find hisdis.doc-fiscal where rowid(hisdis.doc-fiscal) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.doc-fiscal OF hisdis.doc-fiscal NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=doc-fiscal}	
         end.
         when "it-doc-fisc" then do:
             find hisdis.it-doc-fisc where rowid(hisdis.it-doc-fisc) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.it-doc-fisc OF hisdis.it-doc-fisc NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=it-doc-fisc}	
         end.
         when "apur-imposto" then do:
             find hisdis.apur-imposto where rowid(hisdis.apur-imposto) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.apur-imposto OF hisdis.apur-imposto NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=apur-imposto}
         end.
         when "imp-valor" then do:
             find hisdis.imp-valor where rowid(hisdis.imp-valor) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.imp-valor OF hisdis.imp-valor NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=imp-valor}	
         end.
         when "imposto-guia" then do:
             find hisdis.imposto-guia where rowid(hisdis.imposto-guia) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST movdis.imposto-guia OF hisdis.imposto-guia NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9801.i &area=dis &arqmov=imposto-guia}
         end.
    end case.

END PROCEDURE.
