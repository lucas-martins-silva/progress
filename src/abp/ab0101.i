/*****************************************************************************************
         
         ABP/AB0101.I - TEMP-TABLE DE PAR¶METROS
         
******************************************************************************************/

DEFINE TEMP-TABLE ttParam NO-UNDO
       FIELD cdn-param       LIKE mab-param.cdn-param 
       FIELD des-label-param LIKE mab-param.des-label-param 
       FIELD des-param       LIKE mab-param.des-param 
       FIELD des-valor       LIKE mab-param.des-valor
       FIELD cod-modulo      LIKE mab-param.cod-modulo.  
     
DEFINE TEMP-TABLE ttModulos NO-UNDO
    FIELD cdn-modulo         AS INTEGER
    FIELD cd-funcao          LIKE funcao.cd-funcao
    FIELD des-modulo         AS CHARACTER FORMAT "x(50)"
    FIELD log-ativo          AS LOGICAL.
