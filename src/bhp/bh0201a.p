/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0201A 2.00.00.015 } /*** "010015" 14/07/2026 15:13:27  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bh0201a MBH}
&ENDIF

/*******************************************************************************
**
**  Programa: BH0201A.P - Faz a transferˆncia do registro para o arquivo de 
**                        hist¢ricos.
**                        PEDIDOS, FATURAMENTO, OBRIGACOES FISCAIS e COTA€åES
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
DISABLE TRIGGERS FOR LOAD OF hisdis.item-nfs-st.
DISABLE TRIGGERS FOR LOAD OF hisdis.sit-nf-eletro.
DISABLE TRIGGERS FOR LOAD OF hisdis.ret-nf-eletro.

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
     when "item-nfs-st"      OR 
     when "nota-fisc-social" OR
     when "item-nota-social" OR
     WHEN "sit-nf-eletro"    OR
     WHEN "ret-nf-eletro"    THEN DO: 
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
     when "imposto-guia"       OR 
     when "ext-doc-fiscal" then do:
         RUN pi-movdis2 (INPUT c-nome-arq).
         IF  RETURN-VALUE = "NOK":U THEN
             RETURN "NOK":U.
     end.
end case.

PROCEDURE pi-movdis1:
    DEF INPUT PARAM p-nome-arq AS CHAR NO-UNDO.

    case p-nome-arq:
         when "nota-fiscal" then do:
             find movdis.nota-fiscal where rowid(movdis.nota-fiscal) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.nota-fiscal NO-LOCK
                          WHERE hisdis.nota-fiscal.cod-estabel = movdis.nota-fiscal.cod-estabel
                          AND   hisdis.nota-fiscal.serie       = movdis.nota-fiscal.serie
                          AND   hisdis.nota-fiscal.nr-nota-fis = movdis.nota-fiscal.nr-nota-fis) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=nota-fiscal}
         end.
         when "it-nota-fisc" then do:
             find movdis.it-nota-fisc where rowid(movdis.it-nota-fisc) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.it-nota-fisc OF movdis.it-nota-fisc NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=it-nota-fisc}	
         end.
         when "it-nota-imp" then do:
             find movdis.it-nota-imp where rowid(movdis.it-nota-imp) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.it-nota-imp OF movdis.it-nota-imp NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=it-nota-imp}	
         end.
         when "nota-trans" then do:
             find movdis.nota-trans where rowid(movdis.nota-trans) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.nota-trans OF movdis.nota-trans NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=nota-trans}
         end.
         when "fat-ser-lote" then do:
             find movdis.fat-ser-lote where rowid(movdis.fat-ser-lote) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.fat-ser-lote OF movdis.fat-ser-lote NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=fat-ser-lote}
         end.
         when "nar-it-nota" then do:
             find movdis.nar-it-nota where rowid(movdis.nar-it-nota) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.nar-it-nota OF movdis.nar-it-nota NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=nar-it-nota}
         end.
         when "fat-repre" then do:
             find movdis.fat-repre where rowid(movdis.fat-repre) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.fat-repre OF movdis.fat-repre NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=fat-repre}
         end.
         when "fat-duplic" then do:
             find movdis.fat-duplic where rowid(movdis.fat-duplic) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.fat-duplic OF movdis.fat-duplic NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=fat-duplic}
         end.
         when "nota-embal" then do:
             find movdis.nota-embal where rowid(movdis.nota-embal) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.nota-embal NO-LOCK
                          WHERE hisdis.nota-embal.cod-estabel = movdis.nota-embal.cod-estabel
                          AND   hisdis.nota-embal.serie       = movdis.nota-embal.serie      
                          AND   hisdis.nota-embal.nr-nota-fis = movdis.nota-embal.nr-nota-fis
                          AND   hisdis.nota-embal.sigla-emb   = movdis.nota-embal.sigla-emb) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=nota-embal}
         end.
         when "item-embal" then do:
             find movdis.item-embal where rowid(movdis.item-embal) = rw-arqmov no-lock no-error.
             {bhp/bh9800.i &area=dis &arqmov=item-embal}
         end.
         when "devol-cli" then do:
             find movdis.devol-cli where rowid(movdis.devol-cli) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.devol-cli 
                          WHERE hisdis.devol-cli.serie-docto    = movdis.devol-cli.serie-docto
                          AND   hisdis.devol-cli.nro-docto      = movdis.devol-cli.nro-docto
                          AND   hisdis.devol-cli.cod-emitente   = movdis.devol-cli.cod-emitente
                          AND   hisdis.devol-cli.nat-operacao   = movdis.devol-cli.nat-operacao
                          AND   hisdis.devol-cli.sequencia      = movdis.devol-cli.sequencia
                          AND   hisdis.devol-cli.cod-estabel    = movdis.devol-cli.cod-estabel
                          AND   hisdis.devol-cli.serie          = movdis.devol-cli.serie
                          AND   hisdis.devol-cli.nr-nota-fis    = movdis.devol-cli.nr-nota-fis
                          AND   hisdis.devol-cli.nr-sequencia   = movdis.devol-cli.nr-sequencia
                          AND   hisdis.devol-cli.it-codigo      = movdis.devol-cli.it-codigo NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=devol-cli}
         end.
         WHEN "item-nfs-st" THEN DO:
             FIND movdis.item-nfs-st WHERE ROWID(movdis.item-nfs-st) = rw-arqmov NO-LOCK NO-ERROR.
             IF CAN-FIND(FIRST hisdis.item-nfs-st
                         WHERE hisdis.item-nfs-st.cod-docto-nfs            = movdis.item-nfs-st.cod-docto-nfs          
                           AND hisdis.item-nfs-st.cod-emitente-entr        = movdis.item-nfs-st.cod-emitente-entr      
                           AND hisdis.item-nfs-st.cod-estab-entr           = movdis.item-nfs-st.cod-estab-entr         
                           AND hisdis.item-nfs-st.cod-estab-nfs            = movdis.item-nfs-st.cod-estab-nfs          
                           AND hisdis.item-nfs-st.cod-item                 = movdis.item-nfs-st.cod-item               
                           AND hisdis.item-nfs-st.cod-natur-operac-entr    = movdis.item-nfs-st.cod-natur-operac-entr  
                           AND hisdis.item-nfs-st.cod-nota-entr            = movdis.item-nfs-st.cod-nota-entr          
                           AND hisdis.item-nfs-st.cod-ser-entr             = movdis.item-nfs-st.cod-ser-entr           
                           AND hisdis.item-nfs-st.cod-ser-nfs              = movdis.item-nfs-st.cod-ser-nfs            
                           AND hisdis.item-nfs-st.num-seq-item-entr        = movdis.item-nfs-st.num-seq-item-entr      
                           AND hisdis.item-nfs-st.num-seq-nfs              = movdis.item-nfs-st.num-seq-nfs    NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=item-nfs-st}
        END.
        when "nota-fisc-social" then do:
             find movadm.nota-fisc-social where rowid(movadm.nota-fisc-social) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisadm.nota-fisc-social NO-LOCK
                          WHERE hisadm.nota-fisc-social.cod-estabel  = movadm.nota-fisc-social.cod-estabel
                          AND   hisadm.nota-fisc-social.cod-serie    = movadm.nota-fisc-social.cod-serie
                          AND   hisadm.nota-fisc-social.cod-nota-fis = movadm.nota-fisc-social.cod-nota-fis) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=adm &arqmov=nota-fisc-social}
         end.
         when "item-nota-social" then do:
             find movadm.item-nota-social where rowid(movadm.item-nota-social) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisadm.item-nota-social OF movadm.item-nota-social NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=adm &arqmov=item-nota-social}	
         end.
         when "sit-nf-eletro" then do:
             find movdis.sit-nf-eletro where rowid(movdis.sit-nf-eletro) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.sit-nf-eletro OF movdis.sit-nf-eletro NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=sit-nf-eletro}	
         end.
         when "ret-nf-eletro" then do:
             find movdis.ret-nf-eletro where rowid(movdis.ret-nf-eletro) = rw-arqmov no-lock no-error.
             IF  CAN-FIND(FIRST hisdis.ret-nf-eletro OF movdis.ret-nf-eletro NO-LOCK) THEN
                 RETURN "NOK":U.
             {bhp/bh9800.i &area=dis &arqmov=ret-nf-eletro}	
         end.

    END CASE.
END PROCEDURE.

PROCEDURE pi-movdis2:
    DEF INPUT PARAM p-nome-arq AS CHAR NO-UNDO.

    case p-nome-arq:
        when "ped-venda" then do:
            find movdis.ped-venda where rowid(movdis.ped-venda) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.ped-venda 
                         WHERE hisdis.ped-venda.nr-pedido = movdis.ped-venda.nr-pedido NO-LOCK) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=ped-venda}
        end.
        when "ped-item" then do:
            find movdis.ped-item where rowid(movdis.ped-item) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.ped-item OF movdis.ped-item NO-LOCK) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=ped-item}
        end.
        when "ped-ent" then do:
            find movdis.ped-ent where rowid(movdis.ped-ent) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.ped-ent 
                         WHERE hisdis.ped-ent.nome-abrev   = movdis.ped-ent.nome-abrev
                         AND   hisdis.ped-ent.nr-pedcli    = movdis.ped-ent.nr-pedcli
                         AND   hisdis.ped-ent.nr-sequencia = movdis.ped-ent.nr-sequencia
                         AND   hisdis.ped-ent.it-codigo    = movdis.ped-ent.it-codigo
                         AND   hisdis.ped-ent.cod-refer    = movdis.ped-ent.cod-refer
                         AND   hisdis.ped-ent.nr-entrega   = movdis.ped-ent.nr-entrega NO-LOCK) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=ped-ent}
        end.
        when "his-ped-ent" then do:
            find movdis.his-ped-ent where rowid(movdis.his-ped-ent) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.his-ped-ent NO-LOCK
                         where hisdis.his-ped-ent.nome-abrev   = movdis.his-ped-ent.nome-abrev
                         AND   hisdis.his-ped-ent.nr-pedcli    = movdis.his-ped-ent.nr-pedcli
                         AND   hisdis.his-ped-ent.nr-sequencia = movdis.his-ped-ent.nr-sequencia
                         AND   hisdis.his-ped-ent.it-codigo    = movdis.his-ped-ent.it-codigo
                         AND   hisdis.his-ped-ent.cod-refer    = movdis.his-ped-ent.cod-refer
                         AND   hisdis.his-ped-ent.nr-entrega   = movdis.his-ped-ent.nr-entrega) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=his-ped-ent}
        end.
        when "ped-repre" then do:
            find movdis.ped-repre where rowid(movdis.ped-repre) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.ped-repre 
                         WHERE hisdis.ped-repre.nr-pedido         =  movdis.ped-repre.nr-pedido
                         AND   hisdis.ped-repre.nome-ab-rep       =  movdis.ped-repre.nome-ab-rep
                         &IF "{&bf_dis_Versao_ems}" >= "2.04" &THEN
                         AND   hisdis.ped-repre.cod-classificador =  movdis.ped-repre.cod-classificador
                         &ENDIF  NO-LOCK) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=ped-repre}
        end.
        when "cond-ped" then do:
            find movdis.cond-ped where rowid(movdis.cond-ped) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.cond-ped OF movdis.cond-ped NO-LOCK) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=cond-ped}
        end.
        when "fat-estat" then do:
            find movdis.fat-estat where rowid(movdis.fat-estat) = rw-arqmov no-lock no-error.
            {bhp/bh9800.i &area=dis &arqmov=fat-estat}	
        end.
        when "doc-fiscal" then do:
            find movdis.doc-fiscal where rowid(movdis.doc-fiscal) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.doc-fiscal OF movdis.doc-fiscal NO-LOCK) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=doc-fiscal}	
        end.
        when "it-doc-fisc" then do:
            find movdis.it-doc-fisc where rowid(movdis.it-doc-fisc) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.it-doc-fisc OF movdis.it-doc-fisc NO-LOCK) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=it-doc-fisc}	
        end.
        when "apur-imposto" then do:
            find movdis.apur-imposto where rowid(movdis.apur-imposto) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.apur-imposto OF movdis.apur-imposto NO-LOCK) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=apur-imposto}
        end.
        when "imp-valor" then do:
            find movdis.imp-valor where rowid(movdis.imp-valor) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.imp-valor OF movdis.imp-valor NO-LOCK) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=imp-valor}	
        end.
        when "imposto-guia" then do:
            find movdis.imposto-guia where rowid(movdis.imposto-guia) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.imposto-guia OF movdis.imposto-guia NO-LOCK) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=imposto-guia}
        end.
        when "ext-doc-fiscal" then do:
            find movdis.ext-doc-fiscal where rowid(movdis.ext-doc-fiscal) = rw-arqmov no-lock no-error.
            IF  CAN-FIND(FIRST hisdis.ext-doc-fiscal OF movdis.ext-doc-fiscal NO-LOCK) THEN
                RETURN "NOK":U.
            {bhp/bh9800.i &area=dis &arqmov=ext-doc-fiscal}
        end.
    END CASE.

END PROCEDURE.

RETURN "OK":U.
