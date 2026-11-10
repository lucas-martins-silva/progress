PROCEDURE PITransUpsert:
 
EMPTY TEMP-TABLE tt-erro NO-ERROR.
EMPTY TEMP-TABLE ttMaterialFamily NO-ERROR.

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM cTranAction AS CHARACTER NO-UNDO.
DEFINE INPUT PARAM cProgName    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAM cProgVersion AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM TABLE FOR tt-familia-dbr.
DEFINE INPUT PARAM de-val-refer-atualiz AS DEC NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt-erro.
/*PARAMETERS - END*/



/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

    IF NOT CAN-FIND (FIRST tt-familia-dbr) THEN DO: 
        
        {utp/ut-liter.i Fam¡lia_para_integra‡Æo_EAI * r}
        RUN utp/ut-msgs.p("msg":U,5561,trim(RETURN-VALUE)).
        CREATE tt-erro.
        ASSIGN iContErro        = iContErro + 1
               tt-erro.cd-erro  = 5561
               tt-erro.mensagem = RETURN-VALUE
               tt-erro.i-sequen = iContErro. 
       RETURN "NOK":U.
    END.

    /* Cria temp-table's do adapter com base nas temp-table's enviadas pelo EMS. 
       O adapter ir ÿconsiderar valores branco e zero, pois o default dos campos j  foi setado */
     FOR EACH tt-familia-dbr NO-LOCK:
         
         CREATE ttMaterialFamily.  
         ASSIGN iContFam                                   = iContFam + 1
                ttMaterialFamily.ttMaterialFamilyID        = iContFam 
                ttMaterialFamily.MaterialFamilyCode        = tt-familia-dbr.fm-codigo 
                ttMaterialFamily.MaterialFamilyDescription = tt-familia-dbr.des-familia
                ttMaterialFamily.Policy                    = tt-familia-dbr.politica.
     END.     


    /* Envia informa»„es p/ cria»’o do XML no adapter principal  */
    RUN  PIUpsert (INPUT cTranAction,
                   INPUT cProgName,
                   INPUT cProgVersion,
                   INPUT TABLE ttMaterialFamily,
                   INPUT de-val-refer-atualiz,
                   OUTPUT TABLE tt-erro).


/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



