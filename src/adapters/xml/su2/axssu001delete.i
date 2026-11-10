PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

/*
RUN PIDelete ( 
          OUTPUT TABLE tt_log_erro ).

*/
/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

/*PARAMETERS - BEGIN*/
DEF INPUT PARAM p-acao          AS CHAR  .  
DEF INPUT PARAM r-docum-est AS ROWID .
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro NO-ERROR.
DEF VAR cEvent AS CHARACTER INITIAL ? NO-UNDO.

DEFINE var ContactName_00 AS CHARACTER  NO-UNDO.  /*Nome do contato. (Uso interno: Campo = mgadm.cont-emit.nome)*/
DEFINE var ContactSequence_00 AS integer  NO-UNDO.  /*Sequencia contato. (Uso interno: Campo = mgadm.cont-emit.num-seq-cont-emit)*/
DEFINE var cTranAction AS CHARACTER  NO-UNDO.
DEFINE var DocumentNumber_00 AS CHARACTER NO-UNDO.  /*Número do documento. (Uso interno: Campo = movind.docum-est.nro-docto)*/
DEFINE var DocumentSeries_00 AS CHARACTER  NO-UNDO.  /*Série do documento. (Uso interno: Campo = movind.docum-est.serie-docto)*/
DEFINE var DocumentType_00 AS integer  NO-UNDO.  /*Espécie do documento que originou o movimento de estoque, indentificada por um conjunto de indicadores (siglas) intenas do EMS2. Valores: 1 - ACA, 2 - ACT, 3 - NU1, 4 - DD, 5 - DEV, 6 - DIV, 7 - DRM, 8 - EAC, 9 - EGF, 10 - BEM, 11 - NU2, 12 - NU3, 13 - NU4, 14 - ICM, 15 - INV, 16 - IPL, 17 - MOB, 18 - NC, 19 - NF, 20 - NFD, 21 - NFE, 22 - NFS, 23 - NFT, 24 - NU5, 25 - REF, 26 - RCS, 27 - RDD, 28 - REQ, 29 - RFS, 30 - RM, 31 - RRQ, 32 - STR, 33 - TRA, 34 - ZZZ, 35 - SOB, 36 - EDD, 37 - VAR, 38 - ROP. (Uso interno: Campo = movind.docum-est.esp-docto - Include = ininc/i03in218.i)*/
DEFINE var EmailAddress_00 AS CHARACTER  NO-UNDO.  /*E-mail do contato. (Uso interno: Campo = mgadm.cont-emit.e-mail)*/
DEFINE var FiscalOperationCode_00 AS CHARACTER NO-UNDO.  /*Código natureza de operação. (Uso interno: Campo = movind.docum-est.nat-operacao)*/
DEFINE var FiscalOperationDescription_00 AS CHARACTER  NO-UNDO.  /*Descrição da natureza de operação. (Uso interno: Campo = mgind.natur-oper.denominacao)*/

&if "{&bf_dis_versao_ems}" >=  "2.08" &then
  DEFINE var EndConsumer                   AS LOGICAL    NO-UNDO.
  DEFINE var Type_00                       AS INTEGER    NO-UNDO.
  DEFINE var Transfer                      AS LOGICAL    NO-UNDO.
  DEFINE var Kind_00                       AS CHARACTER  NO-UNDO. 
&endif

DEFINE var PhoneNumber_00 AS CHARACTER  NO-UNDO.  /*Telefone do contato. (Uso interno: Campo = mgadm.cont-emit.telefone)*/
DEFINE var SiteDescription_02 AS CHARACTER  NO-UNDO.  /*Descrição do estabelecimento. (Uso interno: Campo = mgadm.estabelec.nome)*/
DEFINE var SiteID_02 AS CHARACTER  NO-UNDO.  /*Código do estabelecimento. (Uso interno: Campo = movind.docum-est.cod-estabel)*/
DEFINE var SiteShortName_00 AS CHARACTER  NO-UNDO.  /*Nome do estabelecimento. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
DEFINE var SiteTaxID_00 AS CHARACTER  NO-UNDO.  /*CGC do estabelecimento. (Uso interno: Campo = mgadm.emitente.cgc)*/

&if "{&bf_dis_versao_ems}" >=  "2.08" &then
  DEFINE var SiteVendorID_00 AS INTEGER NO-UNDO.
&endif
  
