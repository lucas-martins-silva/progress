PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/

DEF INPUT PARAM pTranAction       AS CHAR  NO-UNDO . /* add/upd */
DEF INPUT PARAM pCarrierRowID     AS ROWID NO-UNDO  .  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro      NO-ERROR.
EMPTY TEMP-TABLE tttransporte     NO-ERROR.
EMPTY TEMP-TABLE ttcont-tran      NO-ERROR.

FIND FIRST transporte WHERE ROWID(transporte) = pCarrierRowID NO-LOCK NO-ERROR.

IF AVAIL transporte THEN DO:

    FOR FIRST emitente FIELDS( cod-emitente )
        WHERE emitente.cod-emitente = transporte.cod-emitente NO-LOCK: END.

    CREATE tttransporte.
    ASSIGN tttransporte.bairro           = transporte.bairro          
           tttransporte.cdn-parcei-edi   = transporte.cdn-parcei-edi  
           tttransporte.cep              = transporte.cep             
           tttransporte.cgc              = transporte.cgc             
           tttransporte.cidade           = transporte.cidade          
           tttransporte.cod-transp       = transporte.cod-transp 
           tttransporte.cod-emitente     = emitente.cod-emitente WHEN AVAIL emitente
           tttransporte.contato          = transporte.contato         
           tttransporte.cx-postal        = transporte.cx-postal       
           tttransporte.des-ident-transp = transporte.des-ident-transp
           tttransporte.e-mail           = transporte.e-mail          
           tttransporte.endereco         = transporte.endereco
           tttransporte.estado           = transporte.estado    
           &IF '{&BF_DIS_VERSAO_EMS}' >= '2.05' &THEN
            tttransporte.endereco_text    = transporte.endereco_text
           &ENDIF
           tttransporte.home-page        = transporte.home-page       
           tttransporte.ind-situacao     = transporte.ind-situacao    
           tttransporte.ins-estadual     = transporte.ins-estadual    
           tttransporte.log-edi          = transporte.log-edi         
           tttransporte.natureza         = transporte.natureza        
           tttransporte.nome             = transporte.nome            
           tttransporte.nome-abrev       = transporte.nome-abrev      
           tttransporte.pais             = transporte.pais            
           tttransporte.ramal            = transporte.ramal           
           tttransporte.ramal-fax        = transporte.ramal-fax       
           tttransporte.ramal-modem      = transporte.ramal-modem     
           tttransporte.telef-modem      = transporte.telef-modem     
           tttransporte.telefone         = transporte.telefone        
           tttransporte.telex            = transporte.telex           
           tttransporte.via-transp       = transporte.via-transp
           tttransporte.telefax          = transporte.telefax.

    FOR EACH cont-tran 
        WHERE cont-tran.cod-transp = transporte.cod-transp NO-LOCK:

        CREATE ttcont-tran.
        UPDATE ttcont-tran.cod-transp  = cont-tran.cod-transp
               ttcont-tran.area        = cont-tran.area       
               ttcont-tran.cargo       = cont-tran.cargo      
               ttcont-tran.e-mail      = cont-tran.e-mail     
               ttcont-tran.home-page   = cont-tran.home-page  
               ttcont-tran.nome        = cont-tran.nome       
               ttcont-tran.observacao  = cont-tran.observacao 
               ttcont-tran.ramal       = cont-tran.ramal      
               ttcont-tran.ramal-fax   = cont-tran.ramal-fax  
               ttcont-tran.sequencia   = cont-tran.sequencia  
               ttcont-tran.telefax     = cont-tran.telefax    
               ttcont-tran.telef-modem = cont-tran.telef-modem
               ttcont-tran.telefone    = cont-tran.telefone.          
    END.

    RUN PIUpsert ( INPUT pTranAction,
                   INPUT  TABLE ttcont-tran,
                   INPUT  TABLE tttransporte,
                   OUTPUT TABLE tt_log_erro ).


END.


/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.
