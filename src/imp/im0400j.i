DEFINE TEMP-TABLE tt-saldo-di NO-UNDO
    FIELD cod-embarq            LIKE decla-import-ord.cod-embarq 
    FIELD num-ordem             LIKE decla-import-ord.num-ordem  
    FIELD num-parcela           LIKE decla-import-ord.num-parcela
    FIELD it-codigo             LIKE prazo-compra.it-codigo      
    FIELD qtd-item              LIKE decla-import-ord.qtd-item   
    FIELD quant-receb           LIKE prazo-compra.quant-receb    
    FIELD quant-rejeit          LIKE prazo-compra.quant-rejeit   
    FIELD quant-saldo           LIKE prazo-compra.dec-1
    FIELD quant-alocada         LIKE prazo-compra.dec-1          
    FIELD situacao              LIKE prazo-compra.situacao       
    FIELD r-rowid               AS ROWID
    INDEX ordem num-ordem
    INDEX embarque cod-embarq
.
