/*----------------------------------------------------------------------------
** app/ap9100.i - Definiá∆o da temp-table para integraá∆o com CB, GE, 
**                Fasb, CD e BH
** Observaá∆o : O parÉmetros de integraá∆o:
** 1  - Ativa SeqÅància
** 2  - Baixa
** 3  - Baixa Batch
** 4  - Despesa
** 5  - Devoluá∆o
** 6  - Elimina
** 7  - Elimina Baixa
** 8  - Elimina Desconto
** 9  - Elimina Despesa
** 10 - Elimina Devoluá∆o
** 11 - Elimina Itens
** 12 - Elimina Parcela
** 13 - Elimina Recebimento
** 14 - Elimina SeqÅància
** 15 - Faturamento
** 16 - Inclus∆o
** 17 - Inclus∆o Batch
** 18 - Inclui Itens
** 19 - Inclui Parcela
** 20 - Recebimento
** 21 - Movto
** 22 - Elimina Movto
** 23 - Nota de DÇbito/CrÇdito
---------------------------------------------------------------------------------*/

def temp-table tt-integ-ap NO-UNDO
    field tt-row-tit-ap      as rowid
    field tt-row-mov-ap      as rowid
    field tt-row-des-banc    as rowid
    field tt-ge0102a         as log init no   
    field tt-ge0102b         as log init no   
    field tt-ge0102c         as log init no   
    field tt-ge0102d         as log init no   
    field tt-ge0102e         as log init no   
    field tt-ge0102f         as log init no   
    field tt-ge0102g         as log init no   
    field tt-cb0110a         as log init no
    field tt-cb0110b         as log init no
    field tt-cb0201a         as log init no   
    field tt-cb0202a         as log init no   
    field tt-cb0202b         as log init no   
    field tt-cb0401a         as log init no   
    field tt-cb1202da        as log init no   
    field tt-cb1202a         as log init no
    field tt-cb1202b         as log init no   
    field tt-fc1013a         as log init no
    field tt-fc1014a         as log init no   
    field tt-fc1113a         as log init no
    field tt-fc1114a         as log init no
    field tt-op-ge0102a      as int init 0
    field tt-op-ge0102b      as int init 0
    field tt-op-ge0102c      as int init 0    
    field tt-op-ge0102d      as int init 0    
    field tt-op-ge0102e      as int init 0
    field tt-op-ge0102f      as int init 0
    field tt-op-ge0102g      as int init 0
    field tt-op-cb0110b      as int init 0
    field tt-op-cb0110a      as int init 0
    field tt-op-cb0201a      as int init 0
    field tt-op-cb0202a      as int init 0
    field tt-op-cb0202b      as int init 0
    field tt-op-cb0401a      as int init 0
    field tt-op-cb1202da     as int init 0
    field tt-op-cb1202a      as int init 0
    field tt-op-cb1202b      as int init 0
    field tt-op-fc1013a      as int init 0    
    field tt-op-fc1113a      as int init 0
    field tt-op-fc1014a      as int init 0
    field tt-op-fc1114a      as int init 0.

    
/* app/ap9100.i */