DEFINE var VendorID_00 AS integer NO-UNDO.  /*Código interno de identificação do fornecedor. (Uso interno: Campo = movind.docum-est.cod-emitente)*/
DEFINE var VendorShortName_00 AS CHARACTER  NO-UNDO.  /*Nome abreviado do fornecedor. (Uso interno: Campo = mgadm.emitente.nome-abrev)*/
DEFINE var VendorTaxID_00 AS CHARACTER  NO-UNDO.  /*CGC do fornecedor. (Uso interno: Campo = mgadm.emitente.cgc)*/

DEF BUFFER bf-emitente FOR emitente.

FIND FIRST docum-est 
     WHERE ROWID(docum-est ) = r-docum-est NO-LOCK NO-ERROR.

IF AVAIL docum-est THEN DO:
    
    FIND FIRST emitente 
         WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
    
    FIND FIRST natur-oper 
         WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
    
    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
    
    ASSIGN ContactName_00      = ''
           ContactSequence_00  = 0
           PhoneNumber_00      = ''
           EmailAddress_00     = ''.
            
    /*Atualizar as informa‡äes p/passar como parƒmetro p/a PIDelete:*/
    ASSIGN  cEvent                        = p-acao /* del */           
            cTranAction                   = p-acao
            DocumentNumber_00             = IF AVAIL docum-est  THEN docum-est.nro-docto ELSE ''
            DocumentSeries_00             = IF AVAIL docum-est  THEN docum-est.serie-docto ELSE ''
            DocumentType_00               = IF AVAIL docum-est  THEN  docum-est.esp-doc ELSE 0
            FiscalOperationCode_00        = IF AVAIL docum-est  THEN docum-est.nat-operacao ELSE ''
            FiscalOperationDescription_00 = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE ''
          &if "{&bf_dis_versao_ems}" >=  "2.08" &then
            EndConsumer                   = IF AVAIL natur-oper THEN natur-oper.consum-final ELSE NO
            Type_00                       = IF AVAIL natur-oper THEN natur-oper.tipo         ELSE 1
            Transfer                      = IF AVAIL natur-oper THEN natur-oper.transf       ELSE NO
            Kind_00                       = IF AVAIL natur-oper THEN natur-oper.especie-doc  ELSE ''
            SiteVendorID_00               = IF AVAIL estabelec  THEN estabelec.cod-emitente ELSE 0
          &endif
            SiteDescription_02            = IF AVAIL estabelec  THEN estabelec.nome ELSE ''            
            SiteID_02                     = IF AVAIL docum-est  THEN docum-est.cod-estabel  ELSE ''
            VendorID_00                   = IF AVAIL docum-est  THEN docum-est.cod-emitente ELSE 0
            VendorShortName_00            = IF AVAIL emitente   THEN emitente.nome-abrev ELSE ''
            VendorTaxID_00                = IF AVAIL emitente   THEN emitente.cgc ELSE ''.

    IF AVAIL estabelec THEN
    FIND FIRST bf-emitente 
         WHERE bf-emitente.cod-emitente = estabelec.cod-emitente NO-LOCK NO-ERROR.
    
    IF AVAIL bf-emitente THEN DO:
       ASSIGN SiteShortName_00   = bf-emitente.nome-abrev
              SiteTaxID_00       = bf-emitente.cgc.
    END.
    
   RUN PIDelete (INPUT cEvent,                               
                 INPUT ContactName_00,                       
                 INPUT ContactSequence_00,                   
                 INPUT cTranAction,                          
                 INPUT DocumentNumber_00,                    
                 INPUT DocumentSeries_00,                    
                 INPUT DocumentType_00,                      
                 INPUT EmailAddress_00,                      
                 INPUT FiscalOperationCode_00,               
                 INPUT FiscalOperationDescription_00,  
               &if "{&bf_dis_versao_ems}" >=  "2.08" &then
                 INPUT EndConsumer,
                 INPUT Type_00,
                 INPUT Transfer,
                 INPUT Kind_00,
               &endif
                 INPUT PhoneNumber_00,                       
                 INPUT SiteDescription_02,                   
                 INPUT SiteID_02,                            
                 INPUT SiteShortName_00,                     
                 INPUT SiteTaxID_00,  
               &if "{&bf_dis_versao_ems}" >=  "2.08" &then
                 INPUT SiteVendorID_00,
               &endif
                 OUTPUT TABLE tt_log_erro,                   
                 INPUT VendorID_00,                          
                 INPUT VendorShortName_00,                   
                 INPUT VendorTaxID_00).                      
                                                             
                                                              
                                                                           
 END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */


END PROCEDURE.



