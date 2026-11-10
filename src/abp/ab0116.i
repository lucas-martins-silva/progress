/*****************************************************************************************
         
         ABP/AB0116.I - TEMP-TABLE DE PAR¶METROS
         
******************************************************************************************/

DEFINE TEMP-TABLE ttParam NO-UNDO
       FIELD cdn-param       LIKE mab-param-integr.cdn-param 
       FIELD des-label-param LIKE mab-param-integr.des-label-param 
       FIELD des-param       LIKE mab-param-integr.des-param 
       FIELD des-valor       LIKE mab-param-integr.des-valor. 
     
